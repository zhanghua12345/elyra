import 'dart:convert';
import 'dart:io';
import 'package:elyra/bean/short_play_detail_bean.dart';
import 'package:elyra/bean/short_video_bean.dart';
import 'package:elyra/bean/user_info.dart';
import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/el_collect/controller.dart';
import 'package:elyra/page/el_home/controller.dart';
import 'package:elyra/page/el_me/controller.dart';
import 'package:elyra/page/el_play/state.dart';
import 'package:elyra/request/http.dart';
import 'package:elyra/request/index.dart';
import 'package:elyra/utils/device_info.dart';
import 'package:elyra/utils/el_store.dart';
import 'package:elyra/utils/el_utils.dart';
import 'package:elyra/utils/toast.dart';
import 'package:elyra/widgets/bad_status_widget.dart';
import 'package:elyra/widgets/el_confirm_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class PlayDetailController extends GetxController {
  final state = PlayDetailState();

  late PageController pageController;
  List<VideoPlayerController?> controllers = [];
  int currentIndex = 0;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: currentIndex);
  }

  @override
  void onReady() {
    super.onReady();
    state.shortPlayId = Get.arguments['shortPlayId'] ?? -1;
    state.videoId = Get.arguments['videoId'] ?? 0;
    state.activityId = Get.arguments['activityId'];
    state.imageUrl = Get.arguments['imageUrl'] ?? '';

    getVideoDetails();
  }

  @override
  void onClose() {
    _clearControllers();
    pageController.dispose();
    super.onClose();
  }

  /// 清空所有视频控制器
  void _clearControllers() {
    for (var controller in controllers) {
      controller?.pause();
      controller?.dispose();
    }
    controllers.clear();
  }

  /// 获取视频详情
  Future<void> getVideoDetails() async {
    try {
      Map<String, dynamic> params = {
        'short_play_id': state.shortPlayId,
        "video_id": state.videoId,
      };

      if (state.activityId != null) {
        params['activity_id'] = state.activityId;
      }

      ApiResponse res = await HttpClient().request(
        Apis.getVideoDetails,
        method: HttpMethod.get,
        queryParameters: params,
      );

      if (res.success) {
        state.loadStatus = LoadStatusType.loadSuccess;
        state.detailBean = ShortPlayDetailBean.fromJson(res.data);

        if (state.videoId <= 0) {
          state.videoId = state.detailBean?.videoInfo?.id ?? 0;
        }

        state.episodeList = state.detailBean?.episodeList ?? [];

        // 计算当前解锁索引
        for (var video in state.episodeList) {
          if (video.isLock == true) {
            state.curUnlock = state.episodeList.indexOf(video);
            break;
          }
        }

        // 根据传入的videoId确定初始集数索引
        if (state.videoId > 0) {
          // 查找对应的集数索引
          currentIndex = state.episodeList.indexWhere(
            (episode) => episode.id == state.videoId,
          );
          if (currentIndex == -1) {
            // 如果没找到，使用默认的第一集
            currentIndex = (state.detailBean?.videoInfo?.episode ?? 1) - 1;
          }
        } else {
          // 使用默认的第一集
          currentIndex = (state.detailBean?.videoInfo?.episode ?? 1) - 1;
        }

        state.currentEpisode = currentIndex;

        // 重新初始化PageController为正确的集数
        if (pageController.hasClients) {
          pageController.jumpToPage(currentIndex);
        } else {
          pageController.dispose();
          pageController = PageController(initialPage: currentIndex);
        }

        // 初始化视频控制器列表
        controllers = List<VideoPlayerController?>.filled(
          state.episodeList.length,
          null,
          growable: true, // TODO
        );

        // 如果当前集是锁定状态，则只弹出锁定弹框，不初始化播放器
        if (currentIndex >= 0 &&
            state.episodeList[currentIndex].isLock == true) {
          state.showLockDialog = true;
          _preloadAdjacentVideos(); // 初始化上下播放器
          update();
          return;
        }

        // 初始化当前视频
        await _initializeController(currentIndex);
        _preloadAdjacentVideos(); // 初始化上下播放器

        update();
      } else {
        state.loadStatus = LoadStatusType.loadFailed;
        update();
      }
    } catch (e) {
      state.loadStatus = LoadStatusType.loadFailed;
      update();
      debugPrint('获取视频详情失败: $e');
    }
  }

  /// 初始化视频控制器
  Future<void> _initializeController(int index) async {
    if (index < 0 || index >= state.episodeList.length) return;

    final episode = state.episodeList[index];
    // 锁定剧集不初始化播放器，保持封面背景
    if (episode.isLock == true) return;

    if (controllers[index] != null) return;
    if (episode.videoUrl.isNullString) return;

    VideoPlayerController controller =
        Platform.isAndroid && DeviceInfoUtils().osVersion == '10'
        ? VideoPlayerController.networkUrl(
            Uri.parse(episode.videoUrl!),
            formatHint: VideoFormat.hls,
            viewType: VideoViewType.platformView,
          )
        : VideoPlayerController.networkUrl(
            Uri.parse(episode.videoUrl!),
            formatHint: VideoFormat.hls,
          );

    controllers[index] = controller;

    try {
      await controller.initialize();
      // controller.setPlaybackSpeed(state.curSpeed);  // 设置播放速度

      // 如果有历史播放记录，跳转到指定位置
      if (!episode.playSeconds.isNullString) {
        try {
          int seconds = int.parse(episode.playSeconds!);
          if (seconds > 0) {
            await controller.seekTo(Duration(milliseconds: seconds));
          }
        } catch (e) {
          debugPrint('解析播放进度失败: $e');
        }
      }

      // 添加监听器 TODO
      controller.addListener(() {
        if (currentIndex == index && !isClosed) {
          update();
        }

        // 视频播放完成，自动播放下一集
        // 注意：只有当前正在播放的视频才能触发自动播放
        if (controller.value.isCompleted &&
            !controller.value.isBuffering &&
            index == currentIndex) {
          // 关键修复：只有当前集才能触发
          _playNextEpisode();
        }
      });

      // 如果是当前视频，自动播放
      if (index == currentIndex) {
        controller.play();
      }

      update();
    } catch (e) {
      debugPrint('视频初始化失败: $e');
    }
  }

  /// 预加载相邻视频
  void _preloadAdjacentVideos() {
    if (currentIndex > 0) {
      _initializeController(currentIndex - 1);
    }
    if (currentIndex < state.episodeList.length - 1) {
      _initializeController(currentIndex + 1);
    }
    _releaseUnusedControllers();
  }

  /// 释放未使用的控制器
  void _releaseUnusedControllers() {
    for (int i = 0; i < controllers.length; i++) {
      if (i < currentIndex - 1 || i > currentIndex + 1) {
        controllers[i]?.dispose();
        controllers[i] = null;
      }
    }
  }

  /// 切换集数
  Future<void> onEpisodeChanged(int index, {bool isToggle = false}) async {
    if (index < 0 || index >= state.episodeList.length) return;
    if (index == currentIndex && !isToggle) return;

    // 暂停当前视频并上传播放进度
    if (controllers[currentIndex] != null) {
      await controllers[currentIndex]?.pause();
      if (controllers[currentIndex]?.value.isPlaying == false) {
        uploadHistorySeconds(
          controllers[currentIndex]?.value.position.inMilliseconds ?? 0,
        );
      }
    }

    // 更新当前集数
    currentIndex = index;
    state.currentEpisode = index;

    // 🔥 关键修复：先跳转页面，再检查锁定状态
    if (isToggle && pageController.hasClients) {
      pageController.jumpToPage(index);
    }
    // await Future.delayed(Duration(milliseconds: 200));
    // 检查当前集是否锁定
    final currentEpisode = state.episodeList[index];
    if (currentEpisode.isLock == true) {
      // 集数被锁定，暂停视频并显示锁定蒙层
      controllers[index]?.seekTo(Duration.zero);
      controllers[index]?.pause();
      update();
      await Future.delayed(Duration(milliseconds: 200));
      // 延迟300ms后自动检查金币并尝试解锁（不弹窗）
      await autoCheckAndUnlock(currentEpisode.coins ?? 0, index);
      return;
    }

    // 初始化并播放新视频
    if (controllers[index] == null) {
      await _initializeController(index);
    } else {
      // 如果已经初始化，直接播放
      controllers[index]?.play();
    }

    // 预加载相邻视频
    _preloadAdjacentVideos();

    // 创建历史记录
    createHistory();

    // 更新首页历史记录
    // updateHomeVideo();

    update();
  }

  /// 自动播放下一集
  void _playNextEpisode() {
    if (currentIndex < state.episodeList.length - 1) {
      onEpisodeChanged(currentIndex + 1, isToggle: true);
    }
  }

  /// 创建历史记录
  void createHistory() {
    if (currentIndex < 0 || currentIndex >= state.episodeList.length) return;

    Map<String, dynamic> params = {
      "short_play_id": state.shortPlayId,
      "video_id": state.episodeList[currentIndex].id,
    };

    HttpClient().request(Apis.createHistory, data: params);
  }

  /// 上传播放进度
  void uploadHistorySeconds(int playSeconds) {
    if (currentIndex < 0 || currentIndex >= state.episodeList.length) return;

    Map<String, dynamic> params = {
      "short_play_id": state.shortPlayId,
      "video_id": state.episodeList[currentIndex].id,
      "play_seconds": playSeconds > 0 ? playSeconds : 0,
    };

    HttpClient().request(Apis.uploadHistorySeconds, data: params);

    // 同时保存到本地
    _saveToLocalHistory(playSeconds);
  }

  /// 保存历史记录到本地
  void _saveToLocalHistory(int playSeconds) {
    try {
      final historyData = {
        'short_play_id': state.shortPlayId,
        'video_id': state.episodeList[currentIndex].id,
        'name': state.detailBean?.shortPlayInfo?.name,
        'image_url': state.detailBean?.shortPlayInfo?.imageUrl,
        'episode': currentIndex + 1,
        'play_seconds': playSeconds,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };

      SpUtils().setString(ElStoreKeys.videoHistory, jsonEncode(historyData));
    } catch (e) {
      debugPrint('保存本地历史记录失败: $e');
    }
  }

  /// 上报活动
  void reportActivity() {
    if (state.activityId == null) return;
    if (currentIndex < 0 || currentIndex >= state.episodeList.length) return;

    Map<String, dynamic> params = {
      'short_play_id': state.shortPlayId,
      "short_play_video_id": state.episodeList[currentIndex].shortPlayVideoId,
      "activity_id": state.activityId,
    };

    HttpClient().request(Apis.reportActivity, data: params);
  }

  /// 更新首页历史记录显示
  // void updateHomeVideo() {
  //   try {
  //     final homeLogic = Get.put(HomeController());
  //     int playTime = controllers[currentIndex]?.value.position.inSeconds ?? 0;

  //     homeLogic.state.curVideo = ShortVideoBean()
  //       ..shortPlayId = state.shortPlayId
  //       ..imageUrl = state.detailBean?.shortPlayInfo?.imageUrl
  //       ..name = state.detailBean?.shortPlayInfo?.name
  //       ..playTime = playTime
  //       ..process = currentIndex + 1;

  //     homeLogic.update();
  //   } catch (e) {
  //     debugPrint('更新首页历史失败: $e');
  //   }
  // }

  /// 切换播放速度
  void changeSpeed(double speed) {
    state.curSpeed = speed;
    controllers[currentIndex]?.setPlaybackSpeed(speed);
    update();
  }

  void onRefresh() {
    state.shortPlayId = Get.arguments['shortPlayId'] ?? -1;
    state.videoId = Get.arguments['videoId'] ?? 0;
    state.activityId = Get.arguments['activityId'];
    state.imageUrl = Get.arguments['imageUrl'] ?? '';
    getVideoDetails();
  }

  /// 收藏视频
  Future<bool> collectVideo() async {
    ShortPlayInfo? spInfo = state.detailBean?.shortPlayInfo;

    try {
      if (spInfo?.shortPlayId == null) {
        return false;
      }

      // 使用当前集的video_id
      if (currentIndex < 0 || currentIndex >= state.episodeList.length) {
        return false;
      }

      Map<String, dynamic> params = {
        'short_play_id': spInfo?.shortPlayId,
        'video_id': state.episodeList[currentIndex].id, // 使用当前集的id
      };

      ApiResponse response = await HttpClient().request(
        Apis.collect,
        method: HttpMethod.post,
        data: params,
      );

      if (response.success) {
        // 更新本地状态
        spInfo?.isCollect = true;
        spInfo?.collectTotal = (spInfo.collectTotal ?? 0) + 1;
        update();
        _refreshCollectPage();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint('收藏视频异常: $e');
      return false;
    }
  }

  /// 取消收藏视频
  Future<bool> cancelCollectVideo() async {
    ShortPlayInfo? spInfo = state.detailBean?.shortPlayInfo;
    try {
      if (spInfo?.shortPlayId == null) {
        return false;
      }

      // 使用当前集的video_id
      if (currentIndex < 0 || currentIndex >= state.episodeList.length) {
        return false;
      }

      Map<String, dynamic> params = {
        'short_play_id': spInfo?.shortPlayId,
        'video_id': state.episodeList[currentIndex].id, // 使用当前集的id
      };

      ApiResponse response = await HttpClient().request(
        Apis.cancelCollect,
        method: HttpMethod.post,
        data: params,
      );

      if (response.success) {
        spInfo?.isCollect = false;
        spInfo?.collectTotal = (spInfo.collectTotal ?? 1) - 1;
        update();
        _refreshCollectPage();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint('取消收藏视频异常: $e');
      return false;
    }
  }

  /// 切换收藏状态，返回是否成功
  Future<bool> toggleCollect(BuildContext context) async {
    ShortPlayInfo? spInfo = state.detailBean?.shortPlayInfo;

    if (spInfo == null) return false;

    // 未收藏 → 直接收藏
    if (spInfo.isCollect != true) {
      final success = await collectVideo();
      if (success) {
        spInfo.isCollect = true;
        update();
      }
      return success;
    }

    // 已收藏 → 弹窗确认取消收藏
    return await _showCancelCollectModal(context);
  }

  /// 弹出取消收藏确认弹窗，并在接口成功后更新状态
  Future<bool> _showCancelCollectModal(BuildContext context) async {
    ShortPlayInfo? spInfo = state.detailBean?.shortPlayInfo;

    bool result = false;

    await showElConfirmModal(
      context,
      image: AssetImage('el_model_cancel_collect.png'.icon),
      title: 'Remove from Favorites?',
      child: Text(
        'This drama will be removed from\n your favorites.',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontFamily: 'PingFang SC',
          fontWeight: FontWeight.w400,
          height: 1.50,
          letterSpacing: -0.01,
        ),
      ),
      cancelText: 'Cancel',
      confirmText: 'Remove',
      onCancel: () {
        Navigator.of(context).pop();
        result = false;
      },
      onConfirm: () async {
        Navigator.of(context).pop();

        final success = await cancelCollectVideo();
        if (success) {
          spInfo?.isCollect = false;
          update();
        }
        result = success;
      },
    );

    return result;
  }

  /// 刷新收藏页面数据
  void _refreshCollectPage() {
    try {
      // 尝试获取收藏页面的controller，如果存在则刷新数据
      if (Get.isRegistered<CollectController>()) {
        final collectController = Get.find<CollectController>();
        collectController.onRefresh();
      }
    } catch (e) {
      // 如果收藏页面未初始化，忽略错误
      debugPrint('收藏页面未初始化: $e');
    }
  }

  /// 自动检查并解锁视频（新逻辑：不弹窗，只判断金币）
  Future<void> autoCheckAndUnlock(num coins, int index) async {
    final success = await buyVideoUnlock(
      state.episodeList[index].id!,
      coins,
      toRecharge: false,
    );
    if (success) {
      // 解锁成功，刷新 MePageController 的用户信息
      _refreshMePageUserInfo();
    }
    update();
  }

  Future<bool> buyVideoUnlock(
    num videoId,
    num coins, {
    bool toRecharge = false,
  }) async {
    try {
      if (!toRecharge) {
        // EasyLoading.show(status: 'Loading...');
      }

      ApiResponse response = await HttpClient().request(
        Apis.buyVideo,
        method: HttpMethod.post,
        data: {'short_play_id': state.shortPlayId, 'video_id': videoId},
      );

      if (!toRecharge) {
        // EasyLoading.dismiss();
      }

      if (response.data['status'] == 'success') {
        // 解锁成功，更新当前item的isLock状态
        final episodeIndex = state.episodeList.indexWhere(
          (e) => e.id == videoId,
        );
        if (episodeIndex != -1) {
          state.episodeList[episodeIndex].isLock = false;

          // 如果是当前集，更新解锁索引
          if (episodeIndex != state.episodeList.length - 1) {
            state.curUnlock = episodeIndex + 1;
          }

          update();

          if (controllers[episodeIndex] == null) {
            await _initializeController(episodeIndex);
          }
          if (controllers[episodeIndex] != null) {
            controllers[episodeIndex]!.play();
          }

          // 预加载相邻视频
          _preloadAdjacentVideos();

          // 创建历史记录
          createHistory();

          // 更新首页历史记录
          // updateHomeVideo();
        }

        if (!toRecharge) {
          // Message.show('Unlock successful');
        }
        return true;
      } else if (response.data['status'] == 'not_enough') {
        // 金币不足
        Message.show('Coin not enough');
        return false;
      } else if (response.data['status'] == 'jump') {
        Message.show('Cannot jump episode');
        return false;
      } else {
        return false;
      }
    } catch (e) {
      if (!toRecharge) {
        // EasyLoading.dismiss();
      }
      debugPrint('购买解锁失败: $e');
      return false;
    }
  }

  /// 刷新 MePageController 的用户信息
  void _refreshMePageUserInfo() {
    try {
      if (Get.isRegistered<MePageController>()) {
        final meController = Get.find<MePageController>();
        meController.getUserInfo();
        debugPrint('✅ 已刷新 MePageController 用户信息');
      }
    } catch (e) {
      debugPrint('刷新 MePageController 用户信息失败: $e');
    }
  }
}

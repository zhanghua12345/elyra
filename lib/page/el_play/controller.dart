import 'dart:convert';
import 'dart:io';
import 'package:elyra/bean/short_play_detail_bean.dart';
import 'package:elyra/bean/short_video_bean.dart';
import 'package:elyra/page/el_home/controller.dart';
import 'package:elyra/page/el_play/state.dart';
import 'package:elyra/request/http.dart';
import 'package:elyra/request/index.dart';
import 'package:elyra/utils/device_info.dart';
import 'package:elyra/utils/el_store.dart';
import 'package:elyra/utils/el_utils.dart';
import 'package:elyra/widgets/bad_status_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class PlayDetailController extends GetxController {
  final state = PlayDetailState();
  
  late final PageController pageController;
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
        state.loadStatus  = LoadStatusType.loadSuccess;
        state.detailBean = ShortPlayDetailBean.fromJson(res.data);
        
        if (state.videoId <= 0) {
          state.videoId = state.detailBean?.videoInfo?.id ?? 0;
        }
        
        state.episodeList = state.detailBean?.episodeList ?? [];
        currentIndex = (state.detailBean?.videoInfo?.episode ?? 1) - 1;
        state.currentEpisode = currentIndex;
        
        // 初始化视频控制器列表
        controllers = List<VideoPlayerController?>.filled(
          state.episodeList.length,
          null,
          growable: true,
        );
        
        // 初始化当前视频
        await _initializeController(currentIndex);
        _preloadAdjacentVideos();
        
        update();
      } else {
        state.loadStatus  = LoadStatusType.loadFailed;
        update();
      }
    } catch (e) {
      state.loadStatus  = LoadStatusType.loadFailed;
      update();
      debugPrint('获取视频详情失败: $e');
    }
  }

  /// 初始化视频控制器
  Future<void> _initializeController(int index) async {
    if (index < 0 || index >= state.episodeList.length) return;
    if (controllers[index] != null) return;

    final episode = state.episodeList[index];
    if (episode.videoUrl == null || episode.videoUrl!.isEmpty) return;

    VideoPlayerController controller = Platform.isAndroid &&
            DeviceInfoUtils().osVersion == '10'
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
      controller.setPlaybackSpeed(state.curSpeed);
      
      // 如果有历史播放记录，跳转到指定位置
      if (episode.playSeconds != null && episode.playSeconds!.isNotEmpty) {
        try {
          int seconds = int.parse(episode.playSeconds!);
          if (seconds > 0) {
            await controller.seekTo(Duration(milliseconds: seconds));
          }
        } catch (e) {
          debugPrint('解析播放进度失败: $e');
        }
      }
      
      // 添加监听器
      controller.addListener(() {
        if (currentIndex == index && !isClosed) {
          update();
        }
        
        // 视频播放完成，自动播放下一集
        if (controller.value.isCompleted && !controller.value.isBuffering) {
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

    // 初始化并播放新视频
    if (controllers[index] == null) {
      await _initializeController(index);
    } else {
      // 如果已经初始化，直接播放
      controllers[index]?.play();
    }

    // 跳转到对应页面
    if (isToggle && pageController.hasClients) {
      pageController.jumpToPage(index);
    }

    // 预加载相邻视频
    _preloadAdjacentVideos();
    
    // 创建历史记录
    createHistory();
    
    // 更新首页历史记录
    updateHomeVideo();

    update();
  }

  /// 自动播放下一集
  void _playNextEpisode() {
    if (currentIndex < state.episodeList.length - 1) {
      onEpisodeChanged(currentIndex + 1, isToggle: true);
    }
  }

  /// 收藏/取消收藏视频
  Future<void> toggleCollect() async {
    ShortPlayInfo? spInfo = state.detailBean?.shortPlayInfo;
    if (spInfo == null) return;

    try {
      Map<String, dynamic> params = {
        "short_play_id": spInfo.shortPlayId,
        "video_id": state.episodeList[currentIndex].id
      };

      if (spInfo.isCollect ?? false) {
        await HttpClient().request(Apis.cancelCollectVideo, data: params);
      } else {
        await HttpClient().request(Apis.collectVideo, data: params);
      }

      spInfo.isCollect = !(spInfo.isCollect ?? false);
      update();
    } catch (e) {
      debugPrint('收藏操作失败: $e');
    }
  }

  /// 创建历史记录
  void createHistory() {
    if (currentIndex < 0 || currentIndex >= state.episodeList.length) return;
    
    Map<String, dynamic> params = {
      "short_play_id": state.shortPlayId,
      "video_id": state.episodeList[currentIndex].id
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
  void updateHomeVideo() {
    try {
      final homeLogic = Get.put(HomeController());
      int playTime = controllers[currentIndex]?.value.position.inSeconds ?? 0;
      
      homeLogic.state.curVideo = ShortVideoBean()
        ..shortPlayId = state.shortPlayId
        ..imageUrl = state.detailBean?.shortPlayInfo?.imageUrl
        ..name = state.detailBean?.shortPlayInfo?.name
        ..playTime = playTime
        ..process = currentIndex + 1;
      
      homeLogic.update();
    } catch (e) {
      debugPrint('更新首页历史失败: $e');
    }
  }

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
}

import 'dart:io';

import 'package:elyra/bean/short_video_bean.dart';
import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/el_recommend/state.dart';
import 'package:elyra/request/http.dart';
import 'package:elyra/request/index.dart';
import 'package:elyra/utils/device_info.dart';
import 'package:elyra/utils/user_util.dart';
import 'package:elyra/widgets/el_confirm_modal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:elyra/widgets/bad_status_widget.dart';
import 'package:video_player/video_player.dart';

class RecommendPageController extends GetxController {
  final state = RecommendState();
  final RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );

  final followCtrl = RefreshController();
  bool isVisible = false;

  VideoPlayerController? videoCtrl;

  @override
  void onReady() {
    super.onReady();
    // 页面准备完成后执行的操作
    getRecommendData();
  }

  @override
  void onClose() {
    refreshController.dispose();
    videoCtrl?.dispose();
    super.onClose();
  }

  getRecommendData({
    RefreshController? refreshCtrl,
    bool loadMore = false,
  }) async {
    // 如果正在加载，或者加载更多时没有更多数据，则直接返回
    if (state.isLoading || (loadMore && !state.hasMore)) return;

    // 更新状态
    if (!loadMore) {
      state.loadStatus = LoadStatusType.loading;
    }
    state.isLoading = true;
    update();

    try {
      // 构造请求参数
      Map<String, dynamic> params = {
        'current_page': loadMore ? state.currentPage + 1 : 1,
        'page_size': state.pageSize,
      };

      ApiResponse response = await HttpClient().request(
        Apis.recommands, // 使用收藏列表接口
        method: HttpMethod.get,
        queryParameters: params,
      );

      if (refreshCtrl != null) {
        refreshCtrl.refreshCompleted();
      } else {
        refreshController.refreshCompleted();
      }

      if (response.success) {
        // 解析分页信息
        var pagination = response.data['pagination'];
        state.currentPage = pagination['current_page'] ?? 1;
        state.totalPages = pagination['page_total'] ?? 0;
        state.hasMore = state.currentPage < state.totalPages;

        if (loadMore) {
          // 加载更多数据
          if (response.data['list'] != null &&
              response.data['list'].length > 0) {
            try {
              List<ShortVideoBean> newItems = response.data['list']
                  .map<ShortVideoBean>((item) => ShortVideoBean.fromJson(item))
                  .toList();
              state.recommendList.addAll(newItems);
            } catch (e) {
              print('Error mapping new items: $e');
              // 如果解析失败，我们仍然更新状态以停止加载
              state.loadStatus = LoadStatusType.loadFailed;
            }
          }
        } else {
          // 刷新数据
          state.recommendList.clear();

          if (response.data['list'] != null &&
              response.data['list'].length > 0) {
            try {
              List<ShortVideoBean> newItems = response.data['list']
                  .map<ShortVideoBean>((item) => ShortVideoBean.fromJson(item))
                  .toList();
              state.recommendList = newItems;
              if (state.curVideoId == -1) {
                state.curVideo = state.recommendList.first;
                state.curVideoId = state.recommendList.first.id ?? -1;
              }
              setVideoUrl(state.curVideo.videoInfo?.videoUrl ?? '');
              state.loadStatus = LoadStatusType.loadSuccess;
            } catch (e) {
              print('Error mapping items: $e');
              state.loadStatus = LoadStatusType.loadFailed;
            }
          } else {
            state.loadStatus = LoadStatusType.loadNoData;
          }
        }
        update();
      } else {
        state.loadStatus = LoadStatusType.loadFailed;
        update();
      }
    } catch (e) {
      if (refreshCtrl != null) {
        refreshCtrl.refreshFailed();
      } else {
        refreshController.refreshFailed();
      }
      state.loadStatus = LoadStatusType.loadFailed;
      update();
    } finally {
      state.isLoading = false;
      if (refreshCtrl == null) {
        refreshController.loadComplete(); // 停止加载更多动画
      }
    }
  }

  setVideoUrl(String url, {int index = 0}) {
    videoCtrl?.dispose();
    try {
      videoCtrl =
          VideoPlayerController.networkUrl(
              Uri.parse(url),
              formatHint: VideoFormat.hls,
              viewType:
                  Platform.isAndroid && DeviceInfoUtils().osVersion == '10'
                  ? VideoViewType.platformView
                  : VideoViewType.textureView,
            )
            ..initialize()
                .then((_) {
                  if (isVisible) videoCtrl?.play();
                  update();
                })
                .catchError((e) {})
            ..addListener(() {
              if (videoCtrl?.value.isCompleted ?? false) {
                if (index != state.recommendList.length - 1) {
                  ShortVideoBean video = state.recommendList[index + 1];
                  state.curVideoId = video.id ?? -1;
                  state.curVideo = video;
                  setVideoUrl(
                    video.videoInfo?.videoUrl ?? '',
                    index: index + 1,
                  );
                  update();
                }
              }
            });
    } catch (e) {
      UserUtil().reportErrorEvent(
        'video initialize failed',
        UserUtil.videoError,
        shortPlayId: state.curVideo.shortPlayId ?? 0,
        shortPlayVideoId: state.curVideo.videoInfo!.id ?? 0,
        errMsg: e.toString(),
        payData: state.curVideo.toJson(),
      );
    }
  }

  void onRefresh() {
    state.recommendList.clear();
    getRecommendData();
  }

  void onLoadMore() {
    if (state.hasMore) {
      getRecommendData(loadMore: true);
    } else {
      refreshController.loadNoData(); // 没有更多数据
    }
  }

  /// 收藏视频
  Future<bool> collectVideo() async {
    try {
      // 检查当前视频是否存在
      if (state.curVideo.shortPlayId == null) {
        return false;
      }

      // 构造请求参数
      Map<String, dynamic> params = {
        'short_play_id': state.curVideo.shortPlayId,
      };

      // 如果视频信息存在，添加 video_id
      if (state.curVideo.videoInfo?.id != null) {
        params['video_id'] = state.curVideo.videoInfo?.id;
      }

      ApiResponse response = await HttpClient().request(
        Apis.collect,
        method: HttpMethod.post,
        data: params,
      );

      if (response.success) {
        // 更新本地状态
        state.curVideo.isCollect = true;
        state.curVideo.collectTotal = (state.curVideo.collectTotal ?? 0) + 1;
        update();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('收藏视频异常: $e');
      return false;
    }
  }

  /// 取消收藏视频
  Future<bool> cancelCollectVideo() async {
    try {
      // 检查当前视频是否存在
      if (state.curVideo.shortPlayId == null) {
        return false;
      }

      // 构造请求参数
      Map<String, dynamic> params = {
        'short_play_id': state.curVideo.shortPlayId,
      };

      ApiResponse response = await HttpClient().request(
        Apis.cancelCollect,
        method: HttpMethod.post,
        data: params,
      );

      if (response.success) {
        // 更新本地状态
        state.curVideo.isCollect = false;
        state.curVideo.collectTotal = (state.curVideo.collectTotal ?? 1) - 1;
        update();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('取消收藏视频异常: $e');
      return false;
    }
  }

  /// 切换收藏状态，返回是否成功
  Future<bool> toggleCollect(BuildContext context) async {
    final video = state.curVideo;

    // 未收藏 → 直接收藏
    if (video.isCollect != true) {
      final success = await collectVideo();
      if (success) {
        state.curVideo.isCollect = true;
        update();
      }
      return success;
    }

    // 已收藏 → 弹窗确认取消收藏
    return await _showCancelCollectModal(context);
  }

  /// 弹出取消收藏确认弹窗，并在接口成功后更新状态
  Future<bool> _showCancelCollectModal(BuildContext context) async {
    final video = state.curVideo;
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
          state.curVideo.isCollect = false;
          update();
        }
        result = success;
      },
    );

    return result;
  }
}

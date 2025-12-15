import 'dart:ui';
import 'package:elyra/bean/short_play_detail_bean.dart';
import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/el_play/controller.dart';
import 'package:elyra/page/el_play/sub_page/select/select_episode_page.dart';
import 'package:elyra/widgets/bad_status_widget.dart';
import 'package:elyra/widgets/el_nodata_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

/// 自定义垂直方向扩展的Slider Overlay Shape
class VerticalSliderOverlayShape extends SliderComponentShape {
  final double verticalPadding;

  const VerticalSliderOverlayShape({this.verticalPadding = 6.0});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(0, verticalPadding * 2);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    // 不绘制任何内容，只是扩展触摸区域
  }
}

class PlayDetailPage extends StatefulWidget {
  const PlayDetailPage({super.key});

  @override
  State<PlayDetailPage> createState() => _PlayDetailPageState();
}

class _PlayDetailPageState extends State<PlayDetailPage> {
  final controller = Get.put(PlayDetailController());

  @override
  void dispose() {
    // dispose时controller可能已被清理，不在这里上传进度
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        // 在页面退出前上传播放进度并更新本地历史记录
        if (didPop &&
            controller.controllers.isNotEmpty &&
            controller.currentIndex < controller.controllers.length) {
          final playSeconds =
              controller
                  .controllers[controller.currentIndex]
                  ?.value
                  .position
                  .inMilliseconds ??
              0;

          // 上传到服务器并保存到本地
          controller.uploadHistorySeconds(playSeconds);

          // 确保本地存储已更新（等待一小段时间确保写入完成）
          await Future.delayed(Duration(milliseconds: 50));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: GetBuilder<PlayDetailController>(
          builder: (ctrl) {
            return _buildContent();
          },
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (controller.state.loadStatus == LoadStatusType.loading) {
      return Center(
        child: Image.asset('loading.gif'.icon, width: 120, height: 120),
      );
    }

    if (controller.state.loadStatus == LoadStatusType.loadFailed) {
      return ElNoDataWidget(
        imagePath: 'ely_error.png',
        title: 'No connection',
        description: 'Please check your network',
        buttonText: 'Try again',
        onButtonPressed: controller.onRefresh,
      );
    }

    if (controller.state.loadStatus == LoadStatusType.loadNoData) {
      return ElNoDataWidget(
        imagePath: 'ely_nodata.png',
        imageWidth: 180,
        imageHeight: 223,
        title: null,
        description: 'There is no data for the moment.',
        buttonText: null,
      );
    }

    return _buildMainContent();
  }

  /// 主要内容
  Widget _buildMainContent() {
    String bgImageUrl = controller.state.imageUrl.isNotEmpty
        ? controller.state.imageUrl
        : (controller.state.detailBean?.shortPlayInfo?.imageUrl ?? '');

    return Stack(
      children: [
        // 背景模糊图片
        if (bgImageUrl.isNotEmpty)
          Image.network(
            bgImageUrl,
            width: ScreenUtil().screenWidth,
            height: ScreenUtil().screenHeight,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                Container(color: Colors.black),
          ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            color: Colors.black.withOpacity(0.3),
            width: ScreenUtil().screenWidth,
            height: ScreenUtil().screenHeight,
          ),
        ),

        // 加载指示器
        if (controller.state.detailBean == null)
          Center(
            child: Image.asset('loading.gif'.icon, width: 120, height: 120),
          ),

        // 视频列表
        PageView.builder(
          controller: controller.pageController,
          scrollDirection: Axis.vertical,
          onPageChanged: (index) => controller.onEpisodeChanged(index),
          itemCount: controller.state.episodeList.length,
          itemBuilder: (context, index) => _buildVideoPage(index),
        ),
      ],
    );
  }

  /// 单个视频页面
  Widget _buildVideoPage(int index) {
    if (controller.controllers.isEmpty ||
        index >= controller.controllers.length) {
      return Container();
    }

    final videoController = controller.controllers[index];
    final episode = controller.state.episodeList[index];

    return Stack(
      children: [
        // 视频播放器
        _buildVideoPlayer(index, videoController, episode),

        // 底部信息栏
        _buildBottomBar(index, videoController, episode),

        // 顶部导航栏
        _buildTopBar(),
      ],
    );
  }

  /// 视频播放器
  Widget _buildVideoPlayer(
    int index,
    VideoPlayerController? videoController,
    EpisodeList episode,
  ) {
    if (videoController == null || !videoController.value.isInitialized) {
      return _buildLoadingPlaceholder();
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (videoController.value.isPlaying) {
          videoController.pause();
        } else {
          videoController.play();
        }
        setState(() {});
      },
      child: Container(
        width: ScreenUtil().screenWidth,
        height: ScreenUtil().screenHeight,
        color: Colors.black,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 视频内容 - 使用SizedBox.expand铺满全屏幕并裁切
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: videoController.value.size.width,
                  height: videoController.value.size.height,
                  child: VideoPlayer(videoController),
                ),
              ),
            ),

            // 缓冲指示器
            if (videoController.value.isBuffering)
              Image.asset('loading.gif'.icon, width: 120, height: 120),

            // 播放/暂停按钮
            if (!videoController.value.isPlaying &&
                !videoController.value.isBuffering)
              Icon(Icons.play_circle_outline, color: Colors.white, size: 60.w),
          ],
        ),
      ),
    );
  }

  /// 加载占位符
  Widget _buildLoadingPlaceholder() {
    String bgImageUrl = controller.state.imageUrl.isNotEmpty
        ? controller.state.imageUrl
        : (controller.state.detailBean?.shortPlayInfo?.imageUrl ?? '');

    return Stack(
      children: [
        if (bgImageUrl.isNotEmpty)
          Image.network(
            bgImageUrl,
            width: ScreenUtil().screenWidth,
            height: ScreenUtil().screenHeight,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                Container(color: Colors.black),
          ),
        Center(child: Image.asset('loading.gif'.icon, width: 120, height: 120)),
      ],
    );
  }

  /// 底部信息栏
  Widget _buildBottomBar(
    int index,
    VideoPlayerController? videoController,
    EpisodeList episode,
  ) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        minimum: EdgeInsets.only(bottom: 16.h), // 只加你自己的 padding
        child: _buildBottomContent(videoController, episode),
      ),
    );
  }

  /// 底部内容
  Widget _buildBottomContent(
    VideoPlayerController? videoController,
    EpisodeList episode,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // 收藏按钮
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () async {
                  // 确保当前视频是这个
                  final success = await controller.toggleCollect(context);
                  if (success) {
                    setState(() {});
                  }
                },
                child: Container(
                  child: Image.asset(
                    controller.state.detailBean?.shortPlayInfo?.isCollect ==
                            true
                        ? 'ely_collect.png'.icon
                        : 'ely_collect_cancle.png'.icon,
                    width: 36.w,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 50.h),
          // 标题
          SizedBox(
            width: 273.w,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.state.detailBean?.shortPlayInfo?.name ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'PingFang SC',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 5.h),
                // 描述
                if (controller
                        .state
                        .detailBean
                        ?.shortPlayInfo
                        ?.description
                        ?.isNotEmpty ==
                    true) ...[
                  Text(
                    controller.state.detailBean!.shortPlayInfo!.description!,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.80),
                      fontSize: 12,
                      fontFamily: 'PingFang SC',
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5.h),
                ],
              ],
            ),
          ),

          // 进度条
          if (videoController != null && videoController.value.isInitialized)
            _buildProgressBar(videoController),
          SizedBox(height: 9.w),
          // 底部集数
          _buildBottomControls(videoController, episode),
        ],
      ),
    );
  }

  /// 进度条
  Widget _buildProgressBar(VideoPlayerController videoController) {
    final duration = videoController.value.duration;
    final position = videoController.value.position;
    final progress = duration.inMilliseconds > 0
        ? position.inMilliseconds / duration.inMilliseconds
        : 0.0;
    return Row(
      children: [
        Expanded(
          child: SliderTheme(
            data: SliderThemeData(
              trackHeight: 3.w,
              thumbShape: SliderComponentShape.noThumb,
              // 使用自定义的垂直扩展overlay shape
              overlayShape: VerticalSliderOverlayShape(verticalPadding: 6.h),
              activeTrackColor: Color(0xFFDC23B1),
              inactiveTrackColor: Colors.white.withOpacity(0.2),
              overlayColor: Colors.transparent,
            ),
            child: Slider(
              value: progress.clamp(0.0, 1.0),
              onChanged: (value) {
                final seekPosition = duration * value;
                videoController.seekTo(seekPosition);
                setState(() {});
              },
            ),
          ),
        ),
      ],
    );
  }

  /// 底部控制条
  Widget _buildBottomControls(
    VideoPlayerController? videoController,
    EpisodeList episode,
  ) {
    return Column(
      children: [
        GestureDetector(
          onTap: _showEpisodeSelector,
          child: Container(
            width: 341.w,
            height: 24.w,
            decoration: ShapeDecoration(
              color: Colors.white.withValues(alpha: 0.20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(68.w), // 设计稿的 "pill" 圆角
              ),
            ),

            padding: EdgeInsets.symmetric(horizontal: 16.w),

            child: Row(
              children: [
                Text(
                  'Ep.${controller.currentIndex + 1}/Ep.${controller.state.episodeList.length}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: 'PingFang SC',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Spacer(),
                Image.asset('ely_top_arrow.png'.icon, width: 14.w),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// 顶部导航栏
  Widget _buildTopBar() {
    return Positioned(
      top: ScreenUtil().statusBarHeight,
      left: 0,
      right: 0,
      child: Padding(
        padding: EdgeInsets.only(left: 11.w, right: 16.w, top:4.h),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => Get.back(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 返回按钮
              Padding(
                padding: EdgeInsets.all(5.w), // 扩大点击热区
                child: Image.asset('ely_back.png'.icon, height: 20.h),
              ),
              Text(
                'Ep.${controller.currentIndex + 1}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'PingFang SC',
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 显示选集弹窗
  void _showEpisodeSelector() {
    Get.bottomSheet(
      SelectEpisodePage(
        totalEpisodes: controller.state.episodeList.length,
        initialEpisode: controller.currentIndex + 1,
        shortPlayInfo: controller.state.detailBean?.shortPlayInfo,
        episodeList: controller.state.episodeList,
        onEpisodeSelected: (episode) {
          Get.back();
          controller.onEpisodeChanged(episode - 1, isToggle: true);
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}

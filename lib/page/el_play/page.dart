import 'dart:io';
import 'dart:ui';
import 'package:elyra/bean/short_play_detail_bean.dart';
import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/el_play/controller.dart';
import 'package:elyra/page/el_play/sub_page/select/select_episode_page.dart';
import 'package:elyra/utils/el_color.dart';
import 'package:elyra/widgets/bad_status_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class PlayDetailPage extends StatefulWidget {
  const PlayDetailPage({super.key});

  @override
  State<PlayDetailPage> createState() => _PlayDetailPageState();
}

class _PlayDetailPageState extends State<PlayDetailPage> {
  final logic = Get.put(PlayDetailController());
  bool _isPageVisible = true;

  @override
  void dispose() {
    // 上传最后的播放进度
    if (logic.controllers.isNotEmpty &&
        logic.currentIndex < logic.controllers.length) {
      logic.uploadHistorySeconds(
        logic.controllers[logic.currentIndex]?.value.position.inMilliseconds ??
            0,
      );
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        if (logic.controllers.isNotEmpty &&
            logic.currentIndex < logic.controllers.length) {
          logic.uploadHistorySeconds(
            logic
                    .controllers[logic.currentIndex]
                    ?.value
                    .position
                    .inMilliseconds ??
                0,
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: GetBuilder<PlayDetailController>(
          builder: (ctrl) {
            if (logic.videoStatus == LoadStatusType.loadFailed) {
              return _buildErrorPage();
            }
            return _buildMainContent();
          },
        ),
      ),
    );
  }

  /// 错误页面
  Widget _buildErrorPage() {
    return Container(
      width: ScreenUtil().screenWidth,
      height: ScreenUtil().screenHeight,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: kToolbarHeight + 20.w),
            child: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(Icons.arrow_back_outlined, size: 28),
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'ely_error.png'.icon,
                    width: 180.w,
                    height: 180.w,
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    'No connection',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Please check your network',
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                  ),
                  SizedBox(height: 30.h),
                  ElevatedButton(
                    onPressed: logic.getVideoDetails,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorEnum.mainColor,
                      padding: EdgeInsets.symmetric(
                        horizontal: 40.w,
                        vertical: 12.h,
                      ),
                    ),
                    child: Text(
                      'Try again',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 主要内容
  Widget _buildMainContent() {
    String bgImageUrl = logic.state.imageUrl.isNotEmpty
        ? logic.state.imageUrl
        : (logic.state.detailBean?.shortPlayInfo?.imageUrl ?? '');

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
        if (logic.state.detailBean == null)
          Center(child: CircularProgressIndicator(color: ColorEnum.mainColor)),

        // 视频列表
        PageView.builder(
          controller: logic.pageController,
          scrollDirection: Axis.vertical,
          onPageChanged: (index) => logic.onEpisodeChanged(index),
          itemCount: logic.state.episodeList.length,
          itemBuilder: (context, index) => _buildVideoPage(index),
        ),
      ],
    );
  }

  /// 单个视频页面
  Widget _buildVideoPage(int index) {
    if (logic.controllers.isEmpty || index >= logic.controllers.length) {
      return Container();
    }

    final controller = logic.controllers[index];
    final episode = logic.state.episodeList[index];

    return Stack(
      children: [
        // 视频播放器
        _buildVideoPlayer(index, controller, episode),

        // 底部信息栏
        _buildBottomBar(index, controller, episode),

        // 顶部导航栏
        _buildTopBar(),
      ],
    );
  }

  /// 视频播放器
  Widget _buildVideoPlayer(
    int index,
    VideoPlayerController? controller,
    EpisodeList episode,
  ) {
    if (controller == null || !controller.value.isInitialized) {
      return _buildLoadingPlaceholder();
    }

    return GestureDetector(
      onTap: () {
        if (controller.value.isPlaying) {
          controller.pause();
        } else {
          controller.play();
        }
        setState(() {});
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: FittedBox(
              fit: BoxFit.cover,
              child: VisibilityDetector(
                key: Key('video-$index'),
                onVisibilityChanged: (VisibilityInfo info) {
                  var visiblePercentage = info.visibleFraction * 100;
                  if (visiblePercentage > 20 && logic.currentIndex == index) {
                    _isPageVisible = true;
                    controller.play();
                  } else {
                    _isPageVisible = false;
                    controller.pause();
                  }
                },
                child: SizedBox(
                  width: controller.value.size.width,
                  height: controller.value.size.height,
                  child: VideoPlayer(controller),
                ),
              ),
            ),
          ),

          // 缓冲指示器
          if (controller.value.isBuffering)
            CircularProgressIndicator(color: ColorEnum.mainColor),

          // 播放/暂停按钮
          if (!controller.value.isPlaying && !controller.value.isBuffering)
            Icon(Icons.play_circle_outline, color: Colors.white, size: 60.w),
        ],
      ),
    );
  }

  /// 加载占位符
  Widget _buildLoadingPlaceholder() {
    String bgImageUrl = logic.state.imageUrl.isNotEmpty
        ? logic.state.imageUrl
        : (logic.state.detailBean?.shortPlayInfo?.imageUrl ?? '');

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
        Center(child: CircularProgressIndicator(color: ColorEnum.mainColor)),
      ],
    );
  }

  /// 底部信息栏
  Widget _buildBottomBar(
    int index,
    VideoPlayerController? controller,
    EpisodeList episode,
  ) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        minimum: EdgeInsets.only(bottom: 16.h), // 只加你自己的 padding
        child: _buildBottomContent(controller, episode),
      ),
    );
  }

  /// 底部内容
  Widget _buildBottomContent(
    VideoPlayerController? controller,
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
                onTap: logic.toggleCollect,
                child: Container(
                  child: Image.asset(
                    logic.state.detailBean?.shortPlayInfo?.isCollect == true
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
          Text(
            logic.state.detailBean?.shortPlayInfo?.name ?? '',
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
          // 进度条
          if (controller != null && controller.value.isInitialized)
            _buildProgressBar(controller),
          SizedBox(height: 15.w),
          // 底部集数
          _buildBottomControls(controller, episode),
        ],
      ),
    );
  }

  /// 进度条
  Widget _buildProgressBar(VideoPlayerController controller) {
    final duration = controller.value.duration;
    final position = controller.value.position;
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
              overlayShape: SliderComponentShape.noOverlay,
              activeTrackColor: Color(0xFFDC23B1),
              inactiveTrackColor: Colors.white.withOpacity(0.2),
            ),
            child: Slider(
              value: progress.clamp(0.0, 1.0),
              onChanged: (value) {
                final seekPosition = duration * value;
                controller.seekTo(seekPosition);
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
    VideoPlayerController? controller,
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
                  'Ep.${logic.currentIndex + 1}/Ep.${logic.state.episodeList.length}',
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
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // 返回按钮
            GestureDetector(
              onTap: () => Get.back(),
              child: Image.asset('ely_back.png'.icon, width: 20.w),
            ),
            SizedBox(width: 6.w),
            Text(
              'Ep.${logic.currentIndex + 1}',
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
    );
  }

  /// 显示选集弹窗
  void _showEpisodeSelector() {
    Get.bottomSheet(
      SelectEpisodePage(
        totalEpisodes: logic.state.episodeList.length,
        initialEpisode: logic.currentIndex + 1,
        shortPlayInfo: logic.state.detailBean?.shortPlayInfo,
        episodeList: logic.state.episodeList,
        onEpisodeSelected: (episode) {
          Get.back();
          logic.onEpisodeChanged(episode - 1, isToggle: true);
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}

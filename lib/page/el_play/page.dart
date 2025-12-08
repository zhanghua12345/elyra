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
    if (logic.controllers.isNotEmpty && logic.currentIndex < logic.controllers.length) {
      logic.uploadHistorySeconds(
        logic.controllers[logic.currentIndex]?.value.position.inMilliseconds ?? 0,
      );
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        if (logic.controllers.isNotEmpty && logic.currentIndex < logic.controllers.length) {
          logic.uploadHistorySeconds(
            logic.controllers[logic.currentIndex]?.value.position.inMilliseconds ?? 0,
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
                  Image.asset('ely_error.png'.icon, width: 180.w, height: 180.w),
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
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 30.h),
                  ElevatedButton(
                    onPressed: logic.getVideoDetails,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorEnum.mainColor,
                      padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
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
            errorBuilder: (context, error, stackTrace) => Container(color: Colors.black),
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
          Center(
            child: CircularProgressIndicator(color: ColorEnum.mainColor),
          ),

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
            Icon(
              Icons.play_circle_outline,
              color: Colors.white,
              size: 60.w,
            ),
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
            errorBuilder: (context, error, stackTrace) => Container(color: Colors.black),
          ),
        Center(
          child: CircularProgressIndicator(color: ColorEnum.mainColor),
        ),
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
      child: Platform.isAndroid
          ? SafeArea(child: _buildBottomContent(controller, episode))
          : _buildBottomContent(controller, episode),
    );
  }

  /// 底部内容
  Widget _buildBottomContent(
    VideoPlayerController? controller,
    EpisodeList episode,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0),
            Colors.black.withOpacity(0.3),
            Colors.black.withOpacity(0.6),
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题
          Text(
            logic.state.detailBean?.shortPlayInfo?.name ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10.w),
          
          // 进度条
          if (controller != null && controller.value.isInitialized)
            _buildProgressBar(controller),
          SizedBox(height: 10.w),
          
          // 底部控制条（集数选择和倍速）
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
        // 当前时间
        Text(
          _formatDuration(position),
          style: TextStyle(fontSize: 12.sp, color: Colors.white),
        ),
        SizedBox(width: 8.w),
        
        // 进度条
        Expanded(
          child: SliderTheme(
            data: SliderThemeData(
              trackHeight: 3.w,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.w),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 12.w),
              activeTrackColor: ColorEnum.mainColor,
              inactiveTrackColor: Colors.white.withOpacity(0.3),
              thumbColor: ColorEnum.mainColor,
              overlayColor: ColorEnum.mainColor.withOpacity(0.3),
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
        SizedBox(width: 8.w),
        
        // 总时长
        Text(
          _formatDuration(duration),
          style: TextStyle(fontSize: 12.sp, color: Colors.white),
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
        // 集数信息和向上箭头
        GestureDetector(
          onTap: _showEpisodeSelector,
          child: Container(
            width: 341.w,
            height: 24.w,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12.w),
            ),
            child: Row(
              children: [
                Text(
                  'Ep.${logic.currentIndex + 1}/Ep.${logic.state.episodeList.length}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white,
                  ),
                ),
                Spacer(),
                Image.asset(
                  'ely_top_arrow.png'.icon,
                  width: 16.w,
                  height: 16.w,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10.w),
        
        // 选集和倍速按钮
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 选集按钮
            GestureDetector(
              onTap: _showEpisodeSelector,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.w),
                  color: Color(0xFF949494).withOpacity(0.4),
                ),
                child: Row(
                  children: [
                    // Image.asset('ely_episode.png'.icon, width: 14.w),
                    SizedBox(width: 6.w),
                    Text(
                      'EP.${logic.currentIndex + 1}',
                      style: TextStyle(fontSize: 13.sp, color: Colors.white),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      'All ${logic.state.detailBean?.shortPlayInfo?.episodeTotal ?? 0} Episodes',
                      style: TextStyle(fontSize: 13.sp, color: Color(0xFFBEBEBE)),
                    ),
                  ],
                ),
              ),
            ),
            
            // 倍速按钮
            GestureDetector(
              onTap: _showSpeedSelector,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.w),
                  color: Color(0xFF949494).withOpacity(0.4),
                ),
                child: Text(
                  '${logic.state.curSpeed}x',
                  style: TextStyle(fontSize: 13.sp, color: Colors.white),
                ),
              ),
            ),
          ],
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
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 返回按钮
            GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                padding: EdgeInsets.all(8.w),
                child: Image.asset('ely_back.png'.icon, width: 24.w),
              ),
            ),
            
            // 收藏按钮
            GestureDetector(
              onTap: logic.toggleCollect,
              child: Container(
                padding: EdgeInsets.all(8.w),
                child: Image.asset(
                  logic.state.detailBean?.shortPlayInfo?.isCollect == true
                      ? 'ely_collect.png'.icon
                      : 'ely_collect_cancle.png'.icon,
                  width: 24.w,
                ),
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

  /// 显示倍速选择弹窗
  void _showSpeedSelector() {
    Get.bottomSheet(
      Container(
        height: 165.w,
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.w)),
          gradient: LinearGradient(
            colors: [Colors.white, ColorEnum.mainColor.withOpacity(0.08)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Speed',
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Image.asset('ely_close.png'.icon, width: 24.w),
                ),
              ],
            ),
            SizedBox(height: 15.w),
            SizedBox(
              height: 60.w,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final speed = logic.state.speeds[index];
                  final isSelected = speed == logic.state.curSpeed;
                  
                  return GestureDetector(
                    onTap: () {
                      logic.changeSpeed(speed);
                      Get.back();
                    },
                    child: Container(
                      width: 70.w,
                      height: 54.w,
                      alignment: Alignment.center,
                      decoration: isSelected
                          ? BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  ColorEnum.mainColor,
                                  ColorEnum.mainColor.withOpacity(0.8),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(6.w),
                              border: Border.all(
                                color: ColorEnum.mainColor,
                                width: 1.5,
                              ),
                            )
                          : BoxDecoration(
                              borderRadius: BorderRadius.circular(6.w),
                              color: ColorEnum.mainColor.withOpacity(0.12),
                            ),
                      child: Text(
                        '${speed}x',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (_, __) => SizedBox(width: 10.w),
                itemCount: logic.state.speeds.length,
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  /// 格式化时长
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '$hours:${twoDigits(minutes)}:${twoDigits(seconds)}';
    }
    return '${twoDigits(minutes)}:${twoDigits(seconds)}';
  }
}

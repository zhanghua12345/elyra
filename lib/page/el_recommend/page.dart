import 'dart:ui';
import 'package:elyra/bean/short_video_bean.dart';
import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/el_recommend/controller.dart';
import 'package:elyra/routers/el_routers.dart';
import 'package:elyra/utils/el_color.dart';
import 'package:elyra/widgets/bad_status_widget.dart';
import 'package:elyra/widgets/el_nodata_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class RecommendPage extends StatefulWidget {
  const RecommendPage({super.key});

  @override
  State<RecommendPage> createState() => _RecommendPageState();
}

class _RecommendPageState extends State<RecommendPage> with AutomaticKeepAliveClientMixin {
  late final RecommendPageController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(RecommendPageController());
    // 添加视频播放器监听器，用于更新进度条
    _setupVideoListener();
  }

  void _setupVideoListener() {
    // 定期检查视频控制器状态并更新UI
    Future.delayed(Duration(milliseconds: 100), () {
      if (mounted && controller.videoCtrl != null) {
        controller.videoCtrl!.addListener(() {
          if (mounted) {
            setState(() {});
          }
        });
      }
      if (mounted) {
        _setupVideoListener();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<RecommendPageController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: _buildContent(),
        );
      },
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

  Widget _buildMainContent() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // 背景视频播放器
        _buildVideoPlayer(),
        
        // 底部信息栏
        _buildBottomInfo(),
        
        // 右侧收藏按钮
        _buildCollectButton(),
      ],
    );
  }

  /// 构建视频播放器
  Widget _buildVideoPlayer() {
    return SizedBox(
      width: ScreenUtil().screenWidth,
      height: ScreenUtil().screenHeight,
      child: controller.videoCtrl != null && controller.videoCtrl!.value.isInitialized
          ? GestureDetector(
              onTap: () {
                if (controller.videoCtrl!.value.isPlaying) {
                  controller.videoCtrl!.pause();
                } else {
                  controller.videoCtrl!.play();
                }
                setState(() {});
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 视频内容
                  Positioned.fill(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: VisibilityDetector(
                        key: Key('recommend-video-${controller.state.curVideoId}'),
                        onVisibilityChanged: (VisibilityInfo info) {
                          var visiblePercentage = info.visibleFraction * 100;
                          controller.isVisible = visiblePercentage > 20;
                          if (visiblePercentage > 20) {
                            controller.videoCtrl?.play();
                          } else {
                            controller.videoCtrl?.pause();
                          }
                          controller.update();
                        },
                        child: SizedBox(
                          width: controller.videoCtrl!.value.size.width,
                          height: controller.videoCtrl!.value.size.height,
                          child: VideoPlayer(controller.videoCtrl!),
                        ),
                      ),
                    ),
                  ),
                  
                  // 播放/暂停图标
                  if (_isVideoPaused)
                    Image.asset('play.png'.icon, width: 48.w),
                  if (_isVideoBuffering)
                    CircularProgressIndicator(color: ColorEnum.mainColor),
                ],
              ),
            )
          : Stack(
              alignment: Alignment.center,
              children: [
                if (controller.state.curVideo.imageUrl != null)
                  Image.network(
                    controller.state.curVideo.imageUrl!,
                    width: ScreenUtil().screenWidth,
                    height: ScreenUtil().screenHeight,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(color: Colors.black);
                    },
                  ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    color: Colors.black.withOpacity(0.3),
                  ),
                ),
                CircularProgressIndicator(color: ColorEnum.mainColor),
              ],
            ),
    );
  }

  /// 构建底部信息栏（标题、描述、进度条）
  Widget _buildBottomInfo() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: GestureDetector(
        onTap: () {
          // 暂停视频
          controller.videoCtrl?.pause();
          // TODO: 跳转到视频详情页（需要实现短视频详情页路由）
          // Get.toNamed(
          //   AppRoutes.shortVideo, // 需要在路由中添加此路由
          //   arguments: {
          //     'shortPlayId': controller.state.curVideo.shortPlayId,
          //     'imageUrl': controller.state.curVideo.imageUrl ?? '',
          //   },
          // )?.then((value) {
          //   // 返回后继续播放
          //   controller.videoCtrl?.play();
          // });
          
          // 临时处理：直接恢复播放
          Future.delayed(Duration(milliseconds: 100), () {
            controller.videoCtrl?.play();
          });
        },
        child: Container(
          color: Colors.transparent,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 标题
              Text(
                controller.state.curVideo.name ?? '',
                style: TextStyle(
                  fontSize: 18.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.5),
                      offset: Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8.w),
              // 描述
              Text(
                controller.state.curVideo.description ?? '',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white.withOpacity(0.8),
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.5),
                      offset: Offset(0, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 12.w),
              // 进度条
              _buildProgressBar(),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建进度条
  Widget _buildProgressBar() {
    if (controller.videoCtrl == null || !controller.videoCtrl!.value.isInitialized) {
      return SizedBox.shrink();
    }

    final duration = controller.videoCtrl!.value.duration;
    final position = controller.videoCtrl!.value.position;
    final progress = duration.inMilliseconds > 0 
        ? position.inMilliseconds / duration.inMilliseconds 
        : 0.0;

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        // 计算拖动的位置
        final RenderBox box = context.findRenderObject() as RenderBox;
        final localPosition = box.globalToLocal(details.globalPosition);
        final width = box.size.width - 32.w; // 减去左右padding
        final seekProgress = (localPosition.dx - 16.w) / width;
        final seekPosition = duration * seekProgress.clamp(0.0, 1.0);
        
        // 暂停并跳转到指定位置
        controller.videoCtrl?.seekTo(seekPosition);
      },
      onHorizontalDragEnd: (details) {
        // 拖动结束后继续播放
        controller.videoCtrl?.play();
      },
      child: Row(
        children: [
          // 当前时间
          Text(
            _formatDuration(position),
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.5),
                  offset: Offset(0, 1),
                  blurRadius: 2,
                ),
              ],
            ),
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
                  controller.videoCtrl?.seekTo(seekPosition);
                  setState(() {});
                },
                onChangeStart: (value) {
                  controller.videoCtrl?.pause();
                },
                onChangeEnd: (value) {
                  controller.videoCtrl?.play();
                },
              ),
            ),
          ),
          SizedBox(width: 8.w),
          // 总时长
          Text(
            _formatDuration(duration),
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.5),
                  offset: Offset(0, 1),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 构建收藏按钮
  Widget _buildCollectButton() {
    return Positioned(
      right: 16.w,
      bottom: 120.w,
      child: GestureDetector(
        onTap: () async {
          await controller.toggleCollect();
          setState(() {});
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              controller.state.curVideo.isCollect == true 
                  ? 'ely_collect.png'.icon 
                  : 'ely_collect_cancle.png'.icon,
              width: 40.w,
              height: 40.w,
            ),
            SizedBox(height: 4.w),
            Text(
              '${controller.state.curVideo.collectTotal ?? 0}',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white,
                fontWeight: FontWeight.w500,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.5),
                    offset: Offset(0, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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

  /// 判断视频是否暂停
  bool get _isVideoPaused => !(controller.videoCtrl?.value.isPlaying ?? false);

  /// 判断视频是否缓冲中
  bool get _isVideoBuffering => controller.videoCtrl?.value.isBuffering ?? false;

  @override
  bool get wantKeepAlive => true;
}
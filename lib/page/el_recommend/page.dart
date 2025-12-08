import 'dart:io';
import 'dart:ui';
import 'package:elyra/bean/short_video_bean.dart';
import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/el_recommend/controller.dart';
import 'package:elyra/routers/el_routers.dart';
import 'package:elyra/utils/device_info.dart';
import 'package:elyra/utils/el_color.dart';
import 'package:elyra/widgets/bad_status_widget.dart';
import 'package:elyra/widgets/el_nodata_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class RecommendPage extends StatefulWidget {
  const RecommendPage({super.key});

  @override
  State<RecommendPage> createState() => _RecommendPageState();
}

class _RecommendPageState extends State<RecommendPage> with AutomaticKeepAliveClientMixin {
  late final RecommendPageController controller;
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;
  final Map<int, VideoPlayerController> _videoControllers = {};
  final Map<int, bool> _videoInitialized = {};

  @override
  void initState() {
    super.initState();
    controller = Get.put(RecommendPageController());
    // 监听页面切换
    _pageController.addListener(_onPageChanged);
  }

  void _onPageChanged() {
    final page = _pageController.page?.round() ?? 0;
    if (page != _currentPageIndex) {
      // 暂停之前的视频
      _pauseVideo(_currentPageIndex);
      // 更新当前页面索引
      setState(() {
        _currentPageIndex = page;
      });
      // 播放当前视频
      _playCurrentVideo();
      // 更新controller状态
      if (page < controller.state.recommendList.length) {
        controller.state.curVideo = controller.state.recommendList[page];
        controller.state.curVideoId = controller.state.curVideo.id ?? -1;
        controller.update();
      }
    }
  }

  void _playCurrentVideo() {
    if (_currentPageIndex < controller.state.recommendList.length) {
      final video = controller.state.recommendList[_currentPageIndex];
      _initializeAndPlayVideo(_currentPageIndex, video);
    }
  }

  void _pauseVideo(int index) {
    _videoControllers[index]?.pause();
  }

  void _initializeAndPlayVideo(int index, ShortVideoBean video) {
    if (_videoControllers[index] != null && _videoInitialized[index] == true) {
      _videoControllers[index]?.play();
      return;
    }

    final videoUrl = video.videoInfo?.videoUrl ?? '';
    if (videoUrl.isEmpty) return;

    final videoCtrl = VideoPlayerController.networkUrl(
      Uri.parse(videoUrl),
      formatHint: VideoFormat.hls,
      viewType: Platform.isAndroid && DeviceInfoUtils().osVersion == '10'
          ? VideoViewType.platformView
          : VideoViewType.textureView,
    )
      ..initialize().then((_) {
        if (mounted) {
          setState(() {
            _videoInitialized[index] = true;
          });
          if (_currentPageIndex == index) {
            _videoControllers[index]?.play();
          }
        }
      })
      ..setLooping(true) // 循环播放
      ..addListener(() {
        if (mounted && _currentPageIndex == index) {
          setState(() {}); // 更新进度条
        }
      });

    _videoControllers[index] = videoCtrl;
  }

  @override
  void dispose() {
    _pageController.dispose();
    // 释放所有视频控制器
    for (var controller in _videoControllers.values) {
      controller.dispose();
    }
    _videoControllers.clear();
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
        child: CircularProgressIndicator(color: ColorEnum.mainColor),
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
    // 初始化第一个视频
    if (controller.state.recommendList.isNotEmpty && _videoControllers.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _playCurrentVideo();
      });
    }

    return PageView.builder(
      controller: _pageController,
      scrollDirection: Axis.vertical,
      itemCount: controller.state.recommendList.length,
      onPageChanged: (index) {
        // 预加载下一个视频
        if (index + 1 < controller.state.recommendList.length) {
          final nextVideo = controller.state.recommendList[index + 1];
          _initializeAndPlayVideo(index + 1, nextVideo);
        }
      },
      itemBuilder: (context, index) {
        return _buildVideoItem(index);
      },
    );
  }

  /// 构建单个视频项
  Widget _buildVideoItem(int index) {
    final video = controller.state.recommendList[index];
    final videoCtrl = _videoControllers[index];
    final isInitialized = _videoInitialized[index] ?? false;

    return Stack(
      children: [
        // 视频播放器
        _buildVideoPlayer(index, video, videoCtrl, isInitialized),
        
        // 底部信息栏
        _buildBottomInfo(index, video, videoCtrl, isInitialized),
        
        // 右侧收藏按钮
        _buildCollectButton(index, video),
      ],
    );
  }

  /// 构建视频播放器
  Widget _buildVideoPlayer(int index, ShortVideoBean video, VideoPlayerController? videoCtrl, bool isInitialized) {
    return GestureDetector(
      onTap: () {
        // 点击视频区域：播放/暂停
        if (videoCtrl != null && isInitialized) {
          setState(() {
            if (videoCtrl.value.isPlaying) {
              videoCtrl.pause();
            } else {
              videoCtrl.play();
            }
          });
        }
      },
      child: Container(
        width: ScreenUtil().screenWidth,
        height: ScreenUtil().screenHeight,
        color: Colors.black,
        child: videoCtrl != null && isInitialized
            ? Stack(
                alignment: Alignment.center,
                children: [
                  // 视频内容
                  Positioned.fill(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: videoCtrl.value.size.width,
                        height: videoCtrl.value.size.height,
                        child: VideoPlayer(videoCtrl),
                      ),
                    ),
                  ),
                  
                  // 播放/暂停图标
                  if (!videoCtrl.value.isPlaying && !videoCtrl.value.isBuffering)
                    Image.asset('play.png'.icon, width: 48.w),
                  if (videoCtrl.value.isBuffering)
                    CircularProgressIndicator(color: ColorEnum.mainColor),
                ],
              )
            : Stack(
                alignment: Alignment.center,
                children: [
                  if (video.imageUrl != null)
                    Image.network(
                      video.imageUrl!,
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
      ),
    );
  }

  /// 构建底部信息栏（标题、描述、进度条）
  Widget _buildBottomInfo(int index, ShortVideoBean video, VideoPlayerController? videoCtrl, bool isInitialized) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: GestureDetector(
        onTap: () {
          // 点击底部信息栏：跳转到详情页
          videoCtrl?.pause();
          // TODO: 跳转到视频详情页（需要实现短视频详情页路由）
          // Get.toNamed(
          //   AppRoutes.shortVideo,
          //   arguments: {
          //     'shortPlayId': video.shortPlayId,
          //     'imageUrl': video.imageUrl ?? '',
          //   },
          // )?.then((value) {
          //   videoCtrl?.play();
          // });
          
          // 临时处理：直接恢复播放
          Future.delayed(Duration(milliseconds: 100), () {
            videoCtrl?.play();
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
                video.name ?? '',
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
                video.description ?? '',
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
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 12.w),
              // 进度条
              _buildProgressBar(videoCtrl, isInitialized),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建进度条
  Widget _buildProgressBar(VideoPlayerController? videoCtrl, bool isInitialized) {
    if (videoCtrl == null || !isInitialized) {
      return SizedBox.shrink();
    }

    final duration = videoCtrl.value.duration;
    final position = videoCtrl.value.position;
    final progress = duration.inMilliseconds > 0 
        ? position.inMilliseconds / duration.inMilliseconds 
        : 0.0;

    return Row(
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
                videoCtrl.seekTo(seekPosition);
                setState(() {});
              },
              onChangeStart: (value) {
                videoCtrl.pause();
              },
              onChangeEnd: (value) {
                videoCtrl.play();
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
    );
  }

  /// 构建收藏按钮
  Widget _buildCollectButton(int index, ShortVideoBean video) {
    return Positioned(
      right: 16.w,
      bottom: 180.w,
      child: GestureDetector(
        onTap: () async {
          // 确保当前视频是这个
          controller.state.curVideo = video;
          controller.state.curVideoId = video.id ?? -1;
          await controller.toggleCollect();
          setState(() {});
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              video.isCollect == true 
                  ? 'ely_collect.png'.icon 
                  : 'ely_collect_cancle.png'.icon,
              width: 40.w,
              height: 40.w,
            ),
            SizedBox(height: 4.w),
            Text(
              '${video.collectTotal ?? 0}',
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

  @override
  bool get wantKeepAlive => true;
}

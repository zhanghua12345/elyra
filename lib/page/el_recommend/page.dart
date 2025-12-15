import 'dart:io';
import 'dart:ui';
import 'package:elyra/bean/short_video_bean.dart';
import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/el_recommend/controller.dart';
import 'package:elyra/routers/el_routers.dart';
import 'package:elyra/utils/device_info.dart';
import 'package:elyra/utils/el_color.dart';
import 'package:elyra/utils/jump_detail.dart';
import 'package:elyra/widgets/bad_status_widget.dart';
import 'package:elyra/widgets/el_nodata_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

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

class RecommendPage extends StatefulWidget {
  const RecommendPage({super.key});

  @override
  State<RecommendPage> createState() => _RecommendPageState();
}

class _RecommendPageState extends State<RecommendPage>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  late final RecommendPageController controller;
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;
  final Map<int, VideoPlayerController> _videoControllers = {};
  final Map<int, bool> _videoInitialized = {};
  bool _isPageVisible = true;
  // 添加标记，记录哪些视频已经播放完成并触发了跳转
  final Map<int, bool> _videoCompletedAndJumped = {};

  @override
  void initState() {
    super.initState();
    controller = Get.put(RecommendPageController());
    // 监听页面切换
    _pageController.addListener(_onPageChanged);
    // 监听应用生命周期
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // 当应用进入后台或不可见时暂停视频
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _pauseAllVideos();
    } else if (state == AppLifecycleState.resumed) {
      // 应用恢复时，只有当页面本身是可见的时候才播放
      // 通过 VisibilityDetector 来判断页面可见性
      if (_isPageVisible &&
          _currentPageIndex < controller.state.recommendList.length) {
        _playCurrentVideo();
      }
    }
  }

  void _onPageChanged() {
    final page = _pageController.page?.round() ?? 0;
    // 添加数据加载检查，防止数据未加载完成时跳转
    if (controller.state.recommendList.isEmpty) {
      // 数据未加载，重置回当前页面
      if (_pageController.hasClients &&
          _currentPageIndex < controller.state.recommendList.length) {
        _pageController.jumpToPage(_currentPageIndex);
      }
      return;
    }

    // 检查页面索引是否有效
    if (page >= controller.state.recommendList.length || page < 0) {
      // 索引无效，重置回当前页面
      if (_pageController.hasClients &&
          _currentPageIndex < controller.state.recommendList.length) {
        _pageController.jumpToPage(_currentPageIndex);
      }
      return;
    }

    if (page != _currentPageIndex) {
      // 暂停之前的视频
      _pauseVideo(_currentPageIndex);
      // 更新当前页面索引
      _currentPageIndex = page;
      // 重置新页面的播放完成标记，允许新视频播放完成后跳转
      _videoCompletedAndJumped[page] = false;
      // 播放当前视频
      _playCurrentVideo();
      // 更新controller状态
      if (page < controller.state.recommendList.length) {
        controller.state.curVideo = controller.state.recommendList[page];
        controller.state.curVideoId = controller.state.curVideo.id ?? -1;
        controller.update();
      }
      setState(() {});
    }
  }

  void _playCurrentVideo() {
    if (_currentPageIndex < controller.state.recommendList.length) {
      final video = controller.state.recommendList[_currentPageIndex];
      _initializeAndPlayVideo(_currentPageIndex, video);
    }
  }

  void _pauseAllVideos() {
    for (var ctrl in _videoControllers.values) {
      ctrl.pause();
    }
  }

  void _pauseVideo(int index) {
    _videoControllers[index]?.pause();
  }

  void _initializeAndPlayVideo(int index, ShortVideoBean video) {
    // 先暂停所有其他视频
    _pauseAllVideos();

    if (_videoControllers[index] != null && _videoInitialized[index] == true) {
      if (_isPageVisible && _currentPageIndex == index) {
        // 重置播放完成标记，允许重新播放
        _videoCompletedAndJumped[index] = false;
        _videoControllers[index]?.play();
      }
      return;
    }

    final videoUrl = video.videoInfo?.videoUrl ?? '';
    if (videoUrl.isEmpty) return;

    final videoCtrl =
        VideoPlayerController.networkUrl(
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
                // 初始化时重置播放完成标记
                _videoCompletedAndJumped[index] = false;
              });
              if (_currentPageIndex == index && _isPageVisible) {
                // 确保只有当前视频播放
                _pauseAllVideos();
                _videoControllers[index]?.play();
              }
            }
          })
          ..setLooping(false) // 不循环播放，播放完后跳转下一个
          ..addListener(() {
            if (mounted && _currentPageIndex == index) {
              final ctrl = _videoControllers[index];
              if (ctrl != null && ctrl.value.isInitialized) {
                final position = ctrl.value.position;
                final duration = ctrl.value.duration;

                // 检查视频是否真正播放完成：
                // 1. duration 必须大于 0（视频已加载）
                // 2. position 必须接近 duration（播放到结尾，允许 500ms 误差）
                // 3. 还没有触发过跳转（防止重复触发）
                // 4. 视频不在缓冲中
                if (duration.inMilliseconds > 0 &&
                    position.inMilliseconds > 0 &&
                    position.inMilliseconds >= duration.inMilliseconds - 500 &&
                    _videoCompletedAndJumped[index] != true &&
                    !ctrl.value.isBuffering) {
                  // 标记为已完成并跳转，防止重复触发
                  _videoCompletedAndJumped[index] = true;

                  // 播放完成，重置到0并暂停
                  ctrl.seekTo(Duration.zero);
                  ctrl.pause();

                  // 播放完成后跳转到下一个视频
                  _jumpToNextVideo();
                }
              }
              setState(() {}); // 更新进度条
            }
          });

    _videoControllers[index] = videoCtrl;
  }

  void _preloadVideo(int index, ShortVideoBean video) {
    final videoUrl = video.videoInfo?.videoUrl ?? '';
    if (videoUrl.isEmpty) return;

    if (_videoControllers[index] != null) return;

    final videoCtrl =
        VideoPlayerController.networkUrl(
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
                // 初始化时重置播放完成标记
                _videoCompletedAndJumped[index] = false;
              });
              // 预加载后不自动播放
            }
          })
          ..setLooping(false)
          ..addListener(() {
            if (mounted && _currentPageIndex == index) {
              final ctrl = _videoControllers[index];
              if (ctrl != null && ctrl.value.isInitialized) {
                final position = ctrl.value.position;
                final duration = ctrl.value.duration;

                // 同样的播放完成检查逻辑
                if (duration.inMilliseconds > 0 &&
                    position.inMilliseconds > 0 &&
                    position.inMilliseconds >= duration.inMilliseconds - 500 &&
                    _videoCompletedAndJumped[index] != true &&
                    !ctrl.value.isBuffering) {
                  // 标记为已完成并跳转
                  _videoCompletedAndJumped[index] = true;

                  // 播放完成，重置到0并暂停
                  ctrl.seekTo(Duration.zero);
                  ctrl.pause();

                  // 播放完成后跳转到下一个视频
                  _jumpToNextVideo();
                }
              }
              setState(() {});
            }
          });

    _videoControllers[index] = videoCtrl;
  }

  // 跳转到下一个视频
  void _jumpToNextVideo() {
    if (_currentPageIndex < controller.state.recommendList.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // 已经是最后一个，如果有更多数据则加载
      if (controller.state.hasMore && !controller.state.isLoading) {
        _handleLoadMore().then((_) {
          // 加载完成后跳转到下一个
          if (_currentPageIndex < controller.state.recommendList.length - 1) {
            _pageController.nextPage(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    // 释放所有视频控制器
    for (var controller in _videoControllers.values) {
      controller.dispose();
    }
    _videoControllers.clear();
    // 移除生命周期监听
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<RecommendPageController>(
      builder: (controller) {
        return VisibilityDetector(
          key: Key('recommend-page-visibility'),
          onVisibilityChanged: (VisibilityInfo info) {
            // 检测页面可见性
            if (info.visibleFraction > 0.5) {
              // 页面可见
              _isPageVisible = true;
              _playCurrentVideo();
            } else if (info.visibleFraction < 0.2) {
              // 页面不可见
              _isPageVisible = false;
              _pauseAllVideos();
            }
          },
          child: Scaffold(backgroundColor: Colors.black, body: _buildContent()),
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
    // 初始化第一个视频
    if (controller.state.recommendList.isNotEmpty &&
        _videoControllers.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _playCurrentVideo();
      });
    }

    return RefreshIndicator(
      color: ColorEnum.mainColor,
      backgroundColor: Colors.white,
      onRefresh: () async {
        // 下拉刷新：重置到第一页
        await _handleRefresh();
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          // 检测是否到达底部
          if (notification is ScrollEndNotification) {
            if (_currentPageIndex ==
                controller.state.recommendList.length - 1) {
              // 到达最后一个，加载更多
              if (controller.state.hasMore && !controller.state.isLoading) {
                _handleLoadMore();
              }
            }
          }
          return false;
        },
        child: PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          itemCount: controller.state.recommendList.length,
          onPageChanged: (index) {
            // 预加载下一个视频
            if (index + 1 < controller.state.recommendList.length) {
              final nextVideo = controller.state.recommendList[index + 1];
              // 只初始化，不播放
              if (_videoControllers[index + 1] == null) {
                _preloadVideo(index + 1, nextVideo);
              }
            }
          },
          itemBuilder: (context, index) {
            return _buildVideoItem(index);
          },
        ),
      ),
    );
  }

  // 处理下拉刷新
  Future<void> _handleRefresh() async {
    // 暂停所有视频
    _pauseAllVideos();

    // 清空所有视频控制器
    for (var ctrl in _videoControllers.values) {
      ctrl.dispose();
    }
    _videoControllers.clear();
    _videoInitialized.clear();
    // 清空播放完成标记
    _videoCompletedAndJumped.clear();

    // 重置到第一页
    _currentPageIndex = 0;

    // 调用controller刷新数据
    await controller.getRecommendData();

    // 刷新后自动播放第一个视频
    if (controller.state.recommendList.isNotEmpty) {
      // 跳转到第一页
      if (_pageController.hasClients) {
        await _pageController.animateToPage(
          0,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
      _playCurrentVideo();
    }

    setState(() {});
  }

  // 处理加载更多
  Future<void> _handleLoadMore() async {
    await controller.getRecommendData(loadMore: true);
    setState(() {});
  }

  /// 构建单个视频项
  Widget _buildVideoItem(int index) {
    final video = controller.state.recommendList[index];
    final videoCtrl = _videoControllers[index];
    final isInitialized = _videoInitialized[index] ?? false;

    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          // 视频播放器
          _buildVideoPlayer(index, video, videoCtrl, isInitialized),

          // 底部信息栏
          _buildBottomInfo(index, video, videoCtrl, isInitialized),
        ],
      ),
    );
  }

  /// 构建视频播放器
  Widget _buildVideoPlayer(
    int index,
    ShortVideoBean video,
    VideoPlayerController? videoCtrl,
    bool isInitialized,
  ) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // 点击视频区域：跳转到详情页
        _navigateToDetail(video, videoCtrl);
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

                  // 缓冲指示器
                  if (videoCtrl.value.isBuffering)
                    Image.asset('loading.gif'.icon, width: 120, height: 120),
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
                    child: Container(color: Colors.black.withOpacity(0.3)),
                  ),
                  Image.asset('loading.gif'.icon, width: 120, height: 120),
                ],
              ),
      ),
    );
  }

  // 跳转到详情页
  void _navigateToDetail(
    ShortVideoBean video,
    VideoPlayerController? videoCtrl,
  ) {
    // 暂停当前视频
    videoCtrl?.pause();
    _isPageVisible = false;

    JumpService.toDetail(
      video: {
        'shortPlayId': video.shortPlayId,
        'videoId': video.shortPlayVideoId ?? 0,
        'imageUrl': video.imageUrl ?? '',
      },
    );

    print('跳转到详情页: ${video.name}');
  }

  /// 构建底部信息栏（标题、描述、进度条）
  Widget _buildBottomInfo(
    int index,
    ShortVideoBean video,
    VideoPlayerController? videoCtrl,
    bool isInitialized,
  ) {
    return Positioned(
      left: 0,
      right: 0, // 留出右侧收藏按钮的空间
      bottom: 6.h,
      child: GestureDetector(
        // 阻止事件冒泡到视频播放器
        behavior: HitTestBehavior.opaque,
        onTap: () {
          // 点击底部信息栏：跳转到详情页
          _navigateToDetail(video, videoCtrl);
        },
        child: Container(
          color: Colors.transparent,
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
                      controller.state.curVideo = video;
                      controller.state.curVideoId = video.id ?? 0;
                      final success = await controller.toggleCollect(context);
                      if (success) {
                        setState(() {});
                      }
                    },
                    child: Container(
                      child: Image.asset(
                        video.isCollect == true
                            ? 'ely_collect.png'.icon
                            : 'ely_collect_cancle.png'.icon,
                        width: 36.w,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),
              // 标题
              SizedBox(
                width: 273.w,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video.name ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'PingFang SC',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    // 描述
                    if (video.description != null &&
                        video.description!.isNotEmpty) ...[
                      SizedBox(height: 5.h),
                      Text(
                        video.description!,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.80),
                          fontSize: 12,
                          fontFamily: 'PingFang SC',
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              SizedBox(height: 6.w),
              // 进度条
              _buildProgressBar(index, videoCtrl, isInitialized),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建进度条
  Widget _buildProgressBar(
    int index,
    VideoPlayerController? videoCtrl,
    bool isInitialized,
  ) {
    if (videoCtrl == null || !isInitialized) {
      return SizedBox.shrink();
    }
    final duration = videoCtrl.value.duration;
    final position = videoCtrl.value.position;
    final progress = duration.inMilliseconds > 0
        ? position.inMilliseconds / duration.inMilliseconds
        : 0.0;

    return GestureDetector(
      // 阻止进度条点击事件冒泡
      behavior: HitTestBehavior.opaque,
      onTap: () {
        // 阻止冒泡，不跳转详情页
      },
      child: Row(
        children: [
          // 进度条
          Expanded(
            child: GestureDetector(
              // 进度条可以拖动，但不跳转详情页
              behavior: HitTestBehavior.opaque,
              onTap: () {},
              child: SliderTheme(
                data: SliderThemeData(
                  trackHeight: 3.w,
                  thumbShape: SliderComponentShape.noThumb,
                  // 使用自定义的垂直扩展overlay shape
                  overlayShape: VerticalSliderOverlayShape(
                    verticalPadding: 6.h,
                  ),
                  activeTrackColor: Color(0xFFDC23B1),
                  inactiveTrackColor: Colors.white.withOpacity(0.2),
                  overlayColor: Colors.transparent,
                ),
                child: Slider(
                  value: progress.clamp(0.0, 1.0),
                  onChanged: (value) {
                    final seekPosition = duration * value;
                    videoCtrl.seekTo(seekPosition);
                    setState(() {});
                  },
                  onChangeStart: (value) {
                    // 拖动进度条时暂停
                    videoCtrl.pause();
                  },
                  onChangeEnd: (value) {
                    // 拖动结束后继续播放
                    if (_isPageVisible && _currentPageIndex == index) {
                      videoCtrl.play();
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

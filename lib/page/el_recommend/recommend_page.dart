import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pandaroll/bean/short_video_bean.dart';
import 'package:pandaroll/extend/string_extend.dart';
import 'package:pandaroll/resource/color_resource.dart';
import 'package:pandaroll/routes/app_routes.dart';
import 'package:pandaroll/widgets/bad_status_widget.dart';
import 'package:pandaroll/widgets/custom_network_image_widget.dart';
import 'package:pandaroll/widgets/hot_count_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'logic.dart';

class RecommendPage extends StatefulWidget {
  const RecommendPage({super.key});

  @override
  State<RecommendPage> createState() => _RecommendPageState();
}

class _RecommendPageState extends State<RecommendPage> with AutomaticKeepAliveClientMixin {
  final logic = Get.put(RecommendLogic());
  final state = Get.find<RecommendLogic>().state;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<RecommendLogic>(
        assignId: true,
        builder: (ctrl) {
          if ([LoadStatusType.loadNoData, LoadStatusType.loadFailed].contains(state.loadStatus)) {
            return BadStatusWidget(
              type: state.loadStatus == LoadStatusType.loadNoData ? BadStatusType.nothingYet : BadStatusType.loadFailed,
              onPressed: logic.getRecommendList,
            );
          }
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              SizedBox(
                width: ScreenUtil().screenWidth,
                height: ScreenUtil().screenHeight,
                child: logic.videoCtrl != null && logic.videoCtrl!.value.isInitialized
                    ? GestureDetector(
                        onTap: () {
                          if (logic.videoCtrl!.value.isPlaying) {
                            logic.videoCtrl!.pause();
                          } else {
                            logic.videoCtrl!.play();
                          }
                          setState(() {});
                        },
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Positioned.fill(
                              child: FittedBox(
                                fit: BoxFit.cover,
                                child: VisibilityDetector(
                                  key: Key('recommend-video'),
                                  onVisibilityChanged: (VisibilityInfo info) {
                                    var visiblePercentage = info.visibleFraction * 100;
                                    logic.isVisible = visiblePercentage > 20;
                                    if (visiblePercentage > 20) {
                                      logic.videoCtrl?.play();
                                    } else {
                                      logic.videoCtrl?.pause();
                                    }
                                    logic.update();
                                  },
                                  child: SizedBox(
                                    width: logic.videoCtrl!.value.size.width,
                                    height: logic.videoCtrl!.value.size.height,
                                    child: VideoPlayer(logic.videoCtrl!),
                                  ),
                                ),
                              ),
                            ),
                            if (isPause)
                              Positioned(
                                top: 300.h,
                                child: Image.asset('ic_video_play.png'.icon, width: 48.w),
                              ),
                            if (isBuffering)
                              Positioned(
                                top: 300.h,
                                child: CircularProgressIndicator(color: ColorResource.mainColor),
                              ),
                          ],
                        ),
                      )
                    : AppCachedImage(
                        imageUrl: state.curVideo.videoInfo?.imageUrl ?? '',
                        placeholder: Container(color: Colors.white),
                      ),
              ),
              if (logic.videoCtrl == null || !logic.videoCtrl!.value.isInitialized) ...[
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    color: Colors.black.withAlpha(30),
                    width: ScreenUtil().screenWidth,
                    height: ScreenUtil().screenHeight,
                  ),
                ),
                Center(child: CircularProgressIndicator(color: ColorResource.mainColor)),
              ],
              if (logic.videoCtrl != null && logic.videoCtrl!.value.isInitialized)
                GestureDetector(
                  onTap: () {
                    if (logic.videoCtrl!.value.isPlaying) {
                      logic.videoCtrl!.pause();
                    } else {
                      logic.videoCtrl!.play();
                    }
                    setState(() {});
                  },
                  child: Container(
                    width: ScreenUtil().screenWidth,
                    height: ScreenUtil().screenHeight,
                    color: Colors.transparent,
                  ),
                ),
              Container(
                height: 240.w,
                margin: EdgeInsets.only(bottom: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 15.w, right: 20.w),
                      child: Column(
                        children: [
                          Text(
                            'For You',
                            style: TextStyle(fontSize: 15.sp, color: Colors.white, fontWeight: FontWeight.w500),
                          ),

                          Container(width: 54.w, height: 2.w, color: Colors.white),
                        ],
                      ),
                    ),

                    Container(
                      height: 195.w,
                      margin: EdgeInsets.only(top: 20.w),
                      child: SmartRefresher(
                        controller: logic.refreshCtrl,
                        enablePullUp: true,
                        footer: ClassicFooter(iconPos: IconPosition.left, loadingText: '', noDataText: ''),
                        header: ClassicHeader(
                          iconPos: IconPosition.left,
                          releaseText: '',
                          refreshingText: '',
                          completeText: '',
                        ),
                        onRefresh: () => logic.getRecommendList(refresh: true),
                        onLoading: () => logic.getRecommendList(loadMore: true),
                        child: ListView.separated(
                          padding: EdgeInsets.only(left: 15.w),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) => _videoItem(index),
                          itemCount: state.recommendList.length,
                          separatorBuilder: (context, index) => SizedBox(width: 10.w),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 15.w,
                top: ScreenUtil().statusBarHeight + 20.w,
                child: SizedBox(
                  width: ScreenUtil().screenWidth - 30.w,
                  child: Row(
                    children: [
                      AppCachedImage(
                        imageUrl: state.curVideo.imageUrl ?? '',
                        width: 36.w,
                        height: 36.w,
                        borderRadius: BorderRadius.circular(18.w),
                      ),
                      Container(
                        width: 240.w,
                        margin: EdgeInsets.only(left: 6.w),
                        child: Text(
                          state.curVideo.name ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: ColorResource.mainWhite,
                            fontWeight: FontWeight.w500,
                            shadows: [
                              Shadow(color: Colors.black.withValues(alpha: 0.25), offset: Offset(0, 0), blurRadius: 4),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          logic.videoCtrl!.pause();
                          Get.toNamed(AppRoutes.search)?.then((onValue) {
                            logic.videoCtrl!.play();
                          });
                        },
                        child: Image.asset('ic_recommend_search.png'.icon, width: 24.w),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 10.w,
                top: 280.h,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: logic.collectVideo,
                      child: Column(
                        children: [
                          Image.asset(
                            state.curVideo.isCollect == true ? 'ic_follow_sel.png'.icon : 'ic_follow_unsel.png'.icon,
                            width: 32.w,
                          ),
                          Text(
                            '${state.curVideo.collectTotal ?? 0}',
                            style: TextStyle(fontSize: 12.sp, color: ColorResource.mainWhite),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.h),
                    GestureDetector(
                      onTap: () {
                        logic.videoCtrl!.pause();
                        Get.toNamed(
                          AppRoutes.shortVideo,
                          arguments: {
                            'shortPlayId': state.curVideo.shortPlayId,
                            'imageUrl': state.curVideo.imageUrl ?? '',
                          },
                        )?.then((onValue) {
                          logic.videoCtrl!.play();
                        });
                      },
                      child: Image.asset('ic_episode_outline.png'.icon, width: 32.w),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _videoItem(index) {
    ShortVideoBean video = state.recommendList[index];
    return GestureDetector(
      onTap: () {
        if (state.curVideoId == video.id) {
          logic.videoCtrl?.pause();
          Get.toNamed(
            AppRoutes.shortVideo,
            arguments: {'shortPlayId': video.shortPlayId, 'imageUrl': video.imageUrl ?? ''},
          )?.then((onValue) {
            logic.videoCtrl!.play();
          });
          return;
        }
        state.curVideoId = video.id ?? -1;
        state.curVideo = video;
        setState(() {});

        logic.setVideoUrl(video.videoInfo?.videoUrl ?? '', index: index);
      },
      child: Container(
        width: 128.w,
        height: 192.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(
            color: state.curVideoId == video.id ? ColorResource.mainWhite : Colors.transparent,
            width: 2.w,
          ),
          borderRadius: BorderRadius.circular(8.w),
        ),
        child: Stack(
          children: [
            AppCachedImage(
              imageUrl: video.imageUrl ?? '',
              width: 128.w,
              height: 192.w,
              borderRadius: BorderRadius.circular(6.w),
            ),
            Positioned(
              top: 4.w,
              right: 8.w,
              child: HotCountWidget(
                count: video.watchTotal ?? 0,
                iconColor: ColorResource.mainWhite,
                textColor: ColorResource.mainWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool get isPause => !(logic.videoCtrl?.value.isPlaying ?? false);

  bool get isBuffering => logic.videoCtrl?.value.isBuffering ?? false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    logic.getRecommendList();
    super.initState();
  }
}

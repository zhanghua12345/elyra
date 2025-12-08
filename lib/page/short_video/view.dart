import 'dart:io';
import 'dart:ui';

import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pandaroll/extend/string_extend.dart';
import 'package:pandaroll/page/short_video/logic.dart';
import 'package:pandaroll/resource/color_resource.dart';
import 'package:pandaroll/utils/my_styles.dart';
import 'package:pandaroll/utils/my_utils.dart';
import 'package:pandaroll/utils/toast_utils.dart';
import 'package:pandaroll/widgets/bad_status_widget.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../bean/short_play_detail_bean.dart';
import '../../widgets/custom_network_image_widget.dart';
import '../../widgets/tag_widget.dart';
import '../../widgets/video_progress_bar.dart';
import 'episode_selector_widget.dart';

class ShortVideoPage extends StatefulWidget {
  const ShortVideoPage({super.key});

  @override
  State<ShortVideoPage> createState() => _ShortVideoPageState();
}

class _ShortVideoPageState extends State<ShortVideoPage> with SingleTickerProviderStateMixin {
  final logic = Get.put(ShortVideoLogic());
  final state = Get.find<ShortVideoLogic>().state;

  @override
  void initState() {
    state.imageUrl = Get.arguments['imageUrl'] ?? '';
    state.isFromRecommend = Get.arguments['isFromRecommend'] ?? false;
    super.initState();
  }

  // 选择倍速
  void _selectSpeed(double speed) {
    state.curSpeed = speed;
    logic.controllers[logic.currentIndex]?.setPlaybackSpeed(speed);
  }

  // 选择清晰度
  void _selectResolution(int resolution) {
    state.revolution = resolution;
    logic.getShortPlayDetails();
  }

  String get bgImageUrl => state.imageUrl != '' ? state.imageUrl : state.detailBean?.shortPlayInfo?.imageUrl ?? '';

  bool get isPause =>
      !((logic.controllers[logic.currentIndex]?.value.isPlaying ?? true) ||
          !(logic.controllers[logic.currentIndex]?.value.isBuffering ?? true));

  bool get isAllOver =>
      logic.currentIndex == state.episodeList.length - 1 &&
      (logic.controllers[logic.currentIndex]?.value.isCompleted ?? false);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (logic.controllers.isNotEmpty) {
          logic.uploadHistorySeconds(logic.controllers[logic.currentIndex]?.value.position.inMilliseconds ?? 0);
        }
        if (didPop) return;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: GetBuilder<ShortVideoLogic>(
          assignId: true,
          builder: (ctrl) {
            if (logic.videoStatus == LoadStatusType.loadFailed) {
              return Container(
                width: ScreenUtil().screenWidth,
                height: ScreenUtil().screenHeight,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: kToolbarHeight + 20.w),
                      child: IconButton(onPressed: () => Get.back(), icon: Icon(Icons.arrow_back_outlined, size: 28)),
                    ),
                    BadStatusWidget(type: BadStatusType.notFound, onPressed: logic.getShortPlayDetails),
                  ],
                ),
              );
            }
            return Stack(
              children: [
                AppCachedImage(
                  imageUrl: bgImageUrl,
                  width: ScreenUtil().screenWidth,
                  height: ScreenUtil().screenHeight,
                  placeholder: Container(),
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    color: Colors.black.withAlpha(30),
                    width: ScreenUtil().screenWidth,
                    height: ScreenUtil().screenHeight,
                    child: Center(child: CircularProgressIndicator(color: ColorResource.mainColor)),
                  ),
                ),
                // if (state.detailBean == null) Center(child: CircularProgressIndicator(color: ColorResource.mainColor)),
                PageView.builder(
                  controller: logic.pageController,
                  scrollDirection: Axis.vertical,
                  onPageChanged: (index) => logic.onPageChanged(index, type: 1),
                  itemCount: state.episodeList.length,
                  itemBuilder: (context, index) => _buildEpisodePage(index),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildEpisodePage(int index) {
    if (logic.controllers.isEmpty) return Container();
    final controller = logic.controllers[index];
    final episode = state.episodeList[index];
    return Stack(
      children: [
        // 视频播放器
        if (controller != null && controller.value.isInitialized && !isAllOver)
          GestureDetector(
            onTap: () {
              if (episode.isLock == true) return;
              controller.value.isPlaying ? controller.pause() : controller.play();
              setState(() {});
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: VisibilityDetector(
                      key: Key('short-video'),
                      onVisibilityChanged: (VisibilityInfo info) {
                        var visiblePercentage = info.visibleFraction * 100;
                        if (visiblePercentage > 20) {
                          if (episode.isLock == true) return;
                          controller.play();
                        } else {
                          controller.pause();
                        }
                        logic.update();
                      },
                      child: SizedBox(
                        width: controller.value.size.width,
                        height: controller.value.size.height,
                        child: VideoPlayer(controller),
                      ),
                    ),
                  ),
                ),
                if (logic.loadStatusType == LoadStatusType.loading)
                  Center(child: CircularProgressIndicator(color: ColorResource.mainColor)),
              ],
            ),
          )
        else
          Stack(
            children: [
              AppCachedImage(
                width: ScreenUtil().screenWidth,
                height: ScreenUtil().screenHeight,
                imageUrl: bgImageUrl,
                placeholder: Container(),
              ),
              if (!isAllOver) Center(child: CircularProgressIndicator(color: ColorResource.mainColor)),
            ],
          ),
        if (controller != null && controller.value.isInitialized && !isAllOver)
          GestureDetector(
            onTap: () {
              if (episode.isLock == true) return;
              if (state.toolMuskTimer != null) {
                state.toolMuskTimer?.cancel();
                state.toolMuskTimer = null;
              }
              setState(() {
                state.toolMuskStatus = !state.toolMuskStatus;
              });
            },
            child: Container(
              width: ScreenUtil().screenWidth,
              height: ScreenUtil().screenHeight,
              color: Colors.transparent,
              child: (logic.loadStatusType == LoadStatusType.loadSuccess && state.toolMuskStatus)
                  ? GestureDetector(
                      onTap: () {
                        if (episode.isLock == true) return;
                        if (state.toolMuskTimer != null) {
                          state.toolMuskTimer?.cancel();
                          state.toolMuskTimer = null;
                        }
                        controller.value.isPlaying ? controller.pause() : controller.play();
                        setState(() {});
                      },
                      child: Center(
                        child: controller.value.isPlaying
                            ? Image.asset('ic_video_pause.png'.icon, width: 56.w, height: 56.w)
                            : Image.asset('ic_video_play.png'.icon, width: 50.w, height: 50.w),
                      ),
                    )
                  : null,
            ),
          ),
        if (episode.isLock == true)
          Container(
            width: ScreenUtil().screenWidth,
            height: ScreenUtil().screenHeight,
            color: Colors.black.withValues(alpha: .75),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  EasyThrottle.throttle(
                    'unlock',
                    Duration(seconds: 2),
                    () => logic.buyVideo(episode.id!, episode.coins ?? 0, toRecharge: true),
                  );
                },
                child: Container(
                  width: 260.w,
                  padding: EdgeInsets.symmetric(vertical: 17.w),
                  decoration: MyStyles.mainBorder(width: 1, radius: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('ic_unlock_lock.png'.icon, width: 20.w),
                      SizedBox(width: 3.w),
                      state.curUnlock == index
                          ? RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Unlocking costs ',
                                    style: TextStyle(fontSize: 14.sp, color: ColorResource.mainWhite),
                                  ),
                                  TextSpan(
                                    text: '${episode.coins ?? 0}',
                                    style: TextStyle(fontSize: 10.sp, color: ColorResource.mainWhite),
                                  ),
                                  TextSpan(
                                    text: ' coins',
                                    style: TextStyle(fontSize: 14.sp, color: ColorResource.mainWhite),
                                  ),
                                ],
                              ),
                            )
                          : Text(
                              'Prev.locked',
                              style: TextStyle(fontSize: 14.sp, color: ColorResource.mainWhite),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        // 底部控制器
        Positioned(
          bottom: 0,
          left: 0.w,
          child: Platform.isAndroid ? SafeArea(child: bottomView(episode)) : bottomView(episode),
        ),
        // 顶部返回+收藏
        Positioned(
          top: ScreenUtil().statusBarHeight,
          child: SizedBox(
            width: ScreenUtil().screenWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    if (state.isFromRecommend || state.recommendList.isEmpty) {
                      Get.back();
                    } else {
                      logic.showRecommendDialog();
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(15.w),
                    child: Image.asset('ic_back_white.png'.icon, width: 24.w),
                  ),
                ),
                Visibility(
                  visible: state.toolMuskStatus,
                  child: GestureDetector(
                    onTap: logic.collectVideo,
                    child: Container(
                      padding: EdgeInsets.all(15.w),
                      child: Image.asset(
                        state.detailBean?.shortPlayInfo?.isCollect == true
                            ? 'ic_follow_sel.png'.icon
                            : 'ic_follow_unsel.png'.icon,
                        width: 24.w,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomView(EpisodeList episode) {
    return Visibility(
      visible: state.toolMuskStatus,
      child: Container(
        height: 145.w,
        width: ScreenUtil().screenWidth,
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0),
              Colors.black.withValues(alpha: .3),
              Colors.black.withValues(alpha: .6),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              state.detailBean?.shortPlayInfo?.name ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: ColorResource.mainWhite, fontSize: 14.sp),
            ),
            SizedBox(height: 20.w),
            if (logic.controllers[logic.currentIndex] != null)
              CustomVideoProgressBar(
                controller: logic.controllers[logic.currentIndex]!,
                width: ScreenUtil().screenWidth - 30.w,
                canSlide: episode.isLock == false,
              ),
            SizedBox(height: 10.w),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: showEpSelDialog,
                  child: Container(
                    width: 215.w + 50.w,
                    height: 30.w,
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.w),
                      color: ColorResource.bg_949494.withValues(alpha: .4),
                    ),
                    child: Row(
                      children: [
                        Image.asset('ic_episode.png'.icon, width: 14.sp),
                        SizedBox(width: 6.w),
                        Text(
                          'EP.${logic.currentIndex + 1}',
                          style: TextStyle(fontSize: 13.sp, color: Colors.white),
                        ),
                        const Spacer(),
                        Text(
                          'All ${state.detailBean?.shortPlayInfo?.episodeTotal ?? 0} Episodes',
                          style: TextStyle(fontSize: 13.sp, color: ColorResource.bg_BEBEBE),
                        ),
                      ],
                    ),
                  ),
                ),
                // GestureDetector(
                //   onTap: () {
                //     if (episode.isLock == true) return;
                //     showResolutionSelDialog();
                //   },
                //   child: Container(
                //     width: 50.w,
                //     height: 30.w,
                //     alignment: Alignment.center,
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(50.w),
                //       color: ColorResource.bg_949494.withValues(alpha: .4),
                //     ),
                //     child: Text(
                //       '${state.revolution}P',
                //       style: TextStyle(fontSize: 13.sp, color: Colors.white),
                //     ),
                //   ),
                // ),
                GestureDetector(
                  onTap: () {
                    if (episode.isLock == true) return;
                    showSpeedSelDialog();
                  },
                  child: Container(
                    width: 50.w + 20.w,
                    height: 30.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.w),
                      color: ColorResource.bg_949494.withValues(alpha: .4),
                    ),
                    child: Text(
                      '${state.curSpeed}x',
                      style: TextStyle(fontSize: 13.sp, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  showEpSelDialog() {
    return Get.bottomSheet(
      backgroundColor: Colors.white,
      Container(
        height: MyUtils.isNotEmpty(state.detailBean?.shortPlayInfo?.description) ? 486.w : 436.w,
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.w)),
          gradient: LinearGradient(
            colors: [Colors.white, ColorResource.mainColor.withAlpha(20)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10.w),
                  child: Row(
                    children: [
                      AppCachedImage(
                        imageUrl: state.detailBean?.shortPlayInfo?.imageUrl ?? '',
                        width: 64.w,
                        height: 82.w,
                        borderRadius: BorderRadius.circular(6.w),
                      ),
                      SizedBox(width: 10.w),
                      SizedBox(
                        width: ScreenUtil().screenWidth - 140.w,
                        height: 82.w,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.detailBean?.shortPlayInfo?.name ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: ColorResource.mainBlack,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 10.w),
                            TagWidget(state.detailBean?.shortPlayInfo?.category?.first ?? ''),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Image.asset('ic_dialog_close.png'.icon, width: 24.w),
                ),
              ],
            ),
            SizedBox(height: 10.w),
            if (MyUtils.isNotEmpty(state.detailBean?.shortPlayInfo?.description))
              SizedBox(
                height: 50.w,
                child: Text(
                  state.detailBean?.shortPlayInfo?.description ?? '',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12.sp, color: ColorResource.bg_777777),
                ),
              ),
            SizedBox(height: 10.w),
            Expanded(
              child: EpisodeSelector(
                totalEpisodes: (state.detailBean?.shortPlayInfo?.episodeTotal ?? 0).toInt(),
                initialEpisode: logic.currentIndex + 1,
                onEpisodeSelected: (index) {
                  Get.back();
                  bool? beforeEpUnlock = index - 2 <= 0 ? false : state.episodeList[index - 2].isLock;
                  if (beforeEpUnlock ?? false) {
                    ToastUtils.show('Unable to unlock episodes');
                    return;
                  }
                  logic.onPageChanged(index - 1, isToggle: true);

                  // if (episode.isLock == true) {
                  //   // logic.showVipBuyDialog(episode.coins ?? 0);
                  //   debugPrint('----episode:${index - 1} ${state.detailBean?.videoInfo?.episode}');
                  //   if (index - 1 == state.detailBean?.videoInfo?.episode) {
                  //     logic.onPageChanged(index - 1, isToggle: true);
                  //     return;
                  //   }
                  //   logic.buyVideo(episode.id!, episode.coins ?? 0, toRecharge: index - 1 == logic.currentIndex);
                  // } else {
                  // }
                },
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  showSpeedSelDialog() {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, dialogState) {
          return Container(
            height: 165.w,
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.w)),
              gradient: LinearGradient(
                colors: [Colors.white, ColorResource.mainColor.withAlpha(20)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Speed',
                      style: TextStyle(fontSize: 15.sp, color: ColorResource.mainBlack, fontWeight: FontWeight.w500),
                    ),

                    const Spacer(),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Image.asset('ic_dialog_close.png'.icon, width: 24.w),
                    ),
                  ],
                ),
                SizedBox(height: 15.w),

                SizedBox(
                  height: 60.w,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        _selectSpeed(state.speeds[index]);
                        Get.back();
                      },
                      child: Container(
                        width: 70.w,
                        height: 54.w,
                        alignment: Alignment.center,
                        decoration: state.curSpeed == state.speeds[index]
                            ? MyStyles.mainBorder(width: 1.5, radius: 6)
                            : BoxDecoration(
                                borderRadius: BorderRadius.circular(6.w),
                                color: ColorResource.mainColor.withAlpha(36),
                              ),
                        child: Text(
                          '${state.speeds[index]}x',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: state.curSpeed == state.speeds[index]
                                ? ColorResource.mainWhite
                                : ColorResource.mainBlack,
                          ),
                        ),
                      ),
                    ),
                    separatorBuilder: (_, __) => SizedBox(width: 10.w),
                    itemCount: state.speeds.length,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  showResolutionSelDialog() {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, dialogState) {
          return Container(
            height: 165.w,
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.w)),
              gradient: LinearGradient(
                colors: [Colors.white, ColorResource.mainColor.withAlpha(20)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quality',
                      style: TextStyle(fontSize: 15.sp, color: ColorResource.mainBlack, fontWeight: FontWeight.w500),
                    ),

                    const Spacer(),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Image.asset('ic_dialog_close.png'.icon, width: 24.w),
                    ),
                  ],
                ),
                SizedBox(height: 15.w),

                SizedBox(
                  height: 60.w,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        // state.revolution = state.resolutionList[index].value ?? 540;
                        // logic.getShortPlayDetails();
                        Get.back();
                        _selectResolution(state.resolutionList[index].value ?? 540);
                      },
                      child: Container(
                        width: 70.w,
                        height: 54.w,
                        alignment: Alignment.center,
                        decoration: state.revolution == state.resolutionList[index].value
                            ? MyStyles.mainBorder(width: 1.5)
                            : BoxDecoration(
                                borderRadius: BorderRadius.circular(12.w),
                                color: ColorResource.mainColor.withAlpha(36),
                              ),
                        child: Text(
                          '${state.resolutionList[index].value}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: state.revolution == state.resolutionList[index].value
                                ? ColorResource.mainWhite
                                : ColorResource.mainBlack,
                          ),
                        ),
                      ),
                    ),
                    separatorBuilder: (_, __) => SizedBox(width: 10.w),
                    itemCount: state.resolutionList.length,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:card_swiper/card_swiper.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pandaroll/bean/resolution_bean.dart';
import 'package:pandaroll/bean/short_play_detail_bean.dart';
import 'package:pandaroll/bean/short_video_bean.dart';
import 'package:pandaroll/extend/string_extend.dart';
import 'package:pandaroll/page/collect/logic.dart';
import 'package:pandaroll/page/home/home_controller.dart';
import 'package:pandaroll/page/mine/logic.dart';
import 'package:pandaroll/page/mine/store/logic.dart';
import 'package:pandaroll/page/recommend/logic.dart';
import 'package:pandaroll/page/short_video/state.dart';
import 'package:pandaroll/request/apis.dart';
import 'package:pandaroll/request/http_client.dart';
import 'package:pandaroll/resource/color_resource.dart';
import 'package:pandaroll/routes/app_routes.dart';
import 'package:pandaroll/utils/my_styles.dart';
import 'package:pandaroll/utils/toast_utils.dart';
import 'package:pandaroll/widgets/bad_status_widget.dart';
import 'package:pandaroll/widgets/custom_network_image_widget.dart';
import 'package:pandaroll/widgets/double_line.dart';
import 'package:pandaroll/widgets/store_widget.dart';
import 'package:video_player/video_player.dart';

import '../../bean/goods_bean.dart';
import '../../utils/buy_utils.dart';
import '../../utils/device_info_util.dart';
import '../../utils/my_utils.dart';
import '../../utils/user_util.dart';

class ShortVideoLogic extends GetxController {
  final state = ShortVideoState();
  late final PageController pageController;
  List<VideoPlayerController?> controllers = [];

  LoadStatusType videoStatus = LoadStatusType.loading;
  LoadStatusType loadStatusType = LoadStatusType.loadSuccess;
  int currentIndex = 0;
  bool isVip = false;
  bool showUnlockBtn = false;
  final userLogic = Get.put(MineLogic());

  // VIP金币包订阅弹窗定时器
  Timer? vipCoinSubTimer;

  // 是否已经展示过VIP金币包订阅弹窗
  bool hasShowVipCoinSub = false;

  // 是否正在展示VIP金币包订阅弹窗
  bool isShowingVipCoinSub = false;

  // 是否监听VIP金币包订阅弹窗
  bool listeneVipCoinSub = false;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: currentIndex);
  }

  @override
  void onReady() {
    super.onReady();
    state.shortPlayId = Get.arguments['shortPlayId'] ?? -1;
    state.activityId = Get.arguments['activityId'];
    state.videoId = Get.arguments['videoId'] ?? 0;
    getShortPlayDetails();
    getRecommend();
    // getResolution();
  }

  @override
  void onClose() {
    state.toolMuskTimer?.cancel();
    state.toolMuskTimer = null;
    clearCtrl();
    super.onClose();
  }

  initData() {
    state.toolMuskTimer?.cancel();
    state.toolMuskTimer = null;
    // pageController.dispose();
    currentIndex = 0;
    pageController.jumpToPage(currentIndex);
    // pageController = PageController(initialPage: currentIndex);
    clearCtrl();
    getShortPlayDetails();
    state.recommendList.clear();
    getRecommend();
  }

  clearCtrl() async {
    for (var controller in controllers) {
      await controller?.pause();
      controller?.dispose();
    }
    controllers.clear();
  }

  // 释放非当前、前后的视频控制器，减少内存占用
  void _releaseUnusedControllers() {
    for (int i = 0; i < controllers.length; i++) {
      if (i < currentIndex - 1 || i > currentIndex + 1) {
        controllers[i]?.dispose();
        controllers[i] = null;
      }
    }
  }

  // 初始化视频控制器
  Future<void> _initializeController(int index) async {
    if (index < 0 || index >= state.episodeList.length) return;
    if (controllers[index] != null) return;

    final episode = state.episodeList[index];
    VideoPlayerController controller = Platform.isAndroid && DeviceInfoUtil().osVersion == '10'
        ? VideoPlayerController.networkUrl(
            Uri.parse(episode.videoUrl!),
            formatHint: VideoFormat.hls,
            viewType: VideoViewType.platformView,
          )
        : VideoPlayerController.networkUrl(Uri.parse(episode.videoUrl!), formatHint: VideoFormat.hls);

    controllers[index] = controller;

    try {
      await controller.initialize();
      if (index == currentIndex &&
          (episode.isLock == false || userLogic.state.userInfo.isVip == true) &&
          !isShowingVipCoinSub) {
        controller.play();
        update();
      }
      controller.setPlaybackSpeed(state.curSpeed);
      debugPrint('---seekTo:${episode.playSeconds}');
      controller.addListener(() {
        if (currentIndex == index && !isClosed) update();
        if (currentIndex != index) controller.pause();
        if (!listeneVipCoinSub) {
          checkVipCoinSub();
        }
        if (currentIndex == state.episodeList.length - 1 && (controllers.last?.value.isCompleted ?? false)) {
          showRecommendDialog();
        }
        if (controller.value.isCompleted && !controller.value.isBuffering) {
          onPageChanged(index + 1, isToggle: true);
        }
        // 5秒后隐藏工具栏
        if (controller.value.isPlaying && state.toolMuskTimer == null) {
          state.toolMuskTimer = Timer(const Duration(seconds: 5), () {
            if (controller.value.isPlaying) {
              state.toolMuskStatus = false;
              update();
            }
          });
        }
      });
    } catch (e) {
      // 可根据需要处理异常
      UserUtil().reportErrorEvent(
        'video initialize failed',
        UserUtil.videoError,
        errMsg: e.toString(),
        payData: episode.toJson(),
        shortPlayId: episode.shortPlayId ?? 0,
        shortPlayVideoId: episode.shortPlayVideoId ?? 0,
      );
      debugPrint('---err:$e');
    }
  }

  // 预加载相邻视频
  void _preloadAdjacentVideos() {
    if (currentIndex > 0) _initializeController(currentIndex - 1);
    if (currentIndex < state.episodeList.length - 1) {
      _initializeController(currentIndex + 1);
    }
    _releaseUnusedControllers();
  }

  // 切换剧集时处理视频状态
  Future<void> onPageChanged(
    int index, {
    bool isToggle = false,
    bool isUploadHistorySeconds = true,
    int type = 0,
  }) async {
    // EasyThrottle.throttle('page-change', Duration(seconds: 3), () async {
    debugPrint('--$type-to-index:$index');
    if (index < 0 || index >= state.episodeList.length) return;
    if (listeneVipCoinSub) {
      vipCoinSubTimer?.cancel();
      vipCoinSubTimer = null;
      isShowingVipCoinSub = false;
      listeneVipCoinSub = false;
    }
    // 暂停当前视频
    if (controllers[currentIndex]?.value.isPlaying ?? false) {
      await controllers[currentIndex]?.pause();
      if (isUploadHistorySeconds) uploadHistorySeconds(controllers[currentIndex]?.value.position.inMilliseconds ?? 0);
    }
    if (controllers[currentIndex]?.value.isCompleted ?? false) {
      if (isUploadHistorySeconds) uploadHistorySeconds(0);
      if (state.activityId != null) reportActivity();
    }
    if (isToggle) {
      loadStatusType = LoadStatusType.loading;
      update();

      await _initializeController(index);
      loadStatusType = LoadStatusType.loadSuccess;
      update();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        pageController.jumpToPage(index);
      });
    }
    currentIndex = index;
    if (state.episodeList[index].isLock == true) {
      controllers[index]?.seekTo(Duration(seconds: 0));
      controllers[index]?.pause();
      update();
      EasyThrottle.throttle(
        'show-buy-dialog',
        Duration(milliseconds: 3000),
        () => autoShowBuyDialog(state.episodeList[index].coins ?? 0, index),
      );

      return;
    }

    if (controllers[index] != null) {
      if (state.curUnlock > index || userLogic.state.userInfo.isVip == true) {
        controllers[index]?.play();
      }
    } else {
      if (!isToggle) await _initializeController(index);
      if (state.curUnlock > index || userLogic.state.userInfo.isVip == true) {
        controllers[index]?.play();
      }
    }
    state.toolMuskTimer?.cancel();
    state.toolMuskTimer = null;
    controllers[index]?.setPlaybackSpeed(state.curSpeed);
    updateHomeVideo();
    // print('----curIndex:$currentIndex');
    // 预加载新的相邻视频，并释放多余控制器
    _preloadAdjacentVideos();
    update();
    createHistory();
    // });
  }

  Future<void> getShortPlayDetails({bool toPage = true}) async {
    Map<String, dynamic> params = {
      'short_play_id': state.shortPlayId,
      "video_id": state.videoId,
      // "revolution": state.revolution,
    };
    if (state.activityId != null) {
      params['activity_id'] = state.activityId;
    }
    for (var controller in controllers) {
      controller?.pause();
      controller?.dispose();
    }
    controllers.clear();
    try {
      ApiResponse res = await HttpClient().request(
        Apis.getVideoDetails,
        method: HttpMethod.get,
        queryParameters: params,
      );
      if (res.success) {
        videoStatus = LoadStatusType.loadSuccess;
        state.detailBean = ShortPlayDetailBean.fromJson(res.data);
        if (state.videoId <= 0) {
          state.videoId = state.detailBean?.videoInfo?.id ?? 0;
        }
        state.episodeList = state.detailBean?.episodeList ?? [];
        if (toPage) currentIndex = (state.detailBean?.videoInfo?.episode ?? 1) - 1;
        for (var video in state.episodeList) {
          if (video.isLock == true) {
            state.curUnlock = state.episodeList.indexOf(video);
            break;
          }
        }
        // createHistory();
        controllers = List<VideoPlayerController?>.filled(state.episodeList.length, null, growable: true);
        // await _initializeController(currentIndex);
        // _preloadAdjacentVideos();
        // if(currentIndex != 0){
        if (toPage) {
          onPageChanged(currentIndex, isToggle: true, isUploadHistorySeconds: false);
        } else {
          _initializeController(currentIndex);
        }
        // }

        // update();
      } else {
        videoStatus = LoadStatusType.loadFailed;
        update();
      }
      if (userLogic.state.userInfo.isVip == true) state.curUnlock = 9999;
      update();
    } catch (e) {
      videoStatus = LoadStatusType.loadFailed;
      update();
    }
  }

  checkVipCoinSub() async {
    if (listeneVipCoinSub) return;
    listeneVipCoinSub = true;
    if (vipCoinSubTimer != null) {
      vipCoinSubTimer!.cancel();
      vipCoinSubTimer = null;
    }
    vipCoinSubTimer = Timer(const Duration(milliseconds: 1500), () async {
      if (state.detailBean?.checkPoint?.contains(state.episodeList[currentIndex].shortPlayVideoId) ?? false) {
        final storeLogic = Get.put(StoreLogic());
        storeLogic.isCoinDialog = true;
        storeLogic.state.vipCoinShortPlayId = state.shortPlayId;
        storeLogic.state.vipCoinVideoId = state.episodeList[currentIndex].id;

        storeLogic.getVipPaySetting();
        storeLogic.pauseVideoFunc = () async {
          if (controllers[currentIndex]?.value.isPlaying ?? false) {
            await controllers[currentIndex]?.pause();
          } else {
            Future.delayed(Duration(milliseconds: 1000), () {
              controllers[currentIndex]?.pause();
            });
          }
        };
        storeLogic.coinDialogCallback = () {
          controllers[currentIndex]?.play();
          isShowingVipCoinSub = false;
          vipCoinSubTimer?.cancel();
          vipCoinSubTimer = null;
          update();
        };
      }
    });
  }

  void reportActivity() {
    Map<String, dynamic> params = {
      'short_play_id': state.shortPlayId,
      "short_play_video_id": state.episodeList[currentIndex].shortPlayVideoId,
      "activity_id": state.activityId,
    };
    HttpClient().request(Apis.activeAfterWatchingVideo, data: params);
  }

  void createHistory() {
    if (currentIndex < 0 || currentIndex >= state.episodeList.length) return;
    Map<String, dynamic> params = {"short_play_id": state.shortPlayId, "video_id": state.episodeList[currentIndex].id};
    HttpClient().request(Apis.createHistory, data: params);
  }

  void updateHomeVideo() {
    final homeLogic = Get.put(HomeController());
    final homeState = Get.find<HomeController>().state;
    int playTime = controllers[currentIndex]?.value.position.inSeconds ?? 0;
    homeState.curVideo = ShortVideoBean()
      ..shortPlayId = state.shortPlayId
      ..imageUrl = state.detailBean?.shortPlayInfo?.imageUrl
      ..name = state.detailBean?.shortPlayInfo?.name
      ..playTime = playTime
      ..process = currentIndex + 1;
    homeLogic.update();
  }

  void uploadHistorySeconds(int playSeconds) {
    Map<String, dynamic> params = {
      "short_play_id": state.shortPlayId,
      "video_id": state.episodeList[currentIndex].id,
      "play_seconds": playSeconds > 0 ? playSeconds : 0,
    };
    HttpClient().request(Apis.uploadHistorySeconds, data: params);
  }

  Future<void> collectVideo() async {
    ShortPlayInfo? spInfo = state.detailBean?.shortPlayInfo;
    if (spInfo == null) return;

    Map<String, dynamic> params = {"short_play_id": spInfo.shortPlayId, "video_id": state.episodeList[currentIndex].id};
    if (spInfo.isCollect ?? false) {
      await HttpClient().request(Apis.cancelCollectVideo, data: params);
    } else {
      await HttpClient().request(Apis.collectVideo, data: params);
    }

    spInfo.isCollect = !(spInfo.isCollect ?? false);
    try {
      final recommendLogic = Get.put(RecommendLogic());
      recommendLogic.setCollectVideo(spInfo.shortPlayId!, isCollect: spInfo.isCollect!);
      final collectLogic = Get.put(CollectLogic());
      collectLogic.getCollectList(refresh: true);
    } catch (e) {
      debugPrint('---err:$e');
    }
    update();
  }

  getRecommend() async {
    ApiResponse res = await HttpClient().request(Apis.getDetailsRecommand, method: HttpMethod.get);
    if (res.success) {
      state.recommendList = [...res.data['list'].map((item) => ShortVideoBean.fromJson(item))];
      // if (state.recommendList.isNotEmpty) {
      //   state.recommendId = state.recommendList.first.shortPlayId ?? -1;
      // }
      update();
    }
  }

  getResolution() async {
    ApiResponse res = await HttpClient().request(Apis.getRevolutions, method: HttpMethod.get);
    if (res.success) {
      state.resolutionList = [...res.data['list'].map((item) => ResolutionBean.fromJson(item)).toList()];
      update();
    }
  }

  autoShowBuyDialog(num coins, int index) {
    final mineLogic = Get.put(MineLogic());
    mineLogic.getUserInfo();
    if ((mineLogic.state.userInfo.coinLeftTotal ?? 0 + (mineLogic.state.userInfo.sendCoinLeftTotal ?? 0)) < coins &&
        state.curUnlock == index) {
      UserUtil().reportErrorEvent("pay open", "pay_template_dialog");
      state.detailBean?.payMode == 1 ? showBuyCoinDialog(coins) : showVipBuyDialog(coins);
    } else {
      Future.delayed(Duration(seconds: 1), () {
        buyVideo(state.episodeList[index].id!, coins);
      });
    }
  }

  buyVideo(num videoId, num coins, {bool toRecharge = false}) async {
    ApiResponse res = await HttpClient().request(
      Apis.buyVideo,
      data: {"short_play_id": state.shortPlayId, "video_id": videoId},
    );
    if (res.success) {
      String status = res.data['status'];
      if (status == 'success') {
        int index = state.episodeList.indexWhere((item) => item.id == videoId);
        state.episodeList[index].isLock = false;
        if (index != state.episodeList.length - 1) {
          state.curUnlock = index + 1;
        }
        update();
        onPageChanged(index, isToggle: true);
        final mineLogic = Get.put(MineLogic());
        mineLogic.getUserInfo();
      } else if (res.data['status'] == 'not_enough') {
        ToastUtils.show('Coin not enough');
        UserUtil().reportErrorEvent("pay open", "pay_template_dialog");
        if (toRecharge) state.detailBean?.payMode == 1 ? showBuyCoinDialog(coins) : showVipBuyDialog(coins);
        // toRecharge ? showVipBuyDialog(coins) : showUnlockDialog(coins);
      } else if (status == 'jump') {
        ToastUtils.show('Cannot jump episode');
      }
    } else {
      ToastUtils.show('Purchase failed');
    }
  }

  showVipBuyDialog(num coins) {
    Get.put(StoreLogic());
    EasyThrottle.throttle('restore-short', Duration(seconds: 3), () => BuyUtils.restorePay(showTips: false));
    Get.bottomSheet(
      isScrollControlled: true,
      Container(
        width: ScreenUtil().screenWidth,
        height: ScreenUtil().screenHeight,
        padding: EdgeInsets.fromLTRB(15.w, kToolbarHeight, 15.w, 10.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.w)),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'My Coins:',
                        style: TextStyle(fontSize: 13.sp, color: ColorResource.bg_BCBCBC),
                      ),
                      GetBuilder<MineLogic>(
                        builder: (logic) {
                          return Text(
                            '${(logic.state.userInfo.coinLeftTotal ?? 0) + (logic.state.userInfo.sendCoinLeftTotal ?? 0)}',
                            style: TextStyle(fontSize: 13.sp, color: ColorResource.mainColor),
                          );
                        },
                      ),
                      SizedBox(width: 2.w),
                      Image.asset('ic_coin.png'.icon, width: 16.w),
                      SizedBox(width: 10.w),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 8.w, horizontal: 12.w),
                        decoration: BoxDecoration(
                          color: ColorResource.mainColor,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Unlock:',
                              style: TextStyle(fontSize: 13.sp, color: ColorResource.bg_EFEEF8),
                            ),
                            Text(
                              '$coins',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: ColorResource.bg_FFB635,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Image.asset('ic_coin.png'.icon, width: 16.w),
                          ],
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                      UserUtil().reportErrorEvent("pay cancel", "pay_template_dialog");
                    },
                    child: Image.asset('ic_dialog_close.png'.icon, width: 24.w),
                  ),
                ],
              ),
              SizedBox(height: 15.w),
              GetBuilder<StoreLogic>(
                builder: (logic) {
                  return StoreWidget(
                    store: logic.state.storeBean,
                    onItemTap: (goods) async {
                      logic.func = () {
                        Get.back();
                        getShortPlayDetails(toPage: false);
                        buyVideo(state.episodeList[currentIndex].id!, coins, toRecharge: false);
                        // checkVipCoinSub();
                      };
                      EasyThrottle.throttle(
                        'buy',
                        Duration(seconds: 3),
                        () async => await logic.buyGoods(
                          goods,
                          shortPlayId: state.shortPlayId,
                          videoId: state.episodeList[currentIndex].id,
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  showRecommendDialog() {
    EasyThrottle.throttle('show-recommend', Duration(seconds: 3), () async {
      controllers[currentIndex]?.pause();
      Get.bottomSheet(
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        backgroundColor: Colors.white,
        StatefulBuilder(
          builder: (context, dialogState) {
            return Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: 510.w,
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () => Get
                              ..back()
                              ..back(),
                            child: Image.asset('ic_dialog_close.png'.icon, width: 24.w),
                          ),
                        ],
                      ),
                      SizedBox(height: 15.w),
                      SizedBox(
                        height: 30.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [Image.asset('ic_star_1.png'.icon, width: 10.w)],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6.w),
                              child: Text(
                                'Don\'t Miss This!',
                                style: TextStyle(fontSize: 18.sp, color: Colors.black, fontWeight: FontWeight.w500),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [Image.asset('ic_star_2.png'.icon, width: 18.w)],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15.w),
                      SizedBox(
                        height: 280.w,
                        child: Swiper(
                          onIndexChanged: (index) {
                            state.recommendIndex = index;
                            dialogState(() {});
                          },
                          itemCount: state.recommendList.length,
                          itemBuilder: (context, index) => Stack(
                            children: [
                              Center(
                                child: Container(
                                  width: 196.57.w,
                                  height: 278.77.w,
                                  padding: EdgeInsets.only(top: 14.w, right: 4.w),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(image: AssetImage('ic_recommend_video_bg.png'.icon)),
                                  ),
                                  child: Transform.rotate(
                                    angle: 4 * pi / 180,
                                    child: Column(
                                      children: [
                                        AppCachedImage(
                                          imageUrl: state.recommendList[index].imageUrl ?? '',
                                          width: 158.w,
                                          height: 208.w,
                                          borderRadius: BorderRadius.circular(8.w),
                                        ),
                                        SizedBox(height: 4.w),
                                        SizedBox(
                                          width: 158.w,
                                          child: Text(
                                            state.recommendList[index].name ?? '',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 14.sp, color: ColorResource.mainBlack),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 15.w),
                      SizedBox(
                        height: 12.w,
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (_, index) {
                            bool isSel = index == state.recommendIndex;
                            return Center(
                              child: Container(
                                width: isSel ? 8.w : 6.w,
                                height: isSel ? 8.w : 6.w,
                                decoration: BoxDecoration(
                                  color: isSel ? ColorResource.mainColor : Colors.transparent,
                                  borderRadius: BorderRadius.circular(5.w),
                                  border: Border.all(color: Colors.black, width: isSel ? 1.w : 0.5.w),
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (_, __) => SizedBox(width: 4.w),
                          itemCount: state.recommendList.length,
                        ),
                      ),
                      SizedBox(height: 12.w),

                      GestureDetector(
                        onTap: () {
                          Get.back();
                          state.shortPlayId = state.recommendList[state.recommendIndex].shortPlayId ?? -1;
                          // state.activityId = Get.arguments['activityId'];
                          state.videoId = 0;
                          state.imageUrl = state.recommendList[state.recommendIndex].imageUrl ?? '';
                          // state.isFromRecommend = true;
                          initData();
                        },
                        child: Container(
                          width: 240.w,
                          height: 48.w,
                          decoration: MyStyles.mainBorder(radius: 50, width: 1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Watch Now',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: ColorResource.mainWhite,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Image.asset('ic_play_white.png'.icon, width: 7.w, height: 10.w),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: -37.w,
                  child: Image.asset('ic_recommend_dialog_panda.png'.icon, width: 118.w, height: 64.w),
                ),
              ],
            );
          },
        ),
      );
    });
  }

  showBuyCoinDialog(num coins) async {
    for (var controller in controllers) {
      await controller?.pause();
    }
    final logic = Get.put(StoreLogic(), permanent: true);
    final storeState = Get.find<StoreLogic>().state;
    logic.getStoreInfo();
    Get.bottomSheet(
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      GetBuilder<StoreLogic>(
        assignId: true,
        builder: (ctrl) {
          return SizedBox(
            width: ScreenUtil().screenWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (storeState.refillCoinList.isNotEmpty)
                  Container(
                    margin: EdgeInsets.only(left: 15.w),
                    child: Text(
                      'Weekly Refill',
                      style: TextStyle(fontSize: 15.sp, color: Color(0xFFFFDAA4), fontWeight: FontWeight.w800),
                    ),
                  ),
                if (storeState.refillCoinList.isNotEmpty)
                  // Container(
                  //   height: 85.w,
                  //   margin: EdgeInsets.only(top: 10.w),
                  //   child: ListView.separated(
                  //     padding: EdgeInsets.only(left: 15.w),
                  //     shrinkWrap: true,
                  //     scrollDirection: Axis.horizontal,
                  //     itemBuilder: (context, index) {
                  //       GoodsBean? item = storeState.refillCoinList[index];
                  //       return GestureDetector(
                  //         onTap: () {
                  //           logic.func = () {
                  //             Get.back();
                  //             getShortPlayDetails(toPage: false);
                  //             // checkVipCoinSub();
                  //             buyVideo(state.episodeList[currentIndex].id!, coins, toRecharge: false);
                  //           };
                  //           logic.buyGoods(
                  //             item,
                  //             shortPlayId: state.shortPlayId,
                  //             videoId: state.episodeList[currentIndex].id,
                  //           );
                  //         },
                  //         child: Container(
                  //           width: ScreenUtil().screenWidth - 32.w,
                  //           padding: EdgeInsets.only(left: 14.w, top: 17.w),
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(8.w),
                  //             image: DecorationImage(image: AssetImage('card_bg.png'.icon), fit: BoxFit.fill),
                  //           ),
                  //           child: Row(
                  //             crossAxisAlignment: CrossAxisAlignment.end,
                  //             children: [
                  //               Column(
                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                 children: [
                  //                   Text(
                  //                     'Weekly Refill',
                  //                     style: TextStyle(
                  //                       fontSize: 15.sp,
                  //                       color: ColorResource.mainBlack,
                  //                       fontFamily: 'Inter',
                  //                       fontWeight: FontWeight.w700,
                  //                     ),
                  //                   ),
                  //                   SizedBox(height: 8.w),
                  //                   Row(
                  //                     children: [
                  //                       Image.asset('ic_coin.png'.icon, width: 16.w),
                  //                       SizedBox(width: 4.w),
                  //                       Text(
                  //                         '${item.extInfo?.maxTotalCoins ?? 0}',
                  //                         style: TextStyle(
                  //                           fontSize: 18.sp,
                  //                           color: Color(0xFFFFB635),
                  //                           fontWeight: FontWeight.w700,
                  //                           fontFamily: 'Inter',
                  //                         ),
                  //                       ),
                  //                       SizedBox(width: 4.w),
                  //                       Container(
                  //                         padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.w),
                  //                         decoration: BoxDecoration(
                  //                           color: Color(0xFFFFFDF9).withValues(alpha: .6),
                  //                           border: Border.all(width: 1.w, color: ColorResource.mainWhite),
                  //                           borderRadius: BorderRadius.circular(20.w),
                  //                         ),
                  //                         child: Text(
                  //                           item.extInfo?.receiveCoinsRate ?? '',
                  //                           style: TextStyle(
                  //                             fontSize: 12.sp,
                  //                             fontFamily: 'Inter',
                  //                             fontWeight: FontWeight.w500,
                  //                             color: Color(0xFF9C9EE9),
                  //                           ),
                  //                         ),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                 ],
                  //               ),
                  //               const Spacer(),
                  //               Container(
                  //                 height: item.discountType != 0 ? 46.w : 32.w,
                  //                 padding: EdgeInsets.fromLTRB(18.w, 5.w, 15.w, 5.w),
                  //                 decoration: BoxDecoration(
                  //                   borderRadius: BorderRadius.only(
                  //                     topLeft: Radius.circular(18.w),
                  //                     bottomRight: Radius.circular(8.w),
                  //                   ),
                  //                   gradient: LinearGradient(colors: [Color(0xFFFFEACC), Color(0xFFEBC082)]),
                  //                 ),
                  //                 child: Column(
                  //                   children: [
                  //                     Row(
                  //                       children: [
                  //                         Text(
                  //                           item.discountType != 0
                  //                               ? (Platform.isAndroid
                  //                                     ? (item.productDetails?.price ?? '')
                  //                                     : MyUtils.getDiscountPrice(item.productDetails))
                  //                               : (Platform.isIOS
                  //                                     ? (item.productDetails?.price ?? '')
                  //                                     : MyUtils.getDiscountPrice(item.productDetails)),
                  //                           style: TextStyle(
                  //                             fontFamily: 'Inter',
                  //                             fontWeight: FontWeight.w700,
                  //                             fontSize: 18.sp,
                  //                             height: 0.8,
                  //                           ),
                  //                         ),
                  //                         Text(
                  //                           '/${MyUtils.filterVipType(item.vipType)['shortName']}',
                  //                           style: TextStyle(
                  //                             fontFamily: 'Inter',
                  //                             fontWeight: FontWeight.w400,
                  //                             fontSize: 12.sp,
                  //                           ),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                     if (item.discountType != 0)
                  //                       Text(
                  //                         Platform.isIOS
                  //                             ? (item.productDetails?.price ?? '')
                  //                             : MyUtils.getDiscountPrice(item.productDetails),
                  //                         style: TextStyle(
                  //                           fontSize: 10.sp,
                  //                           color: Colors.black.withValues(alpha: .15),
                  //                           fontWeight: FontWeight.w300,
                  //                           decoration: TextDecoration.lineThrough,
                  //                           decorationColor: Colors.black.withValues(alpha: .15),
                  //                         ),
                  //                       ),
                  //                   ],
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       );
                  //     },
                  //     separatorBuilder: (_, __) => SizedBox(width: 12.w),
                  //     itemCount: storeState.refillCoinList.length,
                  //   ),
                  // ),
                  CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: false,
                      enableInfiniteScroll: false,
                      viewportFraction: .90,
                      height: 85.w,
                      onPageChanged: (index, reason) {
                        state.currentSubCoinIndex = index;
                      },
                    ),
                    items: List.generate(storeState.refillCoinList.length, (index) {
                      final item = storeState.refillCoinList[index];
                      return Builder(
                        builder: (BuildContext context) {
                          return GestureDetector(
                            onTap: () {
                              logic.func = () {
                                Get.back();
                                getShortPlayDetails(toPage: false);
                                // checkVipCoinSub();
                                buyVideo(state.episodeList[currentIndex].id!, coins, toRecharge: false);
                              };
                              logic.buyGoods(
                                item,
                                shortPlayId: state.shortPlayId,
                                videoId: state.episodeList[currentIndex].id,
                              );
                            },
                            child: Container(
                              width: ScreenUtil().screenWidth - 32.w,
                              padding: EdgeInsets.only(left: 14.w, top: 17.w),
                              margin: EdgeInsets.only(right: 12.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.w),
                                image: DecorationImage(image: AssetImage('card_bg.png'.icon), fit: BoxFit.fill),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Weekly Refill',
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          color: ColorResource.mainBlack,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(height: 8.w),
                                      Row(
                                        children: [
                                          Image.asset('ic_coin.png'.icon, width: 16.w),
                                          SizedBox(width: 4.w),
                                          Text(
                                            '${item.extInfo?.maxTotalCoins ?? 0}',
                                            style: TextStyle(
                                              fontSize: 18.sp,
                                              color: Color(0xFFFFB635),
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Inter',
                                            ),
                                          ),
                                          SizedBox(width: 4.w),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.w),
                                            decoration: BoxDecoration(
                                              color: Color(0xFFFFFDF9).withValues(alpha: .6),
                                              border: Border.all(width: 1.w, color: ColorResource.mainWhite),
                                              borderRadius: BorderRadius.circular(20.w),
                                            ),
                                            child: Text(
                                              item.extInfo?.receiveCoinsRate ?? '',
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFF9C9EE9),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Container(
                                    height: item.discountType != 0 ? 46.w : 32.w,
                                    padding: EdgeInsets.fromLTRB(18.w, 5.w, 15.w, 5.w),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(18.w),
                                        bottomRight: Radius.circular(8.w),
                                      ),
                                      gradient: LinearGradient(colors: [Color(0xFFFFEACC), Color(0xFFEBC082)]),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              item.discountType != 0
                                                  ? (Platform.isAndroid
                                                        ? (item.productDetails?.price ?? '')
                                                        : MyUtils.getDiscountPrice(item.productDetails))
                                                  : (Platform.isIOS
                                                        ? (item.productDetails?.price ?? '')
                                                        : MyUtils.getDiscountPrice(item.productDetails)),
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w700,
                                                fontSize: 18.sp,
                                                height: 0.8,
                                              ),
                                            ),
                                            Text(
                                              '/${MyUtils.filterVipType(item.vipType)['shortName']}',
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (item.discountType != 0)
                                          DoubleLine(
                                            text: Platform.isIOS
                                                ? (item.productDetails?.price ?? '')
                                                : MyUtils.getDiscountPrice(item.productDetails),
                                          ),
                                        // Text(
                                        //   Platform.isIOS
                                        //       ? (item.productDetails?.price ?? '')
                                        //       : MyUtils.getDiscountPrice(item.productDetails),
                                        //   style: TextStyle(
                                        //     fontSize: 10.sp,
                                        //     color: Colors.black.withValues(alpha: .15),
                                        //     fontWeight: FontWeight.w300,
                                        //     decoration: TextDecoration.lineThrough,
                                        //     decorationColor: Colors.black.withValues(alpha: .15),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                SizedBox(height: 10.w),
                Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: ScreenUtil().screenWidth,
                          height: 162.w,
                          alignment: Alignment.bottomCenter,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('refill_dialog_top.png'.icon),
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Color(0xFFE0E1FF),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      'Balance: ',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        color: ColorResource.mainBlack,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                    GetBuilder<MineLogic>(
                                      builder: (logic) {
                                        return Text(
                                          '${(logic.state.userInfo.coinLeftTotal ?? 0) + (logic.state.userInfo.sendCoinLeftTotal ?? 0)}',
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            color: Color(0xFFFFB635),
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        );
                                      },
                                    ),
                                    Image.asset('ic_coin.png'.icon, width: 15.w),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          right: 15.w,
                          bottom: 30.w,
                          child: GestureDetector(
                            onTap: () {
                              Get.back();
                              showBuyCloseDialog();
                              UserUtil().reportErrorEvent("pay cancel", "pay_template_dialog");
                            },
                            child: Image.asset('ic_dialog_close.png'.icon, width: 24.w),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: ScreenUtil().screenWidth,
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFFE8E9FA), Colors.white],
                        ),
                      ),
                      child: storeState.storeBean.showType == 1
                          ? Column(
                              children: [
                                SizedBox(height: 16.w),
                                Text(
                                  'Episode Locked',
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w800,
                                    fontFamily: 'Inter',
                                    color: Color(0xFFFFB635),
                                  ),
                                ),
                                SizedBox(height: 13.w),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Price to unlock this episode:',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'Inter',
                                        color: ColorResource.mainBlack,
                                      ),
                                    ),
                                    SizedBox(width: 5.w),
                                    Image.asset('ic_coin.png'.icon, width: 12.w, height: 12.w),
                                    SizedBox(width: 5.w),
                                    Text(
                                      '$coins',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFFFFB635),
                                        fontFamily: 'Inter',
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 25.w),
                                GestureDetector(
                                  onTap: () {
                                    if (storeState.refillCoinList.isNotEmpty) {
                                      GoodsBean? item = storeState.refillCoinList[state.currentSubCoinIndex];
                                      logic.func = () {
                                        Get.back();
                                        getShortPlayDetails(toPage: false);
                                        buyVideo(state.episodeList[currentIndex].id!, coins, toRecharge: false);
                                      };
                                      logic.buyGoods(
                                        item,
                                        shortPlayId: state.shortPlayId,
                                        videoId: state.episodeList[currentIndex].id,
                                      );
                                    } else {
                                      ToastUtils.show('Not enough balance, please recharge!');
                                    }
                                  },
                                  child: Container(
                                    height: 48.w,
                                    width: ScreenUtil().screenWidth - 30.w,
                                    decoration: MyStyles.mainBorder(radius: 50, width: 1, bgColor: Color(0xFFC2C2C2)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset('ic_unlock_lock.png'.icon, width: 14.w),
                                        SizedBox(width: 6.w),
                                        Text(
                                          'Unlock Now',
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w600,
                                            color: ColorResource.mainWhite,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 54.w),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Extra Refill',
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    color: ColorResource.mainBlack,
                                    fontWeight: FontWeight.w800,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                                StoreWidget(
                                  store: storeState.storeBean,
                                  onlyCoins: true,
                                  onItemTap: (goods) async {
                                    logic.func = () {
                                      Get.back();
                                      getShortPlayDetails(toPage: false);
                                      if (goods.buyType != 'sub_vip') {
                                        buyVideo(state.episodeList[currentIndex].id!, coins, toRecharge: false);
                                      }
                                      // checkVipCoinSub();
                                    };
                                    EasyThrottle.throttle(
                                      'buy',
                                      Duration(seconds: 2),
                                      () async => await logic.buyGoods(
                                        goods,
                                        shortPlayId: state.shortPlayId,
                                        videoId: state.episodeList[currentIndex].id,
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(height: 54.w),
                              ],
                            ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Map<String, dynamic> filterVipType(String? type) {
    if (MyUtils.isEmpty(type)) {
      return {};
    }
    List<Map<String, dynamic>> vipTypes = [
      {'type': 'week', 'name': 'Weekly', 'shortName': 'week'},
      {'type': 'month', 'name': 'Wonthly', 'shortName': 'month'},
      {'type': 'three_months', 'name': 'Quarterly', 'shortName': 'quarter'},
      {'type': 'yearly', 'name': 'Yearly', 'shortName': 'year'},
    ];
    final filterType = vipTypes.where((item) => item['type'] == type).cast<Map<String, dynamic>?>().firstOrNull;
    if (filterType != null) {
      return filterType;
    }
    return {};
  }

  showBuyCloseDialog() async {
    ApiResponse res = await HttpClient().request(Apis.getRetainVipPaySetting, method: HttpMethod.get);
    if (res.success) {
      if (MyUtils.isEmpty(res.data['info'])) return;

      Map<String, dynamic> infoMap = res.data['info'];
      // 检查 ext_info 是否也是字符串，如果是则解析
      if (infoMap['ext_info'] != null && infoMap['ext_info'] is String) {
        infoMap['ext_info'] = json.decode(infoMap['ext_info']);
      }
      GoodsBean? item = GoodsBean.fromJson(infoMap);
      if (item.extInfo?.coinsWinBackShow != true) return;
      final logic = Get.put(StoreLogic());
      bool storeRes = await logic.initVipSubCoinStore(item);
      if (Get.currentRoute != AppRoutes.shortVideo) return;
      if (storeRes) {
        Get.dialog(
          GetBuilder<StoreLogic>(
            assignId: true,
            builder: (ctrl) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${filterVipType(item.vipType)['name']} VIP',
                      style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w900, color: Color(0xFFFAD188)),
                    ),
                    SizedBox(height: 20.w),
                    Container(
                      width: ScreenUtil().screenWidth - 32.w,
                      padding: EdgeInsets.only(left: 14.w, top: 17.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.w),
                        image: DecorationImage(image: AssetImage('card_bg.png'.icon), fit: BoxFit.fill),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Image.asset('ic_vip_crown.png'.icon, width: 22.w),
                                  SizedBox(width: 4.w),
                                  Text(
                                    '${filterVipType(item.vipType)['name']} Vip',
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      color: ColorResource.mainBlack,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w700,
                                      height: 1,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12.w),
                              Text(
                                'Unlimited access to all series',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: ColorResource.bg_777777,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Inter',
                                ),
                              ),
                              SizedBox(height: 17.w),
                            ],
                          ),
                          const Spacer(),
                          Container(
                            padding: EdgeInsets.fromLTRB(15.w, 5.w, 13.w, 5.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(18.w),
                                bottomRight: Radius.circular(8.w),
                              ),
                              gradient: LinearGradient(colors: [Color(0xFFFFEACC), Color(0xFFEBC082)]),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 90.w,
                                      child: Text(
                                        item.discountType != 0
                                            ? (Platform.isAndroid
                                                  ? (item.discountType == 2
                                                        ? MyUtils.getDiscountPrice(
                                                            item.productDetails,
                                                            showDiscount: true,
                                                          )
                                                        : item.productDetails?.price ?? '')
                                                  : MyUtils.getDiscountPrice(item.productDetails))
                                            : (Platform.isIOS
                                                  ? (item.productDetails?.price ?? '')
                                                  : MyUtils.getDiscountPrice(item.productDetails)),
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16.sp,
                                          height: 0.8,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '/${filterVipType(item.vipType)['shortName']}',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                if (item.discountType != 0)
                                  DoubleLine(
                                    text: Platform.isIOS
                                        ? (item.productDetails?.price ?? '')
                                        : MyUtils.getDiscountPrice(item.productDetails),
                                  ),
                                // Text(
                                //   Platform.isIOS
                                //       ? (item.productDetails?.price ?? '')
                                //       : MyUtils.getDiscountPrice(item.productDetails),
                                //   style: TextStyle(
                                //     fontSize: 10.sp,
                                //     color: Colors.black.withValues(alpha: .15),
                                //     fontWeight: FontWeight.w300,
                                //     decoration: TextDecoration.lineThrough,
                                //     decorationColor: Colors.black.withValues(alpha: .25),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 14.w),
                      child: Text(
                        'Unlock every show you love!',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic,
                          color: Color(0xFFFAD188),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        logic.isRaminVipDialog = true;
                        logic.state.remainVipDialogBean = item;
                        logic.func = () {
                          Get.back();
                          getShortPlayDetails(toPage: false);
                          logic.isRaminVipDialog = false;
                          // checkVipCoinSub();
                        };
                        logic.buyGoods(
                          item,
                          shortPlayId: state.shortPlayId,
                          videoId: state.episodeList[currentIndex].id,
                        );
                      },
                      child: Container(
                        decoration: MyStyles.mainBorder(radius: 100),
                        padding: EdgeInsets.symmetric(vertical: 17.w),
                        width: 260.w,
                        alignment: Alignment.center,
                        child: Text(
                          'Buy Now',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                            color: ColorResource.mainWhite,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.w),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Image.asset('ic_dialog_close.png'.icon, width: 24.w, height: 24.w),
                    ),
                  ],
                ),
              );
            },
          ),
          barrierDismissible: false,
        );
      }
    }
  }
}

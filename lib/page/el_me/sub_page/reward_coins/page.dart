import 'package:elyra/bean/reward_coin_bean.dart';
import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/el_me/sub_page/reward_coins/controller.dart';
import 'package:elyra/widgets/bad_status_widget.dart';
import 'package:elyra/widgets/el_nodata_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RewardCoinsPage extends StatefulWidget {
  const RewardCoinsPage({super.key});

  @override
  State<RewardCoinsPage> createState() => _RewardCoinsPageState();
}

class _RewardCoinsPageState extends State<RewardCoinsPage> {
  late final RewardCoinsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(RewardCoinsController());
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RewardCoinsController>(
      builder: (controller) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          body: Container(
            padding: EdgeInsets.only(top: ScreenUtil().statusBarHeight),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('ely_background_image.png'.icon),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppBar('Reward Coins'),
                SizedBox(height: 6.h),
                Expanded(
                  child: SmartRefresher(
                    controller: controller.refreshController,
                    enablePullDown: true,
                    enablePullUp: true,
                    onRefresh: controller.onRefresh,
                    header: ClassicHeader(
                      height: 40,
                      textStyle: TextStyle(color: Colors.white),
                      idleText: 'Pull to refresh',
                      releaseText: 'Release to refresh',
                      refreshingText: 'Refreshing...',
                      completeText: 'Refresh completed',
                      failedText: 'Refresh failed',
                    ),
                    child: _buildContent(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBar(String title) {
    return Container(
      padding: EdgeInsets.only(left: 11.w, right: 11.w, top: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => Get.back(),
            child: Padding(
              padding: EdgeInsets.all(5.w),
              child: Image.asset('ely_back.png'.icon, height: 20.h),
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'PingFang SC',
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 30.w),
        ],
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

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: controller.state.rewardList.length,
      itemBuilder: (context, index) {
        return _buildRewardItem(controller.state.rewardList[index]);
      },
    );
  }

  Widget _buildRewardItem(RewardCoinBean record) {
    bool isExpired =
        record.diffDatetime?.toString().contains("Expired") ?? false;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        children: [
          // Top Line Divider
          Container(
            width: 343.w,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1,
                  strokeAlign: BorderSide.strokeAlignCenter,
                  color: Colors.white.withOpacity(0.10),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record.createdAt ?? "",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 12.sp,
                          fontFamily: 'PingFang SC',
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        record.type ?? "",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'PingFang SC',
                        ),
                      ),
                      SizedBox(height: 8.h),
                      if (isExpired)
                        Text(
                          'Expired',
                          style: TextStyle(
                            color: const Color(0xFFFF0BBA),
                            fontSize: 12.sp,
                            fontFamily: 'PingFang SC',
                          ),
                        )
                      else
                        Row(
                          children: [
                            Image.asset('el_time_order.png'.icon, width: 18.w, height: 18.w),
                            SizedBox(width: 4.w),
                            Text(
                              'Expires in ${record.diffDatetime ?? ""}',
                              style: TextStyle(
                                color: const Color(0xFFFFB6EA),
                                fontSize: 12.sp,
                                fontFamily: 'PingFang SC',
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
                // Right Column
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${record.coins ?? 0}',
                      style: TextStyle(
                        color: const Color(0xFFFF0BBA),
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w900,
                        fontFamily: 'DDinPro',
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Remaining: ${record.leftCoins ?? 0}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12.sp,
                        fontFamily: 'PingFang SC',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

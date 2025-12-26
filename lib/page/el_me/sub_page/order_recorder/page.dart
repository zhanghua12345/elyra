import 'package:elyra/bean/order_record_bean.dart';
import 'package:elyra/bean/reward_coin_bean.dart';
import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/el_me/sub_page/order_recorder/controller.dart';
import 'package:elyra/widgets/bad_status_widget.dart';
import 'package:elyra/widgets/el_nodata_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class OrderRecorderPage extends StatefulWidget {
  const OrderRecorderPage({super.key});

  @override
  State<OrderRecorderPage> createState() => _OrderRecorderPageState();
}

class _OrderRecorderPageState extends State<OrderRecorderPage> {
  late final OrderRecorderController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(OrderRecorderController());
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderRecorderController>(
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
                SizedBox(height: 10.h),
                _buildTabSwitcher(controller),
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
      itemCount: controller.state.recordsList.length,
      itemBuilder: (context, index) {
        return _buildRewardItem(controller.state.recordsList[index]);
      },
    );
  }

  Widget _buildRewardItem(OrderRecordBean record) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
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
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
            child: Column(
              children: [
                // Top Row: time & type (Left), coins (Right)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            record.type ?? "",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              color: const Color(0xFF999999),
                              fontSize: 12,
                              fontFamily: 'PingFang SC',
                              fontWeight: FontWeight.w400,
                              height: 1,
                              letterSpacing: -0,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            record.createdAt ?? "",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'PingFang SC',
                              fontWeight: FontWeight.w600,
                              height: 1,
                              letterSpacing: -0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 30.w),
                    Text(
                      '+${record.value ?? 0}',
                      style: TextStyle(
                        color: const Color(0xFFFF0BBA),
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        height: 1,
                        letterSpacing: -0,
                        fontFamily: 'DDinPro',
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

  Widget _buildTabSwitcher(OrderRecorderController controller) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      width: 343.w,
      height: 48.h,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(40.w),
      ),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            left: controller.state.tabIndex == 0 ? 4.w : 179.w,
            top: 4.h,
            child: Container(
              width: 160.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: const Color(0xFFFF0BBA),
                borderRadius: BorderRadius.circular(38.w),
              ),
            ),
          ),
          Row(
            children: [
              _buildTabItem(controller, 0, 'Coin Record'),
              _buildTabItem(controller, 1, 'VIP Record'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(
    OrderRecorderController controller,
    int index,
    String title,
  ) {
    final isSelected = controller.state.tabIndex == index;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => controller.switchTab(index),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

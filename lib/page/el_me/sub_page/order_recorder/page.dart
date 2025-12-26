import 'package:elyra/bean/order_record_bean.dart';
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
  late final OrderRecorderPageController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(OrderRecorderPageController());
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderRecorderPageController>(
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
                _buildAppBar('Order Records'),
                SizedBox(height: 6.h),
                _buildTabSwitcher(controller),
                Expanded(
                  child: SmartRefresher(
                    controller: controller.refreshController,
                    enablePullDown: true,
                    enablePullUp: true,
                    onRefresh: controller.onRefresh,
                    onLoading: controller.onLoadMore,
                    header: const ClassicHeader(
                      height: 40,
                      textStyle: TextStyle(color: Colors.white),
                      idleText: 'Pull to refresh',
                      releaseText: 'Release to refresh',
                      refreshingText: 'Refreshing...',
                      completeText: 'Refresh completed',
                      failedText: 'Refresh failed',
                    ),
                    footer: const CustomFooter(builder: _buildFooter),
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
            style: const TextStyle(
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

  Widget _buildTabSwitcher(OrderRecorderPageController controller) {
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
    OrderRecorderPageController controller,
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

  Widget _buildContent() {
    if (controller.state.loadStatus == LoadStatusType.loading) {
      return Center(
        child: Image.asset('loading.gif'.icon, width: 80.w, height: 80.w),
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

    final records = controller.state.currentList;

    if (records.isEmpty) {
      return ElNoDataWidget(
        imagePath: 'ely_nodata.png',
        imageWidth: 180,
        imageHeight: 223,
        description: 'There is no data for the moment.',
      );
    }

    return _buildContentArea(records);
  }

  Widget _buildContentArea(List<OrderRecordItem> records) {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 20.h),
      itemCount: records.length,
      separatorBuilder: (context, index) =>
          Divider(color: Colors.white.withOpacity(0.1), height: 1.h),
      itemBuilder: (context, index) {
        final record = records[index];
        final isCoin = controller.state.tabIndex == 0;

        return Container(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.title ?? (isCoin ? "Top Up" : "Purchase VIP"),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      record.createdAt ?? '',
                      style: TextStyle(
                        color: const Color(0xFF999999),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    isCoin
                        ? '+${record.coins ?? 0}'
                        : '+${record.vipDays ?? 0} days',
                    style: TextStyle(
                      color: const Color(0xFFFF0BBA),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'DDinPro',
                    ),
                  ),
                  if (record.payMoney != null)
                    Padding(
                      padding: EdgeInsets.only(top: 4.h),
                      child: Text(
                        '${record.payCurrency ?? '\$'}${record.payMoney}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 10.sp,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget _buildFooter(BuildContext context, LoadStatus? mode) {
    Widget body;
    if (mode == LoadStatus.idle) {
      body = const Text(
        "Pull up load",
        style: TextStyle(color: Colors.white54),
      );
    } else if (mode == LoadStatus.loading) {
      body = const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    } else if (mode == LoadStatus.failed) {
      body = const Text(
        "Load Failed! Click retry!",
        style: TextStyle(color: Colors.white54),
      );
    } else if (mode == LoadStatus.canLoading) {
      body = const Text(
        "Release to load more",
        style: TextStyle(color: Colors.white54),
      );
    } else {
      body = const Text(
        "No more data",
        style: TextStyle(color: Colors.white54),
      );
    }
    return SizedBox(height: 55.0, child: Center(child: body));
  }
}

import 'package:elyra/bean/consumption_record_bean.dart';
import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/el_me/sub_page/consumption_records/controller.dart';
import 'package:elyra/widgets/bad_status_widget.dart';
import 'package:elyra/widgets/el_nodata_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ConsumptionRecordsPage extends StatefulWidget {
  const ConsumptionRecordsPage({super.key});

  @override
  State<ConsumptionRecordsPage> createState() => _ConsumptionRecordsPageState();
}

class _ConsumptionRecordsPageState extends State<ConsumptionRecordsPage> {
  late final ConsumptionRecordsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ConsumptionRecordsController());
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConsumptionRecordsController>(
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
                _buildAppBar('Consumption Records'),
                SizedBox(height: 6.h),
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

  Widget _buildContent() {
    if (controller.state.loadStatus == LoadStatusType.loading) {
      return Center(
        child: Image.asset('loading.gif'.icon, width: 120.w, height: 120.w),
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
      itemCount: controller.state.consumptionList.length,
      itemBuilder: (context, index) {
        return _buildConsumptionItem(controller.state.consumptionList[index]);
      },
    );
  }

  Widget _buildConsumptionItem(ConsumptionRecordBean record) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        children: [
          // 上方线条
          Container(
            width: 343.w,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1,
                  strokeAlign: BorderSide.strokeAlignCenter,
                  color: Colors.white.withValues(alpha: 0.10),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Column(
              children: [
                // 上面的row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Purchase Single Episode",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'PingFang SC',
                      ),
                    ),
                    Text(
                      record.createdAt ?? "",
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 12.sp,
                        fontFamily: 'PingFang SC',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                // 下面的row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'EP.${record.episode} ${record.name}',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 12.sp,
                          fontFamily: 'PingFang SC',
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      '-${record.coins ?? 0} Coins',
                      style: TextStyle(
                        color: const Color(0xFFFF0BBA),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w900,
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

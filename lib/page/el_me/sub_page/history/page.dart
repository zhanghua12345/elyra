import 'package:elyra/page/el_me/sub_page/history/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyHistoryPage extends StatelessWidget {
  const MyHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyHistoryPageController>(
      init: MyHistoryPageController(),
      builder: (controller) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                padding: EdgeInsets.all(12.w),
                child: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20.w),
              ),
            ),
            title: Text(
              'Order Records',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFB0027C),
                  const Color(0xFF44267C),
                  const Color(0xFF280A62),
                  const Color(0xFF16003E)
                ],
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: ScreenUtil().statusBarHeight + 56.h),
                _buildTabSwitcher(controller),
                Expanded(
                  child: SmartRefresher(
                    controller: controller.refreshController,
                    onRefresh: controller.onRefresh,
                    child: _buildList(controller),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabSwitcher(MyHistoryPageController controller) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      width: 343.w,
      height: 48.h,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
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
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => controller.switchTab(0),
                  child: Center(
                    child: Text(
                      'Coin Record',
                      style: TextStyle(
                        color: controller.state.tabIndex == 0 ? Colors.white : Colors.white.withValues(alpha: 0.5),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => controller.switchTab(1),
                  child: Center(
                    child: Text(
                      'VIP Record',
                      style: TextStyle(
                        color: controller.state.tabIndex == 1 ? Colors.white : Colors.white.withValues(alpha: 0.5),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildList(MyHistoryPageController controller) {
    final records = controller.state.tabIndex == 0 
        ? controller.state.coinRecords 
        : controller.state.vipRecords;

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 20.h),
      itemCount: records.length,
      separatorBuilder: (context, index) => Divider(
        color: Colors.white.withValues(alpha: 0.1),
        height: 1.h,
      ),
      itemBuilder: (context, index) {
        final record = records[index];
        return Container(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    record['title'],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    record['time'],
                    style: TextStyle(
                      color: const Color(0xFF999999),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              Text(
                record['value'],
                style: TextStyle(
                  color: const Color(0xFFFF0BBA),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'DDinPro',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

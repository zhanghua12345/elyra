import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/el_me/sub_page/el_my_wallet/controller.dart';
import 'package:elyra/routers/el_routers.dart';
import 'package:elyra/widgets/bad_status_widget.dart';
import 'package:elyra/widgets/el_nodata_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyWalletPage extends StatefulWidget {
  const MyWalletPage({super.key});

  @override
  State<MyWalletPage> createState() => _MyWalletPageState();
}

class _MyWalletPageState extends State<MyWalletPage> {
  late final MyWalletController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(MyWalletController());
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyWalletController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              // Background Gradient matching a.html (135deg)
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(-0.7, -0.7), // roughly 135deg
                    end: Alignment(0.7, 0.7),
                    colors: [
                      Color(0xFFB0027C),
                      Color(0xFF44267C),
                      Color(0xFF280A62),
                      Color(0xFF16003E),
                    ],
                  ),
                ),
              ),

              // Content
              SafeArea(
                child: Column(
                  children: [
                    _buildAppBar('My Wallet'),
                    SizedBox(height: 6.h),
                    Expanded(
                      child: SmartRefresher(
                        controller: controller.refreshController,
                        enablePullDown: true,
                        enablePullUp: false,
                        onRefresh: () {
                          controller.onRefresh();
                        },
                        header: const ClassicHeader(
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
            ],
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
              padding: EdgeInsets.all(5.w), // 扩大点击热区
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
          // 右侧可以放置其他操作按钮，暂时留空
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
    return _buildContentArea();
  }

  Widget _buildContentArea() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 25.h),
          _buildBalanceCard(),
          SizedBox(height: 18.h),
          _buildMenuSection(),
        ],
      ),
    );
  }

  Widget _buildBalanceCard() {
    final userInfo = controller.state.customerInfo;
    return Container(
      width: 343.w,
      height: 150.h,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          SizedBox(height: 34.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 37.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Coins Info
                _buildCoinDisplay('Coins', '${userInfo?.coinLeftTotal ?? 0}'),
                // Divider
                Container(
                  width: 1.w,
                  height: 30.h,
                  color: Colors.white.withOpacity(0.1),
                ),
                // Bonus Info
                _buildCoinDisplay(
                  'Bonus',
                  '${userInfo?.sendCoinLeftTotal ?? 0}',
                ),
              ],
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.store),
            child: Container(
              width: 311.w,
              height: 48.h,
              margin: EdgeInsets.only(bottom: 14.h),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE424AE), Color(0xFF6018E6)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(34.r),
              ),
              alignment: Alignment.center,
              child: Text(
                'Store',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'PingFang SC',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoinDisplay(String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (label == 'Coins') ...[
          Image.asset('ely_gold.png'.icon, width: 28.w, height: 28.w),
          SizedBox(width: 12.w),
        ],
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: const Color(0xFFFF0BBA),
                fontSize: 10,
                fontFamily: 'PingFang SC',
                fontWeight: FontWeight.w600,
                height: 1.08,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'PingFang SC',
                fontWeight: FontWeight.w600,
                height: 1,
              ),
            ),
          ],
        ),
        if (label == 'Bonus') ...[
          SizedBox(width: 12.w),
          Image.asset('ely_gold.png'.icon, width: 28.w, height: 28.w),
        ],
      ],
    );
  }

  Widget _buildMenuSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          _buildMenuItem(
            'Consumption records',
            onTap: () => Get.toNamed(AppRoutes.orderRecorder),
          ),
          _buildMenuItem(
            'Purchase records',
            onTap: () => Get.toNamed(AppRoutes.orderRecorder),
          ),
          _buildMenuItem(
            'Reward Coins',
            onTap: () => Get.toNamed(AppRoutes.coinsPack),
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String title, {VoidCallback? onTap,bool isLast = false,}) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.opaque,
          child: Container(
            height: 46.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Image.asset(
                  'ely_right.png'.icon, // Using the user-specified image name
                  width: 10.w,
                  height: 10.w,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
        ),
        if (!isLast)
        Divider(
          color: Colors.white.withOpacity(0.1),
          height: 1,
          thickness: 1,
          indent: 16.w,
          endIndent: 16.w,
        ),
      ],
    );
  }
}

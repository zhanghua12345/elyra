import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/el_coins_pack/controller.dart';
import 'package:elyra/page/el_store/controller.dart';
import 'package:elyra/widgets/bad_status_widget.dart';
import 'package:elyra/widgets/el_nodata_widget.dart';
import 'package:elyra/widgets/week_coin_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ElCoinsPackPage extends StatefulWidget {
  const ElCoinsPackPage({super.key});

  @override
  State<ElCoinsPackPage> createState() => _ElCoinsPackPageState();
}

class _ElCoinsPackPageState extends State<ElCoinsPackPage> {
  late final ElCoinsPackController controller;
  late final StorePageController storeController;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ElCoinsPackController());
    // WeekCoinItem requires StorePageController
    storeController = Get.isRegistered<StorePageController>()
        ? Get.find<StorePageController>()
        : Get.put(StorePageController());
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ElCoinsPackController>(
      builder: (controller) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          body: Container(
            padding: EdgeInsets.only(top: ScreenUtil().statusBarHeight),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('el_coin_pack_bg.png'.icon),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppBar('My Refills'),
                SizedBox(height: 6.h),
                Expanded(
                  child: SmartRefresher(
                    controller: controller.refreshController,
                    enablePullDown: true,
                    enablePullUp: false,
                    onRefresh: controller.onRefresh,
                    header: const ClassicHeader(
                      height: 40,
                      textStyle: TextStyle(color: Colors.white),
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
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          _buildSectionTitle('REWARDS OVERVIEW', 'left'),
          SizedBox(height: 24.h),
          _buildRewardsDisplay(),
          SizedBox(height: 24.h),
          _buildRefillCount(),
          SizedBox(height: 12.h),
          _buildClaimPlaceholder(),
          SizedBox(height: 40.h),
          _buildSectionTitle('WEEKLY REFILL', 'center'),
          SizedBox(height: 20.h),
          _buildRefillList(),
          SizedBox(height: 32.h),
          _buildRulesSection(),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, String align) {
    return Row(
      mainAxisAlignment: align == 'center'
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      children: [
        Container(
          width: 6.w,
          height: 6.w,
          decoration: const BoxDecoration(
            color: Color(0xFFFFB7EB),
            shape: BoxShape.circle,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Text(
            title,
            style: TextStyle(
              color: const Color(0xFFFFB7EB),
              fontSize: 14.sp,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          width: 6.w,
          height: 6.w,
          decoration: const BoxDecoration(
            color: Color(0xFFFFB7EB),
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }

  Widget _buildRewardsDisplay() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Row(
        children: [
          _buildStatTile(
            'Weekly Total',
            controller.state.weeklyTotal.toString(),
          ),
          SizedBox(width: 18.w),

          Container(
            width: 1.w,
            height: 32.h,
            color: Colors.white.withOpacity(0.25),
          ),
          SizedBox(width: 18.w),
          _buildStatTile(
            'Claimable Coins',
            controller.state.claimableCoins.toString(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatTile(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 12.sp,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            Image.asset('ely_gold.png'.icon, width: 18.w, height: 18.w),
            SizedBox(width: 4.w),
            Text(
              value,
              style: TextStyle(
                color: Color(0xFFFF0BBA),
                fontSize: 18.sp,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRefillCount() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 12.w),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Active Refills: ',
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 12.sp,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: '${controller.state.activeRefills}',
              style: TextStyle(
                color: Color(0xFFFFB7EB),
                fontSize: 12.sp,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClaimPlaceholder() {
    return Container(
      width: double.infinity,
      height: 48.h,
      decoration: BoxDecoration(
        color: const Color(0xFF6D6D6D),
        borderRadius: BorderRadius.circular(24.w),
      ),
      alignment: Alignment.center,
      child: Text(
        'Get a Refill to Claim',
        style: TextStyle(
          color: Colors.white.withOpacity(0.5),
          fontSize: 14.sp,
          fontFamily: 'Inter',
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildRefillList() {
    if (controller.state.coinsWeekList.isEmpty) {
      return const SizedBox.shrink();
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: controller.state.coinsWeekList.length,
      separatorBuilder: (context, index) => SizedBox(height: 16.h),
      itemBuilder: (context, index) {
        final item = controller.state.coinsWeekList[index];
        return WeekCoinItem(
          item: item,
          controller: storeController,
          width: 343,
          isOldPrice: true,
        );
      },
    );
  }

  Widget _buildRulesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Subscription Rules',
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 14.sp,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          '1. Up to 2 subscriptions can be active at once.\n'
          '2. Coins are delivered instantly upon purchase.\n'
          '3. Daily bonus coins available from the next day.\n'
          '4. All coins will be revoked when the subscription expires, including both initial and daily coins.',
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 12.sp,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

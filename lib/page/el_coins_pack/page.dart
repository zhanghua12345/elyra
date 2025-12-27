import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/el_coins_pack/controller.dart';
import 'package:elyra/page/el_store/controller.dart';
import 'package:elyra/widgets/bad_status_widget.dart';
import 'package:elyra/widgets/el_nodata_widget.dart';
import 'package:elyra/widgets/week_coin_item.dart';
import 'package:elyra/bean/reward_overview_bean.dart';
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

    // 初始化 Controller（只创建一次）
    storeController = Get.put(
      StorePageController()..isDialogInstance = true,
      tag: 'coins_pack',
    );

    storeController.loadData();
  }

  @override
  void dispose() {
    // 销毁时清理 Controller
    Get.delete<ElCoinsPackController>();
    Get.delete<StorePageController>(tag: 'coins_pack');
    super.dispose();
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
          _buildClaimButtonOrPlaceholder(),
          if (controller.state.receiveList.isNotEmpty) ...[
            SizedBox(height: 24.h),
            _buildReceiveList(),
          ],
          SizedBox(height: 40.h),
          Center(
            child: Container(
              transform: Matrix4.identity()
                ..translate(0.0, 0.0)
                ..rotateZ(-3.14),
              width: 319.w,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    strokeAlign: BorderSide.strokeAlignCenter,
                    color: Colors.white.withOpacity(0.25),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 24.h),
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

  Widget _buildClaimButtonOrPlaceholder() {
    final coinInfo = controller.state.coinInfo;
    if (coinInfo?.isExistSub == 1 && (coinInfo?.receiveCoins ?? 0) > 0) {
      return GestureDetector(
        onTap: () => controller.receiveDay('all'),
        child: Container(
          width: double.infinity,
          height: 48.h,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFE424AE), Color(0xFF6018E6)],
            ),
            borderRadius: BorderRadius.circular(24.w),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Claim All',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Image.asset(
                  'ely_gold.png'.icon,
                  width: 20.w,
                  height: 20.w,
                ),
              ),
              Text(
                '${coinInfo?.receiveCoins ?? 0}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      );
    }

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

  Widget _buildReceiveList() {
    return Column(
      children: controller.state.receiveList.map((item) {
        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: _buildReceiveItem(item),
        );
      }).toList(),
    );
  }

  Widget _buildReceiveItem(RewardReceiveItem item) {
    return Container(
      width: 343.w,
      height: 122.h,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('el_coin_item_bg.png'.icon),
          fit: BoxFit.fill,
        ),
      ),
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${item.title} (${item.dayText})',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontFamily: 'PingFang SC',
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Reward',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 10,
                          fontFamily: 'PingFang SC',
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Image.asset(
                            'ely_gold.png'.icon,
                            width: 14.w,
                            height: 14.w,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '${item.weekMaxTotal ?? 0}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'DDinPro',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(width: 20.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Remaining',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 10,
                          fontFamily: 'PingFang SC',
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Image.asset(
                            'ely_gold.png'.icon,
                            width: 14.w,
                            height: 14.w,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '${item.weekRemainingTotal ?? 0}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'DDinPro',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              if ((item.receiveCoins ?? 0) > 0)
                GestureDetector(
                  onTap: () => controller.receiveDay(item.id!),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Claim',
                        style: TextStyle(
                          color: Color(0xFFFFD67C),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'PingFang SC',
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          Image.asset(
                            'ely_gold.png'.icon,
                            width: 14.w,
                            height: 14.w,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '${item.receiveCoins}',
                            style: const TextStyle(
                              color: Color(0xFFFF7700),
                              fontSize: 14,
                              fontFamily: 'DDinPro',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRefillList() {
    // 纵向列表
    return GetBuilder<StorePageController>(
      tag: 'coins_pack',
      builder: (storeCtrl) {
        if (storeCtrl.state.coinsWeekList.isEmpty) {
          return const SizedBox(
            height: 84,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: storeCtrl.state.coinsWeekList.length,
          itemBuilder: (context, index) {
            final item = storeCtrl.state.coinsWeekList[index];
            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: WeekCoinItem(
                item: item,
                controller: storeCtrl,
                width: 343,
                isOldPrice: true,
              ),
            );
          },
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

import 'package:elyra/page/el_store/controller.dart';
import 'package:elyra/page/el_store/sub_page/store_coin_item.dart';
import 'package:elyra/page/el_store/sub_page/store_vip_item.dart';
import 'package:elyra/widgets/week_coin_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Store商店内容组件
class StoreContentWidget extends StatelessWidget {
  final String? controllerTag; // 可选的controller标签，用于多实例场景
  final bool showTips; // 是否显示底部提示

  const StoreContentWidget({
    super.key,
    this.controllerTag,
    this.showTips = true,
  });

  @override
  Widget build(BuildContext context) {
    // 获取StorePageController实例
    final controller = controllerTag != null
        ? Get.find<StorePageController>(tag: controllerTag)
        : Get.find<StorePageController>();

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔥 关键修复：添加空检查
            if (controller.state.sortList.isNotEmpty &&
                controller.state.paySettings != null)
              ...controller.state.sortList.map((type) {
                if (type == 'list_coins') {
                  return _StoreCoinsSection(controller: controller);
                } else {
                  return _StoreVipCoins(controller: controller);
                }
              }),
            // 底部提示
            if (showTips) _StoreTips(),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}

/// Coins 区块组件
class _StoreCoinsSection extends StatelessWidget {
  final StorePageController controller;
  const _StoreCoinsSection({required this.controller});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StoreSectionTitle(title: 'Go Coins Limited-time coin packs'),
        // Big Coins
        if (controller.state.coinsBigList.isNotEmpty)
          _StoreBigCoins(controller: controller),
        // Week Coins
        if (controller.state.coinsWeekList.isNotEmpty)
          _StoreWeekCoins(controller: controller),
        // Small Coins
        if (controller.state.coinsSmallList.isNotEmpty)
          _StoreSmallCoins(controller: controller),
      ],
    );
  }
}

// 大金币组件
class _StoreBigCoins extends StatelessWidget {
  final StorePageController controller;

  const _StoreBigCoins({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16.h),
        Wrap(
          spacing: 15.w,
          runSpacing: 15.h,
          alignment: WrapAlignment.start,
          children: controller.state.coinsBigList.map((item) {
            return StoreCoinItem(
              controller: controller,
              item: item,
              isBig: true,
            );
          }).toList(),
        ),
      ],
    );
  }
}

// 小金币组件
class _StoreSmallCoins extends StatelessWidget {
  final StorePageController controller;

  const _StoreSmallCoins({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 15.h,
          alignment: WrapAlignment.start,
          children: controller.state.coinsSmallList.map((item) {
            return StoreCoinItem(
              controller: controller,
              item: item,
              isBig: false,
            );
          }).toList(),
        ),
      ],
    );
  }
}

// 周卡金币组件
class _StoreWeekCoins extends StatelessWidget {
  final StorePageController controller;

  const _StoreWeekCoins({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8.h),
        Wrap(
          runSpacing: 8.h,
          alignment: WrapAlignment.start,
          children: controller.state.coinsWeekList.map((item) {
            return WeekCoinItem(
              item: item,
              controller: controller,
              width: 343,
              isOldPrice: true,
            );
          }).toList(),
        ),
      ],
    );
  }
}

/// VIP组件
class _StoreVipCoins extends StatelessWidget {
  final StorePageController controller;
  const _StoreVipCoins({required this.controller});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StoreSectionTitle(title: 'VIP Auto renew,cancel anytime'),
        SizedBox(height: 16.h),
        Wrap(
          runSpacing: 10.h,
          alignment: WrapAlignment.start,
          children: controller.state.subList.map((item) {
            return StoreVipItem(controller: controller, item: item);
          }).toList(),
        ),
      ],
    );
  }
}

/// 标题组件
class _StoreSectionTitle extends StatelessWidget {
  final String title;
  const _StoreSectionTitle({required this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 15.h),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white /* 白 */,
          fontSize: 12,
          fontFamily: 'PingFang SC',
          fontWeight: FontWeight.w500,
          height: 1,
        ),
      ),
    );
  }
}

/// 底部提示组件
class _StoreTips extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 36.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tips',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: 'PingFang SC',
              fontWeight: FontWeight.w500,
              height: 1.25,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            '1. Coins are virtual items and cannot be refunded. Use it for this product.\n'
            '2. Both the coins and the reward coins will never expire. \n'
            '3. Coins will be used first when unlocking episodes. If the amount is insufficient, reward coins will automatically be used.\n'
            '4. The purchase has not been credited, click <Restore> torefresh.\n'
            '5. For other questions, contact us via Profile>Help &feedback.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontFamily: 'PingFang SC',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
        ],
      ),
    );
  }
}

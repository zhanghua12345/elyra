import 'package:elyra/bean/pay_settings_bean.dart';
import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/el_store/controller.dart';
import 'package:elyra/page/el_store/sub_page/store_coin_item.dart';
import 'package:elyra/page/el_store/sub_page/store_week_coin_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Store商店内容组件
/// 可在任何页面复用，共享StorePageController的数据和功能
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
          children: [
            // 🔥 关键修复：添加空检查
            if (controller.state.sortList.isNotEmpty && controller.state.paySettings != null)
              ...controller.state.sortList.map((type) {
                if (type == 'list_coins') {
                  return _StoreCoinsSection(controller: controller);
                } else {
                  return _StoreVipSection(controller: controller);
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
        SizedBox(height: 24.h),
        // Big Coins
        if (controller.state.coinsBigList.isNotEmpty)
          _StoreBigCoins(controller: controller),
        // Small Coins
        if (controller.state.coinsSmallList.isNotEmpty)
          _StoreSmallCoins(controller: controller),
        // Week Coins
        if (controller.state.coinsWeekList.isNotEmpty)
          _StoreWeekCoins(controller: controller),
      ],
    );
  }
}

/// VIP 区块组件
class _StoreVipSection extends StatelessWidget {
  final StorePageController controller;

  const _StoreVipSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    if (controller.state.subList.isEmpty) return SizedBox();

    return Column(
      children: [
        SizedBox(height: 40.h),
        _StoreSectionTitle(title: 'VIP Membership'),
        SizedBox(height: 16.h),
        ...controller.state.subList.map((item) => _StoreVipItem(
              controller: controller,
              item: item,
            )),
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
      height: 48.h,
      alignment: Alignment.center,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white.withOpacity(0.25), Colors.transparent],
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text(
              title,
              style: TextStyle(
                color: Color(0xFFFFE79D),
                fontSize: 14,
                fontFamily: 'PingFang SC',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.white.withOpacity(0.25)],
                ),
              ),
            ),
          ),
        ],
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

// 由于代码较长，我将剩余组件分成多个部分
// 大金币组件
class _StoreBigCoins extends StatelessWidget {
  final StorePageController controller;

  const _StoreBigCoins({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 13.h),
        Wrap(
          spacing: 15.w,
          runSpacing: 13.h,
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
        SizedBox(height: 13.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 13.h,
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
      children: controller.state.coinsWeekList.map((item) {
        return StoreWeekCoinItem(controller: controller, item: item);
      }).toList(),
    );
  }
}

// VIP项组件
class _StoreVipItem extends StatelessWidget {
  final StorePageController controller;
  final PayItem item;

  const _StoreVipItem({
    required this.controller,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    // 根据 vipType 选择背景图
    String bgImage;
    switch (item.vipType) {
      case 'week':
        bgImage = 'store_sup_week.png';
        break;
      case 'month':
        bgImage = 'store_sup_month.png';
        break;
      case 'three_months':
        bgImage = 'store_sup_ quarter.png';
        break;
      case 'year':
        bgImage = 'store_sup_ year.png';
        break;
      default:
        bgImage = 'store_sup_month.png';
    }

    return GestureDetector(
      onTap: () => controller.handlePay(item),
      child: Container(
        margin: EdgeInsets.only(bottom: 24.h),
        width: double.infinity,
        height: 200.h,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(bgImage.icon),
            fit: BoxFit.fill,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 34.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.shortType,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                foreground: Paint()..shader = _getVipGradient(item.vipType),
              ),
            ),
            SizedBox(height: 15.h),
            Row(
              children: [
                Text(
                  item.price,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    foreground: Paint()
                      ..shader = _getVipPriceGradient(item.vipType),
                  ),
                ),
                Text(
                  '/${item.vipType}',
                  style: TextStyle(
                    color: _getVipTextColor(item.vipType),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            Spacer(),
            Text(
              item.description,
              style: TextStyle(
                color: _getVipDescColor(item.vipType),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Shader _getVipGradient(String vipType) {
    List<Color> colors;
    switch (vipType) {
      case 'week':
        colors = [Color(0xFF26343A), Color(0xFF698FA0)];
        break;
      case 'month':
        colors = [Color(0xFF2C5289), Color(0xFF3981EE)];
        break;
      case 'three_months':
        colors = [Color(0xFFD25DB8), Color(0xFFE01DB8)];
        break;
      case 'year':
        colors = [Color(0xFFFFE652), Color(0xFFFDA71E)];
        break;
      default:
        colors = [Colors.white, Colors.white];
    }
    return LinearGradient(
      colors: colors,
    ).createShader(Rect.fromLTWH(0, 0, 200, 24));
  }

  Shader _getVipPriceGradient(String vipType) {
    List<Color> colors;
    switch (vipType) {
      case 'week':
        colors = [Color(0xFFFFFFFF), Color(0xFFBDEDFF)];
        break;
      case 'month':
        colors = [Color(0xFFFFFFFF), Color(0xFFCFFBDB)];
        break;
      case 'three_months':
        colors = [Color(0xFFC6AEFF), Color(0xFFFFFFFF)];
        break;
      case 'year':
        colors = [Color(0xFF9F5300), Color(0xFF9F5300)];
        break;
      default:
        colors = [Colors.white, Colors.white];
    }
    return LinearGradient(
      colors: colors,
    ).createShader(Rect.fromLTWH(0, 0, 200, 44));
  }

  Color _getVipTextColor(String vipType) {
    switch (vipType) {
      case 'week':
        return Color(0xFF26343A);
      case 'month':
        return Color(0xFF2B5289);
      case 'three_months':
        return Color(0xFFDF23B8);
      case 'year':
        return Color(0xFFFE890E);
      default:
        return Colors.white;
    }
  }

  Color _getVipDescColor(String vipType) {
    switch (vipType) {
      case 'week':
        return Color(0xFF26343A);
      case 'month':
        return Color(0xFF2C5289);
      case 'three_months':
        return Color(0xFFDF23B8);
      case 'year':
        return Color(0xFFFE890E);
      default:
        return Colors.white.withOpacity(0.7);
    }
  }
}



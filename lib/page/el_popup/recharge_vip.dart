// 引导充值vip
import 'package:elyra/bean/pay_settings_bean.dart';
import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/el_store/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// =======================
/// VIP 主题配置模型
/// =======================
class VipTheme {
  final String bgImage;
  final String title;
  final List<Color> titleGradient;
  final String priceType;
  final Color priceColor;

  const VipTheme({
    required this.bgImage,
    required this.title,
    required this.titleGradient,
    required this.priceType,
    required this.priceColor,
  });
}

/// =======================
/// VIP 主题统一配置中心
/// =======================

class VipThemes {
  static final Map<String, VipTheme> _themes = {
    'week': VipTheme(
      bgImage: 'popup_recharge_coins_pack_week.png',
      title: 'Weekly VIP',
      titleGradient: [Color(0xFF26343A), Color(0xFF698FA0)],
      priceType: '',
      priceColor: Color(0xFF26343A),
    ),
    'month': VipTheme(
      bgImage: 'popup_recharge_coins_pack_month.png',
      title: 'Monthly VIP',
      titleGradient: [Color(0xFF2C5289), Color(0xFF3981EE)],
      priceType: '/month',
      priceColor: Color(0xFF2B5289),
    ),
    'three_months': VipTheme(
      bgImage: 'popup_recharge_coins_pack_quarter.png',
      title: 'Quarterly VIP',
      titleGradient: [Color(0xFFD25DB8), Color(0xFFE01DB8)],
      priceType: '/quarter',
      priceColor: Color(0xFFDF23B8),
    ),
    'year': VipTheme(
      bgImage: 'popup_recharge_coins_pack_year.png',
      title: 'Yearly VIP',
      titleGradient: [Color(0xFFFFE652), Color(0xFFFDA71E)],
      priceType: '/year',
      priceColor: Color(0xFFFE890E),
    ),
  };

  /// 安全获取，避免异常
  static VipTheme of(String vipType) {
    return _themes[vipType] ?? _themes['month']!;
  }
}

/// 引导充值VIP弹窗
class RechargeVipPopup extends StatefulWidget {
  const RechargeVipPopup({super.key});

  /// 显示弹窗
  static void show() {
    Get.dialog(
      const RechargeVipPopup(),
      barrierColor: Colors.black.withValues(alpha: 0.7),
      transitionDuration: const Duration(milliseconds: 300),

      barrierDismissible: true,
    );
  }

  @override
  State<RechargeVipPopup> createState() => _RechargeVipPopupState();
}

class _RechargeVipPopupState extends State<RechargeVipPopup> {
  late final StorePageController storeController;

  @override
  void initState() {
    super.initState();

    // 初始化 Controller（只创建一次）
    storeController = Get.put(
      StorePageController()..isDialogInstance = true,
      tag: 'vip_dialog',
    );

    storeController.loadData();
  }

  @override
  void dispose() {
    // 弹窗销毁时清理 Controller
    Get.delete<StorePageController>(tag: 'vip_dialog');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// 弹窗主体
            Container(
              width: 375.w,
              height: 543.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                image: DecorationImage(
                  image: AssetImage('popup_recharge_vip_bg.png'.icon),
                  fit: BoxFit.fill,
                ),
              ),
              child: GetBuilder<StorePageController>(
                tag: 'vip_dialog',
                builder: (controller) {
                  if (controller.state.subList.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return Padding(
                    padding: EdgeInsets.only(top: 247.h),
                    child: Column(
                      children: controller.state.subList.map((item) {
                        return _RechargeVipItem(
                          controller: controller,
                          item: item,
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 30.h),

            /// 关闭按钮（InkWell 更规范）
            InkWell(
              onTap: () => Get.back(),
              child: Image.asset(
                'popup_recharge_vip_close.png'.icon,
                width: 28.w,
                height: 28.w,
              ),
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}

/// VIP Item 组件
class _RechargeVipItem extends StatelessWidget {
  final StorePageController controller;
  final PayItem item;

  const _RechargeVipItem({required this.controller, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = VipThemes.of(item.vipType);

    return GestureDetector(
      onTap: () {
        Get.back(); // 关闭弹窗
        controller.createOrder(item); // 直接拉起支付
      },
      child: Container(
        width: 242.w,
        height: 58.h,
        margin: EdgeInsets.only(bottom: 10.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          image: DecorationImage(
            image: AssetImage(theme.bgImage.icon),
            fit: BoxFit.fill,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// 标题
            ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: theme.titleGradient,
                ).createShader(bounds);
              },
              child: Text(
                theme.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'DDinPro',
                  fontWeight: FontWeight.w900,
                  height: 0.88,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            // 价格
            SizedBox(
              height: 24.h,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'USD\$',
                      style: TextStyle(
                        color: theme.priceColor,
                        fontSize: 18,
                        fontFamily: 'DDinPro',
                        fontWeight: FontWeight.w900,
                        height: 1.11,
                      ),
                    ),
                    TextSpan(
                      text: item.price,
                      style: TextStyle(
                        color: theme.priceColor,
                        fontSize: 24,
                        fontFamily: 'DDinPro',
                        fontWeight: FontWeight.w900,
                        height: 0.83,
                      ),
                    ),
                    TextSpan(
                      text: theme.priceType,
                      style: TextStyle(
                        color: theme.priceColor,
                        fontSize: 14,
                        fontFamily: 'PingFang SC',
                        fontWeight: FontWeight.w500,
                        height: 1.43,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// 🔥 使用方式，模拟按钮：点击显示充值金币包弹窗
// GestureDetector(
//   behavior: HitTestBehavior.translucent,
//   onTap: () {
//     // 模拟 PayItem 数据
//     
// RechargeVipPopup.show();
//   },
//   child: Padding(
//     padding: EdgeInsets.all(5.w),
//     child: Container(
//       padding: EdgeInsets.symmetric(
//         horizontal: 8.w,
//         vertical: 4.h,
//       ),
//       decoration: BoxDecoration(
//         color: Colors.orange,
//         borderRadius: BorderRadius.circular(4.r),
//       ),
//       child: Text(
//         'Test',
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: 10,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     ),
//   ),
// ),
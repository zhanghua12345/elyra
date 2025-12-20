// 引导充值金币包
import 'package:elyra/bean/pay_settings_bean.dart';
import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/el_store/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RechargeCoinsPackPopup extends StatefulWidget {
  final PayItem item;

  const RechargeCoinsPackPopup({super.key, required this.item});

  /// 显示弹窗
  static void show(PayItem item) {
    Get.dialog(
      RechargeCoinsPackPopup(item: item),
      barrierColor: Colors.black.withValues(alpha: 0.7),
      barrierDismissible: true,
    );
  }

  @override
  State<RechargeCoinsPackPopup> createState() => _RechargeCoinsPackPopupState();
}

class _RechargeCoinsPackPopupState extends State<RechargeCoinsPackPopup> {
  late final StorePageController storeController;

  @override
  void initState() {
    super.initState();

    // 初始化 Controller（只创建一次）
    storeController = Get.put(
      StorePageController()..isDialogInstance = true,
      tag: 'coins_pack_dialog',
    );
  }

  @override
  void dispose() {
    // 弹窗销毁时清理 Controller
    Get.delete<StorePageController>(tag: 'coins_pack_dialog');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 375.w,
          height: 641.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            image: DecorationImage(
              image: AssetImage('popup_recharge_coins_pack_bg.png'.icon),
              fit: BoxFit.fill,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 192.h),
            child: _RechargeContent(
              item: widget.item,
              controller: storeController,
            ),
          ),
        ),
      ),
    );
  }
}

class _RechargeContent extends StatelessWidget {
  final PayItem item;
  final StorePageController controller;

  const _RechargeContent({required this.item, required this.controller});

  @override
  Widget build(BuildContext context) {
    final gradientPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFFCE63), Color(0xFFFFE1AA)],
      ).createShader(const Rect.fromLTWH(0, 0, 300, 100));
    return Column(
      children: [
        // 标题
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Big Savings\n',
                style: TextStyle(
                  fontSize: 42,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w900,
                  height: 1.2,
                  foreground: gradientPaint,
                ),
              ),
              TextSpan(
                text: 'for Loyal Users',
                style: TextStyle(
                  fontSize: 24,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w900,
                  height: 1.33,
                  foreground: gradientPaint,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 4.h),
        // 副标题
        Text(
          'Extra coins & VIP privileges\nLimited time only',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            height: 1.29,
          ),
        ),
        SizedBox(height: 16.h),
        // 主内容卡片
        Container(
          width: 279.w,
          height: 192.h,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 1),
            borderRadius: BorderRadius.circular(24.r),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xFF6018E6),
                const Color(0xFFE9E1F9),
                const Color(0xFFFF0BBA),
              ],
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: 8.h),
              // First-Time Deal 标签
              Container(
                height: 24,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 2,
                ),
                decoration: ShapeDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(0.00, 0.50),
                    end: Alignment(1.00, 0.50),
                    colors: [const Color(0xFFFF0BBA), const Color(0xFFFFB7EB)],
                  ),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: const Color(0xFFFF0BBA)),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(9.r),
                      bottomRight: Radius.circular(9.r),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: 2,
                  children: [
                    Text(
                      'First-Time Deal',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF6018E6),
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              // 内容区域
              SizedBox(height: 4.h),
              Container(
                height: 144.h,
                width: 254.w,
                decoration: ShapeDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(0.00, 0.50),
                    end: Alignment(1.00, 0.50),
                    colors: [const Color(0xFFFFB7EB), const Color(0xFFFFEBFA)],
                  ),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: const Color(0xFFFF0BBA)),
                    borderRadius: BorderRadius.all(Radius.circular(12.r)),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Only $19.99
                    Text(
                      'Only \$${item.price}',
                      style: TextStyle(
                        color: Color(0xFFFF0BBA),
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    // 金币行
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'store_gold.png'.icon,
                          width: 24.w,
                          height: 24.w,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '${item.coins + item.sendCoins}',
                          style: TextStyle(
                            color: const Color(0xFFFF0BBA),
                            fontSize: 28,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 1.29,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'Coins',
                          style: TextStyle(
                            color: const Color(0xFFFF0BBA),
                            fontSize: 18,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '+1 Week VIP',
                          style: TextStyle(
                            color: const Color(0xFFFF0BBA),
                            fontSize: 16,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                            height: 1.38,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Image.asset(
                          'popup_recharge_coins_pack_vip.png'.icon,
                          height: 16.w,
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    // 详细说明
                    Text(
                      '${item.sendCoins} + First week ${(item.sendCoins / 7).toInt()}=${item.coins + item.sendCoins} coins',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0x99DC23B1),
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 4.h),
        // 续费说明
        Text(
          '${item.sendCoins} coins weekly on renewal',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFFEA64CA),
            fontSize: 12,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            height: 1.9,
          ),
        ),
        SizedBox(height: 6.h),
        // Buy Now 按钮
        GestureDetector(
          onTap: () {
            Get.back();
            // 调用支付
            controller.createOrder(item);
          },
          child: Container(
            width: 279.w,
            height: 48.h,
            decoration: ShapeDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFFFF0BBA),
                  const Color(0xFFE96FFF),
                  const Color(0xFF6018E6),
                ],
              ),
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 3, color: const Color(0xFFFFB6EA)),
                borderRadius: BorderRadius.circular(24.r),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Buy Now',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 12.h),
        InkWell(
          onTap: () => Get.back(),
          child: Text(
            'Maybe Later',
            style: TextStyle(
              color: const Color(0xFFFF65DB),
              fontSize: 14.sp,
              fontFamily: 'PingFang SC',
              fontWeight: FontWeight.w600,
              height: 1.57,
            ),
          ),
        ),
      ],
    );
  }
}

// 🔥 使用方式，模拟按钮：点击显示充值金币包弹窗
// GestureDetector(
//   behavior: HitTestBehavior.translucent,
//   onTap: () {
//     // 模拟 PayItem 数据
//     final mockItem = PayItem(
//       id: 1,
//       buyType: 'sub_coins',
//       coins: 2000,
//       sendCoins: 2800,
//       sendCoinTtl: 7,
//       price: '19.99',
//       priceLocal: '19.99',
//       iosTemplateId: 'test_ios',
//       vipType: 'week',
//       shortType: '',
//       description: 'Weekly coin pack',
//       sort: 1,
//     );
//     RechargeCoinsPackPopup.show(mockItem);
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

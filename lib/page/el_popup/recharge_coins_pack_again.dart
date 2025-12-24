// 用户取消支付，引导充值金币包
import 'package:elyra/bean/pay_settings_bean.dart';
import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/el_store/controller.dart';
import 'package:elyra/utils/store_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RechargeCoinsPackAgainPopup extends StatefulWidget {
  final PayItem item;
  final VoidCallback? onPaymentSuccess; // 🔥 支付成功回调

  const RechargeCoinsPackAgainPopup({
    super.key,
    required this.item,
    this.onPaymentSuccess,
  });

  /// 显示弹窗
  static void show(PayItem item, {VoidCallback? onPaymentSuccess}) {
    Get.dialog(
      RechargeCoinsPackAgainPopup(
        item: item,
        onPaymentSuccess: onPaymentSuccess,
      ),
      barrierColor: Colors.black.withValues(alpha: 0.7),
      barrierDismissible: true,
    );
  }

  @override
  State<RechargeCoinsPackAgainPopup> createState() =>
      _RechargeCoinsPackAgainPopupState();
}

class _RechargeCoinsPackAgainPopupState
    extends State<RechargeCoinsPackAgainPopup> {
  late final StorePageController storeController;

  @override
  void initState() {
    super.initState();

    // 初始化 Controller（只创建一次）
    storeController = Get.put(
      StorePageController()
        ..isDialogInstance = true
        ..onPaymentSuccess = _handlePaymentSuccess, // 🔥 设置支付成功回调
      tag: 'coins_pack_again_dialog',
    );
  }

  /// 🔥 处理支付成功
  void _handlePaymentSuccess() {
    // 关闭弹窗
    Get.back();
    // 触发外部回调
    widget.onPaymentSuccess?.call();
  }

  @override
  void dispose() {
    // 弹窗销毁时清理 Controller
    Get.delete<StorePageController>(tag: 'coins_pack_again_dialog');
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
              width: 324.w,
              child: _RechargeContent(
                item: widget.item,
                controller: storeController,
              ),
            ),
            SizedBox(height: 36.h),

            /// 关闭按钮（InkWell 更规范）
            InkWell(
              onTap: () => Get.back(),
              child: Image.asset(
                'ely_close.png'.icon,
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

class _RechargeContent extends StatelessWidget {
  final PayItem item;
  final StorePageController controller;

  const _RechargeContent({required this.item, required this.controller});

  @override
  Widget build(BuildContext context) {
    final currentPriceObj = getCurrentPrice(item);
    return Column(
      children: [
        // 标题
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// 左侧圆点
            Container(
              width: 6.w,
              height: 6.w,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFF0BBA),
              ),
            ),
            SizedBox(width: 6.w),

            ShaderMask(
              shaderCallback: (bounds) {
                return const LinearGradient(
                  colors: [Color(0xFFFF0BBA), Color(0xFF6018E6)],
                ).createShader(bounds);
              },
              child: Text(
                'WEEKLY REFILL',
                style: TextStyle(
                  color: const Color(0xFFFF0BBA),
                  fontSize: 24,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w900,
                  height: 0.75,
                ),
              ),
            ),
            SizedBox(width: 6.w),

            /// 右侧圆点
            Container(
              width: 6.w,
              height: 6.w,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFF0BBA),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        // 主内容卡片
        Container(
          width: 320.w,
          height: 84.h,
          padding: EdgeInsets.all(1.5.w), // 边框厚度
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            gradient: const LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                Color(0xFF6018E6), // 左下
                Color(0xFFFF0BBA), // 右上
              ],
            ),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.r),
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xFFFFDCE0), Color(0xFFFFD8F4)],
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// ================= 左侧内容 =================
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /// 顶部 Row（图标 + Weekly VIP）
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'popup_recharge_coins_pack_again_guan.png'.icon,
                            width: 24.w,
                            height: 24.w,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            item?.title ?? '',
                            style: TextStyle(
                              color: const Color(0xFFFF0BBA),
                              fontSize: 18,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              height: 1.22,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 7.h),
                      ShaderMask(
                        shaderCallback: (bounds) {
                          return const LinearGradient(
                            colors: [Color(0xFFFF0BBA), Color(0xFF6018E6)],
                          ).createShader(bounds);
                        },
                        child: Text(
                          item.description,
                          style: TextStyle(
                            color: const Color(0xFFFF0BBA),
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            height: 1.17,
                          ),
                        ),
                      ),

                      /// 描述（渐变文字）
                    ],
                  ),
                ),
                SizedBox(width: 12.w),

                /// 右侧价格区（顶到最右）
                Flexible(
                  fit: FlexFit.loose,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      height: 48.h,
                      padding: EdgeInsets.symmetric(horizontal: 21.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(-.80, 0.50),
                          end: Alignment(.50, 0.50),
                          colors: [
                            const Color(0xFFFF0BBA),
                            const Color(0xFF6018E6),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          /// 第一行：$9.99 /week（底部对齐）
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${currentPriceObj?.currencySymbol ?? ''}${currentPriceObj?.rawPrice ?? ''}', // $9.99
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: 'DDinPro',
                                  fontWeight: FontWeight.w700,
                                  height: 1,
                                ),
                              ),
                            ],
                          ),

                          /// 第二行：原价
                          Text(
                            '/week',
                            style: TextStyle(
                              color: const Color(0xFFDFD1FA),
                              fontSize: 12,
                              fontFamily: 'DDinPro',
                              fontWeight: FontWeight.w400,
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          'Unlock every show you love!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xFFFF0BBA),
            fontSize: 18,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            height: 1.33,
          ),
        ),
        SizedBox(height: 12.h),
        // Buy Now 按钮
        GestureDetector(
          onTap: () {
            // 调用支付
            controller.handlePay(item, isPopup: false);
          },
          child: Container(
            width: 279.w,
            height: 48.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.r),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [const Color(0xFFFF0BBA), const Color(0xFF6018E6)],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Buy Now',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// 🔥 使用方式，模拟按钮：点击显示充值金币挽留弹窗
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
//     RechargeCoinsPackAgainPopup.show(mockItem);
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

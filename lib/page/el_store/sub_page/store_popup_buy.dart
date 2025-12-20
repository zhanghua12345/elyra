import 'package:elyra/bean/pay_settings_bean.dart';
import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/el_store/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// 购买确认弹窗
class StorePopupBuy extends StatelessWidget {
  final StorePageController controller;
  final PayItem item;

  const StorePopupBuy({
    super.key,
    required this.controller,
    required this.item,
  });

  /// 显示弹窗
  static void show({
    required StorePageController controller,
    required PayItem item,
  }) {
    Get.dialog(
      StorePopupBuy(
        controller: controller,
        item: item,
      ),
      barrierColor: Colors.black.withValues(alpha: 0.7),
      barrierDismissible: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 343.w,
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        child: Stack(
          children: [
            // 主内容容器
            Container(
              margin: EdgeInsets.only(top: 12.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                image: DecorationImage(
                  image: AssetImage('store_popup_bg.png'.icon),
                  fit: BoxFit.fill,
                  alignment: Alignment.topCenter,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 20.h),
                  // 标题
                  Text(
                    'Bonus You Get',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'PingFang SC',
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // 两个图标
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'store_popup_icon_1.png'.icon,
                        width: 148.w,
                        height: 148.w,
                      ),
                      SizedBox(width: 12.w),
                      Image.asset(
                        'store_popup_icon_2.png'.icon,
                        width: 148.w,
                        height: 148.w,
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),
                  // How Do I Receive Coins 模块
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'How Do I Receive Coins?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'PingFang SC',
                            fontWeight: FontWeight.w600,
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        _buildInfoRow(
                          '1. After purchasing, you will immediately receive:',
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            SizedBox(width: 12.w),
                            Image.asset(
                              'store_gold.png'.icon,
                              width: 20.w,
                              height: 20.w,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              '${item.coins} Coins',
                              style: TextStyle(
                                color: Color(0xFFFFD700),
                                fontSize: 14,
                                fontFamily: 'PingFang SC',
                                fontWeight: FontWeight.w600,
                                height: 1.43,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        _buildInfoRow(
                          '2. Every day for the next 7 days, you will receive:',
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            SizedBox(width: 12.w),
                            Image.asset(
                              'store_gold.png'.icon,
                              width: 20.w,
                              height: 20.w,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              '${(item.sendCoins / 7).toInt()} Coins daily bonus',
                              style: TextStyle(
                                color: Color(0xFFFFD700),
                                fontSize: 14,
                                fontFamily: 'PingFang SC',
                                fontWeight: FontWeight.w600,
                                height: 1.43,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        // 分隔线
                        Container(
                          height: 1.w,
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  // 金额和按钮
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      children: [
                        // 金额显示
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Image.asset(
                              'store_gold.png'.icon,
                              width: 32.w,
                              height: 32.w,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              '${item.coins + item.sendCoins}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontFamily: 'DDinPro',
                                fontWeight: FontWeight.w900,
                                height: 1,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Padding(
                              padding: EdgeInsets.only(bottom: 4.h),
                              child: Text(
                                'Coins',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontSize: 16,
                                  fontFamily: 'PingFang SC',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        // 价格
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Only ',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.6),
                                fontSize: 14,
                                fontFamily: 'PingFang SC',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '\$',
                              style: TextStyle(
                                color: Color(0xFFFF0BBA),
                                fontSize: 16,
                                fontFamily: 'DDinPro',
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            ShaderMask(
                              shaderCallback: (bounds) {
                                return LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Color(0xFFFF0BBA),
                                    Color(0xFF6018E6),
                                  ],
                                ).createShader(bounds);
                              },
                              child: Text(
                                item.price,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: 'DDinPro',
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        // Continue 按钮
                        GestureDetector(
                          onTap: () {
                            Get.back(); // 关闭弹窗
                            controller.handlePay(item, isPopup: false);
                          },
                          child: Container(
                            width: double.infinity,
                            height: 48.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24.r),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xFFFF0BBA),
                                  Color(0xFF6018E6),
                                ],
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Continue',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'PingFang SC',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // 关闭按钮（右上角）
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Image.asset(
                  'store_popup_close.png'.icon,
                  width: 40.w,
                  height: 40.w,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.9),
        fontSize: 14,
        fontFamily: 'PingFang SC',
        fontWeight: FontWeight.w400,
        height: 1.43,
      ),
    );
  }
}

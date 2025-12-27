// 支付详情，点击某个金币包/订阅，底部弹起
import 'package:elyra/bean/pay_settings_bean.dart';
import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/el_store/controller.dart';
import 'package:elyra/utils/store_utils.dart';
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
    Get.bottomSheet(
      StorePopupBuy(controller: controller, item: item),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentPriceObj = getCurrentPrice(item);
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16.r),
        topRight: Radius.circular(16.r),
      ),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('store_popup_bg.png'.icon),
            fit: BoxFit.fitWidth,
            alignment: Alignment.topCenter,
          ),
        ),
        padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 40.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Image.asset(
                    'store_popup_close.png'.icon,
                    width: 24.w,
                    height: 24.w,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Center(
              child: ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    colors: [Color(0xFFFF0BBA), Color(0xFF6018E6)],
                  ).createShader(bounds);
                },
                child: Text(
                  'What You Get',
                  style: TextStyle(
                    color: const Color(0xFFFF0BBA),
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    height: 1,
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            // 第一个框：Weekly Refill Package 和 Daily Bonuses
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Color(0xFF29223C),
              ),
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Column(
                children: [
                  Text(
                    'Bonus You Get',
                    style: TextStyle(
                      color: const Color(0xFFFFB6EA),
                      fontSize: 18.sp,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      height: 1.33,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  // 两个 Item
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Row(
                      children: [
                        // Item 1
                        Expanded(
                          child: Container(
                            height: 61.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Color(0xBF3F385D),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Row(
                              children: [
                                Image.asset(
                                  'store_popup_icon_1.png'.icon,
                                  width: 48.w,
                                  height: 48.w,
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Text(
                                    'Weekly Refill Package',
                                    style: TextStyle(
                                      color: Colors.white /* Color-6 */,
                                      fontSize: 12,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w800,
                                      height: 1.33,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        // Item 2
                        Expanded(
                          child: Container(
                            height: 61.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Color(0xBF3F385D),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Row(
                              children: [
                                Image.asset(
                                  'store_popup_icon_2.png'.icon,
                                  width: 48.w,
                                  height: 48.w,
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Text(
                                    'Daily Bonuses',
                                    style: TextStyle(
                                      color: Colors.white /* Color-6 */,
                                      fontSize: 12,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w800,
                                      height: 1.33,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            // 第二个框：金币详情
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Color(0xFF29223C),
              ),
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Column(
                children: [
                  Text(
                    'How Do I Receive Coins？',
                    style: TextStyle(
                      color: const Color(0xFFFFB6EA),
                      fontSize: 18.sp,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      height: 1.33,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // 分隔线
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: Colors.white.withValues(alpha: 0.10),
                  ),
                  SizedBox(height: 16.h),
                  // 三个金币项目
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      children: [
                        if (item.extInfo?.subCoinsTxtList?.isNotEmpty == true)
                          ...item.extInfo!.subCoinsTxtList!.asMap().entries.map(
                            (entry) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom:
                                      entry.key <
                                          item
                                                  .extInfo!
                                                  .subCoinsTxtList!
                                                  .length -
                                              1
                                      ? 24.h
                                      : 0,
                                ),
                                child: _buildCoinItem(entry.value),
                              );
                            },
                          )
                        else ...[
                          _buildCoinItem(
                            'You receive ${item.coins} coins after purchase',
                          ),
                          SizedBox(height: 24.h),
                          _buildCoinItem(
                            '${item.sendCoins} coins within a week',
                          ),
                          SizedBox(height: 24.h),
                          _buildCoinItem(
                            'Get ${(item.sendCoins / 7).toInt()} coins by logging into the app daily',
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            // 价格
            Text(
              '${currentPriceObj?.currencySymbol ?? ''}${currentPriceObj?.rawPrice ?? ''}/week',
              style: TextStyle(
                color: const Color(0xFFFF0BBA),
                fontSize: 18,
                fontFamily: 'DDinPro',
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 12.h),
            // Continue 按钮
            GestureDetector(
              onTap: () {
                controller.handlePay(item, isPopup: false);
              },
              child: Container(
                width: double.infinity,
                height: 48.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24.r),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFFFF0BBA), Color(0xFF6018E6)],
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Continue',
                  style: TextStyle(
                    color: Colors.white /* Color-6 */,
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    height: 1.29,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoinItem(String text) {
    return Row(
      children: [
        Image.asset('store_gold.png'.icon, width: 16.w, height: 16.w),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.29,
            ),
          ),
        ),
      ],
    );
  }
}

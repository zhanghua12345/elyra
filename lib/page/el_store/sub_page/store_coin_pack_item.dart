import 'package:elyra/bean/pay_settings_bean.dart';
import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/el_store/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 金币商品Item组件（大金币/小金币通用）
class StoreCoinPackItem extends StatelessWidget {
  final StorePageController controller;
  final PayItem item;

  const StoreCoinPackItem({
    super.key,
    required this.controller,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.handlePay(item, isPopup: true),
      child: Container(
        width: double.infinity,
        height: 84.h,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('store_coins_week.png'.icon),
            fit: BoxFit.fill,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// 左侧金币图
            Image.asset(
              'store_coins_week_gold.png'.icon,
              width: 49.w,
              height: 46.w,
            ),

            SizedBox(width: 12.w),

            /// 中间文字区
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Weekly Refill
                Text(
                  'Weekly Refill',
                  style: TextStyle(
                    color: const Color(0xFFDF23B8),
                    fontSize: 14,
                    fontFamily: 'PingFang SC',
                    fontWeight: FontWeight.w700,
                    height: 1.57,
                  ),
                ),
                SizedBox(height: 5.h),

                /// 2000 + 53%
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /// 金币 icon
                    Image.asset(
                      'store_gold.png'.icon,
                      width: 16.w,
                      height: 16.w,
                    ),
                    SizedBox(width: 4.w),

                    /// 2000 渐变文字
                    ShaderMask(
                      shaderCallback: (bounds) {
                        return const LinearGradient(
                          colors: [Color(0xFFFF0BBA), Color(0xFF6018E6)],
                        ).createShader(bounds);
                      },
                      child: Text(
                        '2000',
                        style: TextStyle(
                          color: const Color(0xFFFF0BBA),
                          fontSize: 18,
                          fontFamily: 'DDinPro',
                          fontWeight: FontWeight.w900,
                          height: 0.78,
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),

                    /// +53% 背景标签
                    Container(
                      height: 18.h,
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.40),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        '+53%',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: 'PingFang SC',
                          fontWeight: FontWeight.w400,
                          height: 1,
                          letterSpacing: -0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            /// 右侧价格区（顶到最右）
            Flexible(
              fit: FlexFit.loose,
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: 48.h,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                            '\$' + item.price, // $9.99
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'DDinPro',
                              fontWeight: FontWeight.w700,
                              height: 1,
                            ),
                          ),
                          SizedBox(width: 2.w),
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

                      /// 第二行：原价
                      Text(
                        '\$' + item.price,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.21),
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: Colors.white.withValues(
                            alpha: 0.21,
                          ), // 删除线颜色
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
    );
  }
}

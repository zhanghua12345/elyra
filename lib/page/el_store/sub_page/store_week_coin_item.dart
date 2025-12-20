import 'package:elyra/bean/pay_settings_bean.dart';
import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/el_store/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 周卡金币Item组件
class StoreWeekCoinItem extends StatelessWidget {
  final StorePageController controller;
  final PayItem item;

  const StoreWeekCoinItem({
    super.key,
    required this.controller,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.handlePay(item),
      child: Container(
        margin: EdgeInsets.only(bottom: 20.h),
        width: double.infinity,
        height: 102.h,
        child: Stack(
          children: [
            // 背景图
            Image.asset(
              'store_coins_week.png'.icon,
              width: double.infinity,
              height: 102.h,
              fit: BoxFit.fill,
            ),
            // 内容
            Positioned(
              left: 21.w,
              top: 0,
              bottom: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 金币图标
                  Image.asset(
                    'store_gold.png'.icon,
                    width: 40.w,
                    height: 40.w,
                  ),
                  SizedBox(height: 10.h),
                  // 金币数量
                  Text(
                    '${item.coins} Coins',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'PingFang SC',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            // 右侧内容
            Positioned(
              right: 24.w,
              top: 0,
              bottom: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // 价格
                  Row(
                    children: [
                      Text(
                        '\$',
                        style: TextStyle(
                          color: Color(0xFFFF0BBA),
                          fontSize: 14,
                          fontFamily: 'PingFang SC',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      ShaderMask(
                        shaderCallback: (bounds) {
                          return LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
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
                            fontFamily: 'PingFang SC',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  // Top Up按钮
                  Container(
                    width: 102.w,
                    height: 32.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.h),
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
                      'Top Up',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'PingFang SC',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

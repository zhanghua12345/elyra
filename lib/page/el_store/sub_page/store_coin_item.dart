import 'package:elyra/bean/pay_settings_bean.dart';
import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/el_store/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_utils/get_utils.dart';

/// 金币商品Item组件（大金币/小金币通用）
class StoreCoinItem extends StatelessWidget {
  final StorePageController controller;
  final PayItem item;
  final bool isBig; // true=大金币模式，false=小金币模式

  const StoreCoinItem({
    super.key,
    required this.controller,
    required this.item,
    required this.isBig,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 其他类型直接支付
        controller.handlePay(item);
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 主容器 - 只有右上角圆角35
          ClipRRect(
            borderRadius: BorderRadius.only(topRight: Radius.circular(35.r)),
            child: Container(
              width: isBig ? 164.w : 109.w,
              height: isBig ? 101.h : 99.h,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    isBig
                        ? 'store_coins_big.png'.icon
                        : 'store_coins_small.png'.icon,
                  ),
                  fit: BoxFit.fill,
                ),
              ),
              child: Stack(
                children: [
                  // 赠币角标（右上角）- 会被右上角圆角35裁切
                  if (item.sendCoins > 0)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: SizedBox(
                        width: isBig ? 54.w : 48.w,
                        height: isBig ? 54.h : 50.h,
                        child: Stack(
                          children: [
                            Image.asset(
                              'store_coins_jiao.png'.icon,
                              width: isBig ? 54.w : 48.w,
                              height: isBig ? 54.h : 50.h,
                              fit: BoxFit.fill,
                            ),
                            Positioned.fill(
                              child: Transform.rotate(
                                angle: 0.785398, // 45°
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 10.h),
                                    Text(
                                      '+',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontFamily: 'PingFang SC',
                                        fontWeight: FontWeight.w500,
                                        height: 1.17,
                                      ),
                                    ),
                                    Text(
                                      '${((item.sendCoins / item.coins) * 100).toInt()}%',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontFamily: 'PingFang SC',
                                        fontWeight: FontWeight.w500,
                                        height: 1.17,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  // 金币内容
                  Padding(
                    padding: EdgeInsets.only(left: 12.w, top: 10.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 金币图标
                        Image.asset(
                          'store_gold.png'.icon,
                          width: 28.w,
                          height: 28.w,
                        ),
                        SizedBox(height: 2.h),
                        // 金币数量
                        Text(
                          '${item.coins}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'PingFang SC',
                            fontWeight: FontWeight.w500,
                            height: 1,
                          ),
                        ),
                        // 赠币数量
                        if (item.sendCoins > 0)
                          Text(
                            '+${item.sendCoins} Coins',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                              fontFamily: 'PingFang SC',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        SizedBox(height: isBig ? 7.h : 4.h),
                        Spacer(),
                        Row(
                          children: [
                            Text(
                              item.productDetails.currencySymbol,
                              style: TextStyle(
                                color: const Color(0xFFFF0BBA),
                                fontSize: 12,
                                fontFamily: 'DDinPro',
                                fontWeight: FontWeight.w900,
                                height: 1.17,
                              ),
                            ),
                            SizedBox(width: 2.w),
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
                                item.productDetails.rawPrice.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'DDinPro',
                                  fontWeight: FontWeight.w900,
                                  height: 0.88,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                  // Top Up按钮（仅大金币模式）
                  if (isBig)
                    Positioned(
                      bottom: 10.h,
                      right: 12.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 4.h),
                          Container(
                            width: 79.w,
                            height: 24.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40.r),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Color(0xFFFF0BBA), Color(0xFF6018E6)],
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Top Up',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
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
          ),
          // Hot角标（左上角）- 在ClipRRect外面，不会被裁切
          if (item.cornerMarker == 'fiery')
            Positioned(
              bottom: 92.h,
              left: 12.w,
              child: Container(
                height: isBig ? 17.h : 14.h,
                padding: EdgeInsets.symmetric(horizontal: isBig ? 14.w : 10.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.r),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFFF0BBA), Color(0xFF6018E6)],
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Hot',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isBig ? 12.sp : 11.sp,
                    fontFamily: 'PingFang SC',
                    fontWeight: FontWeight.w500,
                    height: isBig ? 1.17 : 1.27,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

import 'package:elyra/bean/pay_settings_bean.dart';
import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/el_store/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 金币商品Item组件（大金币/小金币通用）
class StoreVipItem extends StatelessWidget {
  final StorePageController controller;
  final PayItem item;

  const StoreVipItem({
    super.key,
    required this.controller,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.handlePay(item),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 主容器 - 只有右上角圆角35
          ClipRRect(
            borderRadius: BorderRadius.only(topRight: Radius.circular(35.r)),
            child: Container(
              width: 109.w,
              height: 99.h,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('store_coins_big.png'.icon),
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
                        width: 48.w,
                        height: 50.h,
                        child: Stack(
                          children: [
                            Image.asset(
                              'store_coins_jiao.png'.icon,
                              width: 48.w,
                              height: 50.h,
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
                        SizedBox(height: 4.h),
                        Spacer(),
                        Row(
                          children: [
                            Text(
                              '\$',
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
                                item.price,
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
                height: 14.h,
                padding: EdgeInsets.symmetric(horizontal: 10.w),
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
                    fontSize: 11.sp,
                    fontFamily: 'PingFang SC',
                    fontWeight: FontWeight.w500,
                    height: 1.27,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

import 'package:elyra/bean/pay_settings_bean.dart';
import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/el_store/controller.dart';
import 'package:elyra/utils/store_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// =======================
/// VIP 主题配置模型
/// =======================
class VipTheme {
  final String bgImage;
  final String title;
  final List<Color> titleGradient;
  final String priceType;
  final Color priceColor;
  final Color originalPrice;
  final String subTitle;
  final Color subTitleColor;
  final Color extraNumColor;
  final Color descColor;

  const VipTheme({
    required this.bgImage,
    required this.title,
    required this.titleGradient,
    required this.priceType,
    required this.priceColor,
    required this.originalPrice,
    required this.subTitle,
    required this.subTitleColor,
    required this.extraNumColor,
    required this.descColor,
  });
}

/// =======================
/// VIP 主题统一配置中心
/// =======================
class VipThemes {
  static final Map<String, VipTheme> _themes = {
    'week': VipTheme(
      bgImage: 'store_sup_week.png',
      title: 'Weekly VIP',
      titleGradient: [Color(0xFF26343A), Color(0xFF698FA0)],
      priceType: '',
      priceColor: Color(0xFF26343A),
      originalPrice: Colors.black.withValues(alpha: 0.15),
      subTitle: 'Unlimited access to all series',
      subTitleColor: Color(0xFF26343A),
      extraNumColor: Colors.white,
      descColor: Color(0xFF26343A),
    ),
    'month': VipTheme(
      bgImage: 'store_sup_month.png',
      title: 'Monthly VIP',
      titleGradient: [Color(0xFF2C5289), Color(0xFF3981EE)],
      priceType: '/month',
      priceColor: Color(0xFF2B5289),
      originalPrice: Colors.black.withValues(alpha: 0.15),
      subTitle: 'Unlimited access to all series',
      subTitleColor: Color(0xFF2C5289),
      extraNumColor: Colors.white,
      descColor: Color(0xFF2C5289),
    ),
    'three_months': VipTheme(
      bgImage: 'store_sup_quarter.png',
      title: 'Quarterly VIP',
      titleGradient: [Color(0xFFD25DB8), Color(0xFFE01DB8)],
      priceType: '/quarter',
      priceColor: Color(0xFFDF23B8),
      originalPrice: Colors.black.withValues(alpha: 0.15),
      subTitle: 'Unlimited access to all series',
      subTitleColor: Color(0xFFDF23B8),
      extraNumColor: Colors.white,
      descColor: Color(0xFFDF23B8),
    ),
    'year': VipTheme(
      bgImage: 'store_sup_year.png',
      title: 'Yearly VIP',
      titleGradient: [Color(0xFFFFE652), Color(0xFFFDA71E)],
      priceType: '/year',
      priceColor: Color(0xFFFE890E),
      originalPrice: Colors.black.withValues(alpha: 0.15),
      subTitle: 'Unlimited access to all series',
      subTitleColor: Color(0xFFFE890E),
      extraNumColor: Color(0xFFFE890E),
      descColor: Color(0xFFFE890E),
    ),
  };

  /// 安全获取，避免异常
  static VipTheme of(String vipType) {
    return _themes[vipType] ?? _themes['month']!;
  }
}

/// =======================
/// VIP 商品 Item
/// =======================
class StoreVipItem extends StatelessWidget {
  final StorePageController controller;
  final PayItem item;

  const StoreVipItem({super.key, required this.controller, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = VipThemes.of(item.vipType);
    final currentPriceObj = getCurrentPrice(item);
    final originalPriceObj = getOriginalPrice(item);

    return GestureDetector(
      onTap: () => controller.handlePay(item),
      child: SizedBox(
        width: double.infinity,
        height: 100.h,
        child: Stack(
          children: [
            /// ================== 背景 + 原内容 ==================
            Container(
              width: double.infinity,
              height: 100.h,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(theme.bgImage.icon),
                  fit: BoxFit.fill,
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  SizedBox(height: 8.h),

                  /// 价格行
                  SizedBox(
                    height: 24.h,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text:
                                '${currentPriceObj?.currencyCode ?? ''}${currentPriceObj?.currencySymbol ?? ''}',
                            style: TextStyle(
                              color: theme.priceColor,
                              fontSize: 18,
                              fontFamily: 'DDinPro',
                              fontWeight: FontWeight.w900,
                              height: 1.11,
                            ),
                          ),
                          TextSpan(
                            text: '${currentPriceObj?.rawPrice ?? ''}',
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
                  SizedBox(height: 3.h),

                  /// 描述
                  Text(
                    item.description,
                    style: TextStyle(
                      color: theme.subTitleColor,
                      fontSize: 12,
                      fontFamily: 'PingFang SC',
                      fontWeight: FontWeight.w400,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),

            /// ================== 删除线原价（顶部浮层） ==================
            if (currentPriceObj?.rawPrice != originalPriceObj?.rawPrice)
              Positioned(
                top: 18.h,
                left: 128.w,
                child: Text(
                  '${originalPriceObj?.currencySymbol ?? ''}${originalPriceObj?.rawPrice ?? ''}',
                  style: TextStyle(
                    color: theme.originalPrice,
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.lineThrough,
                    decorationColor: theme.originalPrice,
                  ),
                ),
              ),

            /// ================== Bonus 区域（底部浮层） ==================
            Positioned(
              left: 0,
              bottom: 0,
              height: 22.h,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 96.w,
                    height: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '+Extra 500',
                          style: TextStyle(
                            color: theme.extraNumColor,
                            fontSize: 12,
                            fontFamily: 'PingFang SC',
                            fontWeight: FontWeight.w500,
                            height: 0.83,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Image.asset(
                          'store_gold.png'.icon,
                          width: 12.w,
                          height: 12.w,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16.w),
                    child: Text(
                      'Bonus expires in ${item.sendCoinTtl} days',
                      style: TextStyle(
                        color: theme.descColor,
                        fontSize: 12,
                        fontFamily: 'PingFang SC',
                        fontWeight: FontWeight.w400,
                        height: 1,
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

import 'package:elyra/bean/pay_settings_bean.dart';
import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/el_store/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// =======================
/// VIP 主题配置模型
/// =======================
class VipTheme {
  final String bgImage;
  final List<Color> titleGradient;
  final List<Color> priceGradient;
  final Color subTitleColor;
  final Color descColor;

  const VipTheme({
    required this.bgImage,
    required this.titleGradient,
    required this.priceGradient,
    required this.subTitleColor,
    required this.descColor,
  });

  Shader titleShader() {
    return LinearGradient(colors: titleGradient)
        .createShader(const Rect.fromLTWH(0, 0, 200, 24));
  }

  Shader priceShader() {
    return LinearGradient(colors: priceGradient)
        .createShader(const Rect.fromLTWH(0, 0, 200, 44));
  }
}

/// =======================
/// VIP 主题统一配置中心
/// =======================
class VipThemes {
  static final Map<String, VipTheme> _themes = {
    'week': VipTheme(
      bgImage: 'store_sup_week.png',
      title:'Weekly VIP',
      titleGradient: [Color(0xFF26343A), Color(0xFF698FA0)],
      priceType:'/month',
      priceGradient: [Color(0xFFFFFFFF), Color(0xFFBDEDFF)],
      originalPrice: Color(0xFF26343A),,
      subTitle:'Unlimited access to all series',
      subTitleColor: Color(0xFF26343A),
      extraNumColor: Color(0xFF26343A),
      descColor: Color(0xFF26343A),
    ),
    'month': VipTheme(
      bgImage: 'store_sup_month.png',
      titleGradient: [Color(0xFF2C5289), Color(0xFF3981EE)],
      priceGradient: [Color(0xFFFFFFFF), Color(0xFFCFFBDB)],
      subTitleColor: Color(0xFF2B5289),
      descColor: Color(0xFF2C5289),
    ),
    'three_months': VipTheme(
      bgImage: 'store_sup_quarter.png',
      titleGradient: [Color(0xFFD25DB8), Color(0xFFE01DB8)],
      priceGradient: [Color(0xFFC6AEFF), Color(0xFFFFFFFF)],
      subTitleColor: Color(0xFFDF23B8),
      descColor: Color(0xFFDF23B8),
    ),
    'year': VipTheme(
      bgImage: 'store_sup_year.png',
      titleGradient: [Color(0xFFFFE652), Color(0xFFFDA71E)],
      priceGradient: [Color(0xFF9F5300), Color(0xFF9F5300)],
      subTitleColor: Color(0xFFFE890E),
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

  const StoreVipItem({
    super.key,
    required this.controller,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final theme = VipThemes.of(item.vipType);

    return GestureDetector(
      onTap: () => controller.handlePay(item),
      child: Container(
        width: double.infinity,
        height: 100.h,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(theme.bgImage.icon),
            fit: BoxFit.fill,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 34.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 标题
            Text(
              item.shortType,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                foreground: Paint()..shader = theme.titleShader(),
              ),
            ),

            SizedBox(height: 15.h),

            /// 价格行
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  item.price,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    foreground: Paint()..shader = theme.priceShader(),
                  ),
                ),
                SizedBox(width: 4.w),
                Text(
                  '/${item.vipType}',
                  style: TextStyle(
                    color: theme.subTitleColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),

            const Spacer(),

            /// 描述
            Text(
              item.description,
              style: TextStyle(
                color: theme.descColor,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

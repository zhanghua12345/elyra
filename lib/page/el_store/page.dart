import 'package:easy_debounce/easy_throttle.dart';
import 'package:elyra/bean/pay_settings_bean.dart';
import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/el_store/controller.dart';
import 'package:elyra/widgets/bad_status_widget.dart';
import 'package:elyra/widgets/el_nodata_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  late final StorePageController controller;
  final TextEditingController _storeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = Get.put(StorePageController());
  }

  @override
  void dispose() {
    _storeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StorePageController>(
      builder: (controller) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          body: Container(
            padding: EdgeInsets.only(top: ScreenUtil().statusBarHeight),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('ely_background_image.png'.icon),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppBar('Store'),
                SizedBox(height: 6.h),
                Expanded(
                  child: SmartRefresher(
                    controller: controller.refreshController,
                    enablePullDown: true,
                    enablePullUp: false,
                    onRefresh: controller.onRefresh,
                    header: ClassicHeader(
                      height: 40,
                      textStyle: TextStyle(color: Colors.white),
                      idleText: 'Pull to refresh',
                      releaseText: 'Release to refresh',
                      refreshingText: 'Refreshing...',
                      completeText: 'Refresh completed',
                      failedText: 'Refresh failed',
                    ),
                    child: _buildContent(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBar(String title) {
    return Container(
      padding: EdgeInsets.only(left: 11.w, right: 11.w, top: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => Get.back(),
            child: Padding(
              padding: EdgeInsets.all(5.w),
              child: Image.asset('ely_back.png'.icon, height: 20.h),
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'PingFang SC',
              fontWeight: FontWeight.w600,
            ),
          ),
          GestureDetector(
            onTap: () {
              EasyThrottle.throttle(
                'restore-tap',
                Duration(seconds: 3),
                () => controller.restorePay(),
              );
            },
            child: Padding(
              padding: EdgeInsets.all(5.w),
              child: Text(
                'Restore',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF999999),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (controller.state.loadStatus == LoadStatusType.loading) {
      return Center(
        child: Image.asset('loading.gif'.icon, width: 120, height: 120),
      );
    }

    if (controller.state.loadStatus == LoadStatusType.loadFailed) {
      return ElNoDataWidget(
        imagePath: 'ely_error.png',
        title: 'No connection',
        description: 'Please check your network',
        buttonText: 'Try again',
        onButtonPressed: controller.onRefresh,
      );
    }

    if (controller.state.loadStatus == LoadStatusType.loadNoData) {
      return ElNoDataWidget(
        imagePath: 'ely_nodata.png',
        imageWidth: 180,
        imageHeight: 223,
        title: null,
        description: 'There is no data for the moment.',
        buttonText: null,
      );
    }

    return _buildContentArea();
  }

  Widget _buildContentArea() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            // 根据排序显示内容
            if (controller.state.sortList.isNotEmpty)
              ...controller.state.sortList.map((type) {
                if (type == 'list_coins') {
                  return _buildCoinsSection();
                } else {
                  return _buildVipSection();
                }
              }),
            // 底部提示
            _buildTips(),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  /// Coins 区块
  Widget _buildCoinsSection() {
    return Column(
      children: [
        SizedBox(height: 24.h),
        // Big Coins
        if (controller.state.coinsBigList.isNotEmpty) _buildBigCoins(),
        // Small Coins
        if (controller.state.coinsSmallList.isNotEmpty) _buildSmallCoins(),
        // Week Coins
        if (controller.state.coinsWeekList.isNotEmpty) _buildWeekCoins(),
      ],
    );
  }

  /// VIP 区块
  Widget _buildVipSection() {
    if (controller.state.subList.isEmpty) return SizedBox();

    return Column(
      children: [
        SizedBox(height: 40.h),
        _buildSectionTitle('VIP Membership'),
        SizedBox(height: 16.h),
        ...controller.state.subList.map((item) => _buildVipItem(item)),
      ],
    );
  }

  /// 标题
  Widget _buildSectionTitle(String title) {
    return Container(
      height: 48.h,
      alignment: Alignment.center,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white.withOpacity(0.25), Colors.transparent],
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text(
              title,
              style: TextStyle(
                color: Color(0xFFFFE79D),
                fontSize: 14,
                fontFamily: 'PingFang SC',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.white.withOpacity(0.25)],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 大金币
  Widget _buildBigCoins() {
    return Column(
      children: [
        SizedBox(height: 13.h),
        Wrap(
          spacing: 15.w,
          runSpacing: 13.h,
          alignment: WrapAlignment.start,
          children: controller.state.coinsBigList.map((item) {
            return GestureDetector(
              onTap: () => controller.handlePay(item),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // 主容器 - 只有右上角圆角35
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(35.r),
                    ),
                    child: Container(
                      width: 164.w,
                      height: 101.h,
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
                                width: 54.w,
                                height: 54.h,
                                child: Stack(
                                  children: [
                                    Image.asset(
                                      'store_coins_jiao.png'.icon,
                                      width: 54.w,
                                      height: 54.h,
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
                                              '\${((item.sendCoins / item.coins) * 100).toInt()}%',
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
                          // 内容区域
                          Positioned(
                            left: 12.w,
                            top: 10.h,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 金币图标和数量
                                Row(
                                  children: [
                                    Image.asset(
                                      'store_gold.png'.icon,
                                      width: 28.w,
                                      height: 28.w,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 2.h),
                                // 金币数量
                                Text(
                                  '\${item.coins}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                // 赠币
                                if (item.sendCoins > 0) ...[
                                  SizedBox(height: 2.h),
                                  Text(
                                    '+\${item.sendCoins} Coins',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                                SizedBox(height: 7.h),
                                // 价格
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      item.priceLocal,
                                      style: TextStyle(
                                        color: Color(0xFFFF0BBA),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    ShaderMask(
                                      shaderCallback: (bounds) {
                                        return LinearGradient(
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
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Top Up按钮
                          Positioned(
                            right: 12.w,
                            bottom: 10.h,
                            child: Container(
                              width: 79.w,
                              height: 24.h,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Color(0xFFFF0BBA), Color(0xFF6018E6)],
                                ),
                                borderRadius: BorderRadius.circular(12.h),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Top Up',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  // Hot角标（左上角）- 在ClipRRect外面，不会被裁切
                  if (item.cornerMarker == 'fiery')
                    Positioned(
                      bottom: 93.h,
                      left: 12.w,
                      child: Container(
                        width: 48.w,
                        height: 17.h,
                        decoration: ShapeDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(0.50, -.7),
                            end: Alignment(0.50, 1),
                            colors: [
                              const Color(0xFFFF0BBA),
                              const Color(0xFF6018E6),
                            ],
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Hot',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// 小金币
  Widget _buildSmallCoins() {
    return Column(
      children: [
        SizedBox(height: 13.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 13.h,
          alignment: WrapAlignment.start,
          children: controller.state.coinsSmallList.map((item) {
            return GestureDetector(
              onTap: () => controller.handlePay(item),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // 主容器 - 只有右上角圆角35
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(35.r),
                    ),
                    child: Container(
                      width: 109.w,
                      height: 99.h,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('store_coins_small.png'.icon),
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
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SizedBox(height: 4.h),
                                            Text(
                                              '+',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 8,
                                                fontWeight: FontWeight.w700,
                                                height: 1,
                                              ),
                                            ),
                                            Text(
                                              '\${((item.sendCoins / item.coins) * 100).toInt()}',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700,
                                                height: 1,
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
                          // 内容区域
                          Positioned.fill(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 12.h,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 金币图标
                                  Row(
                                    children: [
                                      Image.asset(
                                        'store_gold.png'.icon,
                                        width: 22.w,
                                        height: 22.w,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 2.h),
                                  // 金币数量
                                  Text(
                                    '\${item.coins}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  // 赠币
                                  if (item.sendCoins > 0) ...[
                                    SizedBox(height: 2.h),
                                    Text(
                                      '+\${item.sendCoins}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                  Spacer(),
                                  // 价格
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        item.priceLocal,
                                        style: TextStyle(
                                          color: Color(0xFFFF0BBA),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      ShaderMask(
                                        shaderCallback: (bounds) {
                                          return LinearGradient(
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
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
              // Hot角标（左上角）- 在ClipRRect外面，不会被裁切
              if (item.cornerMarker == 'fiery')
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    width: 14.w,
                    height: 40.h,
                    decoration: ShapeDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0.50, -.7),
                        end: Alignment(0.50, 1),
                        colors: [
                          const Color(0xFFFF0BBA),
                          const Color(0xFF6018E6),
                        ],
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        'Hot',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
          }).toList(),
        ),
      ],
    );
  }

  /// 周卡金币
  Widget _buildWeekCoins() {
    return Column(
      children: controller.state.coinsWeekList.map((item) {
        return Container(
          margin: EdgeInsets.only(top: 20.h),
          width: double.infinity,
          height: 168.h,
          decoration: BoxDecoration(
            color: Color(0xFF2A1B3D),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Row(
            children: [
              Image.asset('store_gold.png'.icon, height: 42.h),
              SizedBox(width: 13.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Weekly Refill',
                      style: TextStyle(
                        color: Color(0xFF612900),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Image.asset('store_gold.png'.icon, width: 14.w),
                        SizedBox(width: 4.w),
                        Text(
                          '${item.coins}',
                          style: TextStyle(
                            color: Color(0xFF84560D),
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (item.extInfo?.receiveCoinsRate != null) ...[
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                bottomRight: Radius.circular(16),
                              ),
                            ),
                            child: Text(
                              item.extInfo!.receiveCoinsRate!,
                              style: TextStyle(
                                color: Color(0xFF523927),
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => controller.handlePay(item),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF482A00), Color(0xFF5E1C00)],
                    ),
                    borderRadius: BorderRadius.circular(48),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item.price,
                        style: TextStyle(
                          color: Color(0xFFFFD67C),
                          fontSize: item.price.length > 10
                              ? 12
                              : item.price.length > 8
                              ? 14
                              : 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '/${item.vipType}',
                        style: TextStyle(
                          color: Color(0xFFFFF7D7).withOpacity(0.85),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  /// VIP 项
  Widget _buildVipItem(PayItem item) {
    // 根据 vipType 选择背景图
    String bgImage;
    switch (item.vipType) {
      case 'week':
        bgImage = 'store_sup_week.png';
        break;
      case 'month':
        bgImage = 'store_sup_month.png';
        break;
      case 'three_months':
        bgImage = 'store_sup_ quarter.png';
        break;
      case 'year':
        bgImage = 'store_sup_ year.png';
        break;
      default:
        bgImage = 'store_sup_month.png';
    }

    return GestureDetector(
      onTap: () => controller.handlePay(item),
      child: Container(
        margin: EdgeInsets.only(bottom: 24.h),
        width: double.infinity,
        height: 200.h,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(bgImage.icon),
            fit: BoxFit.fill,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 34.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.shortType,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                foreground: Paint()..shader = _getVipGradient(item.vipType),
              ),
            ),
            SizedBox(height: 15.h),
            Row(
              children: [
                Text(
                  item.price,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    foreground: Paint()
                      ..shader = _getVipPriceGradient(item.vipType),
                  ),
                ),
                Text(
                  '/${item.vipType}',
                  style: TextStyle(
                    color: _getVipTextColor(item.vipType),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            Spacer(),
            Text(
              item.description,
              style: TextStyle(
                color: _getVipDescColor(item.vipType),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// VIP 文字渐变
  Shader _getVipGradient(String vipType) {
    List<Color> colors;
    switch (vipType) {
      case 'week':
        colors = [Color(0xFF26343A), Color(0xFF698FA0)];
        break;
      case 'month':
        colors = [Color(0xFF2C5289), Color(0xFF3981EE)];
        break;
      case 'three_months':
        colors = [Color(0xFFD25DB8), Color(0xFFE01DB8)];
        break;
      case 'year':
        colors = [Color(0xFFFFE652), Color(0xFFFDA71E)];
        break;
      default:
        colors = [Colors.white, Colors.white];
    }
    return LinearGradient(
      colors: colors,
    ).createShader(Rect.fromLTWH(0, 0, 200, 24));
  }

  /// VIP 价格渐变
  Shader _getVipPriceGradient(String vipType) {
    List<Color> colors;
    switch (vipType) {
      case 'week':
        colors = [Color(0xFFFFFFFF), Color(0xFFBDEDFF)];
        break;
      case 'month':
        colors = [Color(0xFFFFFFFF), Color(0xFFCFFBDB)];
        break;
      case 'three_months':
        colors = [Color(0xFFC6AEFF), Color(0xFFFFFFFF)];
        break;
      case 'year':
        colors = [Color(0xFF9F5300), Color(0xFF9F5300)];
        break;
      default:
        colors = [Colors.white, Colors.white];
    }
    return LinearGradient(
      colors: colors,
    ).createShader(Rect.fromLTWH(0, 0, 200, 44));
  }

  /// VIP 文字颜色
  Color _getVipTextColor(String vipType) {
    switch (vipType) {
      case 'week':
        return Color(0xFF26343A);
      case 'month':
        return Color(0xFF2B5289);
      case 'three_months':
        return Color(0xFFDF23B8);
      case 'year':
        return Color(0xFFFE890E);
      default:
        return Colors.white;
    }
  }

  /// VIP 描述颜色
  Color _getVipDescColor(String vipType) {
    switch (vipType) {
      case 'week':
        return Color(0xFF26343A);
      case 'month':
        return Color(0xFF2C5289);
      case 'three_months':
        return Color(0xFFDF23B8);
      case 'year':
        return Color(0xFFFE890E);
      default:
        return Colors.white.withOpacity(0.7);
    }
  }

  /// 底部提示
  Widget _buildTips() {
    return Container(
      margin: EdgeInsets.only(top: 36.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tips',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: 'PingFang SC',
              fontWeight: FontWeight.w500,
              height: 1.25,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            '1. Coins are virtual items and cannot be refunded. Use it for this product.\n'
            '2. Both the coins and the reward coins will never expire. \n'
            '3. Coins will be used first when unlocking episodes. If the amount is insufficient, reward coins will automatically be used.\n'
            '4. The purchase has not been credited, click <Restore> torefresh.\n'
            '5. For other questions, contact us via Profile>Help &feedback.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontFamily: 'PingFang SC',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
        ],
      ),
    );
  }
}

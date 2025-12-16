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
      padding: EdgeInsets.only(left: 11.w, right: 11.w, top:4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => Get.back(),
            child: Padding(
              padding: EdgeInsets.all(5.w), // 扩大点击热区
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
          // 右侧可以放置其他操作按钮，暂时留空
          SizedBox(width: 30.w),
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
        _buildSectionTitle('Coins Purchase'),
        SizedBox(height: 16.h),
        // Big Coins
        if (controller.state.coinsBigList.isNotEmpty)
          _buildBigCoins(),
        // Small Coins
        if (controller.state.coinsSmallList.isNotEmpty)
          _buildSmallCoins(),
        // Week Coins
        if (controller.state.coinsWeekList.isNotEmpty)
          _buildWeekCoins(),
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
                  colors: [
                    Colors.white.withOpacity(0.25),
                    Colors.transparent,
                  ],
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
                  colors: [
                    Colors.transparent,
                    Colors.white.withOpacity(0.25),
                  ],
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
    return Wrap(
      spacing: 28.w,
      runSpacing: 20.h,
      children: controller.state.coinsBigList.map((item) {
        return GestureDetector(
          onTap: () => controller.handlePay(item),
          child: Container(
            width: 164.w,
            height: 168.h,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('store_coins_big.png'.icon),
                fit: BoxFit.fill,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset('store_gold.png'.icon, width: 18.w),
                    SizedBox(width: 6.w),
                    Text(
                      '${item.coins}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'PingFang SC',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                if (item.sendCoins > 0)
                  Text(
                    '+ ${item.sendCoins} Bonus',
                    style: TextStyle(
                      color: Color(0xFFFFE682),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.9),
                    border: Border.all(
                      color: Color(0xFFFFDAA4).withOpacity(0.5),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    item.price,
                    style: TextStyle(
                      color: Color(0xFFFFE88D),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  /// 小金币
  Widget _buildSmallCoins() {
    return Wrap(
      spacing: 14.w,
      runSpacing: 10.h,
      children: controller.state.coinsSmallList.map((item) {
        return GestureDetector(
          onTap: () => controller.handlePay(item),
          child: Container(
            width: 104.w,
            height: 84.h,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('store_coins_small.png'.icon),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('store_gold.png'.icon, width: 13.w),
                    SizedBox(width: 4.w),
                    Text(
                      '${item.coins}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'PingFang SC',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                if (item.sendCoins > 0) ...[
                  SizedBox(height: 4.h),
                  Text(
                    '+ ${item.sendCoins}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 10,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      }).toList(),
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
                      colors: [
                        Color(0xFF482A00),
                        Color(0xFF5E1C00),
                      ],
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
                foreground: Paint()
                  ..shader = _getVipGradient(item.vipType),
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
        colors = [Color(0xFFFFFFFF), Color(0xFF4C84C5)];
        break;
      case 'month':
        colors = [Color(0xFFDEDEDE), Color(0xFF658B75)];
        break;
      case 'three_months':
        colors = [Color(0xFFE8E5FF), Color(0xFF875FE2)];
        break;
      case 'year':
        colors = [Color(0xFF9F5300), Color(0xFF9F5300)];
        break;
      default:
        colors = [Colors.white, Colors.white];
    }
    return LinearGradient(colors: colors).createShader(
      Rect.fromLTWH(0, 0, 200, 24),
    );
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
    return LinearGradient(colors: colors).createShader(
      Rect.fromLTWH(0, 0, 200, 44),
    );
  }

  /// VIP 文字颜色
  Color _getVipTextColor(String vipType) {
    switch (vipType) {
      case 'week':
        return Color(0xFFADD2FF);
      case 'month':
        return Color(0xFFCFFBDB);
      case 'three_months':
        return Color(0xFFCAC4FF);
      case 'year':
        return Color(0xFF9F5300);
      default:
        return Colors.white;
    }
  }

  /// VIP 描述颜色
  Color _getVipDescColor(String vipType) {
    switch (vipType) {
      case 'week':
        return Color(0xFF99B9E0);
      case 'month':
        return Color(0xFFB5DDC0);
      case 'three_months':
        return Color(0xFFCAC4FF);
      case 'year':
        return Color(0xFF9F5300);
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
            'Subscription Rules',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            '1.Coins can only be used within this application.\n'
            '2. Payment: The purchase will be charged to your iTunes account.\n'
            '3. Renewal: Your Apple iTunes account will be charged within 24 hours before the expiration and the subscription period will be extended for another subscription cycle upon successful deduction.\n'
            '4. Cancellation: To cancel the subscription renewal, please turn off the automatic renewal function in the iTunes/Apple ID settings at least 24 hours before the current subscription period expires. If canceled within the last 24 hours before expiration, a subscription fee will still be charged.\n'
            '5. Payment successful but recharge not taking effect for an extended period? Click here to refresh or send an email to: moboreels@moboreader.com.\n'
            '6. Manage your subscriptions: You can view, change, or cancel your subscriptions.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/el_me/controller.dart';
import 'package:elyra/page/el_me/sub_page/login_popup/login_popup.dart';
import 'package:elyra/widgets/bad_status_widget.dart';
import 'package:elyra/widgets/el_nodata_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:url_launcher/url_launcher.dart';

class MePage extends StatefulWidget {
  const MePage({super.key});

  @override
  State<MePage> createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  final controller = Get.put(MePageController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MePageController>(
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

    return _buildMainContent();
  }

  /// 主要内容
  Widget _buildMainContent() {
    final userInfo = controller.state.customerInfo;

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 40.h),

          // 用户信息卡片
          _buildUserInfoCard(userInfo),

          SizedBox(height: 11.h),
          // 金币签到
          _buildDaily(),

          SizedBox(height: 11.h),
          // VIP
          _buildVip(),

          SizedBox(height: 11.h),
          // 菜单列表
          _buildMenuList(),
        ],
      ),
    );
  }

  /// 用户信息卡片
  Widget _buildUserInfoCard(userInfo) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 15.w),
      width: ScreenUtil().screenWidth - 32.w,
      decoration: BoxDecoration(
        color: Color(0xFFE424AE).withValues(alpha: 0.48),
        borderRadius: BorderRadius.circular(21.w),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // 头像
              CircleAvatar(
                radius: 30.w,
                backgroundColor: Color(0xFF565656),
                backgroundImage: userInfo?.avator?.isNotEmpty == true
                    ? NetworkImage(userInfo!.avator!)
                    : null,
                child: userInfo?.avator?.isEmpty != false
                    ? Icon(Icons.person, color: Colors.white, size: 30.w)
                    : null,
              ),
              // 内容区域
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userInfo?.isTourist == true
                            ? 'Visitor'
                            : '${userInfo?.familyName ?? ''} ${userInfo?.givingName ?? ''}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4.w),
                      Text(
                        'ID: ${userInfo?.customerId ?? ''}',
                        style: TextStyle(color: Colors.white, fontSize: 12.sp),
                      ),
                    ],
                  ),
                ),
              ),
              // 登录按钮
              if (userInfo?.isTourist == true)
                GestureDetector(
                  onTap: () {
                    ElLoginPopup.show();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 17.w,
                      vertical: 5.w,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.w),
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    child: Text(
                      'Log in',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          // 金币和Top Up
          Container(
            padding: EdgeInsets.only(top: 40.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // 金币
                    _buildCoinInfo('Coins', '${userInfo?.coinLeftTotal ?? 0}'),
                    SizedBox(width: 30.w),
                    // 赠送金币
                    _buildCoinInfo(
                      'Bonus',
                      '${userInfo?.sendCoinLeftTotal ?? 0}',
                    ),
                  ],
                ),
                // Top Up 按钮
                GestureDetector(
                  onTap: () => {Get.toNamed('/my_wallet')},
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.w,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.w),
                      gradient: LinearGradient(
                        colors: [Color(0xFFE424AE), Color(0xFF6018E6)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Text(
                      'Top Up',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 金币信息
  Widget _buildCoinInfo(String title, String value) {
    return Row(
      children: [
        Image.asset('ely_gold.png'.icon, width: 28.w),
        SizedBox(width: 10.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Color(0xFFF7F497),
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 金币签到
  Widget _buildDaily() {
    return GestureDetector(
      onTap: () => Get.toNamed('/coins_pack'),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('el_me_coins_bg.png'.icon),
            fit: BoxFit.fill,
          ),
        ),
        child: Row(
          children: [
            Image.asset('el_me_gift.png'.icon, width: 40.w, height: 40.w),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Daily reward ready!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Claim your rewards now',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
            Image.asset('el_me_right.png'.icon, width: 24.w),
          ],
        ),
      ),
    );
  }

  /// VIP
  Widget _buildVip() {
    final userInfo = controller.state.customerInfo;
    final bool isVip = userInfo?.isVip == true && userInfo?.isTourist != true;

    return GestureDetector(
      onTap: () => Get.toNamed('/store'),
      child: Container(
        width: 343.w,
        height: 114.h,
        margin: EdgeInsets.symmetric(horizontal: 15.w),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('el_me_activated_bg.png'.icon),
            fit: BoxFit.fill,
          ),
        ),
        child: Stack(
          children: [
            // Main Content Row
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 26.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'el_me_guan.png'.icon,
                          width: 23.w,
                          height: 20.w,
                        ),
                        SizedBox(width: 7.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                isVip ? 'Activated' : 'Not Activated',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 7.h),
                              Text(
                                'All Dramas Free with VIP',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'DIN Black',
                                  fontWeight: FontWeight.w900,
                                  height: 1.50,
                                  letterSpacing: -0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isVip)
                    Container(
                      width: 87.w,
                      height: 29.h,
                      decoration: ShapeDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(0.50, 1.00),
                          end: Alignment(0.50, -.80),
                          colors: [
                            const Color(0xFFFF23C1),
                            const Color(0xFFA16FFF),
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(44),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Subscribe',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'PingFang SC',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (isVip)
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 20.w),
                  child: Image.asset(
                    'el_me_guan.png'.icon,
                    width: 87.w,
                    height: 76.h,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            // Bottom elements
            if (!isVip)
              Positioned(
                left: 0,
                bottom: 0,
                child: Row(
                  children: [
                    Container(
                      width: 104.w,
                      height: 22.h,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('el_me_activated_tip.png'.icon),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '+Extra 500',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontFamily: 'PingFang SC',
                              fontWeight: FontWeight.w500,
                              height: 0.83,
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Image.asset(
                            'ely_gold.png'.icon,
                            width: 12.w,
                            height: 12.w,
                          ),
                          SizedBox(width: 4.w),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Bonus expires in 35 days',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: 'PingFang SC',
                        fontWeight: FontWeight.w400,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              )
            else
              Positioned(
                left: 20.w,
                bottom: 12.h,
                child: Row(
                  children: [
                    Image.asset(
                      'el_me_time.png'.icon,
                      width: 10.w,
                      height: 10.w,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'Expiration Time：${_formatVipTime(userInfo?.vipEndTime)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: 'PingFang SC',
                        fontWeight: FontWeight.w500,
                        height: 1,
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

  String _formatVipTime(int? endTime) {
    if (endTime == null) return '2023-11-23';
    final date = DateTime.fromMillisecondsSinceEpoch(endTime * 1000);
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  /// 菜单列表
  Widget _buildMenuList() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 16.w),
      child: Column(
        children: [
          _buildMenuItem(
            'assets/ely_my_feedback.png',
            'Feedback',
            id: 'feedback',
          ),
          _buildMenuItem(
            'assets/ely_my_language.png',
            'Language',
            id: 'language',
          ),
          _buildMenuItem('assets/ely_my_about.png', 'About', id: 'about'),
          _buildMenuItem(
            'assets/ely_my_setting.png',
            'Setting',
            id: 'setting',
            isLast: true,
          ),
        ],
      ),
    );
  }

  /// 菜单项
  Widget _buildMenuItem(
    dynamic icon,
    String title, {
    String? id, // id is now optional
    bool isLast = false,
    VoidCallback? onTap, // Add onTap callback
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: isLast
              ? BorderSide.none
              : BorderSide(color: Colors.white.withOpacity(0.5), width: 0.5),
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 1.w),
        leading: icon is String
            ? Image.asset(icon, width: 20.w)
            : Icon(icon, color: Colors.white),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.white70),
        onTap:
            onTap ??
            () {
              // Use onTap if provided, otherwise navigate by id
              if (id != null) {
                Get.toNamed('/$id');
              }
            },
      ),
    );
  }

  /// 带URL的菜单项
  Widget _buildMenuItemWithUrl(
    dynamic icon,
    String title,
    String url, {
    bool openInWebView = true,
    bool isLast = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: isLast
              ? BorderSide.none
              : BorderSide(color: Colors.white.withOpacity(0.5), width: 0.5),
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 1.w),
        leading: icon is String
            ? Image.asset(icon, width: 20.w)
            : Icon(icon, color: Colors.white),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.white70),
        onTap: () {
          if (openInWebView) {
            // 在应用内WebView中打开
            Get.toNamed('/web_view', arguments: {'title': title, 'url': url});
          } else {
            // 在外部浏览器打开
            _openExternalUrl(url);
          }
        },
      ),
    );
  }

  /// 在外部浏览器打开URL
  Future<void> _openExternalUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // debugPrint('无法打开链接: $url');
    }
  }

  /// 显示关于ElyraTV的弹窗
  void _showAboutElyraTvDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.w),
        ),
        backgroundColor: Colors.white,
        child: Container(
          width: 280.w,
          padding: EdgeInsets.symmetric(vertical: 20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'el_name.png'.icon, // Using the user-specified image name
                width: 100.w,
                height: 100.w,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 16.h),
              Text(
                'ElyraTV',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                // TODO: Get actual app version, e.g., from package_info_plus or an AppController
                'Version 1.0.0',
                style: TextStyle(color: Colors.grey, fontSize: 14.sp),
              ),
              SizedBox(height: 20.h),
              GestureDetector(
                onTap: () {
                  Get.back(); // Close the dialog
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 10.w,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.w),
                    gradient: LinearGradient(
                      colors: [Color(0xFFE424AE), Color(0xFF6018E6)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Text(
                    'OK',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

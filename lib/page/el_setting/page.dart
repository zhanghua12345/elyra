import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/el_account_logout/page.dart';
import 'package:elyra/page/el_setting/controller.dart';
import 'package:elyra/widgets/bad_status_widget.dart';
import 'package:elyra/widgets/el_nodata_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late final SettingPageController controller;
  final TextEditingController _settingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = Get.put(SettingPageController());
  }

  @override
  void dispose() {
    _settingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingPageController>(
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
                _buildAppBar('Settings'),
                SizedBox(height: 6.h),
                Expanded(child: _buildContent()),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBar(String title) {
    return Container(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => Get.back(),
            child: Image.asset('ely_back.png'.icon, height: 20.h),
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
          SizedBox(width: 20.w),
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
    return SizedBox.expand(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          // Account Deletion
          _buildListTile('Account Deletion', () {
            Get.to(() => AccountLogoutPage());
          }),
          SizedBox(height: 12.h),
          // Log out button
          _buildLogOutButton(),
        ],
      ),
    );
  }

  Widget _buildListTile(String title, VoidCallback onTap) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
        height: 48.h,
        padding: EdgeInsets.symmetric(horizontal: 16.h),
        margin: EdgeInsets.symmetric(horizontal: 16.h),
        decoration: ShapeDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'PingFang SC',
                fontWeight: FontWeight.w600,
                height: 1.50,
              ),
            ),
            Image.asset('ely_right.png'.icon, width: 10.w, height: 10.h),
          ],
        ),
      ),
    );
  }

  Widget _buildLogOutButton() {
    return GestureDetector(
      onTap: () {
        // Implement logout functionality here
        // controller.logOut();
      },
      child: Container(
        height: 48.h,
        margin: EdgeInsets.only(left: 16.w, right: 16.w),
        decoration: ShapeDecoration(
          gradient: LinearGradient(
            begin: Alignment(-.8, 0.5),
            end: Alignment(1, 0),
            colors: [const Color(0xFFE424AD), const Color(0xFF6018E6)],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(34),
          ),
        ),
        child: Center(
          child: Text(
            'Log out',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'PingFang SC',
              fontWeight: FontWeight.w600,
              height: 1.17,
            ),
          ),
        ),
      ),
    );
  }
}

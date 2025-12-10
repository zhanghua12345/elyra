import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/el_about/controller.dart';
import 'package:elyra/widgets/bad_status_widget.dart';
import 'package:elyra/widgets/el_nodata_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  late final AboutPageController controller;
  final TextEditingController _aboutController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = Get.put(AboutPageController());
  }

  @override
  void dispose() {
    _aboutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AboutPageController>(
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
                _buildAppBar('About'),
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
      padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 40.h),
          Image.asset('el_logo.png'.icon, width: 100.w, height: 100.h),
          SizedBox(height: 20.h),
          Text(
            'ElyraTV',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Version 1.0.1',
            style: TextStyle(color: Colors.white, fontSize: 16.sp),
          ),
          SizedBox(height: 40.h),
          _buildListTile('Privacy Policy', () {
            // Navigate to Privacy Policy page
          }),
          _buildListTile('User Agreement', () {
            // Navigate to User Agreement page
          }),
          _buildListTile('Visit Website', () {
            // Open website URL
          }),
        ],
      ),
    );
  }

  Widget _buildListTile(String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 16.sp),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
          ],
        ),
      ),
    );
  }
}

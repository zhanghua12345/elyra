import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/el_web_view/controller.dart';
import 'package:elyra/widgets/bad_status_widget.dart';
import 'package:elyra/widgets/el_nodata_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewPageController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(WebViewPageController());
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WebViewPageController>(
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
                _buildAppBar('WebView'),
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
            onTap: () => Get.back(),
            child: Image.asset('ely_back.png'.icon, height: 20.h),
          ),
          Expanded(
            child: Text(
              controller.state.title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'PingFang SC',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          // 刷新按钮
          GestureDetector(
            onTap: () => controller.reload(),
            child: Icon(Icons.refresh, color: Colors.white, size: 20.h),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (controller.state.loadStatus == LoadStatusType.loadFailed) {
      return ElNoDataWidget(
        imagePath: 'ely_error.png',
        title: 'No connection',
        description: 'Please check your network',
        buttonText: 'Try again',
        onButtonPressed: () => controller.reload(),
      );
    }

    return _buildContentArea();
  }

  Widget _buildContentArea() {
    return Stack(
      children: [
        // WebView
        WebViewWidget(controller: controller.webViewController),
        
        // 加载进度条
        if (controller.state.loadStatus == LoadStatusType.loading)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: LinearProgressIndicator(
              value: controller.state.loadingProgress / 100,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 2.h,
            ),
          ),
      ],
    );
  }
}

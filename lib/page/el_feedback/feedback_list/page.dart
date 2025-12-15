import 'dart:collection';

import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/el_feedback/feedback_list/controller.dart';
import 'package:elyra/widgets/bad_status_widget.dart';
import 'package:elyra/widgets/el_nodata_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class FeedbackListPage extends StatefulWidget {
  const FeedbackListPage({super.key});

  @override
  State<FeedbackListPage> createState() => _FeedbackListPageState();
}

class _FeedbackListPageState extends State<FeedbackListPage> {
  late final FeedbackListPageController controller;
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    controller = Get.put(FeedbackListPageController());
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FeedbackListPageController>(
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
                _buildAppBar('Feedback'),
                SizedBox(height: 6.h),
                Expanded(
                  child: SmartRefresher(
                    controller: _refreshController,
                    enablePullDown: true,
                    enablePullUp: false,
                    onRefresh: () {
                      controller.onRefresh();
                      Future.delayed(const Duration(milliseconds: 500)).then((_) {
                        if (mounted) {
                          _refreshController.refreshCompleted();
                        }
                      });
                    },
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
    if (controller.state.loadStatus == LoadStatusType.loadFailed ||
        controller.state.loadStatus == LoadStatusType.loadNoData) {
      return ElNoDataWidget(
        imagePath: 'ely_error.png',
        title: 'No connection',
        description: 'Please check your network',
        buttonText: 'Try again',
        onButtonPressed: controller.retry,
      );
    }

    return _buildContentArea();
  }

  Widget _buildContentArea() {
    return Stack(
      children: [
        // WebView
        InAppWebView(
          initialSettings: InAppWebViewSettings(
            javaScriptEnabled: true,
            mediaPlaybackRequiresUserGesture: false,
            allowsInlineMediaPlayback: true,
            cacheEnabled: false,
            clearCache: true,
            domStorageEnabled: false,
            transparentBackground: true,
          ),
          initialUserScripts: UnmodifiableListView<UserScript>([
            UserScript(
              source: FeedbackListPageController.androidInterfaceJs,
              injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
            ),
          ]),
          onWebViewCreated: controller.onWebViewCreated,
          onLoadStop: controller.onLoadStop,
          onLoadStart: controller.onLoadStart,
          onReceivedError: controller.onReceivedError,
          onPageCommitVisible: controller.onPageCommitVisible,
        ),

        // 加载指示器
        if (controller.state.loadStatus == LoadStatusType.loading)
          Center(
            child: Image.asset('loading.gif'.icon, width: 120, height: 120),
          ),
      ],
    );
  }
}

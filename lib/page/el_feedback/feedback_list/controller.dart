import 'dart:convert';
import 'dart:io';

import 'package:elyra/page/el_feedback/feedback_detail/page.dart';
import 'package:elyra/page/el_feedback/feedback_list/state.dart';
import 'package:elyra/utils/el_store.dart';
import 'package:elyra/utils/el_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:elyra/widgets/bad_status_widget.dart';

class FeedbackListPageController extends GetxController {
  final state = FeedbackListState();

  InAppWebViewController? webViewController;
  late Map<String, String> userData;

  // Android 接口 JS
  static const String androidInterfaceJs = """
    window.AndroidInterface = {
      getUserInfo: async function () {
        return window.flutter_inappwebview.callHandler('getUserInfo');
      },
      openFeedbackDetail: function (id) {
        return window.flutter_inappwebview.callHandler('openFeedbackDetail', id);
      },
    };
  """;

  @override
  void onInit() {
    super.onInit();
    _initUserData();
  }

  @override
  void onClose() {
    webViewController?.dispose();
    super.onClose();
  }

  /// 初始化用户数据
  void _initUserData() {
    String token = SpUtils().getString(ElStoreKeys.token) ?? '';

    userData = {
      'time_zone': _getTimeZoneOffset(DateTime.now()),
      'type': Platform.isAndroid ? 'android' : 'ios',
      'lang': 'en',
      'theme': 'theme_2',
      'token': token,
    };
  }

  /// 获取时区偏移
  String _getTimeZoneOffset(DateTime dateTime) {
    Duration offset = dateTime.timeZoneOffset;
    int hours = offset.inHours;
    int minutes = offset.inMinutes.remainder(60).abs();
    String sign = hours >= 0 ? '+' : '-';
    return '$sign${hours.abs().toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  /// WebView 创建回调
  Future<void> onWebViewCreated(InAppWebViewController controller) async {
    webViewController = controller;
    registerJsHandlers(controller);

    if (Platform.isIOS) {
      await registerIosMessageHandlers(controller);
    }

    await controller.loadUrl(
      urlRequest: URLRequest(
        url: WebUri('https://campaign.csyib.com/pages/leave/list'),
      ),
    );
  }

  /// 注册 JS 处理器
  void registerJsHandlers(InAppWebViewController controller) {
    controller.addJavaScriptHandler(
      handlerName: 'getUserInfo',
      callback: (args) => jsonEncode(userData),
    );

    controller.addJavaScriptHandler(
      handlerName: 'openFeedbackDetail',
      callback: (args) {
        if (args.isNotEmpty && args[0] is String) {
          final id = args[0] as String;
          debugPrint('openFeedbackDetail==>$id');
          Get.to(() => const FeedbackDetailPage(), arguments: {'id': id});
        }
      },
    );
  }

  /// 注册 iOS 消息处理器
  Future<void> registerIosMessageHandlers(
    InAppWebViewController controller,
  ) async {
    await controller.addWebMessageListener(
      WebMessageListener(
        jsObjectName: "openFeedbackDetail",
        allowedOriginRules: {"*"},
        onPostMessage: (message, origin, isMainFrame, replyProxy) {
          if (message == null) return;
          Get.to(() => const FeedbackDetailPage(), arguments: {'id': message.data});
        },
      ),
    );
  }

  /// WebView 加载完成
  Future<void> onLoadStop(
    InAppWebViewController controller,
    WebUri? url,
  ) async {
    if (Platform.isAndroid) {
      await controller.evaluateJavascript(source: androidInterfaceJs);
    } else if (Platform.isIOS) {
      String userString = jsonEncode(userData);
      Future.delayed(const Duration(seconds: 1)).then((_) {
        controller.evaluateJavascript(
          source:
              '''
            if (typeof window.receiveDataFromNative === 'function') {
              window.receiveDataFromNative($userString);
            }
          ''',
        );
      });
    }

    state.loadStatus = LoadStatusType.loadSuccess;
    update();
  }

  /// WebView 开始加载
  void onLoadStart(InAppWebViewController controller, WebUri? url) {
    state.loadStatus = LoadStatusType.loading;
    update();
  }

  /// WebView 加载错误
  void onReceivedError(
    InAppWebViewController controller,
    WebResourceRequest request,
    WebResourceError error,
  ) {
    Future.delayed(const Duration(milliseconds: 500)).then((_) {
      state.loadStatus = LoadStatusType.loadNoData;
      update();
    });
  }

  /// 页面可见回调
  void onPageCommitVisible(InAppWebViewController controller, WebUri? uri) {
    if (state.loadStatus == LoadStatusType.loadFailed) {
      controller.loadData(data: "<html></html>");
    }
  }

  /// 下拉刷新
  void onRefresh() {
    webViewController?.reload();
  }

  /// 重试加载
  void retry() {
    webViewController?.loadUrl(
      urlRequest: URLRequest(
        url: WebUri('https://campaign.csyib.com/pages/leave/list'),
      ),
    );
  }
}

import 'package:elyra/page/el_web_view/state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:elyra/widgets/bad_status_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPageController extends GetxController {
  final state = WebViewState();
  late WebViewController webViewController;

  @override
  void onInit() {
    super.onInit();
    
    // 获取传入的参数
    final arguments = Get.arguments as Map<String, dynamic>?;
    state.url = arguments?['url'] ?? '';
    state.title = arguments?['title'] ?? 'WebView';
    
    // 初始化 WebViewController
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            state.loadingProgress = progress;
            update();
          },
          onPageStarted: (String url) {
            state.loadStatus = LoadStatusType.loading;
            update();
          },
          onPageFinished: (String url) {
            state.loadStatus = LoadStatusType.loadSuccess;
            _updateNavigationState();
            update();
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('WebView error: ${error.description}');
            state.loadStatus = LoadStatusType.loadFailed;
            update();
          },
        ),
      );
    
    // 加载 URL
    if (state.url.isNotEmpty) {
      webViewController.loadRequest(Uri.parse(state.url));
    } else {
      state.loadStatus = LoadStatusType.loadFailed;
      update();
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  /// 更新导航状态
  Future<void> _updateNavigationState() async {
    state.canGoBack = await webViewController.canGoBack();
    state.canGoForward = await webViewController.canGoForward();
    update();
  }

  /// 后退
  Future<void> goBack() async {
    if (await webViewController.canGoBack()) {
      await webViewController.goBack();
    }
  }

  /// 前进
  Future<void> goForward() async {
    if (await webViewController.canGoForward()) {
      await webViewController.goForward();
    }
  }

  /// 刷新
  Future<void> reload() async {
    await webViewController.reload();
  }
}

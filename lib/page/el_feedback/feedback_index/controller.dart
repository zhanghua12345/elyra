import 'dart:convert';
import 'dart:io';

import 'package:elyra/page/el_feedback/feedback_index/state.dart';
import 'package:elyra/page/el_feedback/feedback_list/page.dart';
import 'package:elyra/request/http.dart';
import 'package:elyra/request/index.dart';
import 'package:elyra/utils/el_store.dart';
import 'package:elyra/utils/el_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:elyra/widgets/bad_status_widget.dart';
import 'package:image_picker/image_picker.dart';

class FeedbackPageController extends GetxController {
  final state = FeedbackState();

  InAppWebViewController? webViewController;
  final ImagePicker _imgPicker = ImagePicker();
  late Map<String, String> userData;

  // Android 接口 JS
  static const String androidInterfaceJs = """
    window.AndroidInterface = {
      getUserInfo: async function () {
        return window.flutter_inappwebview.callHandler('getUserInfo');
      },
      openPhotoPicker: function () {
        return window.flutter_inappwebview.callHandler('openPhotoPicker');
      },
      uploadConvertImage: function () {
        return window.flutter_inappwebview.callHandler('uploadConvertImage');
      },
      openFeedbackList: function () {
        return window.flutter_inappwebview.callHandler('openFeedbackList');
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

    getNoticeNum();
  }

  /// 获取时区偏移
  String _getTimeZoneOffset(DateTime dateTime) {
    Duration offset = dateTime.timeZoneOffset;
    int hours = offset.inHours;
    int minutes = offset.inMinutes.remainder(60).abs();
    String sign = hours >= 0 ? '+' : '-';
    return '$sign${hours.abs().toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  /// 获取通知数量
  Future<void> getNoticeNum() async {
    try {
      final res = await HttpClient().request(
        Apis.getNoticeNum,
        method: HttpMethod.get,
      );

      if (res.success) {
        state.noticeNum =
            int.tryParse(res.data['feedback_notice_num'].toString()) ?? 0;
        update();
      }
    } catch (e) {
      debugPrint('获取通知数量失败: $e');
    }
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
        url: WebUri('https://campaign.csyib.com/pages/leave/index'),
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
      handlerName: 'openPhotoPicker',
      callback: (args) => pickImage(),
    );

    controller.addJavaScriptHandler(
      handlerName: 'uploadConvertImage',
      callback: (args) {
        if (args.isNotEmpty && args[0] is String) {
          uploadImage(args[0] as String);
        }
      },
    );

    controller.addJavaScriptHandler(
      handlerName: 'openFeedbackList',
      callback: (args) => Get.to(() => const FeedbackListPage()),
    );
  }

  /// 注册 iOS 消息处理器
  Future<void> registerIosMessageHandlers(
    InAppWebViewController controller,
  ) async {
    await controller.addWebMessageListener(
      WebMessageListener(
        jsObjectName: "openPhotoPicker",
        allowedOriginRules: {"*"},
        onPostMessage: (message, origin, isMainFrame, replyProxy) {
          pickImage();
        },
      ),
    );

    await controller.addWebMessageListener(
      WebMessageListener(
        jsObjectName: "openFeedbackList",
        allowedOriginRules: {"*"},
        onPostMessage: (message, origin, isMainFrame, replyProxy) {
          Get.to(() => const FeedbackListPage());
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

    await controller.evaluateJavascript(
      source: '''
        window.onImagePicked = function(data) {
          console.log("📷 接收到来自 Flutter 的图片数据", data);
          window.flutter_inappwebview.callHandler('uploadConvertImage', data);
        };
      ''',
    );

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
      state.loadStatus = LoadStatusType.loadFailed;
      update();
    });
  }

  /// 页面可见回调
  void onPageCommitVisible(InAppWebViewController controller, WebUri? uri) {
    if (state.loadStatus == LoadStatusType.loadFailed) {
      controller.loadData(data: "<html></html>");
    }
  }

  /// 选择图片
  Future<void> pickImage() async {
    final XFile? image = await _imgPicker.pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      final compressedImage = await _compressToTargetSize(
        File(image.path),
        1024 * 1024,
      );
      final bytes = await compressedImage.readAsBytes();
      final base64Data = base64Encode(bytes);
      final data = base64Data;

      final js =
          '''
        if (typeof window.onImagePicked === 'function') {
          window.onImagePicked("$data");
        }
      ''';

      webViewController?.evaluateJavascript(source: js);
    }
  }

  /// 压缩图片到目标大小
  Future<File> _compressToTargetSize(File file, int targetSize) async {
    int quality = 90;
    File compressed = file;

    while ((await compressed.length()) > targetSize && quality > 10) {
      final result = await FlutterImageCompress.compressWithFile(
        file.absolute.path,
        quality: quality,
      );

      if (result == null) break;

      compressed = File(
        '${file.parent.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg',
      )..writeAsBytesSync(result);
      quality -= 10;
    }

    return compressed;
  }

  /// 上传图片
  Future<void> uploadImage(String data) async {
    await webViewController?.evaluateJavascript(
      source:
          '''
        if (window.uploadConvertImage) {
          window.uploadConvertImage("$data");
        } else {
          console.error("H5 没有定义 window.uploadConvertImage");
        }
      ''',
    );
  }

  /// 下拉刷新
  void onRefresh() {
    webViewController?.reload();
    getNoticeNum();
  }

  /// 重试加载
  void retry() {
    webViewController?.loadUrl(
      urlRequest: URLRequest(
        url: WebUri('https://campaign.csyib.com/pages/leave/index'),
      ),
    );
  }
}

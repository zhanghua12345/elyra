import 'dart:convert';
import 'dart:io';

import 'package:elyra/page/el_feedback/feedback_detail/state.dart';
import 'package:elyra/utils/el_store.dart';
import 'package:elyra/utils/el_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:elyra/widgets/bad_status_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class FeedbackDetailPageController extends GetxController {
  final state = FeedbackDetailState();

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
    };
  """;

  @override
  void onInit() {
    super.onInit();
    
    // 获取传入的 id
    final arguments = Get.arguments as Map<String, dynamic>?;
    state.feedbackId = arguments?['id'] ?? '';
    
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
      'id': state.feedbackId,
      'time_zone': _getTimeZoneOffset(DateTime.now()),
      'type': Platform.isAndroid ? 'android' : 'ios',
      'lang': 'en',
      'theme': 'theme_19',
      'token': token,
      'application': 'flutter',
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
        url: WebUri('https://campaign.csyib.com/pages/leave/detail'),
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
    // 请求完整相册权限（避免进入有限照片访问模式）
    PermissionStatus status;
    
    if (Platform.isIOS) {
      // iOS 14+ 需要请求完整相册访问权限
      status = await Permission.photos.request();
      
      // 如果用户选择了有限访问，引导用户去设置中开启完整权限
      if (status.isLimited) {
        // 可以选择：继续使用有限访问，或者提示用户去设置
        // 这里我们选择继续使用，但会记录日志
        debugPrint('⚠️ 用户选择了有限照片访问');
      }
    } else {
      // Android
      status = await Permission.storage.request();
    }

    // 如果权限被拒绝，直接返回
    if (status.isDenied || status.isPermanentlyDenied) {
      debugPrint('❌ 相册权限被拒绝');
      // 可以选择显示提示弹窗，引导用户去设置中开启权限
      if (status.isPermanentlyDenied) {
        await openAppSettings();
      }
      return;
    }

    // 权限已授予，选择图片
    final XFile? image = await _imgPicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final compressedImage = await _compressToTargetSize(File(image.path), 1024 * 1024);
      final bytes = await compressedImage.readAsBytes();
      final base64Data = base64Encode(bytes);
      final data = base64Data;

      final js = '''
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

      compressed = File('${file.parent.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg')
        ..writeAsBytesSync(result);
      quality -= 10;
    }

    return compressed;
  }

  /// 上传图片
  Future<void> uploadImage(String data) async {
    await webViewController?.evaluateJavascript(
      source: '''
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
  }

  /// 重试加载
  void retry() {
    webViewController?.loadUrl(
      urlRequest: URLRequest(
        url: WebUri('https://campaign.csyib.com/pages/leave/detail'),
      ),
    );
  }
}

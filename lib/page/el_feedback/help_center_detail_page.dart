import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pandaroll/extend/string_extend.dart';
import 'package:pandaroll/request/apis.dart';
import 'package:pandaroll/utils/my_utils.dart';
import 'package:pandaroll/utils/sp_keys.dart';
import 'package:pandaroll/utils/sp_utils.dart';
import 'package:pandaroll/widgets/bad_status_widget.dart';

class HelpCenterDetailPage extends StatefulWidget {
  const HelpCenterDetailPage({super.key});

  @override
  State<HelpCenterDetailPage> createState() => _HelpCenterDetailScreenState();
}

class _HelpCenterDetailScreenState extends State<HelpCenterDetailPage> {
  late String id;

  InAppWebViewController? _webViewController;
  final ImagePicker _imgPicker = ImagePicker();
  late Map<String, String> _userData;
  LoadStatusType loadingStatus = LoadStatusType.loading;
  static const String _androidInterfaceJs = """
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
  void initState() {
    id = Get.arguments['id'];
    super.initState();
    _initUserData();
  }

  @override
  void dispose() {
    _webViewController?.dispose();
    super.dispose();
  }

  void _initUserData() {
    _userData = {
      'id': id,
      'time_zone': MyUtils.getTimeZoneOffset(DateTime.now()),
      'type': Platform.isAndroid ? 'android' : 'ios',
      'lang': 'en',
      'theme': 'theme_2',
      'token': SpUtils().getString(SpKeys.token) ?? '',
      'application': 'flutter',
    };
  }

  Future<void> _handlePhotoPicker() async {
    final XFile? image = await _imgPicker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    File imageFile = File(image.path);
    final File compressedImage = await _compressToTargetSize(imageFile, 1024 * 1024);
    final bytes = await compressedImage.readAsBytes();
    final base64Data = base64Encode(bytes);
    final data = base64Data;
    final js =
        '''
      if (typeof window.onImagePicked === 'function') {
        window.onImagePicked("$data");
      }
    ''';
    _webViewController?.evaluateJavascript(source: js);
  }

  Future<File> _compressToTargetSize(File file, int targetSize) async {
    int quality = 90;
    File compressed = file;
    while ((await compressed.length()) > targetSize && quality > 10) {
      final result = await FlutterImageCompress.compressWithFile(file.absolute.path, quality: quality);
      if (result == null) break;
      compressed = File('${file.parent.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg')
        ..writeAsBytesSync(result);
      quality -= 10;
    }
    return compressed;
  }

  Future<void> _handlePhotoUpload(String base64Str) async {
    debugPrint("收到 base64 图片数据：$base64Str");
    await _webViewController?.evaluateJavascript(
      source:
          '''
        if (window.uploadConvertImage) {
          window.uploadConvertImage("$base64Str");
        } else {
          console.error("H5 没有定义 window.uploadConvertImage");
        }
      ''',
    );
  }

  Widget _buildWidget() {
    switch (loadingStatus) {
      case LoadStatusType.loading:
        return const Center(child: CircularProgressIndicator());
      case LoadStatusType.loadFailed:
        return BadStatusWidget(
          type: BadStatusType.noNetwork,
          onPressed: () {
            _webViewController?.loadUrl(urlRequest: URLRequest(url: WebUri(Apis.WEB_SITE_FEEDBACK_DETAIL)));
          },
        );
      case LoadStatusType.loadNoData:
        return BadStatusWidget(
          type: BadStatusType.notFound,
          onPressed: () {
            _webViewController?.reload();
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }

  void _registerJsHandlers(InAppWebViewController controller) {
    controller.addJavaScriptHandler(handlerName: 'getUserInfo', callback: (args) => jsonEncode(_userData));
    controller.addJavaScriptHandler(handlerName: 'openPhotoPicker', callback: (args) => _handlePhotoPicker());
    controller.addJavaScriptHandler(
      handlerName: 'uploadConvertImage',
      callback: (args) {
        if (args.isNotEmpty && args[0] is String) {
          _handlePhotoUpload(args[0] as String);
        }
      },
    );
  }

  Future<void> _registerIosMessageHandlers(InAppWebViewController controller) async {
    await controller.addWebMessageListener(
      WebMessageListener(
        jsObjectName: "openPhotoPicker",
        allowedOriginRules: {"*"},
        onPostMessage: (message, origin, isMainFrame, replyProxy) {
          _handlePhotoPicker();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        width: ScreenUtil().screenWidth,
        height: ScreenUtil().screenHeight,
        padding: EdgeInsets.only(top: ScreenUtil().statusBarHeight),
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('ic_bg.png'.icon), fit: BoxFit.fill),
        ),
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: Stack(
                children: [
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
                      UserScript(source: _androidInterfaceJs, injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START),
                    ]),
                    onWebViewCreated: (controller) async {
                      _webViewController = controller;
                      _registerJsHandlers(controller);
                      if (Platform.isIOS) {
                        await _registerIosMessageHandlers(controller);
                      }
                      await controller.loadUrl(urlRequest: URLRequest(url: WebUri(Apis.WEB_SITE_FEEDBACK_DETAIL)));
                    },
                    onLoadStop: (controller, url) async {
                      if (Platform.isAndroid) {
                        await controller.evaluateJavascript(source: _androidInterfaceJs);
                      } else if (Platform.isIOS) {
                        String userString = jsonEncode(_userData);
                        Future.delayed(const Duration(seconds: 1)).then((_) {
                          controller.evaluateJavascript(
                            source:
                                """
                              if (typeof window.receiveDataFromNative === 'function') {
                                window.receiveDataFromNative($userString);
                              }
                            """,
                          );
                        });
                      }
                      await controller.evaluateJavascript(
                        source: """
                          window.onImagePicked = function(data) {
                            window.flutter_inappwebview.callHandler('uploadConvertImage', data);
                          };
                        """,
                      );
                      loadingStatus = LoadStatusType.loadSuccess;
                      setState(() {});
                    },
                    onLoadStart: (controller, url) {
                      loadingStatus = LoadStatusType.loading;
                      setState(() {});
                    },
                    onReceivedError: (controller, request, error) {
                      Future.delayed(const Duration(milliseconds: 500)).then((_) {
                        loadingStatus = LoadStatusType.loadFailed;
                        setState(() {});
                      });
                    },
                    onPageCommitVisible: (controller, uri) {
                      if (loadingStatus == LoadStatusType.loadFailed) {
                        controller.loadData(data: "<html></html>");
                      }
                    },
                  ),
                  _buildWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Image.asset('ic_back.png'.icon, width: 24.w),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          Text(
            'Help Center',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          Container(width: 24.w),
        ],
      ),
    );
  }
}

import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pandaroll/extend/string_extend.dart';
import 'package:pandaroll/main.dart';
import 'package:pandaroll/page/mine/help_center/help_center_list_page.dart';
import 'package:pandaroll/request/apis.dart';
import 'package:pandaroll/request/http_client.dart';
import 'package:pandaroll/utils/my_utils.dart';
import 'package:pandaroll/utils/sp_keys.dart';
import 'package:pandaroll/utils/sp_utils.dart';
import 'package:pandaroll/widgets/bad_status_widget.dart';

class HelpCenterPage extends StatefulWidget {
  const HelpCenterPage({super.key});

  @override
  State<HelpCenterPage> createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends State<HelpCenterPage> with RouteAware {
  InAppWebViewController? _webViewController;
  final ImagePicker _imgPicker = ImagePicker();
  int _noticeNum = 0;
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
      openFeedbackList: function () {
        return window.flutter_inappwebview.callHandler('openFeedbackList');
      },
    };
  """;

  @override
  void initState() {
    super.initState();
    _initUserData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void didPopNext() {
    _getNoticeNum();
    _webViewController?.reload();
  }

  @override
  void dispose() {
    _webViewController?.dispose();
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  void _initUserData() {
    _userData = {
      'time_zone': MyUtils.getTimeZoneOffset(DateTime.now()),
      'type': Platform.isAndroid ? 'android' : 'ios',
      'lang': 'en',
      'theme': 'theme_2',
      'token': SpUtils().getString(SpKeys.token) ?? '',
    };
    _getNoticeNum();
  }

  Future<void> _getNoticeNum() async {
    final res = await HttpClient().request(Apis.getNoticeNum);
    if (res.success) {
      _noticeNum = int.tryParse(res.data['feedback_notice_num'].toString()) ?? 0;
      if (mounted) setState(() {});
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _imgPicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final compressedImage = await _compressToTargetSize(File(image.path), 1024 * 1024);
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

  Future<void> _uploadImage(String data) async {
    await _webViewController?.evaluateJavascript(
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
                      await controller.loadUrl(urlRequest: URLRequest(url: WebUri(Apis.WEB_SITE_FEEDBACK)));
                    },
                    onLoadStop: (controller, url) async {
                      if (Platform.isAndroid) {
                        await controller.evaluateJavascript(source: _androidInterfaceJs);
                      } else if (Platform.isIOS) {
                        String userString = jsonEncode(_userData);
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
          Badge(
            showBadge: _noticeNum > 0,
            badgeContent: Text(
              _noticeNum > 99 ? '99+' : '$_noticeNum',
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
            badgeStyle: BadgeStyle(badgeColor: Color(0xFFF306B9)),
            position: BadgePosition.topEnd(top: -5, end: -5),
            child: GestureDetector(
              onTap: () => Get.to(() => HelpCenterListPage()),
              child: Padding(
                padding: EdgeInsets.all(5.w),
                child: Image.asset('ic_mine_agreement.png'.icon, width: 24.w),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _registerJsHandlers(InAppWebViewController controller) {
    controller.addJavaScriptHandler(handlerName: 'getUserInfo', callback: (args) => jsonEncode(_userData));
    controller.addJavaScriptHandler(handlerName: 'openPhotoPicker', callback: (args) => _pickImage());
    controller.addJavaScriptHandler(
      handlerName: 'uploadConvertImage',
      callback: (args) {
        if (args.isNotEmpty && args[0] is String) {
          _uploadImage(args[0] as String);
        }
      },
    );
    controller.addJavaScriptHandler(
      handlerName: 'openFeedbackList',
      callback: (args) => Get.to(() => HelpCenterListPage()),
    );
  }

  Future<void> _registerIosMessageHandlers(InAppWebViewController controller) async {
    await controller.addWebMessageListener(
      WebMessageListener(
        jsObjectName: "openPhotoPicker",
        allowedOriginRules: {"*"},
        onPostMessage: (message, origin, isMainFrame, replyProxy) {
          _pickImage();
        },
      ),
    );
    await controller.addWebMessageListener(
      WebMessageListener(
        jsObjectName: "openFeedbackList",
        allowedOriginRules: {"*"},
        onPostMessage: (message, origin, isMainFrame, replyProxy) => Get.to(() => HelpCenterListPage()),
      ),
    );
  }

  Widget _buildWidget() {
    print('----loadStatus:${loadingStatus}');
    switch (loadingStatus) {
      case LoadStatusType.loading:
        return Center(child: CircularProgressIndicator());
      case LoadStatusType.loadFailed:
        return BadStatusWidget(
          type: BadStatusType.noNetwork,
          onPressed: () {
            _webViewController?.loadUrl(urlRequest: URLRequest(url: WebUri(Apis.WEB_SITE_FEEDBACK)));
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
}

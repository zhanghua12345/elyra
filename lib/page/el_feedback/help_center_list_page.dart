import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pandaroll/extend/string_extend.dart';
import 'package:pandaroll/main.dart';
import 'package:pandaroll/request/apis.dart';
import 'package:pandaroll/routes/app_routes.dart';
import 'package:pandaroll/utils/my_utils.dart';
import 'package:pandaroll/utils/sp_keys.dart';
import 'package:pandaroll/utils/sp_utils.dart';
import 'package:pandaroll/widgets/bad_status_widget.dart';

class HelpCenterListPage extends StatefulWidget {
  const HelpCenterListPage({super.key});

  @override
  State<HelpCenterListPage> createState() => _HelpCenterListPageState();
}

class _HelpCenterListPageState extends State<HelpCenterListPage> with RouteAware, AutomaticKeepAliveClientMixin {
  InAppWebViewController? _webViewController;
  late Map<String, String> _userData;

  LoadStatusType loadingStatus = LoadStatusType.loading;

  @override
  void initState() {
    super.initState();
    _initUserData();
  }

  void _initUserData() {
    _userData = {
      'time_zone': MyUtils.getTimeZoneOffset(DateTime.now()),
      'type': Platform.isAndroid ? 'android' : 'ios',
      'lang': 'en',
      'theme': 'theme_2',
      'token': SpUtils().getString(SpKeys.token) ?? '',
    };
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void didPopNext() {
    debugPrint('didPopNext');
    _webViewController?.reload();
  }

  @override
  void dispose() {
    super.dispose();
    _webViewController?.dispose();
    routeObserver.unsubscribe(this);
  }

  Widget _buildWidget() {
    switch (loadingStatus) {
      case LoadStatusType.loading:
        return Center(child: CircularProgressIndicator());
      case LoadStatusType.loadFailed:
        return BadStatusWidget(
          type: BadStatusType.noNetwork,
          onPressed: () {
            _webViewController?.loadUrl(urlRequest: URLRequest(url: WebUri(Apis.WEB_SITE_FEEDBACK_LIST)));
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                      transparentBackground: true, // 允许透明背景
                    ),
                    initialUserScripts: UnmodifiableListView<UserScript>([
                      UserScript(
                        source: """
                      window.AndroidInterface = {
                        getUserInfo: async function () {
                          return window.flutter_inappwebview.callHandler('getUserInfo');
                        },
                        openFeedbackDetail: function (id) {
                          return window.flutter_inappwebview.callHandler('openFeedbackDetail',id);
                        },
                      };
                      """,
                        injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
                      ),
                    ]),
                    onWebViewCreated: (controller) async {
                      _webViewController = controller;
                      // Android 获取用户信息
                      _webViewController?.addJavaScriptHandler(
                        handlerName: 'getUserInfo',
                        callback: (args) {
                          return jsonEncode(_userData);
                        },
                      );

                      if (Platform.isAndroid) {
                        // Android 去详情页
                        _webViewController?.addJavaScriptHandler(
                          handlerName: 'openFeedbackDetail',
                          callback: (args) {
                            debugPrint('$args');
                            if (args.isNotEmpty && args[0] is String) {
                              final id = args[0] as String;
                              debugPrint('openFeedbackDetail==>$id');
                              Get.toNamed(AppRoutes.helpCenterDetail, arguments: {'id': id});
                            }
                          },
                        );
                      }
                      if (Platform.isIOS) {
                        await controller.addWebMessageListener(
                          WebMessageListener(
                            jsObjectName: "openFeedbackDetail",
                            allowedOriginRules: {"*"},
                            onPostMessage: (message, origin, isMainFrame, replyProxy) {
                              if (message == null) return;
                              Get.toNamed(AppRoutes.helpCenterDetail, arguments: {'id': message.data});
                            },
                          ),
                        );
                      }
                      await controller.loadUrl(urlRequest: URLRequest(url: WebUri(Apis.WEB_SITE_FEEDBACK_LIST)));
                    },
                    onLoadStop: (controller, url) async {
                      if (Platform.isAndroid) {
                        await controller.evaluateJavascript(
                          source: """
                          window.AndroidInterface = {
                            getUserInfo: async function () {
                              return window.flutter_inappwebview.callHandler('getUserInfo');
                            },
                            openFeedbackDetail: function (id) {
                              return window.flutter_inappwebview.callHandler('openFeedbackDetail',id);
                            },
                          };
                        """,
                        );
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
                      loadingStatus = LoadStatusType.loadSuccess;
                      setState(() {});
                    },
                    onLoadStart: (controller, url) {
                      loadingStatus = LoadStatusType.loading;
                      setState(() {});
                    },
                    onReceivedError: (controller, request, error) {
                      Future.delayed(const Duration(milliseconds: 500)).then((_) {
                        loadingStatus = LoadStatusType.loadNoData;
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

  @override
  bool get wantKeepAlive => true;
}

import 'dart:async';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:elyra/page/el_me/controller.dart';
import 'package:elyra/request/http.dart';
import 'package:elyra/request/index.dart';
import 'package:elyra/routers/el_routers.dart';
import 'package:elyra/utils/el_store.dart';
import 'package:elyra/utils/el_utils.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../bean/register_bean.dart';

class UserUtil {
  static final UserUtil _instance = UserUtil._internal();

  factory UserUtil() => _instance;

  UserUtil._internal();

  String? get token => SpUtils().getString(ElStoreKeys.token);

  Timer? timer;

  register({bool toHome = true}) async {
    try {
      ApiResponse res = await HttpClient().request(Apis.register);
      if (res.success) {
        RegisterBean data = RegisterBean.fromJson(res.data);
        SpUtils().setString(ElStoreKeys.token, data.token ?? '');
        HttpClient().setAuthToken(data.token ?? '');
        if (toHome) Get.offNamed(AppRoutes.main);
        // UserUtil().enterAppPost();
        // FirebaseCommon.reportFirebaseToken();
        Get.put(MePageController());
        Get.find<MePageController>().getUserInfo();

        return Future.value(true);
      }
      if (toHome) Get.offNamed(AppRoutes.main);
      return Future.value(false);
    } catch (e) {
      if (toHome) Get.offNamed(AppRoutes.main);
      return Future.value(false);
    }
  }

  /// 登录
  Future<ApiResponse> login({
    required String type,
    required String openid,
    String? email,
    String? name,
    String? avator,
  }) async {
    // 获取原用户/游客 token
    final String oldToken = token ?? '';

    Map<String, dynamic> params = {
      'platform': type,
      'third_id': openid,
    };
    if (email != null) params['email'] = email;
    if (name != null) params['family_name'] = name;
    if (avator != null) params['avator'] = avator;

    ApiResponse res = await HttpClient().request(Apis.login, data: params);
    if (res.success) {
      // 1. 调用 leaveApp 使用之前的 token 把之前的退出
      if (oldToken.isNotEmpty) {
        leaveApp(postAuthorization: oldToken);
      }

      // 2. 保存新的 token
      final result = res.data as Map<String, dynamic>;
      final String newToken = result['token'] ?? '';
      SpUtils().setString(ElStoreKeys.token, newToken);
      HttpClient().setAuthToken(newToken);

      // 3. 调用 enterTheApp
      enterTheApp();

      // 4. 调用 onLine
      onLine();
    }
    return res;
  }

  /// 离开应用
  Future<void> leaveApp({String? postAuthorization}) async {
    String? auth = postAuthorization ?? token;
    if (auth == null || auth.isEmpty) return;

    HttpClient().request(
      Apis.leaveApp,
      data: {'PostAuthorization': auth},
    );
  }

  /// 进入应用
  Future<void> enterTheApp() async {
    HttpClient().request(Apis.enterTheApp);
  }

  /// 在线上报
  Future<void> onLine({String? postAuthorization}) async {
    String? auth = postAuthorization ?? token;
    if (auth == null || auth.isEmpty) return;

    HttpClient().request(
      Apis.onLine,
      data: {'PostAuthorization': auth},
    );
  }

 //离线上报
  Future<void> offLine({String? postAuthorization}) async {
    String? auth = postAuthorization ?? token;
    if (auth == null || auth.isEmpty) return;

    HttpClient().request(
      Apis.onLine,
      data: {'PostAuthorization': auth},
    );
  }

  // 上报错误信息
  reportErrorEvent(
    String eventName,
    String eventKey, {
    String? errMsg,
    String? type,
    String? orderCode,
    String? transactionId,
    num shortPlayId = 0,
    num shortPlayVideoId = 0,
    Map<String, dynamic>? extendData,
    Map<String, dynamic>? payData,
  }) async {
    String? userId = Get.put(MePageController()).state.customerInfo?.customerId;

    Map<String, dynamic> params = {
      "event_name": eventName,
      "event_key": eventKey,
      "userId": userId,
      "short_play_id": shortPlayId,
      "short_play_video_id": shortPlayVideoId,
    };

    if (type != null) params.putIfAbsent('type', () => type);
    if (orderCode != null) params.putIfAbsent('order_code', () => orderCode);
    if (payData != null) params.putIfAbsent('pay_data', () => payData);
    if (transactionId != null) params.putIfAbsent('transaction_id', () => transactionId);
    if (extendData != null) params.addAll(extendData);
    params.putIfAbsent('error_msg', () => errMsg);
    HttpClient().request(Apis.reportEvent, data: params);
  }

  static String payCallback = 'pay_callback';
  static String payError = 'pay_error';
  static String payRestore = 'pay_restore';
  static String payPlatformTimeout = 'pay_platform_timeout';
  static String videoError = 'video_error';
}

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

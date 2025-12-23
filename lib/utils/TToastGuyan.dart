import 'dart:async';
import 'package:elyra/page/el_me/GXJThimraCenterController.dart';
import 'package:elyra/request/AContentDetail.dart';
import 'package:elyra/request/KAgreement.dart';
import 'package:elyra/routers/QTVTitle.dart';
import 'package:elyra/utils/KXMGlee.dart';
import 'package:elyra/utils/WOJIndex.dart';
import 'package:get/get.dart';

import '../bean/KXAHiveContentBean.dart';

class OUnechoPage {
late List<dynamic> _processImageCloseArr;
late bool _enbale_HorizontallyQuarter = false;


  static final OUnechoPage _instance = OUnechoPage._internal();

  factory OUnechoPage() => _instance;

  OUnechoPage._internal();

  String? get token => SPJiao().getString(ElStoreKeys.token);

  Timer? timer;

  register({bool toHome = true}) async {
    try {
      ApiResponse res = await UFSearchElaris().request(Apis.register);
      if (res.success) {
        MFrontGenresBean data = MFrontGenresBean.fromJson(res.data);
        SPJiao().setString(ElStoreKeys.token, data.token ?? '');
        UFSearchElaris().setAuthToken(data.token ?? '');
        if (toHome) Get.offNamed(IDetailGuan.main);
        
        
        Get.put(LMainController());
        Get.find<LMainController>().getUserInfo();

        return Future.value(true);
      }
      if (toHome) Get.offNamed(IDetailGuan.main);
      return Future.value(false);
    } catch (e) {
      if (toHome) Get.offNamed(IDetailGuan.main);
      return Future.value(false);
    }
  }

  
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
    String? userId = Get.put(LMainController()).state.customerInfo?.customerId;

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
    UFSearchElaris().request(Apis.reportEvent, data: params);
  }

  static String payCallback = 'pay_callback';
  static String payError = 'pay_error';
  static String payRestore = 'pay_restore';
  static String payPlatformTimeout = 'pay_platform_timeout';
  static String videoError = 'video_error';
}

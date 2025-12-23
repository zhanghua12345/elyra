import 'dart:io';

import 'package:dio/dio.dart';
import 'package:elyra/utils/device_info.dart';
import 'package:elyra/utils/el_store.dart';
import 'package:elyra/utils/el_utils.dart';
import 'package:flutter/foundation.dart';

class RequestInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    /// 不加密
    bool isRelease = kReleaseMode;
    if (!isRelease) {
      options.headers.addAll({'security': false});
    } else {
      options.headers.addAll({'security': true});
    }
    final deviceInfo = DeviceInfoUtils();
    String token = SpUtils().getString(ElStoreKeys.token) ?? '';
    if (token.isNotEmpty) {
      options.headers.addAll({'Authorization': token});
    }

    /// 获取时区偏移
    String _getTimeZoneOffset(DateTime dateTime) {
      Duration offset = dateTime.timeZoneOffset;
      int hours = offset.inHours;
      int minutes = offset.inMinutes.remainder(60).abs();
      String sign = hours >= 0 ? '+' : '-';
      return '$sign${hours.abs().toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
    }

    // String idfa = SpUtils().getString(ElStoreKeys.iosIDFA) ?? '';
    // String gaid = Platform.isIOS ? (deviceInfo.deviceIdfv ?? '') : SpUtils().getString(ElStoreKeys.googleAid) ?? '';
    options.headers.addAll({
      'lang-key': 'en',
      'device-id': deviceInfo.deviceId ?? 'unknown',
      'system-type': deviceInfo.systemType ?? 'unknown',
      'model': deviceInfo.deviceModel ?? 'unknown',
      'system-version': deviceInfo.osVersion ?? 'unknown',
      'brand': deviceInfo.deviceBrand ?? 'unknown',
      'app-version': deviceInfo.appVersion ?? 'unknown',
      'app-name': 'PandaLoom',
      'product-prefix': 'pandaloom',
      "time-zone": _getTimeZoneOffset(DateTime.now()),
      // 'idfa': idfa,
      // 'idfv': deviceInfo.deviceIdfv,
      // "device-gaid": gaid,
    });

    super.onRequest(options, handler);
  }
}

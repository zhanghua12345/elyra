import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:io';

class DeviceInfoUtils {
  static final DeviceInfoUtils _instance = DeviceInfoUtils._internal();
  factory DeviceInfoUtils() => _instance;
  DeviceInfoUtils._internal();

  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();
  late PackageInfo _packageInfo;

  // 设备基本信息
  String? _deviceId;
  String? _systemType;
  String? _deviceBrand;
  double? _screenHeight;
  double? _pixelRatio;
  String? _languageCode;
  bool? _isTablet;
  String? _osVersion;
  String? _appVersion;
  String? _appBuildNumber;
  double? _screenWidth;
  String? _deviceModel;
  bool? _isPhysicalDevice;

  // 初始化
  Future<void> init() async {
    try {
      _packageInfo = await PackageInfo.fromPlatform();
      await _getDeviceInfo();
      _getScreenInfo();
      _getLanguageInfo();
    } catch (e) {
      debugPrint('获取设备信息失败: $e');
    }
  }

  // 获取设备信息
  Future<void> _getDeviceInfo() async {
    if (kIsWeb) {
      _getWebDeviceInfo();
    } else if (Platform.isAndroid) {
      await _getAndroidDeviceInfo();
    } else if (Platform.isIOS) {
      await _getIosDeviceInfo();
    }
  }

  // 获取Web设备信息
  void _getWebDeviceInfo() async {
    final webInfo = await _deviceInfoPlugin.webBrowserInfo;
    _deviceId = webInfo.vendor ?? '';
    _deviceModel = webInfo.hardwareConcurrency.toString();
    _osVersion = webInfo.appVersion ?? '';
    _appVersion = _packageInfo.version;
    _appBuildNumber = _packageInfo.buildNumber;
    _isPhysicalDevice = null; // Web平台无法确定
    _systemType = 'web';
  }

  // 获取Android设备信息
  Future<void> _getAndroidDeviceInfo() async {
    final androidInfo = await _deviceInfoPlugin.androidInfo;
    _deviceId = androidInfo.id;
    _deviceModel = androidInfo.model;
    _deviceBrand = androidInfo.brand;
    _osVersion = androidInfo.version.release;
    _appVersion = _packageInfo.version;
    _appBuildNumber = _packageInfo.buildNumber;
    _isTablet = androidInfo.isPhysicalDevice; 
    _isPhysicalDevice = androidInfo.isPhysicalDevice;
    _systemType = 'android';
  }

  // 获取iOS设备信息
  Future<void> _getIosDeviceInfo() async {
    final iosInfo = await _deviceInfoPlugin.iosInfo;
    _deviceModel = iosInfo.model;
    _appVersion = _packageInfo.version;
    _appBuildNumber = _packageInfo.buildNumber;
    _isTablet = iosInfo.model.toLowerCase().contains('ipad');
    _isPhysicalDevice = iosInfo.isPhysicalDevice;
    _deviceBrand = iosInfo.modelName;
    _osVersion = iosInfo.systemVersion;

    _systemType = 'ios';

    final securityStorage = FlutterSecureStorage();
    String? idFv = await securityStorage.read(key: 'identifierForVendor');
    idFv ??= iosInfo.identifierForVendor;
    if (idFv != null) {
      await securityStorage.write(key: "identifierForVendor", value: idFv);
      _deviceId = idFv;
    }
  }

  // 获取屏幕信息
  void _getScreenInfo() {
    final mediaQueryData =
        WidgetsBinding.instance.platformDispatcher.views.first;
    _screenWidth =
        mediaQueryData.physicalSize.width / mediaQueryData.devicePixelRatio;
    _screenHeight =
        mediaQueryData.physicalSize.height / mediaQueryData.devicePixelRatio;
    _pixelRatio = mediaQueryData.devicePixelRatio;
  }

  // 获取语言信息
  void _getLanguageInfo() {
    _languageCode =
        WidgetsBinding.instance.platformDispatcher.locale.languageCode;
  }

  // 公开获取信息的方法
  String? get deviceId => _deviceId;
  String? get deviceModel => _deviceModel;
  String? get systemType => _systemType;
  String? get appBuildNumber => _appBuildNumber;
  double? get screenWidth => _screenWidth;
  double? get screenHeight => _screenHeight;
  double? get pixelRatio => _pixelRatio;
  String? get deviceBrand => _deviceBrand;
  String? get osVersion => _osVersion;
  String? get appVersion => _appVersion;
  String? get languageCode => _languageCode;
  bool? get isTablet => _isTablet;
  bool? get isPhysicalDevice => _isPhysicalDevice;

  // 打印所有设备信息
  void printDeviceInfo() {
    debugPrint('''
设备信息:
  设备ID: $_deviceId
  设备型号: $_deviceModel
  设备品牌: $_deviceBrand
  屏幕高度: $_screenHeight
  像素密度: $_pixelRatio
  语言代码: $_languageCode
  是否平板: $_isTablet
  操作系统版本: $_osVersion
  应用版本: $_appVersion
  应用构建号: $_appBuildNumber
  屏幕宽度: $_screenWidth
  是否物理设备: $_isPhysicalDevice
    ''');
  }

  // 获取设备信息Map
  Map<String, dynamic> toMap() {
    return {
      'deviceId': _deviceId,
      'deviceModel': _deviceModel,
      'deviceBrand': _deviceBrand,
      'screenWidth': _screenWidth,
      'screenHeight': _screenHeight,
      'pixelRatio': _pixelRatio,
      'osVersion': _osVersion,
      'appVersion': _appVersion,
      'appBuildNumber': _appBuildNumber,
      'languageCode': _languageCode,
      'isTablet': _isTablet,
      'isPhysicalDevice': _isPhysicalDevice,
    };
  }
}

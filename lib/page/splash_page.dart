import 'package:elyra/bean/register_bean.dart';
import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/main_page.dart';
import 'package:elyra/request/http.dart';
import 'package:elyra/request/index.dart';
import 'package:elyra/utils/device_info.dart';
import 'package:elyra/utils/el_store.dart';
import 'package:elyra/utils/el_utils.dart';
import 'package:elyra/utils/user_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _hasProcessed = false; // 标记是否已处理过

  @override
  void initState() {
    super.initState();
    // 延迟 1 秒后执行，防止界面一打开就进行异步操作，给用户一点时间看到 Splash 页面
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return; // 检查 mounted 状态
      Future.delayed(const Duration(seconds: 1), () async {
        if (!mounted) return; // 再次检查 mounted 状态
        // 监听网络状态变化
        _listenToNetworkChanges();
        // 尝试执行网络请求
        await _tryExecuteRequest();
      });
    });
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  /// 监听网络状态变化
  void _listenToNetworkChanges() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      // 当网络状态变为可用时，尝试执行请求
      if (results.isNotEmpty && results.first != ConnectivityResult.none && !_hasProcessed && mounted) {
        _tryExecuteRequest();
      }
    });
  }

  /// 尝试执行网络请求
  Future<void> _tryExecuteRequest() async {
    if (_hasProcessed || !mounted) return;

    // 检查网络连接状态
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.isEmpty || connectivityResult.first == ConnectivityResult.none) {
      // 没有网络,等待网络连接
      print('等待网络连接...');
      return;
    }

    // 标记已处理，防止重复执行
    _hasProcessed = true;
    
    // 取消网络监听，防止重复触发
    await _connectivitySubscription?.cancel();

    // 有网络，执行业务逻辑
    String? token = SpUtils().getString(ElStoreKeys.token);
    if (!token.isNullString) {
      // 已有 token，设置设备信息头部后跳转
      final deviceInfo = DeviceInfoUtils();
      HttpClient().addHeaders({
        'device-id': deviceInfo.deviceId ?? 'unknown',
        'system-type': deviceInfo.systemType ?? 'unknown',
        'model': deviceInfo.deviceModel ?? 'unknown',
        'system-version': deviceInfo.osVersion ?? 'unknown',
        'brand': deviceInfo.deviceBrand ?? 'unknown',
        'app-version': deviceInfo.appVersion ?? 'unknown',
      });
      HttpClient().setAuthToken(token!);
      
      if (mounted) {
        // 使用 offAll 清空路由栈，直接跳转到主页
        Get.offAll(() => const MainPage());
      }
    } else {
      // 没有 token，调用注册接口
      await _register();
    }
  }

  _register() async {
    try {
      final deviceInfo = DeviceInfoUtils();
      HttpClient().addHeaders({
        'device-id': deviceInfo.deviceId ?? 'unknown',
        'system-type': deviceInfo.systemType ?? 'unknown',
        'model': deviceInfo.deviceModel ?? 'unknown',
        'system-version': deviceInfo.osVersion ?? 'unknown',
        'brand': deviceInfo.deviceBrand ?? 'unknown',
        'app-version': deviceInfo.appVersion ?? 'unknown',
      });

      ApiResponse res = await HttpClient().request(Apis.register);
      if (res.success) {
        RegisterBean data = RegisterBean.fromJson(res.data);
        final newToken = data.token ?? '';
        SpUtils().setString(ElStoreKeys.token, newToken);
        HttpClient().setAuthToken(newToken);

        // 调用 UserUtil 的方法来管理生命周期
        await UserUtil().enterTheApp();
        UserUtil().startOnlineTimer();

        if (mounted) {
          // 使用 offAll 清空路由栈，直接跳转到主页
          Get.offAll(() => const MainPage());
        }
      } else {
        // 注册失败，显示错误信息但允许用户继续
        _handleRegisterError('注册失败，请检查网络连接');
      }
    } catch (e) {
      // 捕获所有异常，显示友好提示
      print('注册异常: $e');
      _handleRegisterError('网络连接失败，请检查网络设置后重试');
    }
  }

  /// 处理注册错误
  void _handleRegisterError(String message) {
    if (!mounted) return;
    
    // 显示错误对话框
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('提示'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // 关闭对话框
              // 重置标记，允许用户再次尝试
              _hasProcessed = false;
            },
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // 关闭对话框
              _hasProcessed = false; // 重置标记
              _register(); // 重试注册
            },
            child: const Text('重试'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: ScreenUtil().screenWidth,
        height: ScreenUtil().screenHeight,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('el_splash_bg.png'.icon),
            fit: BoxFit.fill,
          ),
        ),
        // child: Column(
        //   mainAxisAlignment: MainAxisAlignment.end,
        //   children: [
        //     Image.asset('el_logo.png'.icon, height: 95.h),
        //     SizedBox(height: 12.h),
        //     Image.asset('el_name.png'.icon, height: 42.h),
        //     SizedBox(height: 120.h),
        //   ],
        // ),
      ),
    );
  }
}

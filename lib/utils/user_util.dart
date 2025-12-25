import 'dart:async';
import 'package:easy_debounce/easy_throttle.dart';
import 'package:elyra/page/el_collect/controller.dart';
import 'package:elyra/page/el_me/controller.dart';
import 'package:elyra/request/http.dart';
import 'package:elyra/request/index.dart';
import 'package:elyra/routers/el_routers.dart';
import 'package:elyra/utils/el_store.dart';
import 'package:elyra/utils/el_utils.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../bean/register_bean.dart';

class UserUtil with WidgetsBindingObserver {
  static final UserUtil _instance = UserUtil._internal();

  factory UserUtil() => _instance;

  UserUtil._internal() {
    WidgetsBinding.instance.addObserver(this);
  }

  String? get token => SpUtils().getString(ElStoreKeys.token);

  bool _isInApp = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (!_isInApp) {
        enterTheApp();
        startOnlineTimer();
      }
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      // 节流处理，防止在 inactive 和 paused 状态间切换时重复调用 leaveApp
      EasyThrottle.throttle(
        'lifecycle_leave_throttle',
        const Duration(milliseconds: 1000),
        () {
          if (_isInApp) {
            leaveApp();
            stopOnlineTimer();
          }
        },
      );
    }
  }

  // 在线上报定时器
  Timer? _onlineTimer;

  /// 游客注册
  /// [toHome] 是否跳转到主页
  /// [refreshUserInfo] 是否刷新用户信息
  Future<bool> register({
    bool toHome = true,
    bool refreshUserInfo = true,
  }) async {
    try {
      ApiResponse res = await HttpClient().request(Apis.register);
      if (res.success) {
        RegisterBean data = RegisterBean.fromJson(res.data);
        final newToken = data.token ?? '';

        // 保存新token
        await SpUtils().setString(ElStoreKeys.token, newToken);
        HttpClient().setAuthToken(newToken);

        // 调用 enterTheApp
        await enterTheApp();

        // 启动在线上报定时器（每10分钟）
        startOnlineTimer();

        if (refreshUserInfo) {
          Get.put(MePageController());
          Get.find<MePageController>().getUserInfo();
        }

        if (toHome) Get.offNamed(AppRoutes.main);
        return Future.value(true);
      }
      if (toHome) Get.offNamed(AppRoutes.main);
      return Future.value(false);
    } catch (e) {
      if (toHome) Get.offNamed(AppRoutes.main);
      return Future.value(false);
    }
  }

  /// 切换账号登录
  Future<ApiResponse> login({
    required String type,
    required String openid,
    String? email,
    String? name,
    String? avator,
  }) async {
    // 1. 获取旧token
    final String oldToken = token ?? '';

    Map<String, dynamic> params = {'platform': type, 'third_id': openid};
    if (email != null) params['email'] = email;
    if (name != null) params['family_name'] = name;
    if (avator != null) params['avator'] = avator;

    // 2. 调用登录接口获取新token
    ApiResponse res = await HttpClient().request(Apis.login, data: params);
    if (res.success) {
      final result = res.data as Map<String, dynamic>;
      final String newToken = result['token'] ?? '';

      // 3. 用旧token调用 leaveApp
      if (oldToken.isNotEmpty) {
        await leaveApp(postAuthorization: oldToken);
        // 删除旧的在线上报定时器
        stopOnlineTimer();
      }

      // 4. 保存新token
      await SpUtils().setString(ElStoreKeys.token, newToken);
      HttpClient().setAuthToken(newToken);

      // 5. 用新token调用 enterTheApp
      await enterTheApp();

      // 6. 启动新的在线上报定时器（每10分钟）
      startOnlineTimer();
    }
    return res;
  }

  /// 退出登录（返回新游客token）
  /// [oldToken] 旧的token，用于调用leaveApp
  /// [newToken] 后端返回的新游客token
  Future<void> logOut({
    required String oldToken,
    required String newToken,
  }) async {
    // 1. 用旧token调用 leaveApp
    if (oldToken.isNotEmpty) {
      await leaveApp(postAuthorization: oldToken);
      // 删除旧的在线上报定时器
      stopOnlineTimer();
    }

    // 2. 保存新token
    await SpUtils().setString(ElStoreKeys.token, newToken);
    HttpClient().setAuthToken(newToken);

    // 3. 用新token调用 enterTheApp
    await enterTheApp();

    // 4. 启动新的在线上报定时器（每10分钟）
    startOnlineTimer();
  }

  /// 离开应用
  Future<void> leaveApp({String? postAuthorization}) async {
    String? auth = postAuthorization ?? token;
    if (auth == null || auth.isEmpty) return;

    final res = await HttpClient().request(
      Apis.leaveApp,
      data: {'PostAuthorization': auth},
    );
    if (res.success) {
      _isInApp = false;
    }
  }

  /// 进入应用
  Future<void> enterTheApp() async {
    if (token == null || token!.isEmpty) return;
    final res = await HttpClient().request(Apis.enterTheApp);
    if (res.success) {
      _isInApp = true;
    }
  }

  /// 在线上报（上报当前用户在线状态）
  Future<void> onLine({String? postAuthorization}) async {
    String? auth = postAuthorization ?? token;
    if (auth == null || auth.isEmpty) return;

    await HttpClient().request(Apis.onLine, data: {'PostAuthorization': auth});
  }

  /// 启动在线上报定时器（每10分钟）
  void startOnlineTimer() {
    // 先停止旧的定时器
    stopOnlineTimer();

    // 立即执行一次上报
    onLine();

    // 启动新的定时器，每10分钟执行一次
    _onlineTimer = Timer.periodic(const Duration(minutes: 10), (timer) {
      onLine();
    });
  }

  /// 停止在线上报定时器
  void stopOnlineTimer() {
    _onlineTimer?.cancel();
    _onlineTimer = null;
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
    if (transactionId != null)
      params.putIfAbsent('transaction_id', () => transactionId);
    if (extendData != null) params.addAll(extendData);
    params.putIfAbsent('error_msg', () => errMsg);
    HttpClient().request(Apis.reportEvent, data: params);
  }

  static String payCallback = 'pay_callback';
  static String payError = 'pay_error';
  static String payRestore = 'pay_restore';
  static String payPlatformTimeout = 'pay_platform_timeout';
  static String videoError = 'video_error';

  /// 刷新个人中心和收藏页面
  void refreshMeAndCollectPage() {
    debugPrint('🔄 [UserUtil] 刷新个人中心和收藏页面...');
    
    // 刷新个人中心页面
    _refreshMePage();
    
    // 刷新收藏页面
    _refreshCollectPage();
  }

  /// 刷新个人中心页面数据
  void _refreshMePage() {
    try {
      if (Get.isRegistered<MePageController>()) {
        final meController = Get.find<MePageController>();
        meController.onRefresh();
        debugPrint('✅ [UserUtil] 个人中心页面刷新成功');
      } else {
        debugPrint('⚠️ [UserUtil] 个人中心页面未初始化');
      }
    } catch (e) {
      debugPrint('❌ [UserUtil] 刷新个人中心页面失败: $e');
    }
  }

  /// 刷新收藏页面数据
  void _refreshCollectPage() {
    try {
      if (Get.isRegistered<CollectController>()) {
        final collectController = Get.find<CollectController>();
        collectController.onRefresh();
        debugPrint('✅ [UserUtil] 收藏页面刷新成功');
      } else {
        debugPrint('⚠️ [UserUtil] 收藏页面未初始化');
      }
    } catch (e) {
      debugPrint('❌ [UserUtil] 刷新收藏页面失败: $e');
    }
  }
}

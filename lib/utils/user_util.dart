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
    debugPrint('🔄 [UserUtil] App生命周期变化: $state');

    if (state == AppLifecycleState.resumed) {
      // App回到前台：检查token → 检查!isInApp → 调用enterTheApp（不启动定时器）
      if (token == null || token!.isEmpty) {
        debugPrint('⚠️ [UserUtil] token为空，跳过回到前台处理');
        return;
      }

      if (!_isInApp) {
        debugPrint('🟢 [UserUtil] App回到前台，调用enterTheApp');
        enterTheApp();
        // 注意：不调用 startOnlineTimer()，定时器继续运行
      }
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      // App退到后台：检查token → 检查isInApp → 调用leaveApp（不停止定时器）
      // 节流处理，防止在 inactive 和 paused 状态间切换时重复调用 leaveApp
      EasyThrottle.throttle(
        'lifecycle_leave_throttle',
        const Duration(milliseconds: 1000),
        () {
          if (token == null || token!.isEmpty) {
            debugPrint('⚠️ [UserUtil] token为空，跳过退到后台处理');
            return;
          }

          if (_isInApp) {
            debugPrint('🔴 [UserUtil] App退到后台，调用leaveApp');
            leaveApp();
            // 注意：不停止定时器，定时器继续运行
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
  /// [isAccountLogout] 是否是账号注销（需要先用旧token调用leaveApp）
  Future<bool> register({
    bool toHome = true,
    bool refreshUserInfo = true,
    bool isAccountLogout = false,
  }) async {
    try {
      debugPrint('🔵 [UserUtil] 开始游客注册，isAccountLogout: $isAccountLogout');

      // 如果是账号注销，先用旧token调用leaveApp
      if (isAccountLogout) {
        final oldToken = token ?? '';
        if (oldToken.isNotEmpty) {
          debugPrint('🔴 [UserUtil] 账号注销：用旧token调用leaveApp');
          await leaveApp(postAuthorization: oldToken);
          stopOnlineTimer();
        }
      }

      ApiResponse res = await HttpClient().request(Apis.register);
      if (res.success) {
        RegisterBean data = RegisterBean.fromJson(res.data);
        final newToken = data.token ?? '';
        debugPrint('🔵 [UserUtil] 注册成功，获取新token');

        // 保存新token
        await SpUtils().setString(ElStoreKeys.token, newToken);
        HttpClient().setAuthToken(newToken);
        debugPrint('🔵 [UserUtil] 新token已保存');

        // 调用 enterTheApp
        debugPrint('🟢 [UserUtil] 调用enterTheApp');
        await enterTheApp();

        // 启动在线上报定时器（每10分钟，不立即调用onLine）
        debugPrint('⏰ [UserUtil] 启动定时器（不立即调用onLine）');
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
      debugPrint('❌ [UserUtil] 注册失败: $e');
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
    // if (oldToken.isNotEmpty) {
    //   await leaveApp(postAuthorization: oldToken);
    //   stopOnlineTimer();
    // }

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
  /// 注意：不会立即调用onLine，只在10分钟后才首次执行
  void startOnlineTimer() {
    debugPrint('⏰ [UserUtil] 启动在线上报定时器（10分钟周期，不立即执行）');
    // 先停止旧的定时器
    stopOnlineTimer();
    onLine();
    // 启动新的定时器，每10分钟执行一次
    // 注意：移除立即执行的 onLine() 调用
    _onlineTimer = Timer.periodic(const Duration(minutes: 10), (timer) {
      debugPrint('⏰ [UserUtil] 定时器触发，执行onLine');
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

import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/el_me/controller.dart';
import 'package:elyra/page/el_me/sub_page/el_setting/state.dart';
import 'package:elyra/page/splash_page.dart';
import 'package:elyra/request/http.dart';
import 'package:elyra/request/index.dart';
import 'package:elyra/utils/el_store.dart';
import 'package:elyra/utils/el_utils.dart';
import 'package:elyra/utils/toast.dart';
import 'package:elyra/utils/user_util.dart';
import 'package:elyra/widgets/bad_status_widget.dart';
import 'package:elyra/widgets/el_confirm_modal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SettingPageController extends GetxController {
  final state = SettingState();
  final RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );

  @override
  void onReady() {
    super.onReady();
    // 页面准备完成后执行的操作
    loadData();
  }

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
  }

  // 加载数据的方法
  void loadData() async {
    if (state.isLoading) return;
    state.isLoading = true;
    try {
      // 加载成功
      state.loadStatus = LoadStatusType.loadSuccess;
      update();
    } catch (err) {
      // 错误处理
      state.loadStatus = LoadStatusType.loadFailed;
      update();
    } finally {
      state.isLoading = false;

      // 确保刷新控制器正确完成
      refreshController.refreshCompleted();
      update();
    }
  }

  // 下拉刷新
  void onRefresh() {
    loadData();
  }

  void logOut() {
    final meController = Get.find<MePageController>();
    // Default to true (isTourist) if null to be safe
    final isTourist = meController.state.customerInfo?.isTourist ?? true;
    final isLogin = !UserUtil().token.isNullString && !isTourist;

    final context = Get.context;
    if (context == null) return;

    showElConfirmModal(
      context,
      image: AssetImage('el_model_logout.png'.icon),
      title: 'Leaving So Soon?',
      child: Text(
        "You'll need to sign in again",
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontFamily: 'PingFang SC',
          fontWeight: FontWeight.w400,
          height: 1.50,
        ),
      ),
      cancelText: 'Cancel',
      confirmText: 'Log Out',
      onCancel: () {
        Navigator.of(context).pop();
      },
      onConfirm: () async {
        Navigator.of(context).pop();
        await _signOut();
      },
    );
  }

  Future<void> _signOut() async {
    // 获取旧token
    final oldToken = UserUtil().token ?? '';

    // 1. 用旧token调用 leaveApp
    if (oldToken.isNotEmpty) {
      await UserUtil().leaveApp(postAuthorization: oldToken);
      // 删除旧的在线上报定时器
      UserUtil().stopOnlineTimer();
    }
    // Call signOut API (退出登录)
    final res = await HttpClient().request(
      Apis.signOut,
      method: HttpMethod.post,
    );

    if (res.success) {
      // 获取后端返回的新游客token
      final newToken = res.data['token'] ?? '';

      // 调用 UserUtil.logOut 处理退出登录逻辑
      await UserUtil().logOut(oldToken: oldToken, newToken: newToken);

      Message.show('Log out success');

      // 关闭当前页面，返回个人中心
      Get.back();

      // 刷新个人中心和收藏页面
      UserUtil().refreshMeAndCollectPage();
    } else {
      Message.show(res.message ?? 'Operation failed, Please try again.');
    }
  }
}

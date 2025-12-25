import 'package:elyra/request/http.dart';
import 'package:elyra/routers/el_routers.dart';
import 'package:elyra/utils/toast.dart';
import 'package:elyra/utils/user_util.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginController extends GetxController {
  bool isLoading = false;

  @override
  void onInit() {
    super.onInit();
  }

  /// Apple 登录
  Future<void> loginWithApple() async {
    if (isLoading) return;
    isLoading = true;
    EasyLoading.show(status: 'Loading...');
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // 执行登录请求
      ApiResponse res = await UserUtil().login(
        type: 'apple',
        openid: credential.userIdentifier!,
        email: credential.email,
        name: '${credential.givenName ?? ''} ${credential.familyName ?? ''}'.trim(),
      );

      if (res.success) {
        Message.show('Login Success');

        // 关闭弹窗
        Get.back();

        // 刷新个人中心和收藏页面
        UserUtil().refreshMeAndCollectPage();

        // 如果当前不在个人中心页面，则跳转到个人中心
        // 注意：这里不使用 Get.offAllNamed，避免清空所有路由栈
        // 如果已经在个人中心页面，则不需要跳转
      } else {
        Message.show(res.message ?? 'Login Failed');
      }
    } catch (e) {
      // 用户取消登录或其它错误
      print('Apple Login Error: $e');
      Message.show('Operation Failed');
    } finally {
      isLoading = false;
      EasyLoading.dismiss();
    }
  }

  /// Google 登录 (占位)
  Future<void> loginWithGoogle() async {
    // TODO: 集成 google_sign_in
    Message.show('Google login is not yet implemented');
  }

  /// Facebook 登录 (占位)
  Future<void> loginWithFacebook() async {
    // TODO: 集成 flutter_facebook_auth
    Message.show('Facebook login is not yet implemented');
  }
}

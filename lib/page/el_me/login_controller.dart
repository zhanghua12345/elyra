import 'package:elyra/page/el_me/controller.dart';
import 'package:elyra/request/http.dart';
import 'package:elyra/routers/el_routers.dart';
import 'package:elyra/utils/toast.dart';
import 'package:elyra/utils/user_util.dart';
import 'package:get/get.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  /// Apple 登录
  Future<void> loginWithApple() async {
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

        // 重启应用
        Get.offAllNamed(
          AppRoutes.splash,
          arguments: {'isRestart': true},
        );
      } else {
        Message.show(res.message ?? 'Login Failed');
      }
    } catch (e) {
      // 用户取消登录或其它错误
      // debugPrint('Apple Login Error: $e');
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

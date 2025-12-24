import 'package:elyra/extend/el_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// 登录弹窗
class ElLoginPopup extends StatelessWidget {
  const ElLoginPopup({super.key});

  /// 显示弹窗
  static void show() {
    Get.bottomSheet(
      const ElLoginPopup(),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(24.w),
        topRight: Radius.circular(24.w),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1624),
          image: DecorationImage(
            image: AssetImage('store_popup_bg.png'.icon),
            fit: BoxFit.fitWidth,
            alignment: Alignment.topCenter,
          ),
        ),
        padding: EdgeInsets.fromLTRB(20.w, 30.h, 20.w, 40.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo
            Image.asset('el_name.png'.icon, width: 183.w, fit: BoxFit.contain),
            SizedBox(height: 51.h),
            // 登录选项列表
            _buildLoginItem(
              icon: 'el_login_apple.png',
              label: 'Continue with Apple',
              onTap: () {
                // TODO: 调用 Apple 登录逻辑
                Get.back();
              },
            ),
            SizedBox(height: 18.h),
            _buildLoginItem(
              icon: 'el_login_facebook.png',
              label: 'Continue with Facebook',
              onTap: () {
                // TODO: 调用 Facebook 登录逻辑
                Get.back();
              },
            ),
            SizedBox(height: 18.h),
            _buildLoginItem(
              icon: 'el_login_google.png',
              label: 'Continue with Google',
              onTap: () {
                // TODO: 调用 Google 登录逻辑
                Get.back();
              },
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginItem({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(27.h),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(icon.icon, width: 18.w, height: 18.w),
            SizedBox(width: 12.w),

            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF333333) /* 黑色 */,
                fontSize: 14,
                fontFamily: 'Alibaba PuHuiTi 2.0',
                fontWeight: FontWeight.w700,
                height: 1,
                letterSpacing: -0,
              ),
            ),
            // 占位以保持文字居中
          ],
        ),
      ),
    );
  }
}

import 'package:elyra/bean/register_bean.dart';
import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/main_page.dart';
import 'package:elyra/request/http.dart';
import 'package:elyra/request/index.dart';
import 'package:elyra/utils/device_info.dart';
import 'package:elyra/utils/el_info_utils.dart';
import 'package:elyra/utils/el_store.dart';
import 'package:elyra/utils/el_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elyra/extend/el_string.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // 延迟 1 秒后执行，防止界面一打开就进行异步操作，给用户一点时间看到 Splash 页面
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 2), () async {
        String? token = SpUtils().getString(ElStoreKeys.token);
        if (!token.isNullString) {
          HttpClient().setAuthToken(token!);

          if (mounted) {
            Navigator.pop(context);
            InfoUtils.pushPage(context, MainPage());
          }
        } else {
          // 如果没有 token，调用注册接口
          await _register();
        }
      });
    });
  }

  _register() async {
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
      SpUtils().setString(ElStoreKeys.token, data.token ?? '');
      HttpClient().setAuthToken(data.token ?? '');

      if (mounted) {
        Navigator.pop(context);
        InfoUtils.pushPage(context, MainPage());
      }
    }
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset('el_logo.png'.icon, height: 95.h),
            SizedBox(height: 12.h),
            Image.asset('el_name.png'.icon, height: 42.h),
            SizedBox(height: 120.h),
          ],
        ),
      ),
    );
  }
}

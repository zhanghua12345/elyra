import 'package:elyra/routers/el_routers.dart';
import 'package:elyra/utils/device_info.dart';
import 'package:elyra/utils/el_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // 竖屏
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
    ),
  );
  await initSDK();
  runApp(const MyApp());
}

initSDK() async {
  await DeviceInfoUtils().init();
  await WakelockPlus.enable();
  await SpUtils().init();
  EasyLoading.init();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      // minTextAdapt: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Elyra',
          navigatorKey: navigatorKey,
          navigatorObservers: [routeObserver],
          getPages: AppRoutes.routes,
          initialRoute: AppRoutes.splash,
          // 注册路由监听器
          debugShowCheckedModeBanner: false,
          locale: Get.deviceLocale,
          // 获取设备语言
          fallbackLocale: const Locale('en', 'US'),
          // 默认语言
          theme: ThemeData(
            primarySwatch: Colors.blue,
            // 设置透明导航栏
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              scrolledUnderElevation: 0,
              systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.transparent),
            ),
          ),
          builder: EasyLoading.init(),
        );
      },
    );
  }
}




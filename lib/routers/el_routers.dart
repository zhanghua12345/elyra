import 'package:elyra/page/main_page.dart';
import 'package:elyra/page/splash_page.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const String splash = '/';
  static const String main = '/main';

  static final routes = [
    GetPage(name: splash, page: () => const SplashPage()),
    GetPage(name: main, page: () => const MainPage()),
  ];
}

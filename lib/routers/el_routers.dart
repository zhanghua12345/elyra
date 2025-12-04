import 'package:elyra/page/main_page.dart';
import 'package:elyra/page/splash_page.dart';
import 'package:elyra/page/el_home/sub_page/vampire/page.dart';
import 'package:elyra/page/el_home/sub_page/search/page.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const String splash = '/';
  static const String main = '/main';
  static const String vampire = '/vampire';
  static const String search = '/search';

  static final routes = [
    GetPage(name: splash, page: () => const SplashPage()),
    GetPage(name: main, page: () => const MainPage()),
    GetPage(name: vampire, page: () => const VampirePage()),
    GetPage(name: search, page: () => const SearchPage()),
  ];
}
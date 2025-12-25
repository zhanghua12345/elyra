import 'package:elyra/page/el_about/page.dart';
import 'package:elyra/page/el_me/sub_page/el_account_logout/page.dart';
import 'package:elyra/page/el_feedback/feedback_detail/page.dart';
import 'package:elyra/page/el_feedback/feedback_index/page.dart';
import 'package:elyra/page/el_feedback/feedback_list/page.dart';
import 'package:elyra/page/el_language/page.dart';
import 'package:elyra/page/el_me/sub_page/history/page.dart';
import 'package:elyra/page/el_play/page.dart';
import 'package:elyra/page/el_me/sub_page/el_setting/page.dart';
import 'package:elyra/page/el_store/page.dart';
import 'package:elyra/page/el_tabbar/page.dart';
import 'package:elyra/page/history/page.dart';
import 'package:elyra/page/splash_page.dart';
import 'package:elyra/page/el_home/sub_page/vampire/page.dart';
import 'package:elyra/page/el_home/sub_page/search/page.dart';
import 'package:elyra/page/el_home/sub_page/search_result/page.dart';
import 'package:elyra/page/test/page.dart';
import 'package:elyra/page/el_web_view/page.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const String splash = '/';
  static const String main = '/main';
  static const String vampire = '/vampire';
  static const String search = '/search';
  static const String searchResult = '/search_result';
  static const String history = '/history';
  static const String language = '/language';
  static const String feedback = '/feedback';
  static const String feedbackList = '/feedback_list';
  static const String feedbackDetail = '/feedback_detail';
  static const String about = '/about';
  static const String setting = '/setting';
  static const String test = '/test';
  static const String playDetail = '/play_detail';
  static const String webView = '/web_view';
  static const String accountLogout = '/account_logout';
  static const String store = '/store';
  static const String myHistory = '/my_history';

  static final routes = [
    GetPage(name: splash, page: () => const SplashPage()),
    GetPage(name: main, page: () => const TabbarPage()),
    GetPage(name: vampire, page: () => const VampirePage()),
    GetPage(name: search, page: () => const SearchPage()),
    GetPage(name: searchResult, page: () => const SearchResultPage()),
    GetPage(name: history, page: () => const HistoryPage()),
    GetPage(name: language, page: () => const LanguagePage()),
    GetPage(name: feedback, page: () => const FeedbackPage()),
    GetPage(name: feedbackList, page: () => const FeedbackListPage()),
    GetPage(name: feedbackDetail, page: () => const FeedbackDetailPage()),
    GetPage(name: about, page: () => const AboutPage()),
    GetPage(name: setting, page: () => const SettingPage()),
    GetPage(name: test, page: () => const TestPage()),
    GetPage(name: playDetail, page: () => const PlayDetailPage()),
    GetPage(name: webView, page: () => const WebViewPage()),
    GetPage(name: accountLogout, page: () => const AccountLogoutPage()),
    GetPage(name: store, page: () => const StorePage()),
    GetPage(name: myHistory, page: () => const MyHistoryPage()),
  ];
}
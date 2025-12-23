
import 'package:elyra/page/LAGuyan.dart';
import 'package:elyra/page/OTJSplash.dart';
import 'package:elyra/page/el_about/GHistory.dart';
import 'package:elyra/page/el_home/sub_page/search/GHistory.dart';
import 'package:elyra/page/el_home/sub_page/search_result/GHistory.dart';
import 'package:elyra/page/el_home/sub_page/vampire/GHistory.dart';
import 'package:elyra/page/el_language/GHistory.dart';
import 'package:elyra/page/el_play/GHistory.dart';
import 'package:elyra/page/el_setting/GHistory.dart';
import 'package:elyra/page/el_web_view/GHistory.dart';
import 'package:elyra/page/history/GHistory.dart';
import 'package:elyra/page/test/GHistory.dart';
import 'package:get/get.dart';

class IDetailGuan {
late bool _canLargeBase = false;
late String _mireoButtonEnd_str;


  static const String splash = '/';
  static const String main = '/main';
  static const String vampire = '/vampire';
  static const String search = '/search';
  static const String searchResult = '/search_result';
  static const String history = '/history';
  static const String language = '/language';
  static const String about = '/about';
  static const String setting = '/setting';
  static const String test = '/test';
  static const String playDetail = '/play_detail';
  static const String webView = '/web_view';

  static final routes = [
    GetPage(name: splash, page: () => const RMRouters()),
    GetPage(name: main, page: () => const EPopupRouters()),
    GetPage(name: vampire, page: () => const RBPRightYear()),
    GetPage(name: search, page: () => const HFSearch()),
    GetPage(name: searchResult, page: () => const LPageLogin()),
    GetPage(name: history, page: () => const VTAbout()),
    GetPage(name: language, page: () => const JRPagePopular()),
    GetPage(name: about, page: () => const TFSearch()),
    GetPage(name: setting, page: () => const QRightUtil()),
    GetPage(name: test, page: () => const CABRight()),
    GetPage(name: playDetail, page: () => const MCDVionLogo()),
    GetPage(name: webView, page: () => const MWGItem()),
  ];
}
import 'package:elyra/page/el_play/sub_page/buy_coins/first_buy.dart';
import 'package:elyra/page/el_play/sub_page/buy_coins/next_buy.dart';
import 'package:get/get.dart';
import 'package:elyra/page/el_home/state.dart';

class HomeController extends GetxController {
  // Your controller code here
  final state = MainState();

  @override
  void onReady() {
    super.onReady();
    NextBuyPopup.show();

  }
}

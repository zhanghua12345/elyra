import 'package:elyra/page/el_me/sub_page/order_recorder/state.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class OrderRecorderPageController extends GetxController {
  final state = OrderRecorderState();
  final RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );

  @override
  void onReady() {
    super.onReady();
    loadData();
  }

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
  }

  void loadData() async {
    // Implement data loading logic here
  }

  void onRefresh() {
    loadData();
    refreshController.refreshCompleted();
  }

  void switchTab(int index) {
    state.tabIndex = index;
    update();
  }
}

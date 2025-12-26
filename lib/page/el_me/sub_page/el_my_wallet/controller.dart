import 'package:elyra/page/el_me/controller.dart';
import 'package:elyra/page/el_me/sub_page/el_my_wallet/state.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyWalletController extends GetxController {
  final state = MyWalletState();
  final RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );

  // 获取 MePageController 实例
  late final MePageController _meController;

  @override
  void onInit() {
    super.onInit();
    // 查找已存在的 MePageController
    _meController = Get.find<MePageController>();
  }

  @override
  void onReady() {
    super.onReady();
    onRefresh();
  }

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
  }

  // 下拉刷新，直接调用 MePageController 的获取用户信息方法
  void onRefresh() async {
    await _meController.getUserInfo();

    // 同步 MePage 的状态到当前页面状态
    state.customerInfo = _meController.state.customerInfo;
    state.loadStatus = _meController.state.loadStatus;

    refreshController.refreshCompleted();
    update();
  }
}

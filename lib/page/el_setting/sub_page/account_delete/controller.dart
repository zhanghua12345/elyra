import 'package:elyra/page/el_setting/sub_page/account_delete/state.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:elyra/widgets/bad_status_widget.dart';

class AccountDeletePageController extends GetxController {
  final state = AccountDeleteState();
  final RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );

  @override
  void onReady() {
    super.onReady();
    // 页面准备完成后执行的操作
    loadData();
  }

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
  }

  // 加载数据的方法
  void loadData() async {
    if (state.isLoading) return;
    state.isLoading = true;
    try {
      // 加载成功
      state.loadStatus = LoadStatusType.loadSuccess;
      update();
    } catch (err) {
      // 错误处理
      state.loadStatus = LoadStatusType.loadFailed;
      update();
    } finally {
      state.isLoading = false;

      // 确保刷新控制器正确完成
      refreshController.refreshCompleted();
      update();
    }
  }

  // 下拉刷新
  void onRefresh() {
    loadData();
  }
}

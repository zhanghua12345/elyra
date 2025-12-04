import 'package:elyra/page/test/state.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:elyra/widgets/bad_status_widget.dart';

class TestController extends GetxController {
  final state = TestState();
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
    if (state.isLoading ) return;
    try {
    state.isLoading = true;

      // 模拟加载数据
      await Future.delayed(Duration(seconds: 2));

      // 加载成功
      state.loadStatus = LoadStatusType.loadSuccess;
      update();
    } catch (err) {
      print('Error mapping items: $err');
    } finally {
      state.isLoading = false;
      refreshController.loadComplete(); // 停止加载更多动画
    }
  }

  // 下拉刷新
  void onRefresh() {
    loadData();
  }
}

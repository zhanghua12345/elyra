import 'package:elyra/page/el_me/sub_page/order_recorder/state.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:elyra/widgets/bad_status_widget.dart';

class OrderRecorderPageController extends GetxController {
  final state = OrderRecorderState();
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
      // 模拟加载数据
      await Future.delayed(const Duration(seconds: 1));

      // 模拟 Mock 数据填充
      if (state.tabIndex == 0) {
        state.coinRecords = [
          {'title': 'Top Up', 'time': '2024-06-10 23:41:18', 'value': '+100'},
          {
            'title': 'Unlock Episode',
            'time': '2024-06-10 21:15:00',
            'value': '-10',
          },
        ];
      } else {
        state.vipRecords = [
          {
            'title': 'Purchase VIP',
            'time': '2024-06-10 23:41:18',
            'value': '+30 days',
          },
          {
            'title': 'VIP Auto Renew',
            'time': '2024-06-10 23:41:18',
            'value': '+30 days',
          },
          {
            'title': 'Purchase VIP',
            'time': '2024-06-10 23:41:18',
            'value': '+7 days',
          },
        ];
      }

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

  // 切换 Tab
  void switchTab(int index) {
    if (state.tabIndex == index) return;
    state.tabIndex = index;
    state.loadStatus = LoadStatusType.loading;
    update();
    loadData();
  }
}

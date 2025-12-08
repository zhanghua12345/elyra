import 'package:elyra/bean/user_info.dart';
import 'package:elyra/page/el_me/state.dart';
import 'package:elyra/request/http.dart';
import 'package:elyra/request/index.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:elyra/widgets/bad_status_widget.dart';

class MyPageController extends GetxController {
  final state = MyState();
  final RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );

  @override
  void onReady() {
    super.onReady();
    // 页面准备完成后执行的操作
    getUserInfo();

  }

  getUserInfo() async {
    try {
      ApiResponse response = await HttpClient().request(Apis.customerInfo, method: HttpMethod.get);
      refreshController.refreshCompleted();

      if (response.success) {
        state.customerInfo = UserInfo.fromJson(response.data);
        update();
      }
    } catch (e) {
      refreshController.refreshCompleted();
    }
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
      await Future.delayed(Duration(seconds: 2));

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

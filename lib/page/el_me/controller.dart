import 'package:elyra/bean/user_info.dart';
import 'package:elyra/page/el_me/state.dart';
import 'package:elyra/request/http.dart';
import 'package:elyra/request/index.dart';
import 'package:elyra/widgets/bad_status_widget.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MePageController extends GetxController {
  final state = MePageState();
  final RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );

  @override
  void onReady() {
    super.onReady();
    getUserInfo();
  }

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
  }

  /// 获取用户信息
  Future<void> getUserInfo() async {
    try {
      state.loadStatus = LoadStatusType.loading;
      update();

      ApiResponse response = await HttpClient().request(
        Apis.customerInfo,
        method: HttpMethod.get,
      );

      if (response.success) {
        state.customerInfo = UserInfo.fromJson(response.data);
        state.loadStatus = LoadStatusType.loadSuccess;
      } else {
        state.loadStatus = LoadStatusType.loadFailed;
      }
    } catch (e) {
      state.loadStatus = LoadStatusType.loadFailed;
    } finally {
      // 确保刷新控制器正确完成
      refreshController.refreshCompleted();
      update();
    }
  }

  /// 刷新
  void onRefresh() {
    getUserInfo();
  }
}

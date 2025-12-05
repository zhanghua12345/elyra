import 'package:elyra/page/el_home/sub_page/search_result/state.dart';
import 'package:elyra/request/http.dart';
import 'package:elyra/request/index.dart';
import 'package:elyra/widgets/bad_status_widget.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:elyra/bean/short_video_bean.dart';

class SearchResultPageController extends GetxController {
  final state = SearchResultState();
  final RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );

  @override
  void onInit() {
    super.onInit();
    // 获取传递的参数
    var arguments = Get.arguments ?? {};
    state.searchKeyword = arguments['search'] ?? '';
  }

  @override
  void onReady() {
    super.onReady();
    getVampireData();
  }

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
  }

  getVampireData({RefreshController? refreshCtrl}) async {
    // 如果正在加载，或者加载更多时没有更多数据，则直接返回
    if (state.isLoading) return;

    state.isLoading = true;
    update();
    try {
      // 构造请求参数
      Map<String, dynamic> params = {'search': state.searchKeyword};

      ApiResponse response = await HttpClient().request(
        Apis.search, // 使用新的API接口
        method: HttpMethod.get,
        queryParameters: params,
      );

      if (refreshCtrl != null) {
        refreshCtrl.refreshCompleted();
      } else {
        refreshController.refreshCompleted();
      }

      if (response.success) {
        // 刷新数据
        state.searchResultList.clear();

        if (response.data['list'] != null && response.data['list'].length > 0) {
          try {
            List<ShortVideoBean> newItems = response.data['list']
                .map<ShortVideoBean>((item) => ShortVideoBean.fromJson(item))
                .toList();
            state.searchResultList = newItems;

            state.loadStatus = LoadStatusType.loadSuccess;
          } catch (e) {
            print('Error mapping items: $e');
            state.loadStatus = LoadStatusType.loadFailed;
          }
        } else {
          state.loadStatus = LoadStatusType.loadNoData;
        }
        update();
      } else {
        state.loadStatus = LoadStatusType.loadFailed;
        update();
      }
    } catch (e) {
      if (refreshCtrl != null) {
        refreshCtrl.refreshFailed();
      } else {
        refreshController.refreshFailed();
      }
      state.loadStatus = LoadStatusType.loadFailed;
      update();
    } finally {
      state.isLoading = false;
      if (refreshCtrl == null) {
        refreshController.loadComplete(); // 停止加载更多动画
      }
    }
  }

  void onRefresh() {
    getVampireData();
  }
}

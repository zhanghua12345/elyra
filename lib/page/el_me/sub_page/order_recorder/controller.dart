import 'package:elyra/bean/order_record_bean.dart';
import 'package:elyra/page/el_me/sub_page/order_recorder/state.dart';
import 'package:elyra/request/http.dart';
import 'package:elyra/request/index.dart';
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
    getOrderData();
  }

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
  }

  getOrderData({RefreshController? refreshCtrl, bool loadMore = false}) async {
    // 如果正在加载，或者加载更多时没有更多数据，则直接返回
    if (state.isLoading || (loadMore && !state.hasMore)) return;

    // 更新状态
    if (!loadMore) {
      state.loadStatus = LoadStatusType.loading;
    }
    state.isLoading = true;
    update();
    try {
      // 0: Coin Record -> 'coins', 1: VIP Record -> 'vip'
      String buyType = state.tabIndex == 0 ? 'coins' : 'vip';

      // 构造请求参数
      Map<String, dynamic> params = {
        'current_page': loadMore ? state.currentPage + 1 : 1,
        'page_size': state.pageSize,
        'buy_type': buyType,
      };

      ApiResponse response = await HttpClient().request(
        Apis.purchaseList,
        method: HttpMethod.get,
        queryParameters: params,
      );

      final rCtrl = refreshCtrl ?? refreshController;

      if (response.success) {
        // 解析分页信息
        var pagination = response.data['pagination'];
        state.currentPage = pagination['current_page'] ?? 1;
        state.totalPages = pagination['page_total'] ?? 0;
        state.hasMore = state.currentPage < state.totalPages;

        List<dynamic> listData = response.data['list'] ?? [];
        List<OrderRecordBean> newItems = listData
            .map<OrderRecordBean>((item) => OrderRecordBean.fromJson(item))
            .toList();

        if (loadMore) {
          if (state.tabIndex == 0) {
            state.coinRecords.addAll(newItems);
          } else {
            state.vipRecords.addAll(newItems);
          }
          rCtrl.loadComplete();
        } else {
          if (state.tabIndex == 0) {
            state.coinRecords = newItems;
          } else {
            state.vipRecords = newItems;
          }
          rCtrl.refreshCompleted();
          state.loadStatus = state.currentList.isEmpty
              ? LoadStatusType.loadNoData
              : LoadStatusType.loadSuccess;
        }

        if (!state.hasMore) {
          rCtrl.loadNoData();
        }
      } else {
        if (loadMore) {
          rCtrl.loadFailed();
        } else {
          rCtrl.refreshFailed();
          state.loadStatus = LoadStatusType.loadFailed;
        }
      }
      update();
    } catch (e) {
      final rCtrl = refreshCtrl ?? refreshController;
      if (loadMore) {
        rCtrl.loadFailed();
      } else {
        rCtrl.refreshFailed();
        state.loadStatus = LoadStatusType.loadFailed;
      }
      update();
    } finally {
      state.isLoading = false;
      update();
    }
  }

  void onRefresh() {
    getOrderData();
  }

  void onLoadMore() {
    if (state.hasMore) {
      getOrderData(loadMore: true);
    } else {
      refreshController.loadNoData();
    }
  }

  // 切换 Tab
  void switchTab(int index) {
    if (state.tabIndex == index) return;
    state.tabIndex = index;
    state.loadStatus = LoadStatusType.loading;
    update();
    getOrderData();
  }
}

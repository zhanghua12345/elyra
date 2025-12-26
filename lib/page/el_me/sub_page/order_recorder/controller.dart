import 'package:elyra/bean/order_record_bean.dart';
import 'package:elyra/page/el_me/sub_page/order_recorder/state.dart';
import 'package:elyra/request/http.dart';
import 'package:elyra/request/index.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:elyra/widgets/bad_status_widget.dart';

class OrderRecorderController extends GetxController {
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

      if (refreshCtrl != null) {
        refreshCtrl.refreshCompleted();
      } else {
        refreshController.refreshCompleted();
      }

      if (refreshCtrl != null) {
        refreshCtrl.refreshCompleted();
      } else {
        refreshController.refreshCompleted();
      }

      if (response.success) {
        // 解析分页信息
        var pagination = response.data['pagination'];
        state.currentPage = pagination['current_page'] ?? 1;
        state.totalPages = pagination['page_total'] ?? 0;
        state.hasMore = state.currentPage < state.totalPages;

        if (loadMore) {
          // 加载更多数据
          if (response.data['list'] != null &&
              response.data['list'].length > 0) {
            try {
              List<OrderRecordBean> newItems = response.data['list']
                  .map<OrderRecordBean>(
                    (item) => OrderRecordBean.fromJson(item),
                  )
                  .toList();

              state.recordsList.addAll(newItems);
            } catch (e) {
              print('Error mapping new items: $e');
              // 如果解析失败，我们仍然更新状态以停止加载
              state.loadStatus = LoadStatusType.loadFailed;
            }
          }
        } else {
          // 刷新数据
          state.recordsList.clear();

          if (response.data['list'] != null &&
              response.data['list'].length > 0) {
            try {
              List<OrderRecordBean> newItems = response.data['list']
                  .map<OrderRecordBean>(
                    (item) => OrderRecordBean.fromJson(item),
                  )
                  .toList();
              state.recordsList = newItems;
              state.loadStatus = LoadStatusType.loadSuccess;
            } catch (e) {
              print('Error mapping items: $e');
              state.loadStatus = LoadStatusType.loadFailed;
            }
          } else {
            state.loadStatus = LoadStatusType.loadNoData;
          }
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
    getOrderData();
  }

  void onLoadMore() {
    if (state.hasMore) {
      getOrderData(loadMore: true);
    } else {
      refreshController.loadNoData(); // 没有更多数据
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

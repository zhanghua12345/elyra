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
    loadData();
  }

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
  }

  // 加载数据的方法
  Future<void> loadData({bool isRefresh = true}) async {
    if (state.isLoading) return;

    if (isRefresh) {
      state.currentPage = 1;
      state.hasMore = true;
    }

    state.isLoading = true;
    try {
      // 0: Coin Record -> 'coins', 1: VIP Record -> 'vip'
      String buyType = state.tabIndex == 0 ? 'coins' : 'vip';

      final response = await HttpClient().request(
        Apis.purchaseList,
        method: HttpMethod.get,
        queryParameters: {
          "current_page": state.currentPage,
          "page_size": state.pageSize,
          "buy_type": buyType,
        },
      );

      if (response.success && response.data != null) {
        final recordBean = OrderRecordBean.fromJson(response.data);
        final list = recordBean.list ?? [];

        if (isRefresh) {
          if (state.tabIndex == 0) {
            state.coinRecords = list;
          } else {
            state.vipRecords = list;
          }
        } else {
          if (state.tabIndex == 0) {
            state.coinRecords.addAll(list);
          } else {
            state.vipRecords.addAll(list);
          }
        }

        // 判断是否还有更多数据
        state.hasMore = list.length >= state.pageSize;
        state.currentPage++;

        state.loadStatus = state.currentList.isEmpty
            ? LoadStatusType.loadNoData
            : LoadStatusType.loadSuccess;
      } else {
        if (isRefresh) {
          state.loadStatus = LoadStatusType.loadFailed;
        }
      }
      update();
    } catch (err) {
      if (isRefresh) {
        state.loadStatus = LoadStatusType.loadFailed;
      }
      update();
    } finally {
      state.isLoading = false;
      if (isRefresh) {
        refreshController.refreshCompleted();
      } else {
        if (state.hasMore) {
          refreshController.loadComplete();
        } else {
          refreshController.loadNoData();
        }
      }
      update();
    }
  }

  // 下拉刷新
  void onRefresh() {
    loadData(isRefresh: true);
  }

  // 上拉加载更多
  void onLoadMore() {
    if (state.hasMore) {
      loadData(isRefresh: false);
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
    loadData(isRefresh: true);
  }
}

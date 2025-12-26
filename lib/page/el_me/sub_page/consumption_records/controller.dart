import 'package:elyra/bean/consumption_record_bean.dart';
import 'package:elyra/page/el_me/sub_page/consumption_records/state.dart';
import 'package:elyra/request/http.dart';
import 'package:elyra/request/index.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:elyra/widgets/bad_status_widget.dart';

class ConsumptionRecordsController extends GetxController {
  final state = ConsumptionRecordsState();
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
      final response = await HttpClient().request(
        Apis.consumptionList,
        method: HttpMethod.get,
        queryParameters: {
          "current_page": state.currentPage,
          "page_size": state.pageSize,
        },
      );

      if (response.success && response.data != null) {
        final recordBean = ConsumptionRecordBean.fromJson(response.data);
        final list = recordBean.list ?? [];

        if (isRefresh) {
          state.consumptionList = list;
        } else {
          state.consumptionList.addAll(list);
        }

        // 判断是否还有更多数据
        state.hasMore = list.length >= state.pageSize;
        state.currentPage++;

        state.loadStatus = state.consumptionList.isEmpty
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
}

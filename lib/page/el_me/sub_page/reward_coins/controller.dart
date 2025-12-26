import 'package:elyra/bean/reward_coin_bean.dart';
import 'package:elyra/page/el_me/sub_page/reward_coins/state.dart';
import 'package:elyra/request/http.dart';
import 'package:elyra/request/index.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:elyra/widgets/bad_status_widget.dart';

class RewardCoinsController extends GetxController {
  final state = RewardCoinsState();
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
      state.loadStatus = LoadStatusType.loading;
      update();
      await Future.delayed(Duration(milliseconds: 500));
    }

    state.isLoading = true;
    try {
      final response = await HttpClient().request(
        Apis.sendCoinList,
        method: HttpMethod.post,
        data: {"current_page": state.currentPage, "page_size": state.pageSize},
      );

      if (response.success && response.data != null) {
        final rewardBean = RewardCoinBean.fromJson(response.data);
        final list = rewardBean.list ?? [];

        if (isRefresh) {
          state.rewardList = list;
        } else {
          state.rewardList.addAll(list);
        }

        // 判断是否还有更多数据
        state.hasMore = list.length >= state.pageSize;
        state.currentPage++;

        state.loadStatus = state.rewardList.isEmpty
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

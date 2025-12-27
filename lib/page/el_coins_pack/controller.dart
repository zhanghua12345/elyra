import 'dart:io';
import 'package:elyra/bean/pay_settings_bean.dart';
import 'package:elyra/bean/reward_overview_bean.dart';
import 'package:elyra/page/el_coins_pack/state.dart';
import 'package:elyra/request/http.dart';
import 'package:elyra/request/index.dart';
import 'package:elyra/utils/toast.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:elyra/widgets/bad_status_widget.dart';

class ElCoinsPackController extends GetxController {
  final state = ElCoinsPackState();
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
  void loadData() async {
    if (state.isLoading) return;
    state.isLoading = true;
    state.loadStatus = LoadStatusType.loading;
    update();

    try {
      // 获取领取详情 (REWARDS OVERVIEW + receive_list)
      final rewardRes = await HttpClient().request(
        Apis.getReceiveDayCoinInfo,
        method: HttpMethod.get,
      );

      if (rewardRes.success && rewardRes.data != null) {
        state.coinInfo = RewardOverviewBean.fromJson(rewardRes.data);
        state.receiveList = state.coinInfo?.receiveList ?? [];

        // 映射核心字段
        state.weeklyTotal = state.coinInfo?.weeklyTotalCoins ?? 0;
        state.claimableCoins = state.coinInfo?.dayCoins ?? 0;
        state.activeRefills = state.coinInfo?.count ?? 0;
      }

      state.loadStatus = LoadStatusType.loadSuccess;
    } catch (err) {
      debugPrint('ElCoinsPackController loadData Error: $err');
      state.loadStatus = LoadStatusType.loadFailed;
    } finally {
      state.isLoading = false;
      refreshController.refreshCompleted();
      update();
    }
  }

  /// 领取金币逻辑 (id 可以是具体条目 ID 或 'all')
  Future<void> receiveDay(String id) async {
    try {
      final res = await HttpClient().request(
        Apis.receiveDayCoin,
        method: HttpMethod.post,
        data: {"id": id},
      );

      if (res.success) {
        Message.show(res.message ?? "Claimed successfully");
        loadData(); // 领取成功后刷新页面数据
      } else {
        Message.show(res.message ?? "Claim failed");
      }
    } catch (e) {
      debugPrint("receiveDay error: $e");
      Message.show("Claim failed");
    }
  }

  // 下拉刷新
  void onRefresh() {
    loadData();
  }
}

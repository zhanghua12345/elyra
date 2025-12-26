import 'dart:io';
import 'package:elyra/bean/pay_settings_bean.dart';
import 'package:elyra/page/el_coins_pack/state.dart';
import 'package:elyra/request/http.dart';
import 'package:elyra/request/index.dart';
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
      // 1. 获取支付配置 (用于展示 coinsWeekList)
      Map<String, dynamic> payParams = {};
      if (Platform.isIOS) {
        try {
        } catch (e) {
          debugPrint('---receipt err:$e');
        }
      }

      final payRes = await HttpClient().request(
        Apis.paySettingsV4,
        data: payParams,
        method: HttpMethod.post,
      );

      if (payRes.success && payRes.data != null) {
        final paySettings = PaySettingsBean.fromJson(payRes.data);
        final allItems = [...paySettings.listCoins, ...paySettings.listSubVip];

        // 过滤周包金币 (sub_coins)
        state.coinsWeekList = allItems
            .where((item) => item.buyType == 'sub_coins')
            .toList();
        state.coinsWeekList.sort((a, b) => b.sort.compareTo(a.sort));
      }

      // 2. 获取领取详情 (REWARDS OVERVIEW)
      final rewardRes = await HttpClient().request(
        Apis.getReceiveDayCoinInfo,
        method: HttpMethod.get,
      );

      if (rewardRes.success && rewardRes.data != null) {
        var data = rewardRes.data;
        // 映射字段：每周总额，可领取，激活数
        state.weeklyTotal = data['weekly_total_coins'] ?? 0;
        state.claimableCoins = data['day_coins'] ?? 0;
        state.activeRefills = data['count'] ?? 0;
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

  // 下拉刷新
  void onRefresh() {
    loadData();
  }
}

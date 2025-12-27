import 'package:elyra/bean/pay_settings_bean.dart';
import 'package:elyra/bean/reward_overview_bean.dart';
import 'package:elyra/widgets/bad_status_widget.dart';

class ElCoinsPackState {
  ElCoinsPackState();

  LoadStatusType loadStatus = LoadStatusType.loading;
  bool isLoading = false;

  // 奖励概览数据
  num weeklyTotal = 0;
  num claimableCoins = 0;
  num activeRefills = 0;

  // 奖励详情/签到详情
  RewardOverviewBean? coinInfo;
  List<RewardReceiveItem> receiveList = [];

  // 周包金币列表
  List<PayItem> coinsWeekList = [];
}

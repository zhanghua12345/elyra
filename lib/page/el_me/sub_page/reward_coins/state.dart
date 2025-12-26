import 'package:elyra/bean/reward_coin_bean.dart';
import 'package:elyra/widgets/bad_status_widget.dart';

class RewardCoinsState {
  RewardCoinsState();

  LoadStatusType loadStatus = LoadStatusType.loading;
  bool isLoading = false;

  // 分页信息
  int currentPage = 1;
  int pageSize = 20;
  bool hasMore = true;

  // 奖励金币数据列表
  List<RewardCoinItem> rewardList = [];
}

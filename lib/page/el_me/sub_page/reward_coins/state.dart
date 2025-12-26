import 'package:elyra/bean/reward_coin_bean.dart';
import 'package:elyra/widgets/bad_status_widget.dart';

class RewardCoinsState {
  RewardCoinsState();

  LoadStatusType loadStatus = LoadStatusType.loading;
  // 奖励金币数据列表
  List<RewardCoinItem> rewardList = [];

  // 分页参数
  int currentPage = 1;
  int pageSize = 20;
  int totalPages = 0;
  bool isLoading = false;
  bool hasMore = true;
}

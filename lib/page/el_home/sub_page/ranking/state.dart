import 'package:elyra/bean/short_video_bean.dart';
import 'package:elyra/widgets/bad_status_widget.dart';

class RankingState {
  RankingState();

  LoadStatusType loadStatus = LoadStatusType.loading;
  List<ShortVideoBean> rankingList = [];
}

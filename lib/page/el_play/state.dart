import 'package:elyra/bean/short_play_detail_bean.dart';
import 'package:elyra/bean/short_video_bean.dart';
import 'package:elyra/widgets/bad_status_widget.dart';

class PlayDetailState {
  PlayDetailState();

  LoadStatusType loadStatus = LoadStatusType.loading;
  
  // 短剧ID和视频ID
  num shortPlayId = -1;
  num videoId = 0;
  num? activityId;
  
  // 视频详情数据
  ShortPlayDetailBean? detailBean;
  List<EpisodeList> episodeList = [];
  
  // 当前播放信息
  int currentEpisode = 0; // 当前集数索引
  
  // 播放设置
  double curSpeed = 1.0;
  final List<double> speeds = [0.75, 1.0, 1.25, 1.5, 2.0, 3.0];
  
  // 背景图片
  String imageUrl = '';
  
  // 推荐列表
  List<ShortVideoBean> recommendList = [];
  int recommendIndex = 0;
}
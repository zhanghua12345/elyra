import 'dart:async';

import 'package:pandaroll/bean/resolution_bean.dart';
import 'package:pandaroll/bean/short_play_detail_bean.dart';
import 'package:pandaroll/bean/short_video_bean.dart';

import '../../bean/store_bean.dart';

class ShortVideoState {
  ShortVideoState();

  num shortPlayId = -1;
  num videoId = -1;
  num? activityId;
  int revolution = 540;
  num curRev = 720;
  int curUnlock = 999;
  int currentSubCoinIndex = 0;
  StoreBean? storeBean;
  ShortPlayDetailBean? detailBean;
  List<EpisodeList> episodeList = [];

  double curSpeed = 1.0;
  final List<double> speeds = [0.75, 1.0, 1.25, 1.5, 2.0, 3.0];
  List<ResolutionBean> resolutionList = [];
  List<ShortVideoBean> recommendList = [];
  int recommendIndex = 0;

  String imageUrl = '';
  bool isFromRecommend = false;
  Timer? toolMuskTimer;
  bool toolMuskStatus = true;
}

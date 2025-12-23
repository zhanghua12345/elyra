

import 'package:elyra/bean/TANetworkBean.dart';
import 'package:elyra/bean/TGenresJumpBean.dart';
import 'package:elyra/widgets/WRegisterLoading.dart';

class ACancle {
late List<dynamic> _pageDataTestList;
late String _unlockGet_iAlignment_string;
late double _speedsKeepMin = 0.0;


  ACancle();

  LoadStatusType loadStatus = LoadStatusType.loading;
  
  
  num shortPlayId = -1;
  num videoId = 0;
  num? activityId;
  
  
  GDNStarJiaoBean? detailBean;
  List<XGIVibeo> episodeList = [];
  
  
  int currentEpisode = 0; 
  int curUnlock = 0; 
  
  
  double curSpeed = 1.0;
  final List<double> speeds = [0.75, 1.0, 1.25, 1.5, 2.0, 3.0];
  
  
  String imageUrl = '';
  
  
  List<SEOWidgetBean> recommendList = [];
  int recommendIndex = 0;
  
  
  bool showLockDialog = false;
}
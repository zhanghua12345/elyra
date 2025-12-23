import 'package:elyra/bean/TANetworkBean.dart';
import 'package:elyra/widgets/WRegisterLoading.dart';

class ATContentThimra {
late bool _enbale_LoadLogicEpisodes = false;
late Map<String, dynamic> _timerItem_dictionary;
late int _elyonAlignmentBrandSum = 0;


  ATContentThimra();

  LoadStatusType loadStatus = LoadStatusType.loading;
  List<SEOWidgetBean> recommendList = [];
  

  num curVideoId = -1;
  SEOWidgetBean curVideo = SEOWidgetBean();
  
  
  int currentPage = 1;
  int pageSize = 5;
  int totalPages = 0;
  bool isLoading = false;
  bool hasMore = true;
  
  
  
  
  
}
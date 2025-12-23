
import 'package:elyra/bean/TANetworkBean.dart';
import 'package:elyra/widgets/WRegisterLoading.dart';

class HMRSettingPack {
late String _emailStorageNum_str;
late int _ettingCount_index = 0;
late int _iconDramaZone_flag = 0;
late String _pluginRankingGiving_string;


  HMRSettingPack();

  LoadStatusType loadStatus = LoadStatusType.loading;
  List<SEOWidgetBean> historyList = [];
  
  
  int currentPage = 1;
  int pageSize = 20;
  int totalPages = 0;
  bool isLoading = false;
  bool hasMore = true;
}

import 'package:elyra/bean/TANetworkBean.dart';
import 'package:elyra/widgets/WRegisterLoading.dart';

class JEGFire {
late int _cancleTextFunctionMark = 0;
late List<dynamic> _ratePromiseTabletArray;


  JEGFire();

  LoadStatusType loadStatus = LoadStatusType.loading;
  bool isLoading = false;
  
  
  List<String> searchHistoryList = [];
  
  
  List<SEOWidgetBean> hotSearchList = [];
  
  
  bool showSearchHistory = false;
}
import 'package:elyra/bean/TANetworkBean.dart';
import 'package:elyra/widgets/WRegisterLoading.dart';
class ONLogoPlay {
late int _registeredGoldPriceCount = 0;
late Map<String, dynamic> _unechoAlignmentCountDictionary;
late Map<String, dynamic> _receiveCategory_urBack_dictionary;


  ONLogoPlay();

  LoadStatusType loadStatus = LoadStatusType.loading;
  List<SEOWidgetBean> searchResultList = [];
  
  
  String searchKeyword = "";
  bool isLoading = false;
}
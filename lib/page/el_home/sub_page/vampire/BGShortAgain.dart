import 'package:elyra/bean/TANetworkBean.dart';
import 'package:elyra/widgets/WRegisterLoading.dart';

class MMonthInfo {
late String _agreementExt_string;
late List<dynamic> _gradientTimeoutTagList;
late List<dynamic> _heightThird_list;


  MMonthInfo();

  LoadStatusType loadStatus = LoadStatusType.loading;
  List<SEOWidgetBean> vampireList = [];
  
  
  int currentPage = 1;
  int pageSize = 20;
  int totalPages = 0;
  bool isLoading = false;
  bool hasMore = true;
  
  
  int categoryId = 0;
  String categoryTitle = "";
}
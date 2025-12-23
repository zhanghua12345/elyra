import 'package:elyra/bean/TANetworkBean.dart';
import 'package:elyra/widgets/WRegisterLoading.dart';

class MYElyon {
late double _networkInterfaceStreamMax = 0.0;
late List<dynamic> _modityPaint_Array;
late List<dynamic> _refreshModeWeek_list;
late int _canclePath_index = 0;


  MYElyon();

  LoadStatusType loadStatus = LoadStatusType.loading;
  List<SEOWidgetBean> collectList = [];
  
  
  int currentPage = 1;
  int pageSize = 20;
  int totalPages = 0;
  bool isLoading = false;
  bool hasMore = true;
  bool isEdit = false;

}
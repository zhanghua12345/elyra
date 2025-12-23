import 'package:elyra/bean/TANetworkBean.dart';
import 'package:elyra/widgets/WRegisterLoading.dart';

class ZQFSelect {
late double _modelAboutOffset = 0.0;
late bool _is_SearchDiscount = false;
late bool _isPathHistoryDesc = false;
late double _visibleDismiss_padding = 0.0;


  ZQFSelect();

  LoadStatusType loadStatus = LoadStatusType.loading;
  List<SEOWidgetBean> bannerList = [];
  List<SEOWidgetBean> popularWeekList = [];
  List<SEOWidgetBean> trendingList = [];
  List<SEOWidgetBean> collectionsList = [];
  
}

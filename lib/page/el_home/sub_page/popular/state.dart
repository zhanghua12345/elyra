import 'package:elyra/bean/short_video_bean.dart';
import 'package:elyra/widgets/bad_status_widget.dart';

class PopularState {
  PopularState();

  LoadStatusType loadStatus = LoadStatusType.loading;
  List<ShortVideoBean> bannerList = [];
  List<ShortVideoBean> popularWeekList = [];
  List<ShortVideoBean> trendingList = [];
  List<ShortVideoBean> collectionsList = [];
  
}

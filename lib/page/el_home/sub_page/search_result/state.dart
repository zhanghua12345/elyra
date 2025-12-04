import 'package:elyra/bean/short_video_bean.dart';
import 'package:elyra/widgets/bad_status_widget.dart';

class SearchResultState {
  SearchResultState();

  LoadStatusType loadStatus = LoadStatusType.loading;
  List<ShortVideoBean> searchResultList = [];
  
  // 搜索相关
  String searchKeyword = "";
  bool isLoading = false;
}
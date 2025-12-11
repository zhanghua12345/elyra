import 'package:elyra/bean/short_video_bean.dart';
import 'package:elyra/widgets/bad_status_widget.dart';

class SearchState {
  SearchState();

  LoadStatusType loadStatus = LoadStatusType.loading;
  bool isLoading = false;
  
  // 搜索历史记录
  List<String> searchHistoryList = [];
  
  // 热门搜索数据
  List<ShortVideoBean> hotSearchList = [];
  
  // 是否显示搜索历史
  bool showSearchHistory = false;
}
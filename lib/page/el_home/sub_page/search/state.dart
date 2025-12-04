import 'package:elyra/widgets/bad_status_widget.dart';
import 'package:elyra/bean/hot_search_bean.dart';

class SearchState {
  SearchState();

  LoadStatusType loadStatus = LoadStatusType.loading;
  bool isLoading = false;
  
  // 搜索历史记录
  List<String> searchHistoryList = [];
  
  // 热门搜索数据
  List<HotSearchBean> hotSearchList = [];
  
  // 是否显示搜索历史
  bool showSearchHistory = false;
}
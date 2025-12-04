import 'package:elyra/bean/short_video_bean.dart';
import 'package:elyra/widgets/bad_status_widget.dart';

class SearchResultState {
  SearchResultState();

  LoadStatusType loadStatus = LoadStatusType.loading;
  List<ShortVideoBean> searchResultList = [];
  
  // 分页参数
  int currentPage = 1;
  int pageSize = 20;
  int totalPages = 0;
  bool isLoading = false;
  bool hasMore = true;
  
  // 分类信息
  int categoryId = 0;
  String categoryTitle = "";
}
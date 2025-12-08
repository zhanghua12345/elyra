import 'package:elyra/bean/short_video_bean.dart';
import 'package:elyra/widgets/bad_status_widget.dart';

class RecommendState {
  RecommendState();

  LoadStatusType loadStatus = LoadStatusType.loading;
  List<ShortVideoBean> recommendList = [];
  

  num curVideoId = -1;
  ShortVideoBean curVideo = ShortVideoBean();
  
  // 分页参数
  int currentPage = 1;
  int pageSize = 5;
  int totalPages = 0;
  bool isLoading = false;
  bool hasMore = true;
  // 添加你需要的其他状态变量
  // 示例：
  // List<YourModel> dataList = [];
  // int currentPage = 1;
  // bool hasMore = true;
}
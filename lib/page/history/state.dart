import 'package:elyra/bean/short_video_bean.dart';
import 'package:elyra/widgets/bad_status_widget.dart';

class HistoryState {
  HistoryState();

  LoadStatusType loadStatus = LoadStatusType.loading;
  List<ShortVideoBean> historyList = [];
  
  // 分页参数
  int currentPage = 1;
  int pageSize = 20;
  int totalPages = 0;
  bool isLoading = false;
  bool hasMore = true;
}

import 'package:elyra/widgets/bad_status_widget.dart';

class OrderRecorderState {
  OrderRecorderState();

  LoadStatusType loadStatus = LoadStatusType.loading;
  bool isLoading = false;

  // 0: Coin Record, 1: VIP Record
  int tabIndex = 0;

  // 添加你需要的其他状态变量
  List<Map<String, dynamic>> coinRecords = [];
  List<Map<String, dynamic>> vipRecords = [];

  // 示例：用于分页
  // int currentPage = 1;
  // bool hasMore = true;
}

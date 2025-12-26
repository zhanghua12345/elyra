import 'package:elyra/bean/order_record_bean.dart';
import 'package:elyra/widgets/bad_status_widget.dart';

class OrderRecorderState {
  OrderRecorderState();

  LoadStatusType loadStatus = LoadStatusType.loading;
  bool isLoading = false;

  // 0: Coin Record (coins), 1: VIP Record (vip)
  int tabIndex = 0;

  // 分页信息
  int currentPage = 1;
  int pageSize = 20;
  bool hasMore = true;

  // 订单记录数据列表
  List<OrderRecordItem> coinRecords = [];
  List<OrderRecordItem> vipRecords = [];

  // 获取当前Tab对应的列表
  List<OrderRecordItem> get currentList =>
      tabIndex == 0 ? coinRecords : vipRecords;
}

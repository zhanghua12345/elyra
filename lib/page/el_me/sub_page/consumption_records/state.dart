import 'package:elyra/bean/consumption_record_bean.dart';
import 'package:elyra/widgets/bad_status_widget.dart';

class ConsumptionRecordsState {
  ConsumptionRecordsState();

  LoadStatusType loadStatus = LoadStatusType.loading;
  // 消费记录数据列表
  List<ConsumptionRecordBean> consumptionList = [];

  // 分页参数
  int currentPage = 1;
  int pageSize = 20;
  int totalPages = 0;
  bool isLoading = false;
  bool hasMore = true;
}

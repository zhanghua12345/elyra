import 'package:elyra/bean/consumption_record_bean.dart';
import 'package:elyra/widgets/bad_status_widget.dart';

class ConsumptionRecordsState {
  ConsumptionRecordsState();

  LoadStatusType loadStatus = LoadStatusType.loading;
  bool isLoading = false;

  // 分页信息
  int currentPage = 1;
  int pageSize = 20;
  bool hasMore = true;

  // 消费记录数据列表
  List<ConsumptionRecordItem> consumptionList = [];
}

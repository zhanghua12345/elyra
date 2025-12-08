import 'package:elyra/bean/user_info.dart';
import 'package:elyra/widgets/bad_status_widget.dart';

class MyState {
  MyState();

  LoadStatusType loadStatus = LoadStatusType.loading;
  bool isLoading = false;
  UserInfo customerInfo = UserInfo();
  // 添加你需要的其他状态变量
  // 示例：
  // List<YourModel> dataList = [];
  // int currentPage = 1;
  // bool hasMore = true;
}
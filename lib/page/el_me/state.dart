import 'package:elyra/bean/user_info.dart';
import 'package:elyra/widgets/bad_status_widget.dart';

class MePageState {
  MePageState();

  LoadStatusType loadStatus = LoadStatusType.loading;
  UserInfo? customerInfo;
}
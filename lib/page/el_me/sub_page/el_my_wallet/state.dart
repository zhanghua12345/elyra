import 'package:elyra/bean/user_info.dart';
import 'package:elyra/widgets/bad_status_widget.dart';

class MyWalletState {
  MyWalletState();

  LoadStatusType loadStatus = LoadStatusType.loading;
  bool isLoading = false;
  UserInfo? customerInfo;
}

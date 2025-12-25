import 'package:elyra/widgets/bad_status_widget.dart';

class ElCoinsPackState {
  ElCoinsPackState();

  LoadStatusType loadStatus = LoadStatusType.loading;
  bool isLoading = false;

  // Weekly total and claimable coins
  int weeklyTotal = 0;
  int claimableCoins = 0;
  int activeRefills = 0;

  // You can add list of refill packages here once the model is defined
}

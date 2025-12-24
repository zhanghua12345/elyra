import 'package:elyra/widgets/bad_status_widget.dart';

class MyHistoryPageState {
  LoadStatusType loadStatus = LoadStatusType.loadSuccess;
  bool isLoading = false;
  
  // 0: Coin Record, 1: VIP Record
  int tabIndex = 0;

  // Mock data for demo
  List<Map<String, dynamic>> coinRecords = [
    {'title': 'Top Up', 'time': '2024-06-10 23:41:18', 'value': '+100'},
    {'title': 'Unlock Episode', 'time': '2024-06-10 21:15:00', 'value': '-10'},
  ];

  List<Map<String, dynamic>> vipRecords = [
    {'title': 'Purchase VIP', 'time': '2024-06-10 23:41:18', 'value': '+30 days'},
    {'title': 'VIP Auto Renew', 'time': '2024-06-10 23:41:18', 'value': '+30 days'},
    {'title': 'Purchase VIP', 'time': '2024-06-10 23:41:18', 'value': '+7 days'},
  ];
}

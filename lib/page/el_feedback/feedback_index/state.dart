import 'package:elyra/widgets/bad_status_widget.dart';

class FeedbackState {
  FeedbackState();

  LoadStatusType loadStatus = LoadStatusType.loading;
  
  // WebView 相关状态
  int noticeNum = 0;
}
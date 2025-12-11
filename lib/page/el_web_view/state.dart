import 'package:elyra/widgets/bad_status_widget.dart';

class WebViewState {
  WebViewState();

  LoadStatusType loadStatus = LoadStatusType.loading;
  
  // WebView 相关状态
  String url = '';
  String title = '';
  int loadingProgress = 0;
  bool canGoBack = false;
  bool canGoForward = false;
}
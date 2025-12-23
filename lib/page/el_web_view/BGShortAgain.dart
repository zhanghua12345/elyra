import 'package:elyra/widgets/WRegisterLoading.dart';

class OMMElyon {
late double _originalMonthAvatorSize = 0.0;
late String _vnewsNextStr;


  OMMElyon();

  LoadStatusType loadStatus = LoadStatusType.loading;
  
  
  String url = '';
  String title = '';
  int loadingProgress = 0;
  bool canGoBack = false;
  bool canGoForward = false;
}
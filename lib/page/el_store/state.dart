import 'package:elyra/bean/pay_settings_bean.dart';
import 'package:elyra/widgets/bad_status_widget.dart';

class StoreState {
  StoreState();

  LoadStatusType loadStatus = LoadStatusType.loading;
  bool isLoading = false;
  
  // 支付配置数据
  PaySettingsBean? paySettings;
  
  // 分类后的数据
  List<PayItem> coinsBigList = [];
  List<PayItem> coinsSmallList = [];
  List<PayItem> coinsWeekList = [];
  List<PayItem> subList = [];
  
  // 排序列表
  List<String> sortList = [];
}
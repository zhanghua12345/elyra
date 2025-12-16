import 'package:elyra/bean/pay_settings_bean.dart';
import 'package:elyra/page/el_store/state.dart';
import 'package:elyra/request/http.dart';
import 'package:elyra/request/index.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:elyra/widgets/bad_status_widget.dart';

class StorePageController extends GetxController {
  final state = StoreState();
  final RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );

  @override
  void onReady() {
    super.onReady();
    loadData();
  }

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
  }

  /// 加载数据
  void loadData() async {
    if (state.isLoading) return;
    state.isLoading = true;
    state.loadStatus = LoadStatusType.loading;
    update();

    try {
      // 调用支付配置接口
      final res = await HttpClient().request(
        Apis.paySettingsV4,
        method: HttpMethod.get,
      );

      if (res.success && res.data != null) {
        state.paySettings = PaySettingsBean.fromJson(res.data);
        state.sortList = state.paySettings!.sort;

        // 分类数据
        _classifyData();

        state.loadStatus = LoadStatusType.loadSuccess;
      } else {
        state.loadStatus = LoadStatusType.loadFailed;
      }
    } catch (err) {
      print('加载失败: $err');
      state.loadStatus = LoadStatusType.loadFailed;
    } finally {
      state.isLoading = false;
      refreshController.refreshCompleted();
      update();
    }
  }

  /// 分类数据
  void _classifyData() {
    if (state.paySettings == null) return;

    final allItems = [
      ...state.paySettings!.listCoins,
      ...state.paySettings!.listSubVip,
    ];

    // 按类型分类
    state.coinsBigList = _filterAndSort(allItems, 'coins', 'big');
    state.coinsSmallList = _filterAndSort(allItems, 'coins', 'small');
    state.coinsWeekList = _filterAndSort(allItems, 'sub_coins');
    state.subList = _filterAndSort(allItems, 'sub_vip');
  }

  /// 筛选和排序数据
  List<PayItem> _filterAndSort(List<PayItem> items, String buyType, [String? size]) {
    var filtered = items.where((item) {
      if (size != null) {
        return item.buyType == buyType && item.size == size;
      }
      return item.buyType == buyType;
    }).toList();

    // 按 sort 字段降序排列
    filtered.sort((a, b) => b.sort.compareTo(a.sort));
    return filtered;
  }

  /// 下拉刷新
  void onRefresh() {
    loadData();
  }

  /// 处理支付
  void handlePay(PayItem item) {
    // TODO: 实现支付逻辑
    print('点击支付: ${item.buyType} - ${item.coins} coins');
  }
}

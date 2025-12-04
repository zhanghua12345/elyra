import 'package:elyra/page/el_home/sub_page/search/state.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:elyra/widgets/bad_status_widget.dart';
import 'package:elyra/request/http.dart';
import 'package:elyra/request/index.dart';
import 'package:elyra/bean/hot_search_bean.dart';
import 'package:elyra/utils/el_utils.dart';
import 'package:elyra/utils/el_store.dart';

class SearchPageController extends GetxController {
  final state = SearchState();
  final RefreshController refreshController = RefreshController(initialRefresh: false);

  @override
  void onInit() {
    super.onInit();
    loadSearchHistory();
  }

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

  // 加载搜索历史记录
  void loadSearchHistory() {
    try {
      List<String>? history = SpUtils().getList<String>(ElStoreKeys.searchHistory);
      if (history != null) {
        state.searchHistoryList = history;
        state.showSearchHistory = history.isNotEmpty;
      }
      update();
    } catch (e) {
      // Error handling
    }
  }

  // 保存搜索历史记录
  void saveSearchHistory(String keyword) {
    // 如果已存在该关键词，则移到最前面
    if (state.searchHistoryList.contains(keyword)) {
      state.searchHistoryList.remove(keyword);
    }
    // 在最前面添加新关键词
    state.searchHistoryList.insert(0, keyword);
    
    // 限制最多保存20条记录
    if (state.searchHistoryList.length > 20) {
      state.searchHistoryList = state.searchHistoryList.sublist(0, 20);
    }
    
    state.showSearchHistory = state.searchHistoryList.isNotEmpty;
    
    // 保存到本地
    SpUtils().setList<String>(ElStoreKeys.searchHistory, state.searchHistoryList);
    
    update();
  }

  // 清空搜索历史记录
  void clearSearchHistory() {
    state.searchHistoryList.clear();
    state.showSearchHistory = false;
    
    SpUtils().remove(ElStoreKeys.searchHistory);
    
    update();
  }

  // 加载数据的方法
  void loadData() async {
    if (state.isLoading) return;
    state.isLoading = true;
    update();

    try {
      // 加载热门搜索数据
      await loadHotSearchData();
      
      // 加载成功
      state.loadStatus = LoadStatusType.loadSuccess;
      update();
    } catch (err) {
      // Error handling
      state.loadStatus = LoadStatusType.loadFailed;
      update();
    } finally {
      state.isLoading = false;
      
      // 确保刷新控制器正确完成
      refreshController.refreshCompleted();
      update();
    }
  }

  // 加载热门搜索数据
  Future<void> loadHotSearchData() async {
    try {
      final response = await HttpClient().request(
        Apis.searchHots,
        method: HttpMethod.get,
      );
      
      if (response.success && response.data != null) {
        List<HotSearchBean> hotList = [];
        if (response.data is List) {
          hotList = (response.data as List)
              .map((item) => HotSearchBean.fromJson(item as Map<String, dynamic>))
              .toList();
        } else if (response.data is Map<String, dynamic> && response.data['list'] != null) {
          hotList = (response.data['list'] as List)
              .map((item) => HotSearchBean.fromJson(item as Map<String, dynamic>))
              .toList();
        }
        state.hotSearchList = hotList;
      }
    } catch (e) {
      // Error handling
    }
  }

  // 下拉刷新
  void onRefresh() {
    loadData();
  }
}
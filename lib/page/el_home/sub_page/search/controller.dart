import 'package:elyra/page/el_home/sub_page/search/state.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPageController extends GetxController {
  final state = SearchState();

  @override
  void onInit() {
    super.onInit();
    loadHistory();
    loadHotSearchData();
  }

  // 加载历史搜索记录
  Future<void> loadHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? history = prefs.getStringList('search_history');
    if (history != null) {
      state.historyList = history;
      state.showHistory = history.isNotEmpty;
    }
    update();
  }

  // 保存搜索记录
  Future<void> saveSearchHistory(String keyword) async {
    // 如果已存在该关键词，则移到最前面
    if (state.historyList.contains(keyword)) {
      state.historyList.remove(keyword);
    }
    // 在最前面添加新关键词
    state.historyList.insert(0, keyword);
    
    // 限制最多保存10条记录
    if (state.historyList.length > 10) {
      state.historyList = state.historyList.sublist(0, 10);
    }
    
    state.showHistory = state.historyList.isNotEmpty;
    
    // 保存到本地
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('search_history', state.historyList);
    
    update();
  }

  // 清空历史记录
  Future<void> clearHistory() async {
    state.historyList.clear();
    state.showHistory = false;
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('search_history');
    
    update();
  }

  // 加载热门搜索数据
  Future<void> loadHotSearchData() async {
    try {
      // 模拟API调用
      // 实际应该调用:
      // ApiResponse response = await HttpClient().request(
      //   '/search/hots',
      //   method: HttpMethod.get,
      // );
      
      // 模拟数据
      state.hotList = [
        HotSearchItem(
          title: "Fantasy Adventure",
          subtitle: "Epic journey begins",
          imageUrl: "https://example.com/image1.jpg"
        ),
        HotSearchItem(
          title: "Sci-fi Universe",
          subtitle: "Future world exploration",
          imageUrl: "https://example.com/image2.jpg"
        ),
        HotSearchItem(
          title: "Mystery Detective",
          subtitle: "Solve the case",
          imageUrl: "https://example.com/image3.jpg"
        ),
        HotSearchItem(
          title: "Romantic Drama",
          subtitle: "Love story unfolds",
          imageUrl: "https://example.com/image4.jpg"
        ),
      ];
      
      state.showHotSearch = state.hotList.isNotEmpty;
      update();
    } catch (e) {
      print('Error loading hot search data: $e');
    }
  }
}
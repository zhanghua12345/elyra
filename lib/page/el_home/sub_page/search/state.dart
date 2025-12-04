class SearchState {
  SearchState();

  // 历史搜索记录
  List<String> historyList = [];
  
  // 热门搜索数据
  List<HotSearchItem> hotList = [];
  
  // 搜索关键字
  String searchKeyword = '';
  
  // 是否显示历史记录
  bool showHistory = false;
  
  // 是否显示热门搜索
  bool showHotSearch = false;
}

class HotSearchItem {
  final String title;
  final String subtitle;
  final String imageUrl;
  
  HotSearchItem({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });
}
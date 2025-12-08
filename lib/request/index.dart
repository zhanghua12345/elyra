class Apis {
  static const String baseUrl = "https://api-csyib.csyib.com/ely";

  static const String register = "/customer/register";
  static const String homeData = "/home/all-modules";
  static const String rankingData = "/homeRanking";
  static const String categoryListAppendShortPlay = "/categoryListAppendShortPlay";
  static const String videoList = "/videoList";
  static const String searchHots = "/search/hots"; // 热搜短剧 get
  static const String search = "/search"; // 搜索接口 get search
  static const String myCollections = "/myCollections"; // 客户收藏列表 get current_page  page_size
  static const String collect = "/collect"; // 收藏 post short_play_id  video_id
  static const String cancelCollect = "/cancelCollect"; // 取消收藏 post short_play_id  
  static const String history = "/myHistorys"; // 历史记录列表 get current_page  page_size 
  static const String createHistory = "/createHistory"; // 创建历史 post short_play_id  video_id 
  static const String recommands = "/getRecommands"; // 创建历史 get current_page  page_size 
  
  static const String customerInfo = "/customer/info";
  static const String reportEvent = "/event/add";
  
}
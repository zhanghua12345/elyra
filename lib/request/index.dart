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
  static const String recommands = "/getRecommands"; // 推荐 get current_page  page_size 
  static const String getVideoDetails = "/getVideoDetails"; // 视频详情 get short_play_id  video_id
  static const String uploadHistorySeconds = "/uploadHistorySeconds"; // 上传播放进度 post short_play_id  video_id  play_seconds
  static const String collectVideo = "/collect"; // 收藏视频 post short_play_id  video_id
  static const String cancelCollectVideo = "/cancelCollect"; // 取消收藏视频 post short_play_id
  static const String reportActivity = "/activeAfterWatchingVideo"; // 上报活动 post short_play_id  short_play_video_id  activity_id
  
  static const String customerInfo = "/customer/info";
  static const String reportEvent = "/event/add";
  static const String getNoticeNum = "/noticeNum";  // 获取反馈通知数量
  
}
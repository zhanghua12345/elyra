import 'dart:convert';

ShortVideoBean shortVideoBeanFromJson(String str) =>
    ShortVideoBean.fromJson(json.decode(str));

String shortVideoBeanToJson(ShortVideoBean data) => json.encode(data.toJson());

class ShortVideoBean {
  ShortVideoBean({
    num? id,
    String? description,
    num? process,
    num? shortId,
    num? shortPlayVideoId,
    String? name,
    num? shortPlayId,
    String? imageUrl,
    num? buyType,
    num? watchTotal,
    String? tagType,
    num? searchClickTotal,
    num? collectTotal,
    num? episodeTotal,
    num? currentEpisode,
    bool? isCollect,
    List<Category>? categoryList,
    String? videoUrl,
    List<String>? category,
    VideoInfo? videoInfo,
    num? allCoins,
    String? horizontallyImg,
  }) {
    _id = id;
    _description = description;
    _process = process;
    _shortId = shortId;
    _shortPlayVideoId = shortPlayVideoId;
    _shortPlayId = shortPlayId;
    _name = name;
    _imageUrl = imageUrl;
    _horizontallyImg = horizontallyImg;
    _watchTotal = watchTotal;
    _episodeTotal = episodeTotal;
    _currentEpisode = currentEpisode;
    _collectTotal = collectTotal;
    _videoUrl = videoUrl;
    _isCollect = isCollect;
    _categoryList = categoryList;
    _searchClickTotal = searchClickTotal;
    _buyType = buyType;
    _tagType = tagType;
    _category = category;
    _videoInfo = videoInfo;
    _allCoins = allCoins;
  }

  ShortVideoBean.fromJson(dynamic json) {
    _id = json['id'];
    _shortId = json['short_id'];
    _shortPlayId = json['short_play_id'];
    _shortPlayVideoId = json['short_play_video_id'];
    _imageUrl = json['image_url'];
    _horizontallyImg = json['horizontally_img'];
    _buyType = json['buy_type'];
    _tagType = json['tag_type'];
    _allCoins = json['all_coins'];
    _collectTotal = json['collect_total'];
    _name = json['name'];
    _description = json['description'];
    _process = json['process'];
    _videoUrl = json['video_url'];
    _category = json['category'] != null ? json['category'].cast<String>() : [];
    _videoInfo = json['video_info'] != null
        ? VideoInfo.fromJson(json['video_info'])
        : null;
    // 处理 is_collect 可能是 int(0/1) 或 bool 的情况
    if (json['is_collect'] != null) {
      if (json['is_collect'] is bool) {
        _isCollect = json['is_collect'];
      } else if (json['is_collect'] is int) {
        _isCollect = json['is_collect'] == 1;
      } else {
        _isCollect = false;
      }
    } else {
      _isCollect = false;
    }
    _watchTotal = json['watch_total'];
    _episodeTotal = json['episode_total'];
    _currentEpisode = json['current_episode'];
    _searchClickTotal = json['search_click_total'];
    if (json['categoryList'] != null) {
      _categoryList = [];
      json['categoryList'].forEach((v) {
        _categoryList?.add(Category.fromJson(v));
      });
    }
  }

  num? _id;

  String? _description;
  num? _process;
  String? _imageUrl;
  String? _horizontallyImg;
  num? _buyType;
  String? _tagType;
  num? _shortId;
  num? _shortPlayVideoId;
  num? _shortPlayId;
  String? _name;
  num? _allCoins;
  List<String>? _category;
  VideoInfo? _videoInfo;
  bool? _isCollect;
  List<Category>? _categoryList;
  num? _collectTotal;
  num? _watchTotal;
  num? _episodeTotal;
  num? _currentEpisode;
  num? _searchClickTotal;
  String? _videoUrl;
  int? _playTime; // 播放时间(秒)

  ShortVideoBean copyWith({
    num? id,
    num? shortId,
    num? shortPlayVideoId,
    num? shortPlayId,
    String? name,
    String? description,
    num? process,
    String? imageUrl,
    String? horizontallyImg,
    num? buyType,
    String? tagType,
    num? allCoins,
    num? collectTotal,
    num? watchTotal,
    num? episodeTotal,
    num? currentEpisode,
    num? searchClickTotal,
    String? videoUrl,
    List<String>? category,
    VideoInfo? videoInfo,
    bool? isCollect,
    List<Category>? categoryList,
  }) => ShortVideoBean(
    id: id ?? _id,
    shortId: shortId ?? _shortId,
    shortPlayVideoId: shortPlayVideoId ?? _shortPlayVideoId,
    shortPlayId: shortPlayId ?? _shortPlayId,
    name: name ?? _name,
    description: description ?? _description,
    process: process ?? _process,
    imageUrl: imageUrl ?? _imageUrl,
    horizontallyImg: horizontallyImg ?? _horizontallyImg,
    buyType: buyType ?? _buyType,
    tagType: tagType ?? _tagType,
    allCoins: allCoins ?? _allCoins,
    collectTotal: collectTotal ?? _collectTotal,
    watchTotal: watchTotal ?? _watchTotal,
    episodeTotal: episodeTotal ?? _episodeTotal,
    currentEpisode: currentEpisode ?? _currentEpisode,
    searchClickTotal: searchClickTotal ?? _searchClickTotal,
    videoUrl: videoUrl ?? _videoUrl,
    category: category ?? _category,
    videoInfo: videoInfo ?? _videoInfo,
    isCollect: isCollect ?? _isCollect,
    categoryList: categoryList ?? _categoryList,
  );

  num? get id => _id;

  num? get shortId => _shortId;

  num? get shortPlayVideoId => _shortPlayVideoId;

  num? get shortPlayId => _shortPlayId;

  String? get name => _name;

  String? get description => _description;

  num? get process => _process;

  String? get imageUrl => _imageUrl;

  String? get horizontallyImg => _horizontallyImg;

  num? get buyType => _buyType;

  String? get tagType => _tagType;

  num? get allCoins => _allCoins;

  num? get collectTotal => _collectTotal;

  num? get watchTotal => _watchTotal;

  num? get episodeTotal => _episodeTotal;

  num? get currentEpisode => _currentEpisode;

  num? get searchClickTotal => _searchClickTotal;

  String? get videoUrl => _videoUrl;

  int? get playTime => _playTime;

  List<String>? get category => _category;

  VideoInfo? get videoInfo => _videoInfo;

  bool? get isCollect => _isCollect;

  List<Category>? get categoryList => _categoryList;

  set id(num? value) => _id = value;
  set shortId(num? value) => _shortId = value;
  set shortPlayVideoId(num? value) => _shortPlayVideoId = value;
  set shortPlayId(num? value) => _shortPlayId = value;
  set name(String? value) => _name = value;
  set description(String? value) => _description = value;
  set process(num? value) => _process = value;
  set imageUrl(String? value) => _imageUrl = value;
  set horizontallyImg(String? value) => _horizontallyImg = value;
  set buyType(num? value) => _buyType = value;
  set tagType(String? value) => _tagType = value;
  set allCoins(num? value) => _allCoins = value;
  set collectTotal(num? value) => _collectTotal = value;
  set watchTotal(num? value) => _watchTotal = value;
  set episodeTotal(num? value) => _episodeTotal = value;
  set currentEpisode(num? value) => _currentEpisode = value;
  set searchClickTotal(num? value) => _searchClickTotal = value;
  set videoUrl(String? value) => _videoUrl = value;
  set playTime(int? value) => _playTime = value;
  set category(List<String>? value) => _category = value;
  set videoInfo(VideoInfo? value) => _videoInfo = value;
  set isCollect(bool? value) => _isCollect = value;
  set categoryList(List<Category>? value) => _categoryList = value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['short_id'] = _shortId;
    map['short_play_video_id'] = _shortPlayVideoId;
    map['short_play_id'] = _shortPlayId;
    map['name'] = _name;
    map['description'] = _description;
    map['process'] = _process;
    map['image_url'] = _imageUrl;
    map['horizontally_img'] = _horizontallyImg;
    map['buy_type'] = _buyType;
    map['tag_type'] = _tagType;
    map['all_coins'] = _allCoins;
    map['collect_total'] = _collectTotal;
    map['watch_total'] = _watchTotal;
    map['episode_total'] = _episodeTotal;
    map['current_episode'] = _currentEpisode;
    map['search_click_total'] = _searchClickTotal;
    map['video_url'] = _videoUrl;
    map['category'] = _category;
    if (_videoInfo != null) {
      map['video_info'] = _videoInfo?.toJson();
    }
    map['is_collect'] = _isCollect;
    if (_categoryList != null) {
      map['categoryList'] = _categoryList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : 1
/// name : ""

Category categoryFromJson(String str) => Category.fromJson(json.decode(str));

String categoryToJson(Category data) => json.encode(data.toJson());

class Category {
  Category({num? id, String? name}) {
    _id = id;
    _name = name;
  }

  Category.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
  }

  num? _id;
  String? _name;

  Category copyWith({num? id, String? name}) =>
      Category(id: id ?? _id, name: name ?? _name);

  num? get id => _id;

  String? get name => _name;

  set id(num? value) => _id = value;
  set name(String? value) => _name = value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    return map;
  }
}

/// id : 19136
/// short_play_video_id : 19136
/// short_play_id : 207
/// short_id : 133
/// promise_view_ad : 0
/// video_url : "https://static.wanmwl.com/videom3u8/a8ec99a023b074938e86/a8ec99a023b074938e86.m3u8"
/// coins : 0
/// vip_coins : 0
/// episode : 1
/// is_vip : 2
/// revolution : {"r540":"videom3u8/a8ec99a023b074938e86/a8ec99a023b074938e86.m3u8","r720":"videom3u8/a8ec99a023b074938e86/a8ec99a023b074938e86.m3u8","r1080":"videom3u8/a8ec99a023b074938e86/a8ec99a023b074938e86.m3u8"}
/// image_url : "https://static.wanmwl.com/eyJrZXkiOiJpbWFnZS9iY2U2NTkyNDUwN2FmZDQyOTdkZC5qcGciLCJlZGl0cyI6eyJyZXNpemUiOnsiZml0IjoiY292ZXIifH19?sign=$13136e4e95c2a9c82971428cbd1d4f533b403890bb5a7c390b1d05a55588390cb27c74948f"

VideoInfo videoInfoFromJson(String str) => VideoInfo.fromJson(json.decode(str));

String videoInfoToJson(VideoInfo data) => json.encode(data.toJson());

class VideoInfo {
  VideoInfo({
    num? id,
    num? shortPlayVideoId,
    num? shortPlayId,
    num? shortId,
    num? promiseViewAd,
    String? videoUrl,
    num? coins,
    num? vipCoins,
    num? episode,
    num? isVip,
    Revolution? revolution,
    String? imageUrl,
  }) {
    _id = id;
    _shortPlayVideoId = shortPlayVideoId;
    _shortPlayId = shortPlayId;
    _shortId = shortId;
    _promiseViewAd = promiseViewAd;
    _videoUrl = videoUrl;
    _coins = coins;
    _vipCoins = vipCoins;
    _episode = episode;
    _isVip = isVip;
    _revolution = revolution;
    _imageUrl = imageUrl;
  }

  VideoInfo.fromJson(dynamic json) {
    _id = json['id'];
    _shortPlayVideoId = json['short_play_video_id'];
    _shortPlayId = json['short_play_id'];
    _shortId = json['short_id'];
    _promiseViewAd = json['promise_view_ad'];
    _videoUrl = json['video_url'];
    _coins = json['coins'];
    _vipCoins = json['vip_coins'];
    _episode = json['episode'];
    _isVip = json['is_vip'];
    _revolution = json['revolution'] != null
        ? Revolution.fromJson(json['revolution'])
        : null;
    _imageUrl = json['image_url'];
  }

  num? _id;
  num? _shortPlayVideoId;
  num? _shortPlayId;
  num? _shortId;
  num? _promiseViewAd;
  String? _videoUrl;
  num? _coins;
  num? _vipCoins;
  num? _episode;
  num? _isVip;
  Revolution? _revolution;
  String? _imageUrl;

  VideoInfo copyWith({
    num? id,
    num? shortPlayVideoId,
    num? shortPlayId,
    num? shortId,
    num? promiseViewAd,
    String? videoUrl,
    num? coins,
    num? vipCoins,
    num? episode,
    num? isVip,
    Revolution? revolution,
    String? imageUrl,
  }) => VideoInfo(
    id: id ?? _id,
    shortPlayVideoId: shortPlayVideoId ?? _shortPlayVideoId,
    shortPlayId: shortPlayId ?? _shortPlayId,
    shortId: shortId ?? _shortId,
    promiseViewAd: promiseViewAd ?? _promiseViewAd,
    videoUrl: videoUrl ?? _videoUrl,
    coins: coins ?? _coins,
    vipCoins: vipCoins ?? _vipCoins,
    episode: episode ?? _episode,
    isVip: isVip ?? _isVip,
    revolution: revolution ?? _revolution,
    imageUrl: imageUrl ?? _imageUrl,
  );

  num? get id => _id;

  num? get shortPlayVideoId => _shortPlayVideoId;

  num? get shortPlayId => _shortPlayId;

  num? get shortId => _shortId;

  num? get promiseViewAd => _promiseViewAd;

  String? get videoUrl => _videoUrl;

  num? get coins => _coins;

  num? get vipCoins => _vipCoins;

  num? get episode => _episode;

  num? get isVip => _isVip;

  Revolution? get revolution => _revolution;

  String? get imageUrl => _imageUrl;

  set id(num? value) => _id = value;
  set shortPlayVideoId(num? value) => _shortPlayVideoId = value;
  set shortPlayId(num? value) => _shortPlayId = value;
  set shortId(num? value) => _shortId = value;
  set promiseViewAd(num? value) => _promiseViewAd = value;
  set videoUrl(String? value) => _videoUrl = value;
  set coins(num? value) => _coins = value;
  set vipCoins(num? value) => _vipCoins = value;
  set episode(num? value) => _episode = value;
  set isVip(num? value) => _isVip = value;
  set revolution(Revolution? value) => _revolution = value;
  set imageUrl(String? value) => _imageUrl = value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['short_play_video_id'] = _shortPlayVideoId;
    map['short_play_id'] = _shortPlayId;
    map['short_id'] = _shortId;
    map['promise_view_ad'] = _promiseViewAd;
    map['video_url'] = _videoUrl;
    map['coins'] = _coins;
    map['vip_coins'] = _vipCoins;
    map['episode'] = _episode;
    map['is_vip'] = _isVip;
    if (_revolution != null) {
      map['revolution'] = _revolution?.toJson();
    }
    map['image_url'] = _imageUrl;
    return map;
  }
}

/// r540 : "videom3u8/a8ec99a023b074938e86/a8ec99a023b074938e86.m3u8"
/// r720 : "videom3u8/a8ec99a023b074938e86/a8ec99a023b074938e86.m3u8"
/// r1080 : "videom3u8/a8ec99a023b074938e86/a8ec99a023b074938e86.m3u8"

Revolution revolutionFromJson(String str) =>
    Revolution.fromJson(json.decode(str));

String revolutionToJson(Revolution data) => json.encode(data.toJson());

class Revolution {
  Revolution({String? r540, String? r720, String? r1080}) {
    _r540 = r540;
    _r720 = r720;
    _r1080 = r1080;
  }

  Revolution.fromJson(dynamic json) {
    _r540 = json['540'];
    _r720 = json['720'];
    _r1080 = json['1080'];
  }

  String? _r540;
  String? _r720;
  String? _r1080;

  Revolution copyWith({String? r540, String? r720, String? r1080}) =>
      Revolution(
        r540: r540 ?? _r540,
        r720: r720 ?? _r720,
        r1080: r1080 ?? _r1080,
      );

  String? get r540 => _r540;

  String? get r720 => _r720;

  String? get r1080 => _r1080;

  set r540(String? value) => _r540 = value;
  set r720(String? value) => _r720 = value;
  set r1080(String? value) => _r1080 = value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['r540'] = _r540;
    map['r720'] = _r720;
    map['r1080'] = _r1080;
    return map;
  }
}

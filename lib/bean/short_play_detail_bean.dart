import 'dart:convert';

/// business_model : "iap"
/// video_info : {"id":7132,"short_play_video_id":7132,"short_play_id":162,"short_id":11,"promise_view_ad":0,"video_url":"https://static.wanmwl.com/videom3u8/3f9afda335fd2616d901/3f9afda335fd2616d901.m3u8","coins":0,"vip_coins":0,"episode":1,"is_vip":2,"play_seconds":"0"}
/// shortPlayInfo : {"id":162,"short_id":11,"short_play_id":162,"name":"Madam President, Holding Multiple Positions  ","description":"It is rumored outside that the prestigious president of Xu's Group is about to marry the daughter of the Xu family. Just because the name of the Xu family's daughter is Pearl, which is the same as his childhood sweetheart in ","process":2,"image_url":"https://static.wanmwl.com/eyJrZXkiOiJpbWFnZS80ZmRhZDg4OWIxNmM3MmQ2MjkwZC5qcGciLCJlZGl0cyI6eyJyZXNpemUiOnsiZml0IjoiY292ZXIifX19?sign=$23f3feca08db05081465b3677a6f671819b85d9f18ad94cc7236f3c89aada01ebe2de98adbca00c6f0c8c5b8621c5e4f6064afb617","horizontally_img":"https://static.wanmwl.com/image/ac2f87aad3384032215c.jpg","buy_type":1,"tag_type":"","all_coins":0,"collect_total":4,"watch_total":307,"episode_total":18,"search_click_total":0,"is_collect":true,"can_share_get_coin":true,"category":["Sweet Romance "]}
/// episodeList : [{"id":7132,"short_play_video_id":7132,"short_play_id":162,"short_id":11,"promise_view_ad":0,"video_url":"https://static.wanmwl.com/videom3u8/3f9afda335fd2616d901/3f9afda335fd2616d901.m3u8","coins":0,"vip_coins":0,"episode":1,"is_vip":2,"is_lock":false,"play_seconds":"0"},{"id":7140,"short_play_video_id":7140,"short_play_id":162,"short_id":11,"promise_view_ad":0,"video_url":"https://static.wanmwl.com/videom3u8/5c5860a67aab8fe3d89d/5c5860a67aab8fe3d89d.m3u8","coins":0,"vip_coins":0,"episode":2,"is_vip":2,"is_lock":false,"play_seconds":"0"},{"id":7136,"short_play_video_id":7136,"short_play_id":162,"short_id":11,"promise_view_ad":0,"video_url":"https://static.wanmwl.com/videom3u8/9f7c98f9c61fdf1bf5fc/9f7c98f9c61fdf1bf5fc.m3u8","coins":0,"vip_coins":0,"episode":3,"is_vip":2,"is_lock":false,"play_seconds":"0"},{"id":7137,"short_play_video_id":7137,"short_play_id":162,"short_id":11,"promise_view_ad":0,"video_url":"https://static.wanmwl.com/videom3u8/72c3555f90fcceb9aab4/72c3555f90fcceb9aab4.m3u8","coins":0,"vip_coins":0,"episode":4,"is_vip":2,"is_lock":false,"play_seconds":"0"},{"id":7133,"short_play_video_id":7133,"short_play_id":162,"short_id":11,"promise_view_ad":0,"video_url":"https://static.wanmwl.com/videom3u8/171bf35b0196bdf1e839/171bf35b0196bdf1e839.m3u8","coins":0,"vip_coins":0,"episode":5,"is_vip":2,"is_lock":false,"play_seconds":"0"},{"id":7135,"short_play_video_id":7135,"short_play_id":162,"short_id":11,"promise_view_ad":0,"video_url":"https://static.wanmwl.com/videom3u8/fff10f96153f53ddc7f6/fff10f96153f53ddc7f6.m3u8","coins":0,"vip_coins":0,"episode":6,"is_vip":2,"is_lock":false,"play_seconds":"0"},{"id":7134,"short_play_video_id":7134,"short_play_id":162,"short_id":11,"promise_view_ad":0,"video_url":"https://static.wanmwl.com/videom3u8/9a3ac7c5924b144b6222/9a3ac7c5924b144b6222.m3u8","coins":0,"vip_coins":0,"episode":7,"is_vip":2,"is_lock":false,"play_seconds":"0"},{"id":7139,"short_play_video_id":7139,"short_play_id":162,"short_id":11,"promise_view_ad":0,"video_url":"https://static.wanmwl.com/videom3u8/17927e0dd452d5a936d0/17927e0dd452d5a936d0.m3u8","coins":0,"vip_coins":0,"episode":8,"is_vip":2,"is_lock":false,"play_seconds":"0"},{"id":7138,"short_play_video_id":7138,"short_play_id":162,"short_id":11,"promise_view_ad":0,"video_url":"https://static.wanmwl.com/videom3u8/1d61d46d30292d0a7269/1d61d46d30292d0a7269.m3u8","coins":0,"vip_coins":0,"episode":9,"is_vip":2,"is_lock":false,"play_seconds":"0"},{"id":7141,"short_play_video_id":7141,"short_play_id":162,"short_id":11,"promise_view_ad":0,"video_url":"https://static.wanmwl.com/videom3u8/70ee4deb9bb176846534/70ee4deb9bb176846534.m3u8","coins":0,"vip_coins":0,"episode":10,"is_vip":2,"is_lock":false,"play_seconds":"0"},{"id":7146,"short_play_video_id":7146,"short_play_id":162,"short_id":11,"promise_view_ad":0,"video_url":"https://static.wanmwl.com/videom3u8/946ec0930ff6d1f9b36e/946ec0930ff6d1f9b36e.m3u8","coins":69,"vip_coins":0,"episode":11,"is_vip":2,"is_lock":true,"play_seconds":"0"},{"id":7144,"short_play_video_id":7144,"short_play_id":162,"short_id":11,"promise_view_ad":0,"video_url":"https://static.wanmwl.com/videom3u8/b92bed7933bbd5916f07/b92bed7933bbd5916f07.m3u8","coins":119,"vip_coins":0,"episode":12,"is_vip":2,"is_lock":true,"play_seconds":"0"},{"id":7142,"short_play_video_id":7142,"short_play_id":162,"short_id":11,"promise_view_ad":0,"video_url":"https://static.wanmwl.com/videom3u8/9679216680a679f7e6c2/9679216680a679f7e6c2.m3u8","coins":149,"vip_coins":0,"episode":13,"is_vip":2,"is_lock":true,"play_seconds":"0"},{"id":7143,"short_play_video_id":7143,"short_play_id":162,"short_id":11,"promise_view_ad":0,"video_url":"https://static.wanmwl.com/videom3u8/a73214d6aa17af4d639d/a73214d6aa17af4d639d.m3u8","coins":249,"vip_coins":0,"episode":14,"is_vip":2,"is_lock":true,"play_seconds":"0"},{"id":7147,"short_play_video_id":7147,"short_play_id":162,"short_id":11,"promise_view_ad":0,"video_url":"https://static.wanmwl.com/videom3u8/3a82aab4550ddc50cfe7/3a82aab4550ddc50cfe7.m3u8","coins":199,"vip_coins":0,"episode":15,"is_vip":2,"is_lock":true,"play_seconds":"0"},{"id":7149,"short_play_video_id":7149,"short_play_id":162,"short_id":11,"promise_view_ad":0,"video_url":"https://static.wanmwl.com/videom3u8/0b0781eefb331cc25fee/0b0781eefb331cc25fee.m3u8","coins":159,"vip_coins":0,"episode":16,"is_vip":2,"is_lock":true,"play_seconds":"0"},{"id":7145,"short_play_video_id":7145,"short_play_id":162,"short_id":11,"promise_view_ad":0,"video_url":"https://static.wanmwl.com/videom3u8/6c2d042f669e7bdaff3d/6c2d042f669e7bdaff3d.m3u8","coins":69,"vip_coins":0,"episode":17,"is_vip":2,"is_lock":true,"play_seconds":"0"},{"id":7148,"short_play_video_id":7148,"short_play_id":162,"short_id":11,"promise_view_ad":0,"video_url":"https://static.wanmwl.com/videom3u8/d6fd3ab315f161b9b980/d6fd3ab315f161b9b980.m3u8","coins":69,"vip_coins":0,"episode":18,"is_vip":2,"is_lock":true,"play_seconds":"0"}]
/// is_collect : true
/// show_share_coin : true
/// share_coin : 100
/// install_coins : 1000
/// revolution : 720
/// user_level : "normal"
/// unlock_video_ad_count : 1
/// discount : 80

ShortPlayDetailBean shortPlayDetailBeanFromJson(String str) => ShortPlayDetailBean.fromJson(json.decode(str));

String shortPlayDetailBeanToJson(ShortPlayDetailBean data) => json.encode(data.toJson());

class ShortPlayDetailBean {
  ShortPlayDetailBean({
    int? payMode,
    String? businessModel,
    VideoInfo? videoInfo,
    ShortPlayInfo? shortPlayInfo,
    List<EpisodeList>? episodeList,
    List<int>? checkPoint,
    bool? isCollect,
    bool? showShareCoin,
    num? shareCoin,
    num? installCoins,
    dynamic revolution,
    String? userLevel,
    num? unlockVideoAdCount,
    num? discount,
  }) {
    _payMode = payMode;
    _businessModel = businessModel;
    _videoInfo = videoInfo;
    _shortPlayInfo = shortPlayInfo;
    _episodeList = episodeList;
    _checkPoint = checkPoint;
    _isCollect = isCollect;
    _showShareCoin = showShareCoin;
    _shareCoin = shareCoin;
    _installCoins = installCoins;
    _revolution = revolution;
    _userLevel = userLevel;
    _unlockVideoAdCount = unlockVideoAdCount;
    _discount = discount;
  }

  ShortPlayDetailBean.fromJson(dynamic json) {
    _businessModel = json['business_model'];
    _payMode = json['pay_mode'];
    _videoInfo = json['video_info'] != null ? VideoInfo.fromJson(json['video_info']) : null;
    _shortPlayInfo = json['shortPlayInfo'] != null ? ShortPlayInfo.fromJson(json['shortPlayInfo']) : null;
    if (json['episodeList'] != null) {
      _episodeList = [];
      json['episodeList'].forEach((v) {
        _episodeList?.add(EpisodeList.fromJson(v));
      });
    }
    _checkPoint = json['check_point'] != null ? json['check_point'].cast<int>() : [];
    _isCollect = json['is_collect'];
    _showShareCoin = json['show_share_coin'];
    _shareCoin = json['share_coin'];
    _installCoins = json['install_coins'];
    _revolution = json['revolution'];
    _userLevel = json['user_level'];
    _unlockVideoAdCount = json['unlock_video_ad_count'];
    _discount = json['discount'];
  }

  int? _payMode;
  String? _businessModel;
  VideoInfo? _videoInfo;
  ShortPlayInfo? _shortPlayInfo;
  List<EpisodeList>? _episodeList;
  List<int>? _checkPoint;
  bool? _isCollect;
  bool? _showShareCoin;
  num? _shareCoin;
  num? _installCoins;
  dynamic _revolution;
  String? _userLevel;
  num? _unlockVideoAdCount;
  num? _discount;

  ShortPlayDetailBean copyWith({
    int? payMode,
    String? businessModel,
    VideoInfo? videoInfo,
    ShortPlayInfo? shortPlayInfo,
    List<EpisodeList>? episodeList,
    List<int>? checkPoint,
    bool? isCollect,
    bool? showShareCoin,
    num? shareCoin,
    num? installCoins,
    dynamic revolution,
    String? userLevel,
    num? unlockVideoAdCount,
    num? discount,
  }) => ShortPlayDetailBean(
    payMode: payMode ?? _payMode,
    businessModel: businessModel ?? _businessModel,
    videoInfo: videoInfo ?? _videoInfo,
    shortPlayInfo: shortPlayInfo ?? _shortPlayInfo,
    episodeList: episodeList ?? _episodeList,
    checkPoint: checkPoint ?? _checkPoint,
    isCollect: isCollect ?? _isCollect,
    showShareCoin: showShareCoin ?? _showShareCoin,
    shareCoin: shareCoin ?? _shareCoin,
    installCoins: installCoins ?? _installCoins,
    revolution: revolution ?? _revolution,
    userLevel: userLevel ?? _userLevel,
    unlockVideoAdCount: unlockVideoAdCount ?? _unlockVideoAdCount,
    discount: discount ?? _discount,
  );

  int? get payMode => _payMode;

  String? get businessModel => _businessModel;

  VideoInfo? get videoInfo => _videoInfo;

  ShortPlayInfo? get shortPlayInfo => _shortPlayInfo;

  List<EpisodeList>? get episodeList => _episodeList;

  List<int>? get checkPoint => _checkPoint;

  bool? get isCollect => _isCollect;

  bool? get showShareCoin => _showShareCoin;

  num? get shareCoin => _shareCoin;

  num? get installCoins => _installCoins;

  dynamic get revolution => _revolution;

  String? get userLevel => _userLevel;

  num? get unlockVideoAdCount => _unlockVideoAdCount;

  num? get discount => _discount;

  // ShortPlayDetailBean setters
  set payMode(int? value) => _payMode = value;

  set businessModel(String? value) => _businessModel = value;

  set videoInfo(VideoInfo? value) => _videoInfo = value;

  set shortPlayInfo(ShortPlayInfo? value) => _shortPlayInfo = value;

  set episodeList(List<EpisodeList>? value) => _episodeList = value;

  set checkPoint(List<int>? value) => _checkPoint = value;

  set isCollect(bool? value) => _isCollect = value;

  set showShareCoin(bool? value) => _showShareCoin = value;

  set shareCoin(num? value) => _shareCoin = value;

  set installCoins(num? value) => _installCoins = value;

  set revolution(dynamic value) => _revolution = value;

  set userLevel(String? value) => _userLevel = value;

  set unlockVideoAdCount(num? value) => _unlockVideoAdCount = value;

  set discount(num? value) => _discount = value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['pay_mode'] = _payMode;
    map['business_model'] = _businessModel;
    if (_videoInfo != null) {
      map['video_info'] = _videoInfo?.toJson();
    }
    if (_shortPlayInfo != null) {
      map['shortPlayInfo'] = _shortPlayInfo?.toJson();
    }
    if (_episodeList != null) {
      map['episodeList'] = _episodeList?.map((v) => v.toJson()).toList();
    }
    map['check_point'] = _checkPoint;
    map['is_collect'] = _isCollect;
    map['show_share_coin'] = _showShareCoin;
    map['share_coin'] = _shareCoin;
    map['install_coins'] = _installCoins;
    map['revolution'] = _revolution;
    map['user_level'] = _userLevel;
    map['unlock_video_ad_count'] = _unlockVideoAdCount;
    map['discount'] = _discount;
    return map;
  }
}

/// id : 7132
/// short_play_video_id : 7132
/// short_play_id : 162
/// short_id : 11
/// promise_view_ad : 0
/// video_url : "https://static.wanmwl.com/videom3u8/3f9afda335fd2616d901/3f9afda335fd2616d901.m3u8"
/// coins : 0
/// vip_coins : 0
/// episode : 1
/// is_vip : 2
/// is_lock : false
/// play_seconds : "0"

EpisodeList episodeListFromJson(String str) => EpisodeList.fromJson(json.decode(str));

String episodeListToJson(EpisodeList data) => json.encode(data.toJson());

class EpisodeList {
  EpisodeList({
    num? id,
    num? shortPlayVideoId,
    num? shortPlayId,
    num? shortId,
    num? promiseViewAd,
    String? videoUrl,
    num? coins,
    num? vipCoins,
    int? episode,
    num? isVip,
    bool? isLock,
    String? playSeconds,
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
    _isLock = isLock;
    _playSeconds = playSeconds;
  }

  EpisodeList.fromJson(dynamic json) {
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
    _isLock = json['is_lock'];
    _playSeconds = json['play_seconds'];
  }

  num? _id;
  num? _shortPlayVideoId;
  num? _shortPlayId;
  num? _shortId;
  num? _promiseViewAd;
  String? _videoUrl;
  num? _coins;
  num? _vipCoins;
  int? _episode;
  num? _isVip;
  bool? _isLock;
  String? _playSeconds;

  EpisodeList copyWith({
    num? id,
    num? shortPlayVideoId,
    num? shortPlayId,
    num? shortId,
    num? promiseViewAd,
    String? videoUrl,
    num? coins,
    num? vipCoins,
    int? episode,
    num? isVip,
    bool? isLock,
    String? playSeconds,
  }) => EpisodeList(
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
    isLock: isLock ?? _isLock,
    playSeconds: playSeconds ?? _playSeconds,
  );

  num? get id => _id;

  num? get shortPlayVideoId => _shortPlayVideoId;

  num? get shortPlayId => _shortPlayId;

  num? get shortId => _shortId;

  num? get promiseViewAd => _promiseViewAd;

  String? get videoUrl => _videoUrl;

  num? get coins => _coins;

  num? get vipCoins => _vipCoins;

  int? get episode => _episode;

  num? get isVip => _isVip;

  bool? get isLock => _isLock;

  String? get playSeconds => _playSeconds;

  // EpisodeList setters
  set id(num? value) => _id = value;

  set shortPlayVideoId(num? value) => _shortPlayVideoId = value;

  set shortPlayId(num? value) => _shortPlayId = value;

  set shortId(num? value) => _shortId = value;

  set promiseViewAd(num? value) => _promiseViewAd = value;

  set videoUrl(String? value) => _videoUrl = value;

  set coins(num? value) => _coins = value;

  set vipCoins(num? value) => _vipCoins = value;

  set episode(int? value) => _episode = value;

  set isVip(num? value) => _isVip = value;

  set isLock(bool? value) => _isLock = value;

  set playSeconds(String? value) => _playSeconds = value;

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
    map['is_lock'] = _isLock;
    map['play_seconds'] = _playSeconds;
    return map;
  }
}

/// id : 162
/// short_id : 11
/// short_play_id : 162
/// name : "Madam President, Holding Multiple Positions  "
/// description : "It is rumored outside that the prestigious president of Xu's Group is about to marry the daughter of the Xu family. Just because the name of the Xu family's daughter is Pearl, which is the same as his childhood sweetheart in "
/// process : 2
/// image_url : "https://static.wanmwl.com/eyJrZXkiOiJpbWFnZS80ZmRhZDg4OWIxNmM3MmQ2MjkwZC5qcGciLCJlZGl0cyI6eyJyZXNpemUiOnsiZml0IjoiY292ZXIifX19?sign=$23f3feca08db05081465b3677a6f671819b85d9f18ad94cc7236f3c89aada01ebe2de98adbca00c6f0c8c5b8621c5e4f6064afb617"
/// horizontally_img : "https://static.wanmwl.com/image/ac2f87aad3384032215c.jpg"
/// buy_type : 1
/// tag_type : ""
/// all_coins : 0
/// collect_total : 4
/// watch_total : 307
/// episode_total : 18
/// search_click_total : 0
/// is_collect : true
/// can_share_get_coin : true
/// category : ["Sweet Romance "]

ShortPlayInfo shortPlayInfoFromJson(String str) => ShortPlayInfo.fromJson(json.decode(str));

String shortPlayInfoToJson(ShortPlayInfo data) => json.encode(data.toJson());

class ShortPlayInfo {
  ShortPlayInfo({
    num? id,
    num? shortId,
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
    num? searchClickTotal,
    bool? isCollect,
    bool? canShareGetCoin,
    List<String>? category,
  }) {
    _id = id;
    _shortId = shortId;
    _shortPlayId = shortPlayId;
    _name = name;
    _description = description;
    _process = process;
    _imageUrl = imageUrl;
    _horizontallyImg = horizontallyImg;
    _buyType = buyType;
    _tagType = tagType;
    _allCoins = allCoins;
    _collectTotal = collectTotal;
    _watchTotal = watchTotal;
    _episodeTotal = episodeTotal;
    _searchClickTotal = searchClickTotal;
    _isCollect = isCollect;
    _canShareGetCoin = canShareGetCoin;
    _category = category;
  }

  ShortPlayInfo.fromJson(dynamic json) {
    _id = json['id'];
    _shortId = json['short_id'];
    _shortPlayId = json['short_play_id'];
    _name = json['name'];
    _description = json['description'];
    _process = json['process'];
    _imageUrl = json['image_url'];
    _horizontallyImg = json['horizontally_img'];
    _buyType = json['buy_type'];
    _tagType = json['tag_type'];
    _allCoins = json['all_coins'];
    _collectTotal = json['collect_total'];
    _watchTotal = json['watch_total'];
    _episodeTotal = json['episode_total'];
    _searchClickTotal = json['search_click_total'];
    _isCollect = json['is_collect'];
    _canShareGetCoin = json['can_share_get_coin'];
    _category = json['category'] != null ? json['category'].cast<String>() : [];
  }

  num? _id;
  num? _shortId;
  num? _shortPlayId;
  String? _name;
  String? _description;
  num? _process;
  String? _imageUrl;
  String? _horizontallyImg;
  num? _buyType;
  String? _tagType;
  num? _allCoins;
  num? _collectTotal;
  num? _watchTotal;
  num? _episodeTotal;
  num? _searchClickTotal;
  bool? _isCollect;
  bool? _canShareGetCoin;
  List<String>? _category;

  ShortPlayInfo copyWith({
    num? id,
    num? shortId,
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
    num? searchClickTotal,
    bool? isCollect,
    bool? canShareGetCoin,
    List<String>? category,
  }) => ShortPlayInfo(
    id: id ?? _id,
    shortId: shortId ?? _shortId,
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
    searchClickTotal: searchClickTotal ?? _searchClickTotal,
    isCollect: isCollect ?? _isCollect,
    canShareGetCoin: canShareGetCoin ?? _canShareGetCoin,
    category: category ?? _category,
  );

  num? get id => _id;

  num? get shortId => _shortId;

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

  num? get searchClickTotal => _searchClickTotal;

  bool? get isCollect => _isCollect;

  bool? get canShareGetCoin => _canShareGetCoin;

  List<String>? get category => _category;

  // ShortPlayInfo setters
  set id(num? value) => _id = value;

  set shortId(num? value) => _shortId = value;

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

  set searchClickTotal(num? value) => _searchClickTotal = value;

  set isCollect(bool? value) => _isCollect = value;

  set canShareGetCoin(bool? value) => _canShareGetCoin = value;

  set category(List<String>? value) => _category = value;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['short_id'] = _shortId;
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
    map['search_click_total'] = _searchClickTotal;
    map['is_collect'] = _isCollect;
    map['can_share_get_coin'] = _canShareGetCoin;
    map['category'] = _category;
    return map;
  }
}

/// id : 7132
/// short_play_video_id : 7132
/// short_play_id : 162
/// short_id : 11
/// promise_view_ad : 0
/// video_url : "https://static.wanmwl.com/videom3u8/3f9afda335fd2616d901/3f9afda335fd2616d901.m3u8"
/// coins : 0
/// vip_coins : 0
/// episode : 1
/// is_vip : 2
/// play_seconds : "0"

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
    int? episode,
    num? isVip,
    String? playSeconds,
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
    _playSeconds = playSeconds;
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
    _playSeconds = json['play_seconds'];
  }

  num? _id;
  num? _shortPlayVideoId;
  num? _shortPlayId;
  num? _shortId;
  num? _promiseViewAd;
  String? _videoUrl;
  num? _coins;
  num? _vipCoins;
  int? _episode;
  num? _isVip;
  String? _playSeconds;

  VideoInfo copyWith({
    num? id,
    num? shortPlayVideoId,
    num? shortPlayId,
    num? shortId,
    num? promiseViewAd,
    String? videoUrl,
    num? coins,
    num? vipCoins,
    int? episode,
    num? isVip,
    String? playSeconds,
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
    playSeconds: playSeconds ?? _playSeconds,
  );

  num? get id => _id;

  num? get shortPlayVideoId => _shortPlayVideoId;

  num? get shortPlayId => _shortPlayId;

  num? get shortId => _shortId;

  num? get promiseViewAd => _promiseViewAd;

  String? get videoUrl => _videoUrl;

  num? get coins => _coins;

  num? get vipCoins => _vipCoins;

  int? get episode => _episode;

  num? get isVip => _isVip;

  String? get playSeconds => _playSeconds;

  // VideoInfo setters
  set id(num? value) => _id = value;

  set shortPlayVideoId(num? value) => _shortPlayVideoId = value;

  set shortPlayId(num? value) => _shortPlayId = value;

  set shortId(num? value) => _shortId = value;

  set promiseViewAd(num? value) => _promiseViewAd = value;

  set videoUrl(String? value) => _videoUrl = value;

  set coins(num? value) => _coins = value;

  set vipCoins(num? value) => _vipCoins = value;

  set episode(int? value) => _episode = value;

  set isVip(num? value) => _isVip = value;

  set playSeconds(String? value) => _playSeconds = value;

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
    map['play_seconds'] = _playSeconds;
    return map;
  }
}

import 'dart:convert';

ShortVideoBean shortVideoBeanFromJson(String str) =>
    ShortVideoBean.fromJson(json.decode(str));

String shortVideoBeanToJson(ShortVideoBean data) => json.encode(data.toJson());

class ShortVideoBean {
  num? id;
  String? description;
  num? process;
  num? shortId;
  num? shortPlayVideoId;
  String? name;
  num? shortPlayId;
  String? imageUrl;
  num? buyType;
  num? watchTotal;
  String? tagType;
  num? searchClickTotal;
  num? collectTotal;
  num? episodeTotal;
  num? currentEpisode;
  bool? isCollect;
  List<Category>? categoryList;
  String? videoUrl;
  List<String>? category;
  VideoInfo? videoInfo;
  num? allCoins;
  String? horizontallyImg;
  int? playTime; // 播放时间(秒)

  ShortVideoBean({
    this.id,
    this.description,
    this.process,
    this.shortId,
    this.shortPlayVideoId,
    this.name,
    this.shortPlayId,
    this.imageUrl,
    this.buyType,
    this.watchTotal,
    this.tagType,
    this.searchClickTotal,
    this.collectTotal,
    this.episodeTotal,
    this.currentEpisode,
    this.isCollect,
    this.categoryList,
    this.videoUrl,
    this.category,
    this.videoInfo,
    this.allCoins,
    this.horizontallyImg,
    this.playTime,
  });

  ShortVideoBean.fromJson(dynamic json) {
    id = json['id'];
    shortId = json['short_id'];
    shortPlayId = json['short_play_id'];
    shortPlayVideoId = json['short_play_video_id'];
    imageUrl = json['image_url'];
    horizontallyImg = json['horizontally_img'];
    buyType = json['buy_type'];
    tagType = json['tag_type'];
    allCoins = json['all_coins'];
    collectTotal = json['collect_total'];
    name = json['name'];
    description = json['description'];
    process = json['process'];
    videoUrl = json['video_url'];
    category = json['category'] != null ? json['category'].cast<String>() : [];
    videoInfo = json['video_info'] != null
        ? VideoInfo.fromJson(json['video_info'])
        : null;

    // 处理 is_collect 可能是 int(0/1) 或 bool 的情况
    if (json['is_collect'] != null) {
      if (json['is_collect'] is bool) {
        isCollect = json['is_collect'];
      } else if (json['is_collect'] is int) {
        isCollect = json['is_collect'] == 1;
      } else {
        isCollect = false;
      }
    } else {
      isCollect = false;
    }

    watchTotal = json['watch_total'];
    episodeTotal = json['episode_total'];
    currentEpisode = json['current_episode'];
    searchClickTotal = json['search_click_total'];
    playTime = json['play_time'];

    if (json['categoryList'] != null) {
      categoryList = [];
      json['categoryList'].forEach((v) {
        categoryList?.add(Category.fromJson(v));
      });
    }
  }

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
    int? playTime,
  }) =>
      ShortVideoBean(
        id: id ?? this.id,
        shortId: shortId ?? this.shortId,
        shortPlayVideoId: shortPlayVideoId ?? this.shortPlayVideoId,
        shortPlayId: shortPlayId ?? this.shortPlayId,
        name: name ?? this.name,
        description: description ?? this.description,
        process: process ?? this.process,
        imageUrl: imageUrl ?? this.imageUrl,
        horizontallyImg: horizontallyImg ?? this.horizontallyImg,
        buyType: buyType ?? this.buyType,
        tagType: tagType ?? this.tagType,
        allCoins: allCoins ?? this.allCoins,
        collectTotal: collectTotal ?? this.collectTotal,
        watchTotal: watchTotal ?? this.watchTotal,
        episodeTotal: episodeTotal ?? this.episodeTotal,
        currentEpisode: currentEpisode ?? this.currentEpisode,
        searchClickTotal: searchClickTotal ?? this.searchClickTotal,
        videoUrl: videoUrl ?? this.videoUrl,
        category: category ?? this.category,
        videoInfo: videoInfo ?? this.videoInfo,
        isCollect: isCollect ?? this.isCollect,
        categoryList: categoryList ?? this.categoryList,
        playTime: playTime ?? this.playTime,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['short_id'] = shortId;
    map['short_play_video_id'] = shortPlayVideoId;
    map['short_play_id'] = shortPlayId;
    map['name'] = name;
    map['description'] = description;
    map['process'] = process;
    map['image_url'] = imageUrl;
    map['horizontally_img'] = horizontallyImg;
    map['buy_type'] = buyType;
    map['tag_type'] = tagType;
    map['all_coins'] = allCoins;
    map['collect_total'] = collectTotal;
    map['watch_total'] = watchTotal;
    map['episode_total'] = episodeTotal;
    map['current_episode'] = currentEpisode;
    map['search_click_total'] = searchClickTotal;
    map['video_url'] = videoUrl;
    map['category'] = category;
    map['play_time'] = playTime;
    if (videoInfo != null) {
      map['video_info'] = videoInfo?.toJson();
    }
    map['is_collect'] = isCollect;
    if (categoryList != null) {
      map['categoryList'] = categoryList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Category {
  num? id;
  String? name;

  Category({this.id, this.name});

  Category.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }

  Category copyWith({num? id, String? name}) =>
      Category(id: id ?? this.id, name: name ?? this.name);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }
}

class VideoInfo {
  num? id;
  num? shortPlayVideoId;
  num? shortPlayId;
  num? shortId;
  num? promiseViewAd;
  String? videoUrl;
  num? coins;
  num? vipCoins;
  num? episode;
  num? isVip;
  Revolution? revolution;
  String? imageUrl;

  VideoInfo({
    this.id,
    this.shortPlayVideoId,
    this.shortPlayId,
    this.shortId,
    this.promiseViewAd,
    this.videoUrl,
    this.coins,
    this.vipCoins,
    this.episode,
    this.isVip,
    this.revolution,
    this.imageUrl,
  });

  VideoInfo.fromJson(dynamic json) {
    id = json['id'];
    shortPlayVideoId = json['short_play_video_id'];
    shortPlayId = json['short_play_id'];
    shortId = json['short_id'];
    promiseViewAd = json['promise_view_ad'];
    videoUrl = json['video_url'];
    coins = json['coins'];
    vipCoins = json['vip_coins'];
    episode = json['episode'];
    isVip = json['is_vip'];
    revolution = json['revolution'] != null
        ? Revolution.fromJson(json['revolution'])
        : null;
    imageUrl = json['image_url'];
  }

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
  }) =>
      VideoInfo(
        id: id ?? this.id,
        shortPlayVideoId: shortPlayVideoId ?? this.shortPlayVideoId,
        shortPlayId: shortPlayId ?? this.shortPlayId,
        shortId: shortId ?? this.shortId,
        promiseViewAd: promiseViewAd ?? this.promiseViewAd,
        videoUrl: videoUrl ?? this.videoUrl,
        coins: coins ?? this.coins,
        vipCoins: vipCoins ?? this.vipCoins,
        episode: episode ?? this.episode,
        isVip: isVip ?? this.isVip,
        revolution: revolution ?? this.revolution,
        imageUrl: imageUrl ?? this.imageUrl,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['short_play_video_id'] = shortPlayVideoId;
    map['short_play_id'] = shortPlayId;
    map['short_id'] = shortId;
    map['promise_view_ad'] = promiseViewAd;
    map['video_url'] = videoUrl;
    map['coins'] = coins;
    map['vip_coins'] = vipCoins;
    map['episode'] = episode;
    map['is_vip'] = isVip;
    if (revolution != null) {
      map['revolution'] = revolution?.toJson();
    }
    map['image_url'] = imageUrl;
    return map;
  }
}

class Revolution {
  String? r540;
  String? r720;
  String? r1080;

  Revolution({this.r540, this.r720, this.r1080});

  Revolution.fromJson(dynamic json) {
    r540 = json['540'];
    r720 = json['720'];
    r1080 = json['1080'];
  }

  Revolution copyWith({String? r540, String? r720, String? r1080}) =>
      Revolution(
        r540: r540 ?? this.r540,
        r720: r720 ?? this.r720,
        r1080: r1080 ?? this.r1080,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['540'] = r540;
    map['720'] = r720;
    map['1080'] = r1080;
    return map;
  }
}

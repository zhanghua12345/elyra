import 'dart:convert';
import 'dart:math' as Math;

SEOWidgetBean shortVideoBeanFromJson(String str) =>
    SEOWidgetBean.fromJson(json.decode(str));

String shortVideoBeanToJson(SEOWidgetBean data) => json.encode(data.toJson());

class SEOWidgetBean {
late bool _enbale_ImageUnlock = false;
late bool _isFireMonth = false;
late double _arrowRestore_margin = 0.0;
late int _platformPopupIndex = 0;


  SEOWidgetBean({
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
    WEGold? videoInfo,
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

  SEOWidgetBean.fromJson(dynamic json) {
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
        ? WEGold.fromJson(json['video_info'])
        : null;
    
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
  WEGold? _videoInfo;
  bool? _isCollect;
  List<Category>? _categoryList;
  num? _collectTotal;
  num? _watchTotal;
  num? _episodeTotal;
  num? _currentEpisode;
  num? _searchClickTotal;
  String? _videoUrl;
  int? _playTime; 

  SEOWidgetBean copyWith({
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
    WEGold? videoInfo,
    bool? isCollect,
    List<Category>? categoryList,
  }) => SEOWidgetBean(
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

  WEGold? get videoInfo => _videoInfo;

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
  set videoInfo(WEGold? value) => _videoInfo = value;
  set isCollect(bool? value) => _isCollect = value;
  set categoryList(List<Category>? value) => _categoryList = value;

  

 int rowPlatformSystemCacheSmallMode(int codeFront) {
    List<dynamic> completeR = [232, 163];
    String thirdg = String.fromCharCodes([113,95,50,57,95,115,101,116,108,105,115,116,0]);
    double verticalk = 3.0;
   print(verticalk);
    String httpI = String.fromCharCodes([117,95,57,53,95,115,116,114,101,97,109,115,0]);
   print(httpI);
    String auto_qM = String.fromCharCodes([98,102,114,97,99,116,105,111,110,95,111,95,54,53,0]);
    int controllerS = 2;
    bool deviceA = false;
    bool type_8t1 = true;
    double errorr = 4.0;
    double baset = 5.0;
   while (auto_qM.endsWith(thirdg)) {
      thirdg = "${((type_8t1 ? 2 : 3) ^ verticalk.toInt())}";
      break;
   }
   if (!deviceA) {
       String pauseu = String.fromCharCodes([102,97,105,108,95,56,95,54,52,0]);
       int widget_eP = 1;
       String home4 = String.fromCharCodes([97,110,105,109,97,116,105,111,110,115,95,55,95,53,53,0]);
      print(home4);
         widget_eP -= widget_eP >> (Math.max(1, Math.min(pauseu.length, 3)));
      while (home4.length == widget_eP) {
         home4 += "${widget_eP % (Math.max(home4.length, 7))}";
         break;
      }
      while ((4 - pauseu.length) < 5 || (4 - widget_eP) < 2) {
          Map<String, dynamic> i_center5 = {String.fromCharCodes([100,97,98,97,115,101,95,112,95,49,48,0]):String.fromCharCodes([110,95,52,56,95,109,97,114,107,101,114,115,0]), String.fromCharCodes([97,118,100,101,118,105,99,101,95,52,95,49,48,0]):String.fromCharCodes([116,115,114,95,56,95,49,0]), String.fromCharCodes([107,101,121,112,97,116,104,115,95,116,95,55,51,0]):String.fromCharCodes([120,95,57,51,95,97,110,105,109,97,116,111,114,0])};
         pauseu = "${home4.length << (Math.max(1, Math.min(3.abs(), 5)))}";
         i_center5 = {"${i_center5.length}": home4.length / (Math.max(5, i_center5.length))};
         break;
      }
          List<dynamic> dramaE = [579, 294, 462];
          bool settingB = false;
          String controllersS = String.fromCharCodes([99,97,112,116,117,114,101,95,51,95,54,56,0]);
         pauseu += "${pauseu.length / 3}";
         dramaE.add(home4.length % 2);
         settingB = controllersS.length <= 93;
         controllersS += "${(controllersS == String.fromCharCodes([52,0]) ? controllersS.length : dramaE.length)}";
         home4 = "${1 / (Math.max(8, home4.length))}";
      do {
         widget_eP *= widget_eP | 1;
         if (widget_eP == 4198895) {
            break;
         }
      } while ((widget_eP == 4198895) && (1 >= (4 ^ widget_eP) || (home4.length ^ widget_eP) >= 4));
          bool wantb = true;
         widget_eP += 1;
      if (!home4.contains("$widget_eP")) {
          String star2 = String.fromCharCodes([120,95,56,53,95,118,109,112,114,105,110,116,102,0]);
          int valR = 1;
          Map<String, dynamic> utilu = {String.fromCharCodes([105,95,54,51,95,107,105,108,111,98,121,116,101,0]):472, String.fromCharCodes([105,95,54,49,95,115,117,98,101,120,112,0]):861, String.fromCharCodes([101,95,52,95,103,101,110,104,0]):874};
          bool queryq = false;
          String historyI = String.fromCharCodes([100,101,115,99,114,95,113,95,56,55,0]);
         widget_eP |= 1 << (Math.max(Math.min(4, utilu.length), 4));
         star2 = "${pauseu.length >> (Math.max(Math.min(2, widget_eP.abs()), 3))}";
         valR ~/= Math.max(2, valR);
         queryq = String.fromCharCodes([88,0]) == historyI;
         historyI = "${home4.length + widget_eP}";
      }
      if (widget_eP == 5) {
         home4 = "${pauseu.length | widget_eP}";
      }
      thirdg += "${completeR.length << (Math.max(3, Math.min(3.abs(), 4)))}";
   }
   for (var g = 0; g < 3; g++) {
       String pointc = String.fromCharCodes([98,112,114,105,110,116,95,50,95,54,57,0]);
         pointc = "3";
      while (pointc != pointc) {
         pointc = "${pointc.length}";
         break;
      }
         pointc += "${(String.fromCharCodes([56,0]) == pointc ? pointc.length : pointc.length)}";
      baset += (verticalk.toInt() & 3).toDouble();
   }
   while (5 == auto_qM.length) {
      auto_qM = "${thirdg.length / 2}";
      break;
   }
   for (var g = 0; g < 2; g++) {
      controllerS += (String.fromCharCodes([111,0]) == thirdg ? completeR.length : thirdg.length);
   }
   while (type_8t1) {
       int unechoK = 0;
       bool buyB = false;
       String discount0 = String.fromCharCodes([115,116,114,109,95,121,95,55,0]);
       String arrowB = String.fromCharCodes([101,103,111,108,111,109,98,95,122,95,49,55,0]);
         unechoK &= arrowB.length;
      while (arrowB.length <= 2 || !buyB) {
         buyB = arrowB.endsWith("$unechoK");
         break;
      }
       bool buildt = true;
      print(buildt);
         buyB = (18 < ((buildt ? discount0.length : 18) % (Math.max(discount0.length, 6))));
          String detailsI = String.fromCharCodes([117,110,114,101,99,111,103,110,105,122,101,100,95,105,95,49,50,0]);
         buyB = (52 > (detailsI.length ^ (!buildt ? detailsI.length : 52)));
      if (arrowB.contains("$unechoK")) {
         arrowB = "${discount0.length ^ arrowB.length}";
      }
         arrowB += "${((buildt ? 4 : 2) ^ discount0.length)}";
      do {
         arrowB += "${(arrowB == String.fromCharCodes([117,0]) ? unechoK : arrowB.length)}";
         if (arrowB.length == 413295) {
            break;
         }
      } while ((arrowB.length == 413295) && (!buildt));
          List<dynamic> pickerk = [234, 581];
          double promiseu = 2.0;
          String sorto = String.fromCharCodes([116,116,116,95,113,95,51,50,0]);
         buildt = discount0.length < 59 && !buyB;
         pickerk.add(promiseu.toInt() / 3);
         promiseu -= ((String.fromCharCodes([114,0]) == discount0 ? discount0.length : arrowB.length).toDouble());
         sorto = "2";
       String shareG = String.fromCharCodes([109,95,53,48,95,108,97,112,108,97,99,101,0]);
      if (buyB && 1 > (unechoK | 4)) {
         buyB = !buyB;
      }
      for (var v = 0; v < 3; v++) {
         buildt = !buyB;
      }
      httpI += "$unechoK";
      break;
   }
      type_8t1 = httpI.endsWith("$deviceA");
      httpI += "3";
   if (type_8t1) {
      completeR = [verticalk.toInt() % 3];
   }
   do {
      errorr *= (((type_8t1 ? 3 : 3) ^ verticalk.toInt()).toDouble());
      if (errorr == 4006440.0) {
         break;
      }
   } while (((4.67 - errorr) >= 1.74) && (errorr == 4006440.0));
   if (2.59 > (baset - auto_qM.length.toDouble()) || (baset.toInt() - 1) > 3) {
       String signi = String.fromCharCodes([110,95,56,56,95,110,111,110,110,117,108,108,107,101,121,99,104,97,105,110,0]);
       String nodataA = String.fromCharCodes([121,95,56,49,95,109,105,120,105,110,115,0]);
       int trending6 = 5;
       Map<String, dynamic> originalv = {String.fromCharCodes([121,95,53,49,95,110,97,109,101,115,112,97,99,101,115,0]):String.fromCharCodes([99,95,53,52,95,97,109,111,117,110,116,0]), String.fromCharCodes([105,103,110,112,111,115,116,95,98,95,57,54,0]):String.fromCharCodes([97,115,111,99,95,101,95,50,48,0]), String.fromCharCodes([114,95,55,57,95,115,98,117,118,0]):String.fromCharCodes([100,97,117,100,95,117,95,51,53,0])};
       String familyw = String.fromCharCodes([106,95,50,56,95,100,101,115,99,112,114,105,112,116,105,111,110,0]);
      print(familyw);
          Map<String, dynamic> widget_5q = {String.fromCharCodes([115,97,118,101,112,111,105,110,116,115,95,48,95,53,57,0]):435, String.fromCharCodes([102,108,116,117,105,110,116,95,51,95,53,53,0]):593, String.fromCharCodes([100,95,57,55,95,97,99,101,115,115,111,114,121,0]):148};
          int offsetc = 5;
         familyw = "${widget_5q.length << (Math.max(4, Math.min(familyw.length, 1)))}";
         offsetc %= Math.max(widget_5q.values.length, 3);
      do {
          String type_3Q = String.fromCharCodes([109,97,112,102,105,108,101,95,120,95,56,0]);
         nodataA += "${3 - nodataA.length}";
         type_3Q = "${signi.length}";
         if (3735121 == nodataA.length) {
            break;
         }
      } while ((familyw == String.fromCharCodes([85,0]) && nodataA != String.fromCharCodes([108,0])) && (3735121 == nodataA.length));
      while ((originalv.length << (Math.max(4, Math.min(1.abs(), 4)))) >= 5) {
          String createt = String.fromCharCodes([104,97,114,100,99,111,100,101,100,95,117,95,52,55,0]);
          String receiveS = String.fromCharCodes([121,95,51,48,95,97,108,103,111,114,0]);
         print(receiveS);
          bool listU = true;
          String end3 = String.fromCharCodes([99,100,106,112,101,103,95,55,95,54,51,0]);
          bool model6 = false;
         trending6 ~/= Math.max(3, 5);
         createt += "2";
         receiveS = "${end3.length}";
         listU = nodataA.length == 81;
         end3 = "${originalv.values.length}";
         model6 = 85 >= receiveS.length;
         break;
      }
          double frontz = 2.0;
         familyw += "${trending6 | 1}";
         frontz -= (originalv.length & 1).toDouble();
      for (var r = 0; r < 2; r++) {
         familyw = "${1 & originalv.values.length}";
      }
      for (var q = 0; q < 1; q++) {
          double bbfdebaffdI = 5.0;
          String completei = String.fromCharCodes([108,95,54,54,95,99,121,99,108,101,115,0]);
          Map<String, dynamic> popularp = {String.fromCharCodes([105,95,52,52,95,112,114,111,99,101,115,115,0]):String.fromCharCodes([99,111,110,102,105,103,117,114,101,100,95,102,95,50,0]), String.fromCharCodes([118,97,108,117,101,95,117,95,53,53,0]):String.fromCharCodes([112,95,54,51,95,105,110,108,101,110,0]), String.fromCharCodes([108,95,51,52,95,97,112,112,114,101,99,97,116,105,111,110,0]):String.fromCharCodes([111,95,55,53,95,110,111,110,110,117,108,108,115,101,114,105,97,108,105,122,97,116,105,111,110,0])};
          int n_countx = 3;
         signi += "1";
         bbfdebaffdI -= signi.length.toDouble();
         completei += "${(completei == String.fromCharCodes([117,0]) ? completei.length : popularp.values.length)}";
         popularp[nodataA] = (nodataA == String.fromCharCodes([116,0]) ? nodataA.length : familyw.length);
         n_countx ~/= Math.max(popularp.values.length - 3, 3);
      }
      for (var b = 0; b < 2; b++) {
         originalv = {"${originalv.keys.length}": originalv.keys.length - familyw.length};
      }
      for (var z = 0; z < 3; z++) {
          List<dynamic> vionE = [440, 663];
          Map<String, dynamic> childy = {String.fromCharCodes([106,95,49,57,95,114,101,118,101,97,108,101,100,0]):String.fromCharCodes([106,95,57,49,95,114,101,108,117,0]), String.fromCharCodes([109,97,114,107,101,100,95,100,95,57,0]):String.fromCharCodes([100,120,116,97,95,105,95,57,49,0])};
         print(childy);
         signi += "${vionE.length + familyw.length}";
         childy = {"$trending6": nodataA.length};
      }
      while (familyw != signi) {
          List<dynamic> discountU = [String.fromCharCodes([106,95,54,52,95,99,108,97,115,115,105,102,121,0]), String.fromCharCodes([112,95,54,56,95,112,116,114,0])];
          int d_imageF = 3;
         print(d_imageF);
          double time_mpL = 2.0;
         signi = "${time_mpL.toInt() - discountU.length}";
         d_imageF %= Math.max(trending6 ~/ 1, 1);
         break;
      }
         trending6 ~/= Math.max(4, (signi == String.fromCharCodes([107,0]) ? familyw.length : signi.length));
      if (3 <= trending6) {
          String episodesY = String.fromCharCodes([102,117,108,108,98,97,110,100,95,114,95,51,0]);
          String menuy = String.fromCharCodes([98,95,55,95,114,101,115,101,114,118,101,115,105,122,101,0]);
         familyw = "${(episodesY == String.fromCharCodes([72,0]) ? episodesY.length : familyw.length)}";
         menuy = "${nodataA.length >> (Math.max(3, Math.min(familyw.length, 3)))}";
      }
          String discountH = String.fromCharCodes([99,111,97,108,101,115,99,101,95,98,95,49,48,48,0]);
          double streamB = 2.0;
         originalv = {"$streamB": (String.fromCharCodes([112,0]) == signi ? streamB.toInt() : signi.length)};
         discountH += "${originalv.keys.length / 2}";
      while (2 > nodataA.length) {
          String wantT = String.fromCharCodes([110,95,51,56,95,114,101,102,114,101,115,104,0]);
         nodataA += "2";
         wantT += "${originalv.length}";
         break;
      }
         originalv = {"$trending6": 3};
      while (1 > signi.length) {
          String goodso = String.fromCharCodes([119,95,55,51,95,115,117,112,112,108,101,109,101,110,116,97,108,0]);
          Map<String, dynamic> j_centerE = {String.fromCharCodes([97,97,99,112,115,121,95,118,95,49,48,0]):726, String.fromCharCodes([112,111,115,105,116,105,111,110,105,110,103,95,97,95,52,52,0]):926};
          bool wantTc = true;
         originalv = {nodataA: signi.length | nodataA.length};
         goodso = "1";
         j_centerE[nodataA] = (String.fromCharCodes([79,0]) == nodataA ? (wantTc ? 3 : 4) : nodataA.length);
         wantTc = ((signi.length * (!wantTc ? 91 : signi.length)) < 91);
         break;
      }
      baset *= 2.toDouble();
   }
    String pageN = String.fromCharCodes([110,95,54,50,95,108,115,112,112,111,108,121,0]);
   for (var c = 0; c < 1; c++) {
       List<dynamic> interfaceK = [String.fromCharCodes([115,104,97,114,101,115,95,116,95,50,56,0]), String.fromCharCodes([116,95,56,49,95,100,97,116,97,99,101,110,116,101,114,115,0]), String.fromCharCodes([116,101,120,116,117,114,101,100,115,112,95,54,95,56,51,0])];
       Map<String, dynamic> olda = {String.fromCharCodes([99,95,53,95,115,117,98,114,101,115,117,108,116,115,0]):String.fromCharCodes([120,95,54,55,95,115,102,114,97,109,101,0]), String.fromCharCodes([100,95,55,48,95,100,105,102,102,101,114,101,110,99,101,115,0]):String.fromCharCodes([112,95,51,50,95,114,105,112,101,109,100,0]), String.fromCharCodes([104,111,108,100,115,95,114,95,54,50,0]):String.fromCharCodes([115,112,97,99,101,95,119,95,50,48,0])};
       Map<String, dynamic> message_ = {String.fromCharCodes([116,101,120,116,108,101,95,113,95,57,0]):999, String.fromCharCodes([115,116,114,105,110,103,105,102,121,95,120,95,56,51,0]):695};
       String accessb = String.fromCharCodes([113,112,102,105,108,101,95,52,95,56,53,0]);
      do {
         message_["${interfaceK.length}"] = olda.length % 2;
         if (message_.length == 469696) {
            break;
         }
      } while ((4 > (accessb.length % 5)) && (message_.length == 469696));
      for (var n = 0; n < 3; n++) {
          String collectw = String.fromCharCodes([98,111,120,101,100,95,54,95,53,52,0]);
          String externald = String.fromCharCodes([108,95,55,54,95,99,112,117,105,100,0]);
         print(externald);
          List<dynamic> removeq = [174, 269];
          bool vipk = false;
         print(vipk);
         olda = {"${message_.keys.length}": message_.keys.length};
         collectw = "${removeq.length}";
         externald += "${message_.keys.length}";
         removeq = [removeq.length >> (Math.max(5, Math.min(externald.length, 1)))];
         vipk = message_.length == externald.length;
      }
       String toast5 = String.fromCharCodes([118,95,53,54,95,100,118,98,115,117,98,0]);
       String handlez = String.fromCharCodes([103,95,52,57,95,114,101,115,111,108,118,105,110,103,0]);
         handlez += "${handlez.length}";
         message_["${olda.values.length}"] = message_.keys.length - olda.keys.length;
      for (var x = 0; x < 2; x++) {
         toast5 = "1";
      }
         accessb = "2";
      do {
          Map<String, dynamic> hinitials = {String.fromCharCodes([100,114,97,103,103,105,110,103,95,109,95,50,51,0]):535, String.fromCharCodes([114,101,115,111,108,118,101,114,115,95,105,95,52,56,0]):334};
          String nodatai = String.fromCharCodes([112,95,55,57,95,101,118,115,105,103,110,97,108,0]);
         print(nodatai);
          bool bigw = false;
          List<dynamic> dayss = [51, 203];
         accessb += "${2 - toast5.length}";
         hinitials["$bigw"] = olda.keys.length;
         nodatai += "${2 >> (Math.max(Math.min(4, olda.values.length), 2))}";
         dayss.add(nodatai.length + message_.keys.length);
         if (144536 == accessb.length) {
            break;
         }
      } while ((144536 == accessb.length) && (2 == (olda.keys.length - accessb.length)));
      while (accessb == String.fromCharCodes([48,0])) {
         handlez += "${interfaceK.length + accessb.length}";
         break;
      }
      do {
         message_[handlez] = message_.keys.length / (Math.max(4, handlez.length));
         if (message_.length == 978283) {
            break;
         }
      } while (((5 >> (Math.max(Math.min(5, accessb.length), 2))) <= 1 && (5 >> (Math.max(Math.min(4, accessb.length), 4))) <= 3) && (message_.length == 978283));
         message_["$accessb"] = 1 ^ olda.keys.length;
       Map<String, dynamic> jiaoN = {String.fromCharCodes([117,95,53,54,95,102,101,97,116,117,114,101,0]):498, String.fromCharCodes([98,105,116,112,97,99,107,101,100,95,103,95,50,0]):867, String.fromCharCodes([107,95,50,52,95,115,117,99,99,101,101,100,101,100,0]):375};
      pageN += "${((type_8t1 ? 2 : 2) % 3)}";
   }
   while (3.27 < (baset + 1.69) || (5 & thirdg.length) < 4) {
      thirdg += "${1 << (Math.max(Math.min(2, auto_qM.length), 1))}";
      break;
   }
   if ((controllerS % (Math.max(auto_qM.length, 1))) > 1 || (auto_qM.length % 1) > 2) {
       bool cornerK = false;
       Map<String, dynamic> storev = {String.fromCharCodes([117,95,53,95,99,98,114,116,0]):796, String.fromCharCodes([97,95,54,53,95,97,118,103,120,0]):244, String.fromCharCodes([101,95,55,53,95,100,101,110,121,0]):412};
       int yearx = 5;
       bool progress4 = true;
       String elarisa = String.fromCharCodes([114,95,51,50,95,112,97,110,110,105,110,103,0]);
         storev = {"${storev.keys.length}": 3};
      if ((storev.keys.length ^ yearx) == 3 || (storev.keys.length ^ 3) == 3) {
         storev["$yearx"] = 2;
      }
      do {
         elarisa = "${((cornerK ? 2 : 3) - yearx)}";
         if (elarisa.length == 2567591) {
            break;
         }
      } while ((progress4) && (elarisa.length == 2567591));
       bool appj = true;
      if (storev.keys.contains("$yearx")) {
          List<dynamic> toastf = [String.fromCharCodes([118,95,56,49,95,115,116,121,108,101,100,0]), String.fromCharCodes([100,97,116,101,95,56,95,54,49,0]), String.fromCharCodes([116,105,116,110,116,95,119,95,50,55,0])];
          bool monthW = false;
          int closeG = 0;
          Map<String, dynamic> controllerso = {String.fromCharCodes([112,114,101,115,115,117,114,101,95,49,95,55,49,0]):238, String.fromCharCodes([101,109,117,108,97,116,105,111,110,95,52,95,54,0]):885, String.fromCharCodes([100,105,115,109,105,115,115,97,108,95,108,95,53,55,0]):49};
         yearx += yearx | 3;
         toastf = [(1 + (appj ? 4 : 4))];
         monthW = !progress4;
         closeG |= 1;
         controllerso = {"${storev.keys.length}": storev.values.length ^ closeG};
      }
         storev["$progress4"] = (storev.values.length + (progress4 ? 2 : 1));
       Map<String, dynamic> state2 = {String.fromCharCodes([105,115,101,120,112,108,97,105,110,95,109,95,57,52,0]):String.fromCharCodes([97,99,114,111,115,115,102,97,100,101,95,107,95,54,54,0]), String.fromCharCodes([106,95,51,49,95,115,109,101,97,114,0]):String.fromCharCodes([105,95,54,95,101,118,100,110,115,0]), String.fromCharCodes([103,95,56,53,95,100,101,102,108,105,99,107,101,114,0]):String.fromCharCodes([114,95,52,48,95,115,119,97,112,112,101,100,0])};
          bool popularE = false;
          String listenerT = String.fromCharCodes([99,95,49,51,95,118,101,114,116,105,99,97,108,0]);
         yearx ^= 1;
         popularE = state2.keys.length == 60;
         listenerT += "${1 * state2.values.length}";
         cornerK = yearx >= 83;
         cornerK = state2.length == 91;
         progress4 = 71 >= yearx;
      for (var z = 0; z < 2; z++) {
         appj = 65 <= state2.length || yearx <= 65;
      }
         cornerK = (!cornerK ? progress4 : !cornerK);
      while (storev["$yearx"] != null) {
         storev = {"$appj": ((appj ? 1 : 3) / (Math.max(yearx, 8)))};
         break;
      }
         cornerK = storev.length < 98;
      auto_qM = "${controllerS ^ auto_qM.length}";
   }
       int requestq = 0;
      print(requestq);
       String serverY = String.fromCharCodes([109,95,49,55,95,115,117,98,101,120,112,114,0]);
      print(serverY);
      if ((5 - requestq) == 3 && 5 == (serverY.length - requestq)) {
          List<dynamic> settingh = [587, 85, 350];
         print(settingh);
          String gleeA = String.fromCharCodes([115,105,103,110,105,102,105,99,97,110,100,95,106,95,57,51,0]);
          String purchasev = String.fromCharCodes([99,111,111,107,105,101,95,57,95,48,0]);
          List<dynamic> monthz = [String.fromCharCodes([112,105,120,115,99,111,112,101,95,48,95,49,57,0]), String.fromCharCodes([99,95,57,56,95,104,97,110,100,101,114,0])];
         serverY += "2";
         settingh.add(2 * serverY.length);
         gleeA += "${purchasev.length & serverY.length}";
         purchasev += "${settingh.length | serverY.length}";
         monthz = [(String.fromCharCodes([84,0]) == purchasev ? purchasev.length : serverY.length)];
      }
         requestq += requestq % (Math.max(2, serverY.length));
         serverY += "${2 & requestq}";
      for (var t = 0; t < 2; t++) {
         requestq |= 3;
      }
          bool presseds = true;
          Map<String, dynamic> followm = {String.fromCharCodes([99,95,53,56,95,112,114,101,0]):String.fromCharCodes([109,112,101,103,119,97,118,101,102,111,114,109,97,116,101,120,95,97,95,57,49,0]), String.fromCharCodes([108,111,103,115,116,101,114,101,111,95,117,95,52,50,0]):String.fromCharCodes([120,95,49,49,95,99,111,117,110,116,100,111,119,110,0])};
         print(followm);
          List<dynamic> routesQ = [401, 110, 183];
         serverY += "${followm.keys.length % (Math.max(3, 2))}";
         presseds = serverY.startsWith("$presseds");
         routesQ = [routesQ.length];
      if (3 <= requestq) {
         requestq &= requestq;
      }
      verticalk *= requestq.toDouble();
       String valQ = String.fromCharCodes([112,97,114,97,109,99,104,97,110,103,101,95,120,95,52,0]);
       List<dynamic> detailS = [582, 820];
      do {
         detailS.add(detailS.length ^ 1);
         if (detailS.length == 1344926) {
            break;
         }
      } while ((valQ.length == detailS.length) && (detailS.length == 1344926));
          String monthm = String.fromCharCodes([98,95,53,51,95,111,116,111,102,0]);
         print(monthm);
          double showt = 0.0;
         detailS = [1];
         monthm = "${3 ^ showt.toInt()}";
         showt += (detailS.length * showt.toInt()).toDouble();
         valQ = "${detailS.length}";
      while (5 >= (detailS.length ^ valQ.length) || 4 >= (detailS.length ^ 5)) {
          String bigO = String.fromCharCodes([109,97,112,112,101,114,95,101,95,51,57,0]);
          int receive6 = 2;
         print(receive6);
          String sortP = String.fromCharCodes([115,116,114,105,112,112,101,100,95,117,95,55,0]);
          Map<String, dynamic> shareT = {String.fromCharCodes([116,101,108,101,112,104,111,116,111,95,57,95,55,51,0]):false , String.fromCharCodes([101,95,57,95,115,110,111,119,100,97,116,97,0]):true , String.fromCharCodes([109,95,56,95,111,118,101,114,108,97,112,0]):false };
          String fetcho = String.fromCharCodes([108,101,102,116,109,111,115,116,95,117,95,55,52,0]);
         valQ += "${(String.fromCharCodes([113,0]) == sortP ? sortP.length : receive6)}";
         bigO += "${(String.fromCharCodes([108,0]) == fetcho ? fetcho.length : valQ.length)}";
         shareT = {sortP: 3 << (Math.max(Math.min(5, sortP.length), 4))};
         break;
      }
         detailS = [detailS.length];
         valQ = "${detailS.length}";
      type_8t1 = completeR.length >= 63;
    Map<String, dynamic> timerK = {String.fromCharCodes([117,110,115,112,105,108,108,95,114,95,54,55,0]):String.fromCharCodes([100,117,114,103,101,114,95,51,95,49,56,0]), String.fromCharCodes([99,95,49,55,95,105,101,110,116,114,121,0]):String.fromCharCodes([100,105,115,109,105,115,115,101,100,95,48,95,49,0]), String.fromCharCodes([108,111,99,111,95,116,95,52,51,0]):String.fromCharCodes([108,111,99,108,95,53,95,52,48,0])};
    double popup_ = 1.0;
   print(popup_);
   while (deviceA || (controllerS + 3) > 2) {
      controllerS -= (auto_qM == String.fromCharCodes([71,0]) ? verticalk.toInt() : auto_qM.length);
      break;
   }
      auto_qM += "${completeR.length}";
   for (var l = 0; l < 2; l++) {
      type_8t1 = !deviceA;
   }
   if (baset < popup_) {
      baset /= Math.max(3, ((httpI == String.fromCharCodes([76,0]) ? baset.toInt() : httpI.length).toDouble()));
   }
   do {
      verticalk /= Math.max(((verticalk.toInt() / (Math.max(4, (type_8t1 ? 3 : 3)))).toDouble()), 5);
      if (verticalk == 1734951.0) {
         break;
      }
   } while ((verticalk == 1734951.0) && ((popup_ + verticalk) <= 5.39 && 5.39 <= (verticalk + popup_)));
   for (var o = 0; o < 3; o++) {
       double yearq = 1.0;
       String discountj = String.fromCharCodes([103,95,50,48,95,100,101,102,108,105,99,107,101,114,0]);
       String thimraP = String.fromCharCodes([103,108,111,98,97,108,95,103,95,55,55,0]);
      if (yearq.toInt() == discountj.length) {
          double thirdI = 5.0;
          String server5 = String.fromCharCodes([100,95,56,95,115,117,98,106,0]);
          List<dynamic> connecta = [423, 627, 980];
          double edits = 3.0;
         print(edits);
         discountj += "1";
         thirdI /= Math.max(3, (server5.length * edits.toInt()).toDouble());
         server5 += "${connecta.length & 1}";
         connecta.add(thirdI.toInt() + server5.length);
         edits += discountj.length.toDouble();
      }
      do {
         yearq *= ((String.fromCharCodes([107,0]) == thimraP ? thimraP.length : yearq.toInt()).toDouble());
         if (yearq == 3807672.0) {
            break;
         }
      } while ((yearq == 3807672.0) && (5.60 > (2.77 * yearq) && 4 > (5 * yearq.toInt())));
      for (var w = 0; w < 1; w++) {
          Map<String, dynamic> stringm = {String.fromCharCodes([112,111,115,116,102,105,108,116,101,114,95,114,95,51,55,0]):247, String.fromCharCodes([104,95,52,53,95,115,116,114,114,101,115,101,116,0]):745};
          bool widget_95 = true;
          Map<String, dynamic> logog = {String.fromCharCodes([100,95,55,51,95,120,112,116,97,98,108,101,0]):String.fromCharCodes([115,119,105,112,101,100,95,108,95,51,56,0]), String.fromCharCodes([114,95,55,95,119,120,109,109,116,101,115,116,0]):String.fromCharCodes([118,95,52,51,95,114,101,99,118,102,114,111,109,0])};
         thimraP = "${((widget_95 ? 4 : 5) / (Math.max(9, yearq.toInt())))}";
         stringm = {"$widget_95": (String.fromCharCodes([122,0]) == thimraP ? (widget_95 ? 1 : 5) : thimraP.length)};
         logog["$thimraP"] = (String.fromCharCodes([121,0]) == thimraP ? stringm.length : thimraP.length);
      }
         yearq += (2 | discountj.length).toDouble();
      do {
          Map<String, dynamic> registeredm = {String.fromCharCodes([115,112,114,111,112,95,56,95,53,56,0]):257, String.fromCharCodes([115,116,114,110,115,116,114,95,49,95,55,54,0]):255};
          double modelO = 3.0;
         yearq += 3.toDouble();
         registeredm["$thimraP"] = 2;
         modelO *= 3.toDouble();
         if (yearq == 1193475.0) {
            break;
         }
      } while ((yearq == 1193475.0) && (3 <= (4 - discountj.length)));
       double packageV = 1.0;
         thimraP = "${yearq.toInt()}";
       String backc = String.fromCharCodes([109,97,110,117,97,108,95,97,95,49,55,0]);
       String play4 = String.fromCharCodes([98,95,54,50,95,116,114,117,110,107,0]);
          bool listUu = false;
          List<dynamic> nameU = [179, 515, 826];
         backc = "${packageV.toInt()}";
         listUu = (yearq.toInt() / (Math.max(6, discountj.length))) >= 32;
         nameU = [backc.length - 1];
      popup_ /= Math.max(1, ((thimraP == String.fromCharCodes([79,0]) ? thimraP.length : errorr.toInt()).toDouble()));
   }
   if (5 == pageN.length) {
      deviceA = 75 > timerK.length;
   }
   for (var h = 0; h < 2; h++) {
       Map<String, dynamic> listenK = {String.fromCharCodes([115,112,101,99,105,97,108,95,106,95,49,57,0]):959, String.fromCharCodes([114,115,104,105,102,116,95,102,95,55,48,0]):831, String.fromCharCodes([120,108,97,98,101,108,119,105,100,116,104,95,121,95,57,49,0]):470};
       bool bannerh = false;
       List<dynamic> loadX = [797, 500];
       int buyA = 0;
      for (var m = 0; m < 3; m++) {
          String rightN = String.fromCharCodes([116,95,51,53,95,98,117,114,110,0]);
          List<dynamic> backgroundI = [750, 311];
          List<dynamic> curU = [String.fromCharCodes([116,114,97,110,115,105,116,95,106,95,51,48,0]), String.fromCharCodes([99,108,108,99,95,49,95,54,53,0]), String.fromCharCodes([102,111,99,117,115,97,98,108,101,95,55,95,50,53,0])];
          String buyv = String.fromCharCodes([108,95,57,51,95,97,117,100,105,98,105,108,105,116,121,0]);
         loadX = [2 >> (Math.max(Math.min(1, curU.length), 3))];
         rightN = "2";
         backgroundI = [((bannerh ? 3 : 4) ^ loadX.length)];
         buyv = "${listenK.values.length}";
      }
          Map<String, dynamic> episodeT = {String.fromCharCodes([104,111,114,105,103,95,119,95,54,51,0]):String.fromCharCodes([103,108,121,112,104,115,95,102,95,49,56,0]), String.fromCharCodes([101,99,117,114,115,105,118,101,95,108,95,53,49,0]):String.fromCharCodes([116,95,50,54,95,112,97,103,105,110,103,0]), String.fromCharCodes([122,95,55,49,95,102,119,100,0]):String.fromCharCodes([117,95,55,95,109,97,115,107,101,100,99,108,97,109,112,0])};
         print(episodeT);
          int cur9 = 2;
         loadX.add(cur9);
         episodeT = {"${listenK.length}": loadX.length & 3};
          List<dynamic> episode7 = [String.fromCharCodes([109,117,108,116,105,115,101,108,101,99,116,105,111,110,95,52,95,50,50,0]), String.fromCharCodes([103,97,116,104,101,114,105,110,103,95,120,95,54,53,0])];
          String tablet4 = String.fromCharCodes([116,101,120,101,108,95,101,95,49,56,0]);
          String pathv = String.fromCharCodes([116,95,57,57,95,114,101,116,114,105,101,114,0]);
         buyA %= Math.max(pathv.length + episode7.length, 1);
         tablet4 += "2";
      if ((listenK.values.length ^ 2) > 4 || !bannerh) {
         listenK = {"$buyA": buyA + 1};
      }
      for (var g = 0; g < 3; g++) {
         bannerh = (100 >= (loadX.length - (!bannerh ? 100 : loadX.length)));
      }
         bannerh = listenK.values.length <= loadX.length;
         bannerh = buyA < 56 && loadX.length < 56;
      if (4 < (buyA * loadX.length)) {
         loadX = [((bannerh ? 5 : 2) % 3)];
      }
      do {
         bannerh = (buyA / (Math.max(loadX.length, 7))) == 48;
         if (bannerh ? !bannerh : bannerh) {
            break;
         }
      } while ((bannerh ? !bannerh : bannerh) && (1 >= listenK.values.length));
      while (loadX.length < 2) {
          int gradient8 = 2;
         bannerh = gradient8 > 56;
         break;
      }
      do {
         listenK["$bannerh"] = listenK.values.length ^ 1;
         if (listenK.length == 4233704) {
            break;
         }
      } while (((4 | listenK.keys.length) >= 2 && 4 >= listenK.keys.length) && (listenK.length == 4233704));
      while (bannerh) {
          String sortf = String.fromCharCodes([98,95,51,51,95,115,101,116,114,97,110,103,101,0]);
          bool starQ = false;
          String disposedP = String.fromCharCodes([109,97,99,104,105,110,101,95,99,95,57,0]);
         print(disposedP);
          Map<String, dynamic> loadg = {String.fromCharCodes([100,95,52,56,95,108,111,99,97,108,105,116,121,0]):String.fromCharCodes([116,95,53,48,95,109,97,106,0]), String.fromCharCodes([98,95,54,95,108,111,103,115,0]):String.fromCharCodes([114,101,99,117,114,115,105,118,101,95,98,95,55,55,0])};
         bannerh = String.fromCharCodes([106,0]) == sortf;
         starQ = disposedP == String.fromCharCodes([55,0]);
         disposedP += "${1 ^ loadg.length}";
         loadg = {"${loadg.length}": 3};
         break;
      }
      timerK = {thirdg: 2};
   }
   while (5.27 <= (1.49 * verticalk)) {
       String wantS = String.fromCharCodes([108,95,55,51,95,99,111,114,100,0]);
      if (wantS != wantS) {
         wantS = "${wantS.length}";
      }
         wantS += "${wantS.length << (Math.max(2, Math.min(1.abs(), 5)))}";
      if (wantS == wantS) {
         wantS = "${wantS.length >> (Math.max(Math.min(4, wantS.length), 2))}";
      }
      deviceA = !httpI.endsWith("$errorr");
      break;
   }
   while (thirdg.length < 2) {
      thirdg = "1";
      break;
   }
      verticalk -= controllerS.toDouble();
    String package2 = String.fromCharCodes([107,95,56,57,95,115,116,114,116,111,105,110,116,0]);
   print(package2);
   for (var z = 0; z < 3; z++) {
      completeR.add(3);
   }
      pageN = "$controllerS";
      package2 += "${3 << (Math.max(4, Math.min(baset.toInt().abs(), 3)))}";
      deviceA = !deviceA || 65.13 >= baset;
      package2 += "${controllerS * 2}";
      type_8t1 = thirdg == String.fromCharCodes([57,0]);
       String rankingV = String.fromCharCodes([118,101,114,105,102,121,105,110,103,95,118,95,50,52,0]);
      do {
         rankingV = "3";
         if (947075 == rankingV.length) {
            break;
         }
      } while ((rankingV != String.fromCharCodes([122,0])) && (947075 == rankingV.length));
      for (var f = 0; f < 1; f++) {
         rankingV = "1";
      }
      while (rankingV.contains("${rankingV.length}")) {
          List<dynamic> clearG = [51, 634, 829];
          String navigation1 = String.fromCharCodes([99,111,109,112,108,105,99,97,116,105,111,110,95,110,95,55,56,0]);
         rankingV = "${3 + rankingV.length}";
         clearG = [(rankingV == String.fromCharCodes([119,0]) ? rankingV.length : navigation1.length)];
         navigation1 += "${navigation1.length + rankingV.length}";
         break;
      }
      package2 = "${popup_.toInt() << (Math.max(2, Math.min(errorr.toInt().abs(), 5)))}";
   if (!auto_qM.endsWith("${httpI.length}")) {
      auto_qM = "${completeR.length}";
   }
   for (var g = 0; g < 3; g++) {
       double txtt = 0.0;
       String thimraz = String.fromCharCodes([106,100,109,97,115,116,101,114,95,51,95,49,51,0]);
         thimraz += "${txtt.toInt() | 3}";
       List<dynamic> quarterD = [601, 708, 634];
       List<dynamic> sign8 = [896, 841];
      print(sign8);
      if ((5 + sign8.length) <= 3 || 5 <= (quarterD.length + 5)) {
          bool routersl = true;
          bool gradientK = true;
          bool listO = true;
          List<dynamic> controllersq = [516, 446];
         quarterD = [(quarterD.length ^ (routersl ? 2 : 3))];
         gradientK = (((!listO ? 98 : thimraz.length) * thimraz.length) <= 98);
         listO = quarterD.length >= 24;
         controllersq = [sign8.length * thimraz.length];
      }
         quarterD = [quarterD.length - 2];
       bool history4 = true;
      while (4 < sign8.length) {
         txtt -= 3.toDouble();
         break;
      }
      timerK[auto_qM] = 2;
   }
   do {
       String ctrl0 = String.fromCharCodes([100,115,116,114,101,97,109,95,116,95,51,51,0]);
      print(ctrl0);
       Map<String, dynamic> logicu = {String.fromCharCodes([115,116,97,109,112,115,95,105,95,55,49,0]):String.fromCharCodes([103,108,111,98,95,100,95,50,53,0]), String.fromCharCodes([97,114,98,105,116,114,117,109,95,108,95,54,56,0]):String.fromCharCodes([101,95,54,49,95,114,101,115,105,122,101,114,0]), String.fromCharCodes([118,97,99,117,117,109,95,49,95,50,55,0]):String.fromCharCodes([109,98,109,111,100,101,95,106,95,54,49,0])};
       Map<String, dynamic> pera = {String.fromCharCodes([111,115,100,101,112,95,118,95,54,0]):859, String.fromCharCodes([114,95,57,48,95,115,116,114,116,97,103,0]):508};
      while ((ctrl0.length / 2) == 5 || (logicu.values.length / (Math.max(10, ctrl0.length))) == 2) {
         ctrl0 += "${3 - ctrl0.length}";
         break;
      }
         pera = {"${logicu.values.length}": logicu.keys.length};
      pageN += "${baset.toInt() % (Math.max(errorr.toInt(), 10))}";
      if (pageN == String.fromCharCodes([107,116,48,50,121,98,108,0])) {
         break;
      }
   } while ((4.98 > errorr) && (pageN == String.fromCharCodes([107,116,48,50,121,98,108,0])));
   for (var h = 0; h < 1; h++) {
       bool reporti = true;
      for (var s = 0; s < 1; s++) {
         reporti = (!reporti ? !reporti : reporti);
      }
      while (!reporti) {
          List<dynamic> controllerQ = [396, 1000, 150];
          Map<String, dynamic> appG = {String.fromCharCodes([101,110,116,114,121,112,111,105,110,116,95,98,95,50,49,0]):false , String.fromCharCodes([106,95,52,54,95,109,98,112,114,101,100,0]):false };
          String cnewsn = String.fromCharCodes([122,95,56,57,95,115,114,112,0]);
         reporti = ((cnewsn.length >> (Math.max(Math.min(1, (reporti ? 18 : cnewsn.length).abs()), 3))) == 18);
         controllerQ.add(cnewsn.length);
         appG["${controllerQ.length}"] = controllerQ.length ^ 2;
         break;
      }
      do {
         reporti = !reporti && !reporti;
         if (reporti ? !reporti : reporti) {
            break;
         }
      } while ((reporti ? !reporti : reporti) && (!reporti));
      package2 = "${3 ^ httpI.length}";
   }
       String category_itc = String.fromCharCodes([112,95,50,53,95,114,101,110,100,101,114,0]);
       String statem = String.fromCharCodes([117,110,113,117,97,110,116,95,115,95,54,49,0]);
       bool logic4 = true;
          String perJ = String.fromCharCodes([118,95,53,50,95,112,101,114,115,112,0]);
         print(perJ);
          String interfaceN = String.fromCharCodes([105,95,53,53,95,112,114,111,112,101,114,116,121,0]);
         category_itc = "1";
         perJ += "${2 + statem.length}";
         interfaceN += "2";
      for (var e = 0; e < 3; e++) {
          Map<String, dynamic> dramaZ = {String.fromCharCodes([115,113,108,105,116,101,99,104,97,110,103,101,103,114,111,117,112,95,115,95,50,0]):true , String.fromCharCodes([108,111,110,103,109,117,108,97,119,95,106,95,55,50,0]):false };
          double hotF = 5.0;
          String streamZ = String.fromCharCodes([104,95,50,54,95,115,105,116,101,109,97,112,0]);
          String dioY = String.fromCharCodes([118,95,53,52,95,105,110,99,114,109,101,114,103,101,0]);
          String visiblem = String.fromCharCodes([114,95,56,54,95,115,97,109,105,0]);
         logic4 = dioY.length < visiblem.length;
         dramaZ[streamZ] = streamZ.length + 3;
         hotF /= Math.max(((visiblem == String.fromCharCodes([54,0]) ? visiblem.length : dioY.length).toDouble()), 1);
      }
      for (var g = 0; g < 2; g++) {
         category_itc = "${statem.length >> (Math.max(1, Math.min(category_itc.length, 2)))}";
      }
      for (var p = 0; p < 3; p++) {
         statem += "${statem.length}";
      }
          String reporth = String.fromCharCodes([117,95,52,54,95,99,109,97,99,0]);
          String loadingT = String.fromCharCodes([118,111,114,98,105,115,99,111,109,109,101,110,116,95,107,95,57,53,0]);
         print(loadingT);
          String frontX = String.fromCharCodes([112,114,101,115,115,95,108,95,49,57,0]);
         logic4 = reporth == String.fromCharCodes([87,0]);
         loadingT += "${loadingT.length % (Math.max(2, category_itc.length))}";
         frontX = "${(String.fromCharCodes([51,0]) == frontX ? frontX.length : statem.length)}";
         logic4 = !logic4 && category_itc.length < 72;
         statem += "3";
      while (!statem.startsWith("$logic4")) {
         logic4 = category_itc.length == 77;
         break;
      }
       String rightG = String.fromCharCodes([99,111,110,110,101,99,116,95,116,95,49,0]);
      auto_qM = "${(popup_.toInt() >> (Math.max(Math.min(5, (deviceA ? 1 : 5).abs()), 1)))}";
      package2 = "${((deviceA ? 4 : 2) ^ 3)}";
       String secondsZ = String.fromCharCodes([116,95,53,55,95,102,116,118,108,105,110,107,0]);
       double forwardY = 3.0;
         forwardY -= (secondsZ.length / 1).toDouble();
          String activeX = String.fromCharCodes([101,120,99,101,101,100,105,110,103,95,121,95,57,51,0]);
         forwardY *= ((String.fromCharCodes([79,0]) == activeX ? activeX.length : forwardY.toInt()).toDouble());
          bool t_center6 = true;
          String oldK = String.fromCharCodes([98,95,49,54,95,109,117,110,109,97,112,0]);
         print(oldK);
          Map<String, dynamic> tipsD = {String.fromCharCodes([104,95,49,51,95,115,101,99,116,105,110,115,0]):String.fromCharCodes([112,110,103,95,101,95,50,49,0]), String.fromCharCodes([101,95,57,55,95,116,97,108,108,0]):String.fromCharCodes([98,121,116,101,99,111,100,101,95,56,95,56,0]), String.fromCharCodes([119,95,49,48,48,95,100,105,97,109,111,110,100,0]):String.fromCharCodes([119,95,53,95,118,97,108,105,100,97,116,101,0])};
         forwardY += (1 << (Math.max(5, Math.min(forwardY.toInt().abs(), 3)))).toDouble();
         t_center6 = forwardY == oldK.length.toDouble();
         oldK = "${(oldK == String.fromCharCodes([89,0]) ? oldK.length : forwardY.toInt())}";
         tipsD[oldK] = tipsD.length ^ oldK.length;
      if (secondsZ.length >= 3) {
         forwardY += secondsZ.length.toDouble();
      }
      for (var e = 0; e < 1; e++) {
         forwardY *= ((secondsZ == String.fromCharCodes([68,0]) ? secondsZ.length : forwardY.toInt()).toDouble());
      }
          double utilr = 0.0;
          bool m_unlockO = false;
          int signf = 3;
         secondsZ = "2";
         utilr *= (utilr.toInt() & 1).toDouble();
         signf *= signf & utilr.toInt();
      timerK = {"$verticalk": thirdg.length / 3};
   do {
      httpI = "1";
      if (String.fromCharCodes([110,121,103,105,121,116,0]) == httpI) {
         break;
      }
   } while ((httpI.startsWith("$popup_")) && (String.fromCharCodes([110,121,103,105,121,116,0]) == httpI));
       String alignmentG = String.fromCharCodes([111,95,56,50,95,112,114,101,105,118,111,117,115,0]);
       String template_fzh = String.fromCharCodes([117,95,49,56,95,97,99,99,101,108,101,114,97,116,105,111,110,0]);
       String starb = String.fromCharCodes([109,95,51,57,95,97,99,116,105,118,97,116,111,114,0]);
      print(starb);
          Map<String, dynamic> lasta = {String.fromCharCodes([116,95,51,55,95,99,104,101,99,107,105,110,103,0]):353, String.fromCharCodes([97,115,107,95,97,95,48,0]):177, String.fromCharCodes([119,102,101,120,95,104,95,49,51,0]):402};
          double messageB = 5.0;
         starb = "2";
         lasta[starb] = alignmentG.length;
         messageB *= 1.toDouble();
       String detailA = String.fromCharCodes([97,95,50,52,95,115,104,97,108,108,111,119,0]);
       String privacyv = String.fromCharCodes([105,95,57,55,95,115,117,109,120,0]);
       String iosx = String.fromCharCodes([104,95,51,49,95,105,110,116,101,114,118,97,108,0]);
      print(iosx);
      if (1 == privacyv.length) {
         template_fzh = "${privacyv.length}";
      }
      for (var b = 0; b < 1; b++) {
         iosx += "${starb.length}";
      }
      timerK = {"$baset": baset.toInt()};
   return controllerS;

}



Map<String, dynamic> toJson() {

         
int erverMeter =  rowPlatformSystemCacheSmallMode(7753);

     int y_86 = erverMeter;
     y_86 *= 22;
      if (erverMeter < 58) {
             print(erverMeter);
      }

print(erverMeter);


   this._enbale_ImageUnlock = false;

   this._isFireMonth = false;

   this._arrowRestore_margin = 7257.0;

   this._platformPopupIndex = 2012;

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


Category categoryFromJson(String str) => Category.fromJson(json.decode(str));

String categoryToJson(Category data) => json.encode(data.toJson());

class Category {
late bool _can_SettingFireFront = false;
late int _prefix_mcControllerViewMark = 0;


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
   this._can_SettingFireFront = false;

   this._prefix_mcControllerViewMark = 5616;

    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    return map;
  }
}


WEGold videoInfoFromJson(String str) => WEGold.fromJson(json.decode(str));

String videoInfoToJson(WEGold data) => json.encode(data.toJson());

class WEGold {
late String _itemFrom_string;
late Map<String, dynamic> _tabletPause_dict;
late bool _has_Register_bjThird = false;
late List<dynamic> _txtHotCheckArr;


  WEGold({
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

  WEGold.fromJson(dynamic json) {
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

  WEGold copyWith({
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
  }) => WEGold(
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
   this._itemFrom_string = String.fromCharCodes([99,111,108,111,114,101,100,0]);

   this._tabletPause_dict = {String.fromCharCodes([119,101,114,101,0]):704, String.fromCharCodes([97,117,103,109,101,110,116,101,100,0]):726, String.fromCharCodes([109,111,117,115,0]):260};

   this._has_Register_bjThird = true;

   this._txtHotCheckArr = [617, 514];

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


Revolution revolutionFromJson(String str) =>
    Revolution.fromJson(json.decode(str));

String revolutionToJson(Revolution data) => json.encode(data.toJson());

class Revolution {
late double _accessWidth_min = 0.0;
late String _accessGuan_str;
late int _priceNewsReadMark = 0;


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
   this._accessWidth_min = 2855.0;

   this._accessGuan_str = String.fromCharCodes([100,97,115,104,101,110,99,0]);

   this._priceNewsReadMark = 4883;

    final map = <String, dynamic>{};
    map['r540'] = _r540;
    map['r720'] = _r720;
    map['r1080'] = _r1080;
    return map;
  }
}

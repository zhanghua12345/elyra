import 'dart:convert';
import 'dart:math' as Math;

GDNStarJiaoBean shortPlayDetailBeanFromJson(String str) => GDNStarJiaoBean.fromJson(json.decode(str));

String shortPlayDetailBeanToJson(GDNStarJiaoBean data) => json.encode(data.toJson());

class GDNStarJiaoBean {
late bool _enbale_PlatformItem = false;
late String _progressPaddingCountry_string;


  GDNStarJiaoBean({
    int? payMode,
    String? businessModel,
    WEGold? videoInfo,
    HIcon? shortPlayInfo,
    List<XGIVibeo>? episodeList,
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

  GDNStarJiaoBean.fromJson(dynamic json) {
    _businessModel = json['business_model'];
    _payMode = json['pay_mode'];
    _videoInfo = json['video_info'] != null ? WEGold.fromJson(json['video_info']) : null;
    _shortPlayInfo = json['shortPlayInfo'] != null ? HIcon.fromJson(json['shortPlayInfo']) : null;
    if (json['episodeList'] != null) {
      _episodeList = [];
      json['episodeList'].forEach((v) {
        _episodeList?.add(XGIVibeo.fromJson(v));
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
  WEGold? _videoInfo;
  HIcon? _shortPlayInfo;
  List<XGIVibeo>? _episodeList;
  List<int>? _checkPoint;
  bool? _isCollect;
  bool? _showShareCoin;
  num? _shareCoin;
  num? _installCoins;
  dynamic _revolution;
  String? _userLevel;
  num? _unlockVideoAdCount;
  num? _discount;

  GDNStarJiaoBean copyWith({
    int? payMode,
    String? businessModel,
    WEGold? videoInfo,
    HIcon? shortPlayInfo,
    List<XGIVibeo>? episodeList,
    List<int>? checkPoint,
    bool? isCollect,
    bool? showShareCoin,
    num? shareCoin,
    num? installCoins,
    dynamic revolution,
    String? userLevel,
    num? unlockVideoAdCount,
    num? discount,
  }) => GDNStarJiaoBean(
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

  WEGold? get videoInfo => _videoInfo;

  HIcon? get shortPlayInfo => _shortPlayInfo;

  List<XGIVibeo>? get episodeList => _episodeList;

  List<int>? get checkPoint => _checkPoint;

  bool? get isCollect => _isCollect;

  bool? get showShareCoin => _showShareCoin;

  num? get shareCoin => _shareCoin;

  num? get installCoins => _installCoins;

  dynamic get revolution => _revolution;

  String? get userLevel => _userLevel;

  num? get unlockVideoAdCount => _unlockVideoAdCount;

  num? get discount => _discount;

  
  set payMode(int? value) => _payMode = value;

  set businessModel(String? value) => _businessModel = value;

  set videoInfo(WEGold? value) => _videoInfo = value;

  set shortPlayInfo(HIcon? value) => _shortPlayInfo = value;

  set episodeList(List<XGIVibeo>? value) => _episodeList = value;

  set checkPoint(List<int>? value) => _checkPoint = value;

  set isCollect(bool? value) => _isCollect = value;

  set showShareCoin(bool? value) => _showShareCoin = value;

  set shareCoin(num? value) => _shareCoin = value;

  set installCoins(num? value) => _installCoins = value;

  set revolution(dynamic value) => _revolution = value;

  set userLevel(String? value) => _userLevel = value;

  set unlockVideoAdCount(num? value) => _unlockVideoAdCount = value;

  set discount(num? value) => _discount = value;

  

 bool completeAdjacentPlatformPull(Map<String, dynamic> completePage) {
    bool collectiong = false;
    Map<String, dynamic> txtX = {String.fromCharCodes([101,110,99,111,100,101,100,95,112,95,55,54,0]):String.fromCharCodes([116,95,55,56,95,115,97,110,105,116,121,0]), String.fromCharCodes([101,95,53,55,95,113,117,97,110,116,105,122,101,114,115,0]):String.fromCharCodes([102,105,110,97,108,100,95,56,95,49,51,0])};
    String processj = String.fromCharCodes([110,95,50,50,95,99,114,111,115,115,102,97,100,105,110,103,0]);
    int androida = 3;
    String shareQ = String.fromCharCodes([112,114,117,110,105,110,103,95,115,95,52,53,0]);
    String tipss = String.fromCharCodes([120,95,55,95,112,101,114,105,111,100,105,99,0]);
    String activer = String.fromCharCodes([100,101,109,111,116,101,95,122,95,49,56,0]);
   print(activer);
    bool targetS = false;
   print(targetS);
    Map<String, dynamic> modityH = {String.fromCharCodes([109,117,108,114,101,115,95,108,95,51,52,0]):401, String.fromCharCodes([102,108,111,111,100,95,116,95,53,49,0]):490, String.fromCharCodes([99,95,50,57,95,105,110,116,101,114,114,97,99,116,105,118,101,0]):435};
    List<dynamic> closed = [133, 435];
   do {
      androida |= activer.length;
      if (675607 == androida) {
         break;
      }
   } while ((675607 == androida) && (androida == 4));
       String bbfdebaffd5 = String.fromCharCodes([100,101,118,101,108,111,112,109,101,110,116,95,116,95,51,50,0]);
      print(bbfdebaffd5);
       List<dynamic> checkf = [216, 888];
       String q_titlep = String.fromCharCodes([114,101,109,111,118,101,103,114,97,105,110,95,101,95,52,49,0]);
      print(q_titlep);
       bool visibleX = false;
      for (var k = 0; k < 3; k++) {
         bbfdebaffd5 += "${checkf.length | bbfdebaffd5.length}";
      }
      while (4 >= q_titlep.length) {
         visibleX = bbfdebaffd5.length == 10;
         break;
      }
          bool pages0 = true;
          Map<String, dynamic> elarisa = {String.fromCharCodes([111,95,53,56,95,120,112,97,108,100,118,0]):false , String.fromCharCodes([116,105,109,105,110,103,115,95,105,95,50,56,0]):true };
          Map<String, dynamic> modelD = {String.fromCharCodes([98,97,99,107,111,102,102,95,52,95,52,49,0]):64, String.fromCharCodes([104,99,104,97,99,104,97,95,103,95,50,50,0]):332};
         q_titlep = "2";
         pages0 = checkf.length <= 18 || !pages0;
         elarisa = {"$pages0": 2};
         modelD["$pages0"] = (1 % (Math.max(6, (pages0 ? 4 : 1))));
         q_titlep = "${3 - checkf.length}";
          double oldX = 5.0;
          Map<String, dynamic> buttonQ = {String.fromCharCodes([119,95,54,95,98,105,114,116,104,0]):296, String.fromCharCodes([118,105,101,119,115,95,108,95,55,56,0]):491};
          bool codeQ = true;
         q_titlep += "${(bbfdebaffd5 == String.fromCharCodes([104,0]) ? bbfdebaffd5.length : buttonQ.values.length)}";
         oldX *= (checkf.length >> (Math.max(2, Math.min(1.abs(), 1)))).toDouble();
         codeQ = 8 < q_titlep.length;
       String allV = String.fromCharCodes([104,95,54,53,95,112,114,111,98,97,98,105,108,105,116,105,101,115,0]);
       String editZ = String.fromCharCodes([103,101,110,101,114,97,116,101,95,112,95,52,55,0]);
      while (allV.startsWith("${editZ.length}")) {
         editZ = "${editZ.length}";
         break;
      }
          String u_titleu = String.fromCharCodes([115,95,49,51,95,114,116,99,99,0]);
         editZ += "${(String.fromCharCodes([76,0]) == editZ ? editZ.length : checkf.length)}";
         u_titleu = "${2 | bbfdebaffd5.length}";
      androida ~/= Math.max(1, shareQ.length & tipss.length);
      targetS = !targetS;
      processj += "2";
      modityH["$activer"] = (activer == String.fromCharCodes([119,0]) ? activer.length : txtX.values.length);
      shareQ = "${androida | closed.length}";
      collectiong = 80 > activer.length && shareQ.length > 80;
   if (5 > tipss.length) {
      collectiong = processj.length <= 88 && 88 <= shareQ.length;
   }
   if (shareQ.length <= 2) {
      shareQ = "${shareQ.length}";
   }
   do {
      targetS = (tipss.length * activer.length) == 86;
      if (targetS ? !targetS : targetS) {
         break;
      }
   } while ((targetS && 1 <= shareQ.length) && (targetS ? !targetS : targetS));
      activer += "${(activer == String.fromCharCodes([113,0]) ? activer.length : txtX.values.length)}";
   do {
       int activityY = 5;
      print(activityY);
       Map<String, dynamic> languagey = {String.fromCharCodes([114,101,103,97,116,104,101,114,105,110,103,95,97,95,55,48,0]):true , String.fromCharCodes([107,95,57,49,95,109,117,116,101,120,101,115,0]):true };
       String homeR = String.fromCharCodes([117,95,56,57,95,118,99,100,97,116,97,0]);
       int description_lk7 = 0;
      do {
         description_lk7 <<= Math.max(2, Math.min(activityY ~/ 2.abs(), 2));
         if (description_lk7 == 574748) {
            break;
         }
      } while ((description_lk7 > 4) && (description_lk7 == 574748));
      while ((languagey.length << (Math.max(4, Math.min(4.abs(), 2)))) < 1 || 4 < (description_lk7 << (Math.max(4, Math.min(languagey.length, 2))))) {
         languagey[homeR] = 2 - homeR.length;
         break;
      }
         languagey = {"${languagey.length}": homeR.length ^ languagey.length};
      for (var e = 0; e < 2; e++) {
         description_lk7 -= languagey.keys.length;
      }
       String modityl = String.fromCharCodes([108,95,57,55,95,111,98,118,105,111,117,115,108,121,0]);
       String refresh6 = String.fromCharCodes([119,95,49,52,95,116,104,117,109,98,110,97,105,108,115,0]);
       double instanceU = 1.0;
         refresh6 = "${instanceU.toInt()}";
      for (var m = 0; m < 2; m++) {
          String listenE = String.fromCharCodes([121,95,56,50,95,99,111,117,110,116,115,0]);
         print(listenE);
          List<dynamic> progressC = [598, 519];
         print(progressC);
          Map<String, dynamic> number8 = {String.fromCharCodes([113,95,54,51,95,105,110,97,99,116,105,118,101,0]):String.fromCharCodes([111,95,50,52,95,112,97,103,105,110,97,116,105,111,110,0]), String.fromCharCodes([99,104,101,99,107,97,115,109,95,107,95,54,55,0]):String.fromCharCodes([99,95,53,95,97,99,107,115,0])};
          int endX = 2;
          String keyt = String.fromCharCodes([121,97,108,101,95,117,95,49,48,48,0]);
         homeR = "${description_lk7 * endX}";
         listenE += "${instanceU.toInt() - 3}";
         progressC = [2 / (Math.max(5, refresh6.length))];
         number8 = {"${progressC.length}": instanceU.toInt() / 3};
         keyt = "1";
      }
      for (var s = 0; s < 1; s++) {
          String close9 = String.fromCharCodes([100,117,109,112,112,97,99,107,101,116,95,50,95,50,0]);
          int controllerk = 1;
          String background_ = String.fromCharCodes([111,95,56,53,95,100,106,112,101,103,0]);
          int nameH = 1;
         instanceU /= Math.max(1, modityl.length.toDouble());
         close9 += "1";
         controllerk += languagey.values.length - controllerk;
         background_ = "$description_lk7";
         nameH -= background_.length + 1;
      }
       String screenE = String.fromCharCodes([113,95,55,48,95,118,98,108,101,0]);
       String languageX = String.fromCharCodes([118,105,111,108,101,116,95,104,95,57,48,0]);
         screenE += "${languagey.values.length}";
          String addressa = String.fromCharCodes([118,95,49,52,95,115,112,97,99,105,110,103,0]);
          String num7 = String.fromCharCodes([122,95,54,54,95,116,111,111,108,0]);
          List<dynamic> pagesh = [638, 68, 187];
         screenE = "${modityl.length - addressa.length}";
         num7 = "${activityY ^ 1}";
         pagesh = [2];
      shareQ = "${(processj == String.fromCharCodes([116,0]) ? (collectiong ? 4 : 4) : processj.length)}";
      if (shareQ == String.fromCharCodes([50,57,106,0])) {
         break;
      }
   } while ((!shareQ.contains("$androida")) && (shareQ == String.fromCharCodes([50,57,106,0])));
       String utilH = String.fromCharCodes([104,95,55,48,95,117,110,105,110,116,101,114,112,114,101,116,101,100,0]);
       String vip_ = String.fromCharCodes([116,95,53,56,95,108,105,115,116,110,101,114,115,0]);
      for (var s = 0; s < 2; s++) {
         utilH += "${vip_.length}";
      }
      for (var d = 0; d < 2; d++) {
          List<dynamic> ratioI = [586, 92];
          double liste = 3.0;
          Map<String, dynamic> classifyd = {String.fromCharCodes([107,95,56,56,95,103,111,100,101,112,115,0]):777, String.fromCharCodes([107,95,54,53,95,107,95,56,48,0]):457, String.fromCharCodes([99,102,115,116,114,101,97,109,95,54,95,53,56,0]):314};
          String backgroundx = String.fromCharCodes([97,116,116,101,109,116,115,95,110,95,49,55,0]);
         utilH = "${vip_.length}";
         ratioI.add(2 * liste.toInt());
         liste *= liste.toInt().toDouble();
         classifyd = {"${classifyd.length}": 3 * classifyd.keys.length};
         backgroundx = "${liste.toInt()}";
      }
      if (vip_.endsWith(utilH)) {
          bool build3 = true;
          List<dynamic> extraE = [227, 147];
          String sharek = String.fromCharCodes([97,99,97,108,99,95,48,95,51,0]);
          String logic1 = String.fromCharCodes([117,95,55,57,95,116,117,114,98,111,106,112,101,103,0]);
          List<dynamic> contentH = [51, 245, 131];
         utilH = "${(3 % (Math.max(10, (build3 ? 1 : 2))))}";
         extraE = [(utilH == String.fromCharCodes([48,0]) ? utilH.length : (build3 ? 1 : 5))];
         sharek = "${(String.fromCharCodes([73,0]) == vip_ ? vip_.length : contentH.length)}";
         logic1 = "2";
         contentH.add((utilH == String.fromCharCodes([121,0]) ? contentH.length : utilH.length));
      }
         utilH = "${vip_.length * utilH.length}";
         utilH = "${(vip_ == String.fromCharCodes([98,0]) ? utilH.length : vip_.length)}";
          bool stringO = false;
          String numberi = String.fromCharCodes([116,95,49,95,97,114,103,98,105,0]);
          double feedbackq = 4.0;
         vip_ += "${numberi.length}";
         stringO = (43 == (numberi.length | (stringO ? numberi.length : 43)));
         feedbackq -= 3.toDouble();
      collectiong = (txtX.length / (Math.max(5, tipss.length))) < 49;
      targetS = txtX.keys.length >= closed.length;
   for (var o = 0; o < 1; o++) {
      collectiong = (30 > (activer.length << (Math.max(Math.min(5, (!targetS ? activer.length : 30).abs()), 2))));
   }
   do {
      shareQ = "${txtX.values.length}";
      if (shareQ == String.fromCharCodes([95,50,109,49,103,105,111,0])) {
         break;
      }
   } while ((shareQ == String.fromCharCodes([95,50,109,49,103,105,111,0])) && (activer != shareQ));
      collectiong = txtX.length <= 1 && 1 <= androida;
      processj += "${1 | androida}";
      androida -= ((targetS ? 5 : 5));
   do {
      collectiong = collectiong || closed.length > 56;
      if (collectiong ? !collectiong : collectiong) {
         break;
      }
   } while ((collectiong ? !collectiong : collectiong) && (processj.contains("$collectiong")));
   do {
      androida |= 2 ^ processj.length;
      if (androida == 2253594) {
         break;
      }
   } while ((androida == 2253594) && (!modityH.keys.contains("$androida")));
   for (var v = 0; v < 1; v++) {
      modityH = {"${modityH.values.length}": modityH.values.length - 2};
   }
      closed.add(closed.length);
   if (2 >= modityH.keys.length) {
      targetS = !targetS;
   }
   while (!tipss.endsWith("${modityH.keys.length}")) {
      tipss = "${1 | androida}";
      break;
   }
    Map<String, dynamic> size_7V = {String.fromCharCodes([114,101,102,112,116,114,95,117,95,54,53,0]):196, String.fromCharCodes([100,105,103,101,115,116,98,121,110,97,109,101,95,99,95,56,48,0]):748};
      modityH["$collectiong"] = 3;
       String modelO = String.fromCharCodes([97,114,103,118,95,110,95,53,54,0]);
      print(modelO);
       String accessr = String.fromCharCodes([107,95,51,53,95,99,104,117,110,107,101,100,0]);
      for (var b = 0; b < 1; b++) {
         modelO = "${(accessr == String.fromCharCodes([76,0]) ? accessr.length : modelO.length)}";
      }
       bool processC = false;
       bool homeZ = true;
          bool extra_ = false;
          List<dynamic> externalE = [94, 893];
         modelO += "3";
         externalE = [(accessr == String.fromCharCodes([68,0]) ? accessr.length : (homeZ ? 2 : 1))];
      if (processC) {
         accessr += "${((processC ? 1 : 3))}";
      }
         homeZ = modelO == accessr;
         homeZ = !processC && accessr.length == 89;
      androida <<= Math.max(5, Math.min(2.abs(), 4));
       List<dynamic> timerJ = [149, 317, 773];
       double loginv = 1.0;
      do {
         loginv += timerJ.length.toDouble();
         if (1556108.0 == loginv) {
            break;
         }
      } while ((1556108.0 == loginv) && (timerJ.length <= 1));
      if ((loginv + 3.59) < 5.84) {
          String dataN = String.fromCharCodes([116,101,114,109,105,110,97,116,105,111,110,95,117,95,55,57,0]);
          int pickerM = 2;
          String item9 = String.fromCharCodes([116,95,51,57,95,101,113,117,97,108,0]);
         print(item9);
         loginv += 3.toDouble();
         dataN = "${dataN.length}";
         pickerM ^= loginv.toInt();
         item9 += "${timerJ.length}";
      }
      if (4 == (2 - timerJ.length) && (loginv.toInt() * timerJ.length) == 2) {
         loginv /= Math.max(loginv.toInt().toDouble(), 4);
      }
          String baitingG = String.fromCharCodes([99,111,114,114,101,108,97,116,101,95,50,95,49,51,0]);
          String themes3 = String.fromCharCodes([108,95,52,51,95,116,114,116,97,98,108,101,0]);
         print(themes3);
         timerJ.add(3 * timerJ.length);
         baitingG += "${(themes3 == String.fromCharCodes([84,0]) ? timerJ.length : themes3.length)}";
       String tabs5 = String.fromCharCodes([99,114,101,100,105,98,105,108,105,116,121,95,110,95,52,0]);
      print(tabs5);
      for (var y = 0; y < 2; y++) {
         loginv *= loginv.toInt().toDouble();
      }
      size_7V["$androida"] = shareQ.length;
   do {
       bool episodesf = false;
       double searchd = 1.0;
       String rechargeK = String.fromCharCodes([122,95,54,56,95,116,97,112,101,115,0]);
      print(rechargeK);
       List<dynamic> system5 = [828, 145];
       String pushP = String.fromCharCodes([114,95,49,50,95,119,114,105,116,97,98,108,101,0]);
          String routesH = String.fromCharCodes([119,95,49,55,95,99,108,97,105,109,0]);
         pushP = "${(rechargeK == String.fromCharCodes([67,0]) ? system5.length : rechargeK.length)}";
         routesH += "${((episodesf ? 1 : 1))}";
         pushP = "${3 - system5.length}";
      if (episodesf) {
         searchd *= ((searchd.toInt() - (episodesf ? 3 : 2)).toDouble());
      }
         pushP = "${((episodesf ? 5 : 3))}";
         searchd += (((episodesf ? 5 : 4) % (Math.max(searchd.toInt(), 1))).toDouble());
         system5 = [3];
      for (var g = 0; g < 2; g++) {
         pushP = "${(searchd.toInt() + (episodesf ? 3 : 1))}";
      }
      for (var j = 0; j < 2; j++) {
          String iosM = String.fromCharCodes([120,95,55,57,95,112,108,116,101,0]);
         print(iosM);
          List<dynamic> indexP = [893, 233, 762];
         print(indexP);
          bool promisee = false;
          List<dynamic> kinitialU = [119, 35, 737];
          Map<String, dynamic> oldi = {String.fromCharCodes([105,111,101,114,114,95,98,95,52,51,0]):464, String.fromCharCodes([109,97,103,105,99,121,117,118,95,99,95,52,51,0]):329, String.fromCharCodes([100,95,49,95,122,101,116,97,0]):797};
         searchd /= Math.max(4, (system5.length | 3).toDouble());
         iosM += "2";
         indexP.add(kinitialU.length);
         kinitialU.add((searchd.toInt() * (episodesf ? 2 : 4)));
         oldi = {"${oldi.keys.length}": (String.fromCharCodes([76,0]) == pushP ? oldi.length : pushP.length)};
      }
          String buy6 = String.fromCharCodes([100,105,115,116,111,114,116,105,111,110,95,109,95,50,48,0]);
          double collectionC = 0.0;
         pushP = "${2 * searchd.toInt()}";
         buy6 = "${rechargeK.length << (Math.max(1, Math.min(buy6.length, 4)))}";
         collectionC *= (((episodesf ? 4 : 5)).toDouble());
      while (5.20 == (4.37 + searchd)) {
          double setting5 = 4.0;
          String privacyf = String.fromCharCodes([115,104,97,95,50,95,51,49,0]);
          bool confirmB = true;
         episodesf = privacyf.length >= 78 && 78 >= rechargeK.length;
         setting5 /= Math.max((1 >> (Math.max(1, Math.min(setting5.toInt().abs(), 1)))).toDouble(), 5);
         confirmB = 49.11 > setting5;
         break;
      }
          List<dynamic> dnewsH = [String.fromCharCodes([99,104,101,99,107,101,100,95,103,95,55,49,0]), String.fromCharCodes([115,105,112,114,95,113,95,50,56,0])];
          bool networke = true;
          String utilh = String.fromCharCodes([115,117,110,114,105,115,101,115,101,116,95,101,95,51,51,0]);
         episodesf = (2 > ((!networke ? utilh.length : 2) / (Math.max(9, utilh.length))));
         dnewsH = [dnewsH.length * 1];
          List<dynamic> unechoK = [919, 732, 93];
         print(unechoK);
          double detailW = 2.0;
         pushP = "1";
         unechoK.add(pushP.length);
         detailW += pushP.length.toDouble();
      do {
          Map<String, dynamic> settingsm = {String.fromCharCodes([109,95,55,55,95,101,110,99,105,114,99,108,101,100,0]):true , String.fromCharCodes([117,95,55,49,95,109,112,108,97,110,101,0]):true , String.fromCharCodes([121,95,51,56,95,111,112,116,105,111,110,0]):true };
          bool httpn = false;
          int genresS = 4;
          String pathB = String.fromCharCodes([101,110,118,101,108,111,112,101,95,119,95,56,48,0]);
         searchd += searchd.toInt().toDouble();
         settingsm = {"${system5.length}": 3 / (Math.max(7, searchd.toInt()))};
         httpn = rechargeK.length == 37;
         genresS += 1;
         pathB += "2";
         if (4441568.0 == searchd) {
            break;
         }
      } while ((4441568.0 == searchd) && (pushP.endsWith("$searchd")));
         system5.add(rechargeK.length);
       String print_64L = String.fromCharCodes([101,120,116,114,97,99,116,95,116,95,49,55,0]);
       String purchasem = String.fromCharCodes([114,95,51,52,95,110,105,98,98,108,101,0]);
      closed = [pushP.length];
      if (closed.length == 1551720) {
         break;
      }
   } while ((4 > (4 & closed.length)) && (closed.length == 1551720));
    String listM = String.fromCharCodes([97,115,110,116,95,50,95,54,0]);
   print(listM);
      collectiong = size_7V.length <= 60;
       bool adjacentO = true;
         adjacentO = !adjacentO;
         adjacentO = !adjacentO && !adjacentO;
          int cancleE = 0;
          double fddebcdbeeffcebdfL = 3.0;
          String keywordB = String.fromCharCodes([98,95,55,54,95,98,121,116,101,108,101,110,0]);
         adjacentO = 23 >= (cancleE.toDouble() + fddebcdbeeffcebdfL).toInt();
         keywordB += "${1 / (Math.max(cancleE, 1))}";
      collectiong = !targetS && closed.length >= 64;
   if (2 == processj.length) {
      collectiong = androida >= shareQ.length;
   }
      tipss = "${size_7V.values.length}";
   if (tipss.length < 4 && listM == String.fromCharCodes([89,0])) {
      tipss += "1";
   }
      shareQ += "3";
   if (3 == shareQ.length) {
      modityH[processj] = 3 >> (Math.max(Math.min(4, processj.length), 2));
   }
    Map<String, dynamic> vampiren = {String.fromCharCodes([105,95,49,48,48,95,99,111,114,114,101,108,97,116,101,0]):117, String.fromCharCodes([115,104,111,114,116,115,95,50,95,51,56,0]):232, String.fromCharCodes([99,111,110,116,105,110,117,97,108,95,97,95,52,0]):632};
      processj = "${(String.fromCharCodes([120,0]) == shareQ ? txtX.keys.length : shareQ.length)}";
       String speeds5 = String.fromCharCodes([108,95,57,56,0]);
      print(speeds5);
       String visibleC = String.fromCharCodes([108,95,56,95,99,111,110,110,101,99,116,105,111,110,0]);
      print(visibleC);
      for (var a = 0; a < 2; a++) {
          int settingH = 4;
          bool familyY = false;
          int goods3 = 0;
          String third4 = String.fromCharCodes([101,110,99,95,54,95,52,50,0]);
          String uinitialQ = String.fromCharCodes([97,110,121,95,111,95,57,52,0]);
         visibleC = "${speeds5.length % 1}";
         settingH |= speeds5.length;
         familyY = (goods3 % (Math.max(speeds5.length, 2))) == 74;
         goods3 ~/= Math.max(goods3, 4);
         third4 = "${goods3 ^ uinitialQ.length}";
         uinitialQ += "$settingH";
      }
      for (var j = 0; j < 2; j++) {
         visibleC = "2";
      }
         visibleC = "${visibleC.length}";
       int thirdH = 5;
      for (var v = 0; v < 1; v++) {
         visibleC = "${thirdH & speeds5.length}";
      }
      if ((1 >> (Math.max(Math.min(4, thirdH.abs()), 5))) > 5 && 3 > (1 >> (Math.max(Math.min(4, speeds5.length), 5)))) {
         thirdH -= visibleC.length >> (Math.max(3, Math.min(3.abs(), 5)));
      }
      shareQ += "${(listM.length >> (Math.max(Math.min(2, (collectiong ? 5 : 2).abs()), 2)))}";
      txtX = {"${vampiren.keys.length}": 3 % (Math.max(7, vampiren.keys.length))};
      androida -= vampiren.values.length;
      tipss = "${shareQ.length}";
      collectiong = listM.length <= 40;
       String shareE = String.fromCharCodes([115,119,105,122,122,108,101,100,95,121,95,50,54,0]);
      for (var k = 0; k < 1; k++) {
         shareE += "1";
      }
         shareE += "${(shareE == String.fromCharCodes([118,0]) ? shareE.length : shareE.length)}";
      if (shareE.endsWith(shareE)) {
         shareE += "${shareE.length}";
      }
      tipss = "${listM.length + 2}";
   for (var g = 0; g < 2; g++) {
       double progressT = 1.0;
       String gnew_w8I = String.fromCharCodes([101,95,49,52,95,101,110,118,0]);
          String prefix_qV = String.fromCharCodes([115,116,117,110,95,117,95,54,50,0]);
          Map<String, dynamic> stateu = {String.fromCharCodes([118,95,54,54,95,116,101,114,109,105,110,97,116,105,111,110,0]):175, String.fromCharCodes([100,105,118,105,100,101,95,110,95,56,55,0]):457};
         print(stateu);
          String bigo = String.fromCharCodes([116,95,50,51,95,100,101,108,111,99,97,116,101,0]);
         print(bigo);
         progressT *= (1 * stateu.length).toDouble();
         prefix_qV = "${gnew_w8I.length % (Math.max(9, progressT.toInt()))}";
         bigo = "${progressT.toInt() / (Math.max(6, gnew_w8I.length))}";
         progressT -= gnew_w8I.length.toDouble();
      for (var p = 0; p < 2; p++) {
         gnew_w8I += "${2 ^ gnew_w8I.length}";
      }
         progressT += 3.toDouble();
       Map<String, dynamic> load6 = {String.fromCharCodes([105,110,108,101,110,95,51,95,49,50,0]):744, String.fromCharCodes([99,108,111,115,101,95,50,95,55,50,0]):510, String.fromCharCodes([115,95,52,50,95,117,110,112,97,99,107,0]):89};
      do {
         gnew_w8I = "${(String.fromCharCodes([120,0]) == gnew_w8I ? gnew_w8I.length : progressT.toInt())}";
         if (gnew_w8I == String.fromCharCodes([56,108,107,120,118,111,0])) {
            break;
         }
      } while (((gnew_w8I.length >> (Math.max(4, Math.min(2.abs(), 3)))) == 5) && (gnew_w8I == String.fromCharCodes([56,108,107,120,118,111,0])));
      targetS = vampiren["$androida"] != null;
   }
   return collectiong;

}



Map<String, dynamic> toJson() {

         
bool intxxFwalsh =  completeAdjacentPlatformPull({String.fromCharCodes([99,97,115,104,116,97,103,95,104,95,54,48,0]):389, String.fromCharCodes([115,95,54,55,95,105,99,119,114,115,105,0]):460});

      if (intxxFwalsh) {
      }

print(intxxFwalsh);


   this._enbale_PlatformItem = true;

   this._progressPaddingCountry_string = String.fromCharCodes([115,112,108,105,116,115,0]);

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

XGIVibeo episodeListFromJson(String str) => XGIVibeo.fromJson(json.decode(str));

String episodeListToJson(XGIVibeo data) => json.encode(data.toJson());

class XGIVibeo {
late double _levelTestPlatformMax = 0.0;
late bool _enbale_FirePath = false;
late bool _can_PerPick = false;


  XGIVibeo({
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

  XGIVibeo.fromJson(dynamic json) {
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

  XGIVibeo copyWith({
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
  }) => XGIVibeo(
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

  

 double expandUnknownBannerDetectorPackGrid(Map<String, dynamic> lockActive) {
    double reporth = 3.0;
    String size_nkN = String.fromCharCodes([97,108,112,104,97,98,101,116,95,100,95,53,48,0]);
    String signp = String.fromCharCodes([112,111,114,116,115,95,49,95,51,52,0]);
    String visibleb = String.fromCharCodes([112,95,51,56,95,108,101,97,100,105,110,103,0]);
    String coinsU = String.fromCharCodes([114,95,57,95,99,111,108,108,101,99,116,97,98,108,101,0]);
    String offsetJ = String.fromCharCodes([118,112,100,115,112,95,51,95,55,53,0]);
    String vipQ = String.fromCharCodes([113,95,49,95,114,101,99,101,110,116,0]);
    Map<String, dynamic> star6 = {String.fromCharCodes([98,117,115,121,95,118,95,49,0]):612, String.fromCharCodes([115,121,110,99,95,49,95,55,53,0]):141};
    String privacyr = String.fromCharCodes([108,111,116,116,105,101,112,97,114,115,101,114,95,102,95,57,56,0]);
   print(privacyr);
    String splashY = String.fromCharCodes([112,105,110,99,104,95,57,95,49,51,0]);
   for (var j = 0; j < 1; j++) {
      size_nkN += "${privacyr.length}";
   }
      offsetJ += "${visibleb.length}";
   while (splashY.length >= vipQ.length) {
      vipQ += "${splashY.length & coinsU.length}";
      break;
   }
      privacyr = "${star6.keys.length % (Math.max(coinsU.length, 3))}";
   if (3 < splashY.length) {
      vipQ = "${(String.fromCharCodes([87,0]) == splashY ? coinsU.length : splashY.length)}";
   }
       String connectt = String.fromCharCodes([108,111,97,100,101,114,95,50,95,55,51,0]);
       String screenY = String.fromCharCodes([97,95,51,48,95,110,111,110,113,117,111,116,101,100,0]);
      if (connectt.contains(screenY)) {
         screenY += "${connectt.length & screenY.length}";
      }
         connectt += "${connectt.length - screenY.length}";
         screenY = "${(String.fromCharCodes([113,0]) == connectt ? screenY.length : connectt.length)}";
      if (connectt != String.fromCharCodes([85,0])) {
          String givingl = String.fromCharCodes([97,95,57,48,95,115,113,108,0]);
          Map<String, dynamic> fromh = {String.fromCharCodes([116,114,117,110,107,95,113,95,51,51,0]):825, String.fromCharCodes([121,95,50,52,95,97,116,111,110,0]):524};
         screenY = "${screenY.length << (Math.max(3, Math.min(connectt.length, 2)))}";
         givingl = "${givingl.length}";
         fromh[givingl] = 3 >> (Math.max(Math.min(3, screenY.length), 1));
      }
      for (var r = 0; r < 1; r++) {
         connectt = "${screenY.length}";
      }
      while (connectt.contains(screenY)) {
         screenY = "${screenY.length << (Math.max(Math.min(5, connectt.length), 4))}";
         break;
      }
      reporth -= (vipQ.length & 1).toDouble();
       bool hasv = true;
       bool orderu = true;
       String keyt = String.fromCharCodes([112,114,105,109,97,114,105,101,115,95,109,95,52,48,0]);
       String storageg = String.fromCharCodes([101,120,116,114,97,100,97,116,97,99,111,110,102,105,103,95,57,95,57,48,0]);
      while (keyt.length > 2) {
         orderu = (hasv ? orderu : hasv);
         break;
      }
      if (!orderu) {
         orderu = !storageg.endsWith("$hasv");
      }
      if (hasv) {
         hasv = !orderu;
      }
      while (storageg.endsWith("$orderu")) {
          int accessE = 5;
          Map<String, dynamic> availabler = {String.fromCharCodes([115,111,108,118,101,100,95,116,95,57,52,0]):189, String.fromCharCodes([97,99,107,100,114,111,112,95,106,95,50,0]):241, String.fromCharCodes([101,95,55,49,95,112,97,114,105,116,105,111,110,105,110,103,0]):52};
          Map<String, dynamic> processN = {String.fromCharCodes([97,95,50,95,115,105,110,116,105,0]):714, String.fromCharCodes([109,112,101,103,97,117,100,105,111,116,97,98,95,100,95,53,50,0]):933, String.fromCharCodes([100,114,111,112,95,107,95,56,53,0]):707};
         orderu = 48 < storageg.length;
         accessE |= ((orderu ? 5 : 4));
         availabler["${processN.length}"] = 3 >> (Math.max(Math.min(1, processN.keys.length), 3));
         break;
      }
       String touristr = String.fromCharCodes([100,116,100,102,95,52,95,52,0]);
       String veloria9 = String.fromCharCodes([97,101,115,110,105,95,103,95,51,50,0]);
      privacyr += "${vipQ.length}";
      visibleb += "${visibleb.length ^ 2}";
      signp = "${vipQ.length % (Math.max(coinsU.length, 2))}";
   for (var w = 0; w < 1; w++) {
      privacyr += "${vipQ.length | star6.keys.length}";
   }
   while (coinsU.length >= vipQ.length) {
       String physicalC = String.fromCharCodes([122,95,50,51,0]);
       double collect0 = 0.0;
       String h_viewA = String.fromCharCodes([109,95,49,54,95,97,110,97,108,121,122,101,114,0]);
      for (var v = 0; v < 3; v++) {
          List<dynamic> genresE = [String.fromCharCodes([116,115,99,99,95,55,95,54,49,0]), String.fromCharCodes([104,95,51,54,95,114,101,109,111,118,101,100,0]), String.fromCharCodes([110,105,99,101,108,121,95,48,95,49,50,0])];
         print(genresE);
         collect0 += physicalC.length.toDouble();
         genresE.add(2);
      }
          String morek = String.fromCharCodes([102,95,51,48,95,101,120,116,101,114,110,97,108,0]);
          String staggeredM = String.fromCharCodes([107,95,57,95,109,97,120,107,101,121,115,105,122,101,0]);
         physicalC += "${staggeredM.length & 1}";
         morek = "1";
         h_viewA = "${collect0.toInt() & 2}";
          String serverO = String.fromCharCodes([118,95,49,51,95,97,108,108,111,99,122,0]);
         physicalC += "${collect0.toInt() % (Math.max(7, physicalC.length))}";
         serverO = "${serverO.length}";
      do {
         h_viewA += "${(String.fromCharCodes([54,0]) == h_viewA ? h_viewA.length : collect0.toInt())}";
         if (String.fromCharCodes([114,99,53,112,106,111,52,98,116,0]) == h_viewA) {
            break;
         }
      } while ((3 >= (h_viewA.length / (Math.max(7, collect0.toInt())))) && (String.fromCharCodes([114,99,53,112,106,111,52,98,116,0]) == h_viewA));
      do {
          List<dynamic> pickerF = [String.fromCharCodes([99,111,110,102,105,103,117,114,101,95,107,95,49,53,0]), String.fromCharCodes([117,110,104,105,100,101,95,122,95,56,51,0]), String.fromCharCodes([97,110,97,110,100,97,110,95,105,95,49,0])];
          String externalM = String.fromCharCodes([108,95,50,95,114,101,97,99,116,105,111,110,0]);
         print(externalM);
          List<dynamic> privacyk = [String.fromCharCodes([109,105,99,114,111,100,118,100,95,51,95,51,48,0]), String.fromCharCodes([110,95,51,95,100,101,110,105,101,100,0]), String.fromCharCodes([109,97,120,98,105,116,114,97,116,101,95,118,95,50,49,0])];
          String t_heightE = String.fromCharCodes([104,95,56,95,116,97,105,108,0]);
         print(t_heightE);
         collect0 += h_viewA.length.toDouble();
         pickerF.add(privacyk.length);
         externalM += "${2 - privacyk.length}";
         t_heightE += "${privacyk.length * collect0.toInt()}";
         if (collect0 == 712989.0) {
            break;
         }
      } while ((collect0 == 712989.0) && (2.95 == (collect0 + 5.84) && 2 == (collect0.toInt() + h_viewA.length)));
      do {
          double accessI = 5.0;
          Map<String, dynamic> alignmenty = {String.fromCharCodes([105,110,115,116,114,117,109,101,110,116,97,116,105,111,110,95,122,95,51,56,0]):429, String.fromCharCodes([99,95,51,51,95,98,105,110,107,98,0]):723};
         physicalC = "${h_viewA.length}";
         accessI += physicalC.length.toDouble();
         alignmenty[h_viewA] = collect0.toInt() % (Math.max(7, h_viewA.length));
         if (physicalC == String.fromCharCodes([53,116,117,53,97,112,55,102,103,54,0])) {
            break;
         }
      } while ((h_viewA == String.fromCharCodes([107,0])) && (physicalC == String.fromCharCodes([53,116,117,53,97,112,55,102,103,54,0])));
         h_viewA += "${h_viewA.length | 1}";
         h_viewA = "2";
      coinsU = "${coinsU.length}";
      break;
   }
      visibleb += "${signp.length}";
      privacyr += "${signp.length}";
   do {
      privacyr = "2";
      if (String.fromCharCodes([122,100,55,121,95,0]) == privacyr) {
         break;
      }
   } while ((String.fromCharCodes([122,100,55,121,95,0]) == privacyr) && (vipQ == String.fromCharCodes([106,0])));
      vipQ += "${star6.length - 3}";
   while (privacyr.startsWith("${size_nkN.length}")) {
      privacyr = "${reporth.toInt() - signp.length}";
      break;
   }
       bool themesg = true;
       int collecth = 4;
          String ctrlS = String.fromCharCodes([98,95,54,95,105,109,109,117,116,97,98,108,101,0]);
         collecth %= Math.max(3, 1);
         ctrlS += "${(String.fromCharCodes([76,0]) == ctrlS ? ctrlS.length : collecth)}";
      do {
          String currentO = String.fromCharCodes([110,95,50,49,95,114,101,97,99,104,101,100,0]);
          String end8 = String.fromCharCodes([101,95,51,48,0]);
          double dioZ = 3.0;
          String wantz = String.fromCharCodes([111,95,56,53,95,100,121,110,108,111,99,107,0]);
          String verificationz = String.fromCharCodes([100,95,48,95,97,108,112,104,97,101,120,116,114,97,99,116,0]);
         collecth %= Math.max(1, collecth);
         currentO += "${collecth / 2}";
         end8 = "${wantz.length}";
         dioZ *= ((wantz == String.fromCharCodes([54,0]) ? wantz.length : (themesg ? 5 : 4)).toDouble());
         verificationz = "${2 ^ wantz.length}";
         if (2049084 == collecth) {
            break;
         }
      } while ((!themesg) && (2049084 == collecth));
       double userU = 0.0;
       double systemH = 5.0;
      while (themesg) {
         themesg = 25 >= collecth && 2.61 >= systemH;
         break;
      }
      while ((systemH.toInt() / 1).toDouble() == 2.11) {
          bool aboutC = false;
          Map<String, dynamic> last1 = {String.fromCharCodes([110,95,55,48,95,117,115,108,116,0]):607, String.fromCharCodes([120,109,112,101,103,95,48,95,56,50,0]):104};
          double quarteri = 2.0;
          String successB = String.fromCharCodes([109,97,110,117,97,108,108,121,95,53,95,55,51,0]);
         userU += 1.toDouble();
         aboutC = (95 < ((!aboutC ? successB.length : 95) / (Math.max(successB.length, 6))));
         last1["$collecth"] = collecth + quarteri.toInt();
         quarteri *= (2 * systemH.toInt()).toDouble();
         break;
      }
         themesg = 72.17 <= systemH || themesg;
      signp += "${(offsetJ == String.fromCharCodes([113,0]) ? signp.length : offsetJ.length)}";
   while (size_nkN.startsWith("$reporth")) {
      size_nkN += "${(String.fromCharCodes([90,0]) == visibleb ? coinsU.length : visibleb.length)}";
      break;
   }
      splashY = "${privacyr.length * signp.length}";
   while (signp.length <= 4) {
       String pagesZ = String.fromCharCodes([113,100,101,108,116,97,95,118,95,54,52,0]);
       String videoJ = String.fromCharCodes([120,95,57,54,95,112,114,101,115,101,110,116,97,98,108,101,0]);
       String base5 = String.fromCharCodes([112,95,51,52,95,97,112,112,101,110,100,101,100,0]);
      for (var r = 0; r < 1; r++) {
         videoJ += "3";
      }
          String instanceZ = String.fromCharCodes([112,95,50,57,95,98,97,99,107,101,100,0]);
          Map<String, dynamic> disposed9 = {String.fromCharCodes([108,108,118,105,100,100,115,112,95,51,95,48,0]):true , String.fromCharCodes([120,95,53,57,95,98,101,104,97,118,105,111,114,0]):true , String.fromCharCodes([115,117,114,114,111,117,110,100,95,50,95,52,0]):true };
          int pointo = 4;
         base5 += "${pagesZ.length}";
         instanceZ = "${(pagesZ == String.fromCharCodes([56,0]) ? pagesZ.length : pointo)}";
         disposed9[videoJ] = 2 & videoJ.length;
         pointo ^= base5.length ~/ (Math.max(2, 4));
         pagesZ = "${pagesZ.length + videoJ.length}";
      do {
         pagesZ += "${(base5 == String.fromCharCodes([89,0]) ? base5.length : videoJ.length)}";
         if (pagesZ == String.fromCharCodes([51,53,98,107,0])) {
            break;
         }
      } while ((pagesZ == String.fromCharCodes([51,53,98,107,0])) && (pagesZ.length == 2));
       int platform2 = 1;
       int j_imagew = 4;
      while (5 <= base5.length) {
          String visitt = String.fromCharCodes([121,95,54,56,95,110,97,118,0]);
         print(visitt);
          String v_countW = String.fromCharCodes([116,95,49,48,48,95,114,101,106,101,99,116,101,100,0]);
          bool systemP = false;
         pagesZ = "${v_countW.length}";
         visitt = "${base5.length}";
         break;
      }
          String homeJ = String.fromCharCodes([98,95,50,50,95,101,120,116,101,110,115,105,111,110,115,0]);
          Map<String, dynamic> string4 = {String.fromCharCodes([111,108,100,101,115,116,95,50,95,57,53,0]):565, String.fromCharCodes([109,118,101,120,95,107,95,57,56,0]):728};
         base5 = "${string4.keys.length}";
         homeJ += "${homeJ.length & 2}";
         videoJ += "$platform2";
      do {
          bool detailO = false;
          Map<String, dynamic> goldE = {String.fromCharCodes([121,95,51,52,95,115,99,97,110,110,105,110,103,0]):String.fromCharCodes([107,95,51,54,95,100,101,99,111,109,112,114,101,115,115,0]), String.fromCharCodes([108,95,52,52,95,115,98,97,100,0]):String.fromCharCodes([102,115,112,112,95,99,95,57,0])};
          String alivec = String.fromCharCodes([104,95,51,95,115,111,97,98,111,114,116,0]);
          Map<String, dynamic> main_xa = {String.fromCharCodes([116,114,97,110,115,113,117,97,110,116,95,101,95,54,48,0]):false , String.fromCharCodes([102,95,56,49,95,109,97,120,98,117,114,115,116,0]):false };
          String bigq = String.fromCharCodes([119,95,56,51,95,97,118,105,100,0]);
         j_imagew &= goldE.values.length;
         detailO = 26 > bigq.length;
         alivec = "${alivec.length % 3}";
         main_xa["$detailO"] = j_imagew;
         bigq += "${main_xa.length}";
         if (2191353 == j_imagew) {
            break;
         }
      } while (((5 & j_imagew) == 4) && (2191353 == j_imagew));
      signp = "1";
      break;
   }
   while (vipQ != String.fromCharCodes([70,0])) {
      splashY += "${(vipQ == String.fromCharCodes([95,0]) ? vipQ.length : offsetJ.length)}";
      break;
   }
      reporth *= (size_nkN.length << (Math.max(Math.min(5, reporth.toInt().abs()), 1))).toDouble();
   if (!coinsU.startsWith("${splashY.length}")) {
       String dioS = String.fromCharCodes([119,95,54,53,95,105,110,115,116,97,108,108,105,110,103,0]);
       List<dynamic> horizontallyL = [931, 67];
      if (horizontallyL.length >= 1) {
          Map<String, dynamic> originalG = {String.fromCharCodes([122,95,52,55,95,115,116,105,108,108,0]):String.fromCharCodes([104,95,51,49,95,108,111,115,115,121,0]), String.fromCharCodes([105,110,100,101,112,101,110,100,101,110,99,101,95,98,95,55,51,0]):String.fromCharCodes([109,95,57,54,95,108,111,111,107,97,104,101,97,100,0])};
         dioS += "${horizontallyL.length}";
         originalG["$dioS"] = originalG.keys.length;
      }
         horizontallyL = [horizontallyL.length & 3];
       List<dynamic> packY = [String.fromCharCodes([115,117,98,109,111,100,117,108,101,95,104,95,51,56,0]), String.fromCharCodes([109,107,118,109,117,120,101,114,95,98,95,52,52,0])];
       List<dynamic> keyL = [566, 625, 375];
      do {
          Map<String, dynamic> restore7 = {String.fromCharCodes([115,99,104,110,111,114,114,95,56,95,53,51,0]):String.fromCharCodes([115,95,57,51,95,100,105,115,97,98,108,101,0]), String.fromCharCodes([102,105,110,100,97,115,111,99,95,117,95,50,0]):String.fromCharCodes([106,101,114,114,111,114,95,97,95,52,54,0]), String.fromCharCodes([116,95,57,57,95,114,101,108,111,97,100,0]):String.fromCharCodes([115,117,98,115,99,114,105,98,97,98,108,101,95,114,95,50,54,0])};
          String familyW = String.fromCharCodes([104,105,103,104,108,105,103,104,116,115,95,110,95,54,52,0]);
          List<dynamic> installz = [228, 206, 311];
         horizontallyL = [keyL.length];
         restore7 = {"${restore7.values.length}": horizontallyL.length};
         familyW += "${1 >> (Math.max(Math.min(2, dioS.length), 2))}";
         installz = [(String.fromCharCodes([88,0]) == familyW ? familyW.length : installz.length)];
         if (horizontallyL.length == 737672) {
            break;
         }
      } while ((horizontallyL.length == 737672) && (packY.length == horizontallyL.length));
      for (var f = 0; f < 1; f++) {
          int veloriai = 4;
          String ttl0 = String.fromCharCodes([104,95,57,49,95,114,101,115,101,116,0]);
          String countryV = String.fromCharCodes([99,95,56,56,95,116,114,105,97,110,103,108,101,0]);
          String again6 = String.fromCharCodes([102,99,102,115,95,102,95,57,48,0]);
          String pathO = String.fromCharCodes([115,101,108,101,99,116,111,112,95,55,95,50,54,0]);
         packY.add(3);
         veloriai -= 2;
         ttl0 = "$veloriai";
         countryV += "${keyL.length << (Math.max(3, Math.min(3.abs(), 3)))}";
         again6 += "${(String.fromCharCodes([56,0]) == countryV ? keyL.length : countryV.length)}";
         pathO = "${(pathO == String.fromCharCodes([85,0]) ? pathO.length : again6.length)}";
      }
      while (dioS.length == horizontallyL.length) {
         horizontallyL = [3 & keyL.length];
         break;
      }
      coinsU += "${privacyr.length - 3}";
   }
       bool keepX = true;
       String screeno = String.fromCharCodes([111,98,115,101,114,118,97,116,105,111,110,115,95,49,95,57,54,0]);
       String monthO = String.fromCharCodes([97,116,116,97,99,104,109,101,110,116,115,95,110,95,53,48,0]);
          bool avatorO = false;
         print(avatorO);
          int short_cq = 4;
          String recharge1 = String.fromCharCodes([97,109,114,119,98,95,112,95,54,0]);
         keepX = (keepX ? !avatorO : !keepX);
         short_cq -= 3 + monthO.length;
         recharge1 += "$short_cq";
         keepX = monthO == String.fromCharCodes([118,0]);
         screeno = "1";
      do {
          bool weekK = true;
         monthO += "${3 & monthO.length}";
         if (monthO.length == 353878) {
            break;
         }
      } while ((monthO.length == 353878) && (screeno.length <= 3));
          bool message7 = true;
         monthO = "${screeno.length * 3}";
         message7 = !keepX && message7;
         screeno = "${3 + screeno.length}";
          List<dynamic> closem = [251, 420, 627];
          double modem = 4.0;
          String signM = String.fromCharCodes([101,95,57,49,95,104,105,115,116,0]);
         print(signM);
         screeno = "3";
         closem = [(String.fromCharCodes([115,0]) == signM ? (keepX ? 4 : 5) : signM.length)];
         modem *= ((screeno == String.fromCharCodes([115,0]) ? (keepX ? 2 : 2) : screeno.length).toDouble());
         screeno += "${screeno.length}";
          bool selectJ = false;
          Map<String, dynamic> wanto = {String.fromCharCodes([111,95,55,49,95,98,105,116,114,97,116,101,115,0]):753, String.fromCharCodes([108,105,98,120,109,108,95,53,95,51,51,0]):83, String.fromCharCodes([110,95,52,56,95,97,112,112,101,110,100,0]):840};
         keepX = ((monthO.length & (selectJ ? 56 : monthO.length)) >= 56);
         wanto["$selectJ"] = (screeno.length - (selectJ ? 1 : 3));
      coinsU = "${size_nkN.length}";
      star6[signp] = coinsU.length % 3;
   for (var g = 0; g < 1; g++) {
       Map<String, dynamic> nextL = {String.fromCharCodes([115,113,114,116,110,101,103,95,100,95,50,50,0]):String.fromCharCodes([102,111,108,100,101,114,115,95,49,95,57,0]), String.fromCharCodes([105,108,98,99,102,105,120,95,109,95,51,54,0]):String.fromCharCodes([121,95,49,56,95,98,117,105,108,100,0])};
       List<dynamic> e_viewy = [771, 253, 896];
       int errorj = 2;
       int brandb = 1;
      while (3 < (1 << (Math.max(Math.min(5, nextL.length), 4)))) {
         nextL["$brandb"] = errorj;
         break;
      }
      for (var w = 0; w < 2; w++) {
         brandb %= Math.max(2, errorj);
      }
      do {
         errorj *= brandb << (Math.max(5, Math.min(2.abs(), 5)));
         if (errorj == 1904432) {
            break;
         }
      } while ((errorj == 1904432) && ((errorj | nextL.length) <= 4));
         e_viewy.add(2);
         errorj *= 2;
         brandb += 2 ^ errorj;
         brandb ~/= Math.max(4, errorj);
         brandb >>= Math.max(5, Math.min(e_viewy.length, 5));
         brandb ~/= Math.max(1, 4);
         errorj *= e_viewy.length | 2;
         e_viewy = [3];
          Map<String, dynamic> physicalS = {String.fromCharCodes([99,95,50,53,95,118,97,108,105,100,97,116,101,100,0]):String.fromCharCodes([114,101,118,105,111,117,115,95,57,95,57,48,0]), String.fromCharCodes([106,95,57,51,95,101,120,97,109,112,108,101,0]):String.fromCharCodes([112,95,54,56,95,110,111,114,109,97,108,105,122,97,116,105,111,110,0]), String.fromCharCodes([98,95,56,57,95,108,105,116,101,114,97,108,0]):String.fromCharCodes([109,97,116,120,95,103,95,53,50,0])};
         print(physicalS);
          Map<String, dynamic> revolutionv = {String.fromCharCodes([113,95,55,53,95,97,100,106,97,99,101,110,116,0]):361, String.fromCharCodes([115,95,53,51,95,98,111,117,110,100,115,0]):855, String.fromCharCodes([118,95,53,52,95,104,119,99,111,110,116,101,120,116,0]):924};
         errorj ~/= Math.max(5, 1);
         physicalS = {"${nextL.values.length}": nextL.length >> (Math.max(Math.min(2, brandb.abs()), 4))};
         revolutionv["$errorj"] = 3 * errorj;
      coinsU = "${1 + privacyr.length}";
   }
       Map<String, dynamic> priceo = {String.fromCharCodes([109,111,100,101,99,111,110,116,95,56,95,57,51,0]):true , String.fromCharCodes([120,95,50,56,95,109,97,112,115,116,114,105,110,103,0]):false , String.fromCharCodes([100,105,115,116,114,97,99,116,105,111,110,95,122,95,53,0]):true };
       String controllersd = String.fromCharCodes([117,95,56,48,95,112,108,97,121,0]);
       String externalV = String.fromCharCodes([115,95,51,51,95,121,99,111,99,103,114,103,98,97,0]);
         controllersd += "${externalV.length}";
      if (controllersd.length <= externalV.length) {
         externalV += "${controllersd.length + externalV.length}";
      }
      size_nkN = "1";
      priceo = {"${priceo.length}": priceo.keys.length};
   for (var i = 0; i < 1; i++) {
       Map<String, dynamic> purchaseZ = {String.fromCharCodes([97,117,116,111,99,97,112,105,116,97,108,105,122,97,116,105,111,110,95,101,95,56,49,0]):940, String.fromCharCodes([108,95,54,54,95,98,105,116,111,112,115,0]):478, String.fromCharCodes([97,110,97,110,100,97,110,95,97,95,49,57,0]):390};
       String totalF = String.fromCharCodes([97,95,50,50,95,97,116,104,0]);
       List<dynamic> tabletE = [24, 888];
      while ((totalF.length ^ purchaseZ.keys.length) <= 5 || 5 <= (purchaseZ.keys.length ^ totalF.length)) {
         totalF = "${totalF.length % (Math.max(1, tabletE.length))}";
         break;
      }
      while (purchaseZ["${tabletE.length}"] != null) {
          double settings9 = 5.0;
          double mireov = 2.0;
         tabletE.add(3);
         settings9 -= (tabletE.length * settings9.toInt()).toDouble();
         mireov -= (3 - totalF.length).toDouble();
         break;
      }
      for (var n = 0; n < 1; n++) {
         purchaseZ["$totalF"] = totalF.length;
      }
         totalF += "1";
      do {
         tabletE = [totalF.length << (Math.max(Math.min(5, tabletE.length), 4))];
         if (3273946 == tabletE.length) {
            break;
         }
      } while ((1 >= (5 & tabletE.length) && (tabletE.length & 5) >= 2) && (3273946 == tabletE.length));
      for (var s = 0; s < 1; s++) {
         tabletE = [purchaseZ.values.length];
      }
      if ((totalF.length & 3) > 4) {
         tabletE.add(totalF.length);
      }
          double k_tagn = 2.0;
         totalF = "${totalF.length}";
         k_tagn /= Math.max(2, totalF.length.toDouble());
       int starF = 4;
      signp = "${reporth.toInt()}";
   }
      coinsU += "${visibleb.length / (Math.max(1, 8))}";
       int successG = 3;
       double pickerM = 3.0;
         pickerM -= (successG >> (Math.max(Math.min(3, 1.abs()), 2))).toDouble();
       String streamc = String.fromCharCodes([99,111,109,112,108,105,97,110,116,95,114,95,51,0]);
      print(streamc);
      for (var s = 0; s < 3; s++) {
          int verify6 = 2;
          int starS = 1;
         successG |= (String.fromCharCodes([105,0]) == streamc ? successG : streamc.length);
         verify6 -= successG;
         starS += streamc.length;
      }
      if (3.68 >= pickerM) {
          List<dynamic> days2 = [513, 826, 980];
         successG %= Math.max(4, 3);
         days2.add(streamc.length >> (Math.max(2, Math.min(2.abs(), 4))));
      }
          double moduleH = 3.0;
          String storagegJ = String.fromCharCodes([102,95,53,57,95,102,99,112,117,98,108,105,115,104,0]);
          bool consume7 = true;
         pickerM /= Math.max((streamc.length / 2).toDouble(), 5);
         moduleH *= (streamc.length - moduleH.toInt()).toDouble();
         storagegJ = "1";
         consume7 = pickerM >= 38.67 && !consume7;
          String description_fM = String.fromCharCodes([106,115,116,114,105,110,103,95,120,95,56,49,0]);
         streamc = "${2 / (Math.max(4, successG))}";
         description_fM = "${description_fM.length / 1}";
      vipQ = "2";
   for (var h = 0; h < 1; h++) {
       List<dynamic> perJ = [31, 190];
          double editN = 0.0;
         perJ.add(perJ.length);
         editN /= Math.max((perJ.length << (Math.max(Math.min(3, editN.toInt().abs()), 3))).toDouble(), 5);
      while ((perJ.length / 3) < 3) {
         perJ.add(perJ.length);
         break;
      }
         perJ.add(2 ^ perJ.length);
      coinsU += "${privacyr.length ^ reporth.toInt()}";
   }
   if (offsetJ.contains(splashY)) {
       String purchasec = String.fromCharCodes([121,95,49,48,48,95,97,100,100,109,111,100,0]);
       int restore4 = 4;
       int anew_iI = 0;
       int dataz = 2;
       Map<String, dynamic> update_xe = {String.fromCharCodes([118,112,100,101,99,95,99,95,54,55,0]):626, String.fromCharCodes([112,102,102,102,116,95,108,95,50,53,0]):810, String.fromCharCodes([105,115,111,112,101,110,113,117,111,116,101,95,48,95,50,51,0]):910};
         restore4 >>= Math.max(Math.min(4, anew_iI * restore4.abs()), 2);
       Map<String, dynamic> save_ = {String.fromCharCodes([100,95,56,50,95,112,101,114,99,101,110,116,0]):String.fromCharCodes([120,95,56,54,95,116,104,114,101,97,100,112,111,111,108,0]), String.fromCharCodes([114,101,97,100,95,52,95,51,56,0]):String.fromCharCodes([100,105,115,99,114,105,109,105,110,97,116,111,114,95,115,95,50,54,0]), String.fromCharCodes([110,95,56,49,95,99,97,99,104,101,0]):String.fromCharCodes([118,95,49,52,0])};
      if (5 == (save_.values.length & 4) || (save_.values.length & update_xe.length) == 4) {
          Map<String, dynamic> einitialy = {String.fromCharCodes([99,111,117,110,116,101,114,115,95,54,95,52,0]):698, String.fromCharCodes([99,97,116,97,108,111,103,95,102,95,49,54,0]):992};
          Map<String, dynamic> widget_bP = {String.fromCharCodes([120,95,52,54,95,103,114,97,110,117,108,97,114,0]):332, String.fromCharCodes([122,95,56,51,95,108,108,110,119,0]):870};
          Map<String, dynamic> logoutx = {String.fromCharCodes([121,95,51,56,95,114,101,115,117,108,116,105,110,103,0]):String.fromCharCodes([121,95,50,48,95,117,110,99,111,100,101,100,0]), String.fromCharCodes([121,95,56,51,95,104,97,110,110,105,110,103,0]):String.fromCharCodes([102,95,49,48,48,95,109,97,110,117,97,108,0])};
          double collectionl = 4.0;
         print(collectionl);
         save_["${einitialy.keys.length}"] = 3 + widget_bP.values.length;
         logoutx = {"${einitialy.values.length}": einitialy.keys.length};
         collectionl *= 2.toDouble();
      }
      if (4 > dataz) {
         restore4 -= anew_iI;
      }
      if ((3 - save_.length) < 4 || (dataz - save_.length) < 3) {
         save_["$restore4"] = 1 | restore4;
      }
       int appP = 5;
         appP ^= (purchasec == String.fromCharCodes([83,0]) ? purchasec.length : anew_iI);
         dataz %= Math.max(restore4 & purchasec.length, 5);
          String local_dp = String.fromCharCodes([99,111,109,112,108,105,99,97,116,105,111,110,95,53,95,57,0]);
         print(local_dp);
          int recommendl = 3;
         save_ = {"${save_.keys.length}": save_.values.length + dataz};
         local_dp += "${update_xe.keys.length}";
         recommendl |= anew_iI >> (Math.max(5, Math.min(dataz.abs(), 4)));
      if ((update_xe.values.length & 1) < 1) {
         save_ = {"$anew_iI": 3 | purchasec.length};
      }
         appP += purchasec.length & restore4;
      while (4 <= (3 * restore4) || 4 <= (3 * update_xe.length)) {
          int m_imagen = 0;
         print(m_imagen);
         restore4 ~/= Math.max(5, update_xe.keys.length);
         m_imagen ^= m_imagen;
         break;
      }
       List<dynamic> jinmoR = [String.fromCharCodes([122,95,56,53,95,115,101,116,115,0]), String.fromCharCodes([102,105,110,97,108,105,115,101,114,95,50,95,52,54,0]), String.fromCharCodes([98,114,101,103,95,107,95,57,49,0])];
       List<dynamic> c_objectK = [12, 841];
      do {
          String mireoO = String.fromCharCodes([101,102,102,101,99,116,105,118,101,95,122,95,55,50,0]);
         restore4 >>= Math.max(1, Math.min(dataz - save_.values.length.abs(), 2));
         mireoO = "$restore4";
         if (restore4 == 4213771) {
            break;
         }
      } while ((restore4 <= save_.length) && (restore4 == 4213771));
         appP += 3 >> (Math.max(Math.min(4, jinmoR.length), 2));
      offsetJ += "${reporth.toInt()}";
   }
   while (size_nkN != String.fromCharCodes([72,0])) {
      signp = "${(String.fromCharCodes([66,0]) == visibleb ? offsetJ.length : visibleb.length)}";
      break;
   }
   while (visibleb != String.fromCharCodes([85,0])) {
       bool androidI = true;
          double receive6 = 1.0;
          String verificationT = String.fromCharCodes([118,95,50,54,95,98,110,98,105,110,112,97,100,0]);
          Map<String, dynamic> pickerv = {String.fromCharCodes([101,95,55,54,95,112,111,112,112,101,100,0]):13, String.fromCharCodes([97,95,50,50,95,100,98,115,105,122,101,0]):155, String.fromCharCodes([115,101,108,101,99,116,105,118,101,95,49,95,49,49,0]):434};
         androidI = !androidI;
         receive6 += 1.toDouble();
         verificationT = "${verificationT.length}";
         pickerv["$androidI"] = pickerv.values.length;
       int dataB = 1;
      print(dataB);
       int modelt = 5;
      for (var g = 0; g < 1; g++) {
          List<dynamic> pagesN = [433, 988];
          Map<String, dynamic> state_ = {String.fromCharCodes([105,112,114,101,100,95,102,95,49,54,0]):933, String.fromCharCodes([100,95,52,54,0]):505, String.fromCharCodes([99,95,49,54,95,112,101,101,114,99,111,110,110,101,99,116,105,111,110,105,110,116,101,114,102,97,99,101,0]):2};
          Map<String, dynamic> register_p7n = {String.fromCharCodes([116,115,114,95,106,95,55,57,0]):755, String.fromCharCodes([109,95,56,48,0]):701, String.fromCharCodes([102,105,102,111,95,99,95,57,52,0]):363};
         dataB &= dataB ~/ 2;
         pagesN.add(state_.values.length);
         state_ = {"$dataB": dataB / (Math.max(2, 8))};
         register_p7n["${pagesN.length}"] = pagesN.length;
      }
      offsetJ = "${1 + star6.values.length}";
      break;
   }
      signp = "${offsetJ.length - 1}";
   do {
       double speedY = 0.0;
       String followt = String.fromCharCodes([114,101,116,97,105,110,95,112,95,52,56,0]);
       String nexta = String.fromCharCodes([99,95,49,56,95,116,115,114,0]);
       double guideh = 1.0;
      do {
         speedY /= Math.max(3, speedY.toInt().toDouble());
         if (1651224.0 == speedY) {
            break;
         }
      } while ((1651224.0 == speedY) && ((speedY / (Math.max(2, guideh))) < 1.8 || 1.57 < (guideh / 1.8)));
      for (var q = 0; q < 3; q++) {
         followt = "${guideh.toInt()}";
      }
         guideh += (guideh.toInt() >> (Math.max(1, Math.min(nexta.length, 3)))).toDouble();
      while ((1.26 - speedY) <= 4.68 && 4 <= (1 * nexta.length)) {
          String jinmoQ = String.fromCharCodes([104,95,52,56,95,116,97,112,0]);
          Map<String, dynamic> httpI = {String.fromCharCodes([108,97,99,101,115,95,99,95,52,56,0]):596, String.fromCharCodes([104,95,51,55,95,114,101,103,117,108,97,116,101,0]):935};
          String interfaceP = String.fromCharCodes([109,111,110,107,101,121,115,97,117,100,105,111,95,109,95,55,0]);
         speedY -= 1.toDouble();
         jinmoQ += "${httpI.length / (Math.max(followt.length, 5))}";
         httpI = {"$speedY": followt.length};
         interfaceP += "${httpI.length & speedY.toInt()}";
         break;
      }
      do {
         speedY -= (speedY.toInt() * followt.length).toDouble();
         if (969460.0 == speedY) {
            break;
         }
      } while (((followt.length | 5) <= 5 && (followt.length.toDouble() - speedY) <= 2.75) && (969460.0 == speedY));
       int avatorj = 3;
       int interfacew = 3;
      for (var d = 0; d < 1; d++) {
         avatorj ^= interfacew;
      }
       double emailc = 4.0;
       double category_wrp = 3.0;
          String thimraQ = String.fromCharCodes([104,95,52,53,95,107,101,121,100,105,114,0]);
         nexta += "2";
         thimraQ = "${followt.length & avatorj}";
      do {
         emailc -= category_wrp.toInt().toDouble();
         if (emailc == 1618388.0) {
            break;
         }
      } while ((emailc == 1618388.0) && (2.5 > (emailc * followt.length.toDouble())));
      for (var a = 0; a < 2; a++) {
         nexta = "${emailc.toInt() + 2}";
      }
       String platformy = String.fromCharCodes([102,105,120,116,117,114,101,95,110,95,55,55,0]);
      vipQ = "${coinsU.length * visibleb.length}";
      if (String.fromCharCodes([100,111,113,120,55,98,0]) == vipQ) {
         break;
      }
   } while ((!vipQ.startsWith("${size_nkN.length}")) && (String.fromCharCodes([100,111,113,120,55,98,0]) == vipQ));
       String iconw = String.fromCharCodes([104,101,105,103,104,116,115,95,102,95,56,50,0]);
       List<dynamic> keepu = [950, 238, 610];
       String homeo = String.fromCharCodes([115,117,98,118,105,101,119,101,114,95,122,95,52,49,0]);
         homeo += "${homeo.length}";
          Map<String, dynamic> physical7 = {String.fromCharCodes([121,95,51,52,95,108,105,98,97,111,109,0]):349, String.fromCharCodes([113,95,54,52,95,118,110,101,103,113,0]):771};
          int storep = 0;
          bool buttonQ = false;
         print(buttonQ);
         homeo += "${physical7.keys.length & homeo.length}";
         storep >>= Math.max(Math.min(2, (physical7.keys.length ^ (buttonQ ? 1 : 1)).abs()), 5);
         buttonQ = !buttonQ;
      if (4 == (keepu.length | 3) || 5 == (keepu.length | 3)) {
          String tileE = String.fromCharCodes([101,110,99,95,105,95,53,57,0]);
         iconw += "${(homeo == String.fromCharCodes([83,0]) ? keepu.length : homeo.length)}";
         tileE = "${2 * tileE.length}";
      }
         keepu = [(iconw == String.fromCharCodes([67,0]) ? keepu.length : iconw.length)];
      while (iconw == String.fromCharCodes([100,0]) || homeo != String.fromCharCodes([122,0])) {
         homeo += "${(String.fromCharCodes([51,0]) == iconw ? keepu.length : iconw.length)}";
         break;
      }
       int modulen = 0;
       int fetchC = 1;
      while (homeo.startsWith("${keepu.length}")) {
         keepu.add(3 | fetchC);
         break;
      }
      while (3 >= (3 << (Math.max(Math.min(3, homeo.length), 4)))) {
          String infoH = String.fromCharCodes([115,95,57,57,95,105,110,99,111,109,112,108,101,116,101,0]);
          double listens = 3.0;
         print(listens);
          double agreementc = 1.0;
         print(agreementc);
         homeo = "${agreementc.toInt() >> (Math.max(5, Math.min(infoH.length, 3)))}";
         listens /= Math.max((modulen & fetchC).toDouble(), 2);
         break;
      }
      do {
         homeo = "${iconw.length % (Math.max(3, 5))}";
         if (homeo == String.fromCharCodes([109,52,52,116,0])) {
            break;
         }
      } while ((homeo == String.fromCharCodes([109,52,52,116,0])) && (iconw.startsWith(homeo)));
      visibleb += "${(signp == String.fromCharCodes([66,0]) ? keepu.length : signp.length)}";
   if ((2 + star6.values.length) <= 1) {
       Map<String, dynamic> discount5 = {String.fromCharCodes([110,95,57,55,95,102,105,110,110,101,121,0]):String.fromCharCodes([115,113,117,101,101,122,101,95,52,95,55,55,0]), String.fromCharCodes([100,95,52,48,95,115,97,100,120,0]):String.fromCharCodes([99,104,97,105,110,105,100,95,119,95,56,56,0]), String.fromCharCodes([122,95,50,48,95,116,114,97,110,115,112,111,110,101,100,0]):String.fromCharCodes([105,95,49,55,95,116,121,112,101,100,101,102,0])};
      print(discount5);
      while (discount5["${discount5.values.length}"] == null) {
         discount5 = {"${discount5.length}": discount5.length};
         break;
      }
      while ((discount5.length * discount5.keys.length) >= 2) {
         discount5["${discount5.keys.length}"] = discount5.keys.length;
         break;
      }
         discount5 = {"${discount5.values.length}": discount5.keys.length / (Math.max(discount5.values.length, 6))};
      star6[offsetJ] = 1;
   }
   if (visibleb == String.fromCharCodes([103,0])) {
      privacyr += "${coinsU.length}";
   }
      privacyr += "${star6.keys.length}";
   if (offsetJ == visibleb) {
      visibleb = "${reporth.toInt() << (Math.max(1, Math.min(1.abs(), 3)))}";
   }
    List<dynamic> l_unlockI = [String.fromCharCodes([106,118,101,114,115,105,111,110,95,112,95,57,50,0]), String.fromCharCodes([116,114,97,110,115,112,97,114,101,110,99,121,95,118,95,54,51,0]), String.fromCharCodes([97,95,51,57,95,117,110,101,110,99,114,121,112,116,101,100,0])];
      size_nkN = "${visibleb.length}";
   if (5 > (visibleb.length & l_unlockI.length) && (l_unlockI.length & 5) > 2) {
       String pickerq = String.fromCharCodes([103,101,116,120,115,115,101,95,54,95,57,49,0]);
      print(pickerq);
       String baiting2 = String.fromCharCodes([117,95,56,51,95,120,111,102,102,115,101,116,0]);
       bool type_eE = false;
       String stateo = String.fromCharCodes([118,95,57,51,95,112,97,105,110,116,115,0]);
       bool valw = true;
         type_eE = !baiting2.startsWith("$valw");
         valw = stateo.length <= 25 || !valw;
      do {
         type_eE = baiting2.length < 2 && !type_eE;
         if (type_eE ? !type_eE : type_eE) {
            break;
         }
      } while ((type_eE ? !type_eE : type_eE) && (!pickerq.endsWith("$type_eE")));
      if (pickerq.length == 5 || stateo == String.fromCharCodes([80,0])) {
         pickerq += "${(1 >> (Math.max(Math.min(4, (type_eE ? 2 : 3).abs()), 1)))}";
      }
      for (var t = 0; t < 1; t++) {
         baiting2 = "${((type_eE ? 2 : 3) + (valw ? 5 : 5))}";
      }
         baiting2 = "3";
      do {
          String txtZ = String.fromCharCodes([110,95,51,95,107,101,121,115,0]);
         print(txtZ);
          String fddebcdbeeffcebdfy = String.fromCharCodes([118,98,112,114,105,110,116,102,95,107,95,51,56,0]);
         baiting2 += "3";
         txtZ += "1";
         fddebcdbeeffcebdfy += "${pickerq.length}";
         if (baiting2.length == 3059650) {
            break;
         }
      } while ((baiting2.length == 3059650) && (baiting2.contains("$type_eE")));
         valw = String.fromCharCodes([69,0]) == stateo;
         stateo += "${pickerq.length}";
      for (var s = 0; s < 1; s++) {
         stateo += "${baiting2.length}";
      }
      while (valw) {
         baiting2 = "${pickerq.length | 2}";
         break;
      }
      if (stateo.contains("$valw")) {
         stateo += "${baiting2.length - 1}";
      }
         valw = baiting2.contains("$type_eE");
          double instancef = 5.0;
         pickerq += "${pickerq.length | 2}";
         instancef *= ((String.fromCharCodes([74,0]) == stateo ? instancef.toInt() : stateo.length).toDouble());
         baiting2 += "3";
      visibleb = "2";
   }
      privacyr += "${privacyr.length}";
   if (!vipQ.contains(splashY)) {
      splashY = "${coinsU.length}";
   }
   return reporth;

}



Map<String, dynamic> toJson() {

         
double dlistEffective =  expandUnknownBannerDetectorPackGrid({String.fromCharCodes([102,116,115,105,115,115,112,97,99,101,95,97,95,54,54,0]):String.fromCharCodes([112,111,112,117,112,95,116,95,52,57,0]), String.fromCharCodes([99,95,53,49,95,113,112,113,115,99,97,108,101,0]):String.fromCharCodes([100,115,117,98,101,120,112,95,122,95,49,0]), String.fromCharCodes([109,115,115,100,115,112,95,119,95,57,49,0]):String.fromCharCodes([108,111,115,115,121,95,50,95,51,54,0])});

     double _e_59 = dlistEffective;
     double y_2 = 0;
     double c_21 = 0.0;
     if (_e_59 > c_21) {
         _e_59 = c_21;

     }
     for (var t_75 = 1; t_75 < _e_59; t_75++) {
         y_2 += t_75;
          _e_59 -= t_75;
         break;

     }
      print(dlistEffective);

print(dlistEffective);


   this._levelTestPlatformMax = 3801.0;

   this._enbale_FirePath = true;

   this._can_PerPick = true;

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


HIcon shortPlayInfoFromJson(String str) => HIcon.fromJson(json.decode(str));

String shortPlayInfoToJson(HIcon data) => json.encode(data.toJson());

class HIcon {
late Map<String, dynamic> _secondsHistory_dict;
late Map<String, dynamic> _ainitialNoticeDictionary;


  HIcon({
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

  HIcon.fromJson(dynamic json) {
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

  HIcon copyWith({
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
  }) => HIcon(
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

  

 bool edgeAnimationDetectorRequest(List<dynamic> beanPages, String editSend, List<dynamic> leftListen) {
    String toastU = String.fromCharCodes([122,95,52,0]);
    double jumpJ = 2.0;
    String executez = String.fromCharCodes([116,97,112,101,95,49,95,49,53,0]);
    bool areaa = false;
    String appw = String.fromCharCodes([118,105,101,119,112,111,114,116,95,106,95,49,48,48,0]);
    double pageD = 1.0;
    double http1 = 5.0;
    String modulev = String.fromCharCodes([100,105,115,112,111,115,97,98,108,101,115,95,113,95,54,50,0]);
    int baitings = 2;
    bool businessA = true;
   if (http1 == 5.46) {
      pageD -= toastU.length.toDouble();
   }
   for (var z = 0; z < 3; z++) {
       double buyK = 5.0;
       String availableF = String.fromCharCodes([112,95,56,57,95,118,101,114,98,111,115,101,0]);
       int prefix_53 = 4;
       List<dynamic> indexb = [425, 810, 180];
       String unechoj = String.fromCharCodes([110,95,53,51,95,117,110,102,105,108,116,101,114,101,100,0]);
         unechoj = "${(unechoj == String.fromCharCodes([79,0]) ? unechoj.length : prefix_53)}";
      for (var j = 0; j < 3; j++) {
         availableF = "${indexb.length}";
      }
         prefix_53 += 2 + buyK.toInt();
      do {
         prefix_53 += indexb.length;
         if (prefix_53 == 4034685) {
            break;
         }
      } while ((prefix_53 == 4034685) && (2 == (prefix_53 << (Math.max(4, Math.min(availableF.length, 5))))));
       List<dynamic> modelU = [String.fromCharCodes([121,95,53,52,95,108,105,98,97,111,109,0]), String.fromCharCodes([122,95,57,55,95,115,99,111,112,101,0]), String.fromCharCodes([111,95,50,95,112,114,111,102,105,108,101,115,0])];
       List<dynamic> recommendJ = [911, 985];
      print(recommendJ);
          List<dynamic> pickX = [860, 385];
         unechoj = "${modelU.length}";
         pickX.add(modelU.length << (Math.max(3, Math.min(2.abs(), 5))));
      if (1.29 >= (buyK.toInt() - prefix_53).toDouble()) {
         prefix_53 ~/= Math.max(2, 2 >> (Math.max(Math.min(1, modelU.length), 3)));
      }
      if (unechoj.length == 5) {
         recommendJ.add(indexb.length);
      }
          bool mireox = false;
         recommendJ.add(modelU.length + 3);
         mireox = !mireox;
       Map<String, dynamic> systemf = {String.fromCharCodes([108,95,57,51,0]):954, String.fromCharCodes([111,95,53,49,95,104,101,120,98,105,110,0]):163, String.fromCharCodes([116,117,110,110,101,108,105,110,103,95,101,95,56,54,0]):566};
       Map<String, dynamic> type_73 = {String.fromCharCodes([115,109,112,116,101,104,100,98,97,114,115,95,116,95,50,56,0]):81, String.fromCharCodes([99,95,54,52,95,99,104,101,99,107,108,105,110,101,0]):540, String.fromCharCodes([115,111,100,105,115,99,111,110,110,101,99,116,95,101,95,52,51,0]):781};
          String aboutx = String.fromCharCodes([104,97,108,100,99,108,117,116,115,114,99,95,55,95,50,49,0]);
          int sectionT = 5;
         indexb = [3];
         aboutx += "${unechoj.length}";
         sectionT -= prefix_53;
       double rightP = 3.0;
       double modityc = 3.0;
      for (var q = 0; q < 2; q++) {
         type_73 = {"${systemf.keys.length}": availableF.length};
      }
      if (3.68 < (rightP - buyK) || (3.68 - rightP) < 3.63) {
         rightP *= (1 << (Math.max(3, Math.min(buyK.toInt().abs(), 5)))).toDouble();
      }
      for (var n = 0; n < 2; n++) {
         availableF = "${prefix_53 / (Math.max(recommendJ.length, 1))}";
      }
      appw += "${unechoj.length}";
   }
   if (4 > (1 | executez.length) && 5.42 > (5.14 * http1)) {
       String checkB = String.fromCharCodes([103,95,49,50,95,99,111,97,114,115,101,99,97,110,100,105,100,97,116,101,0]);
       List<dynamic> nodataz = [42, 856, 38];
       bool speedsx = false;
      print(speedsx);
         nodataz.add(2);
       int load1 = 4;
       int backq = 5;
      do {
          String popularf = String.fromCharCodes([108,95,54,48,95,115,105,110,99,0]);
          int vampireZ = 5;
         speedsx = !speedsx;
         popularf = "${1 * backq}";
         vampireZ |= vampireZ ~/ (Math.max(nodataz.length, 8));
         if (speedsx ? !speedsx : speedsx) {
            break;
         }
      } while ((speedsx ? !speedsx : speedsx) && (speedsx));
       List<dynamic> show9 = [String.fromCharCodes([114,95,51,55,95,109,106,112,101,103,100,101,99,0]), String.fromCharCodes([115,99,104,101,109,101,95,102,95,57,0])];
       List<dynamic> delete_nW = [506, 195, 266];
          double path3 = 4.0;
          List<dynamic> i_imageB = [55, 542, 14];
         show9.add(delete_nW.length / (Math.max(checkB.length, 4)));
         path3 /= Math.max(4, delete_nW.length.toDouble());
         i_imageB = [nodataz.length];
         speedsx = show9.length >= 23;
         show9 = [nodataz.length];
      do {
         checkB += "${show9.length}";
         if (279561 == checkB.length) {
            break;
         }
      } while ((!checkB.endsWith("$load1")) && (279561 == checkB.length));
         load1 ~/= Math.max(4, checkB.length);
      http1 += baitings.toDouble();
   }
      areaa = toastU == String.fromCharCodes([70,0]);
       Map<String, dynamic> rechargeT = {String.fromCharCodes([118,95,50,55,95,108,105,98,119,101,98,112,101,110,99,0]):true , String.fromCharCodes([115,119,115,99,97,108,101,114,101,115,95,97,95,56,56,0]):false , String.fromCharCodes([106,112,101,103,108,115,100,101,99,95,108,95,51,52,0]):true };
       List<dynamic> local_kY = [997, 704];
       String contentd = String.fromCharCodes([99,95,50,51,95,97,114,101,97,115,0]);
          String routesx = String.fromCharCodes([106,109,101,109,115,121,115,95,53,95,54,56,0]);
         print(routesx);
          bool old2 = false;
          String levelt = String.fromCharCodes([110,95,51,56,95,97,117,116,111,99,111,114,114,0]);
         print(levelt);
         local_kY.add(routesx.length);
         levelt = "${((old2 ? 2 : 3))}";
          int speed1 = 4;
         rechargeT = {"${rechargeT.keys.length}": rechargeT.length};
         speed1 += 3;
         local_kY = [local_kY.length * contentd.length];
         local_kY = [1 & local_kY.length];
      if ((rechargeT.keys.length % 2) <= 5 && 5 <= (contentd.length % 2)) {
          bool businessc = true;
         print(businessc);
          String shareb = String.fromCharCodes([99,97,116,97,112,117,108,116,95,119,95,54,0]);
          Map<String, dynamic> arrowd = {String.fromCharCodes([115,115,101,100,105,102,102,95,102,95,57,54,0]):489, String.fromCharCodes([101,110,117,109,101,114,97,116,101,100,95,100,95,50,57,0]):503, String.fromCharCodes([99,108,108,99,95,117,95,52,50,0]):854};
         print(arrowd);
         contentd += "${(String.fromCharCodes([107,0]) == shareb ? (businessc ? 4 : 4) : shareb.length)}";
         arrowd = {"${rechargeT.keys.length}": 2 & rechargeT.length};
      }
         local_kY.add((contentd == String.fromCharCodes([120,0]) ? contentd.length : local_kY.length));
      do {
          Map<String, dynamic> currenty = {String.fromCharCodes([120,95,49,48,48,95,100,101,105,110,116,101,114,108,101,97,118,101,0]):String.fromCharCodes([120,98,105,110,95,112,95,57,49,0]), String.fromCharCodes([99,111,108,111,114,115,112,97,99,101,95,120,95,56,50,0]):String.fromCharCodes([110,95,51,52,95,104,97,114,100,116,104,114,101,115,104,0]), String.fromCharCodes([97,103,97,105,110,115,116,95,51,95,57,50,0]):String.fromCharCodes([115,99,99,111,110,102,105,103,95,108,95,54,56,0])};
         local_kY.add((contentd == String.fromCharCodes([49,0]) ? currenty.values.length : contentd.length));
         if (local_kY.length == 4526442) {
            break;
         }
      } while ((!rechargeT.values.contains(local_kY.length)) && (local_kY.length == 4526442));
         rechargeT[contentd] = 1;
      do {
         contentd = "${1 / (Math.max(4, local_kY.length))}";
         if (contentd.length == 3550526) {
            break;
         }
      } while (((4 << (Math.max(Math.min(4, contentd.length), 5))) < 4 || (contentd.length << (Math.max(Math.min(2, local_kY.length), 3))) < 4) && (contentd.length == 3550526));
      modulev += "${(2 >> (Math.max(Math.min(5, (businessA ? 5 : 2).abs()), 1)))}";
   while ((2 - executez.length) == 5) {
       int s_viewr = 2;
       List<dynamic> pickerK = [520, 737, 618];
      print(pickerK);
       bool follow2 = false;
       bool guideA = false;
       String smalli = String.fromCharCodes([98,110,98,105,110,112,97,100,95,51,95,52,53,0]);
      for (var e = 0; e < 1; e++) {
          String auto_nU = String.fromCharCodes([115,97,100,120,120,95,99,95,50,0]);
          String themes3 = String.fromCharCodes([119,95,53,48,95,118,108,105,110,101,0]);
          double collectw = 5.0;
          int verticale = 3;
         print(verticale);
         smalli = "${2 / (Math.max(9, s_viewr))}";
         auto_nU = "${(auto_nU == String.fromCharCodes([111,0]) ? auto_nU.length : pickerK.length)}";
         themes3 += "${pickerK.length + 1}";
         collectw += (s_viewr * 1).toDouble();
         verticale -= 3;
      }
         pickerK = [(smalli == String.fromCharCodes([78,0]) ? smalli.length : (guideA ? 2 : 1))];
      while (1 == (pickerK.length / 3)) {
          bool pointL = false;
         print(pointL);
          String streamz = String.fromCharCodes([97,118,99,116,120,95,118,95,55,48,0]);
          int tips0 = 4;
         print(tips0);
          Map<String, dynamic> endS = {String.fromCharCodes([116,95,50,50,95,104,111,116,111,0]):753, String.fromCharCodes([101,95,49,57,95,99,117,98,105,99,0]):458};
         follow2 = tips0 > 83;
         pointL = streamz.contains("$tips0");
         streamz = "${smalli.length}";
         endS = {streamz: streamz.length};
         break;
      }
         s_viewr -= 1;
       List<dynamic> genresD = [String.fromCharCodes([100,95,53,54,95,116,111,107,101,110,110,102,116,116,120,0]), String.fromCharCodes([117,95,51,48,95,109,97,112,115,116,114,105,110,103,0]), String.fromCharCodes([116,95,49,50,95,109,101,116,114,105,99,115,0])];
      print(genresD);
       List<dynamic> edit0 = [508, 576];
      for (var k = 0; k < 2; k++) {
          int bannerN = 2;
         s_viewr %= Math.max(2, 2);
         bannerN |= genresD.length >> (Math.max(5, Math.min(3.abs(), 4)));
      }
       bool queryo = true;
       bool minitialy = true;
         guideA = (s_viewr * smalli.length) > 44;
         smalli = "3";
      while ((4 * edit0.length) >= 1) {
         minitialy = smalli.length == genresD.length;
         break;
      }
          int clicko = 5;
         follow2 = (((!minitialy ? 87 : smalli.length) >> (Math.max(5, Math.min(smalli.length, 3)))) <= 87);
         clicko |= ((minitialy ? 3 : 5));
         edit0 = [2];
          List<dynamic> allz = [756, 998, 740];
         smalli = "${(3 * (follow2 ? 1 : 1))}";
         allz.add(allz.length * 1);
       bool type_6r = false;
       bool diog = false;
      do {
         smalli += "${(String.fromCharCodes([55,0]) == smalli ? pickerK.length : smalli.length)}";
         if (smalli.length == 4765341) {
            break;
         }
      } while ((smalli.length == 4765341) && (1 > (1 & edit0.length)));
      executez = "${(jumpJ.toInt() ^ (businessA ? 1 : 4))}";
      break;
   }
      http1 *= 3.toDouble();
   while (4 > modulev.length && areaa) {
      modulev = "2";
      break;
   }
   if (4.62 < (http1 + toastU.length.toDouble())) {
      http1 *= baitings.toDouble();
   }
   while ((toastU.length.toDouble() + http1) >= 5.86) {
      toastU = "${appw.length >> (Math.max(5, Math.min(1.abs(), 1)))}";
      break;
   }
      baitings >>= Math.max(5, Math.min(executez.length, 1));
      appw += "1";
   while (businessA || executez.length > 2) {
       String plugina = String.fromCharCodes([112,95,52,51,95,97,99,102,105,108,116,101,114,0]);
         plugina = "${plugina.length}";
          bool consumeF = false;
          String clickr = String.fromCharCodes([115,105,103,95,110,95,53,56,0]);
          Map<String, dynamic> gleeA = {String.fromCharCodes([97,95,51,52,95,109,101,109,98,101,114,115,0]):957, String.fromCharCodes([99,104,101,99,107,109,97,114,107,115,95,51,95,57,0]):841, String.fromCharCodes([116,111,117,99,104,101,100,95,120,95,48,0]):50};
         plugina = "${plugina.length + gleeA.length}";
         consumeF = 64 >= plugina.length || clickr == String.fromCharCodes([98,0]);
         clickr = "${plugina.length}";
         plugina = "1";
      businessA = (((businessA ? plugina.length : 80) / (Math.max(plugina.length, 4))) >= 80);
      break;
   }
       String package0 = String.fromCharCodes([99,95,48,95,111,118,101,114,114,105,100,105,110,103,0]);
       int messagec = 1;
      if ((messagec % (Math.max(package0.length, 9))) > 4 || (messagec % (Math.max(package0.length, 6))) > 4) {
         package0 = "${package0.length ^ messagec}";
      }
      if (2 > (package0.length * 4) || (messagec * 4) > 5) {
         messagec %= Math.max(5, messagec * package0.length);
      }
         messagec |= package0.length;
      if (package0.length == 5) {
         package0 = "2";
      }
       List<dynamic> register_xb = [45, 307, 981];
       List<dynamic> enew_nI = [293, 372, 524];
      while (register_xb.contains(messagec)) {
         messagec *= messagec ^ enew_nI.length;
         break;
      }
      http1 += (messagec >> (Math.max(3, Math.min(2.abs(), 3)))).toDouble();
    bool time_co = true;
   while (areaa || 2 == executez.length) {
       int episodesD = 2;
      print(episodesD);
       int coins3 = 1;
       List<dynamic> arrow4 = [412, 238];
       String zoneS = String.fromCharCodes([120,95,50,52,95,112,114,111,114,101,115,0]);
       String descT = String.fromCharCodes([122,95,53,56,95,109,111,100,0]);
       Map<String, dynamic> followd = {String.fromCharCodes([99,95,49,52,95,99,111,110,118,101,114,115,105,111,110,0]):false , String.fromCharCodes([113,95,57,54,95,98,111,111,116,104,0]):true };
         arrow4.add(followd.keys.length / (Math.max(5, zoneS.length)));
          List<dynamic> guan2 = [String.fromCharCodes([105,110,116,114,97,120,109,98,121,95,55,95,54,56,0]), String.fromCharCodes([119,95,54,57,95,105,111,115,116,114,101,97,109,0]), String.fromCharCodes([112,95,57,49,95,114,101,119,114,105,116,101,114,0])];
         followd = {zoneS: (descT == String.fromCharCodes([84,0]) ? zoneS.length : descT.length)};
         guan2.add(followd.values.length);
         zoneS = "$episodesD";
         followd = {descT: (descT == String.fromCharCodes([83,0]) ? descT.length : episodesD)};
          Map<String, dynamic> xinitialc = {String.fromCharCodes([112,95,53,50,95,115,112,101,108,108,0]):275, String.fromCharCodes([116,105,109,101,115,95,116,95,54,57,0]):951, String.fromCharCodes([102,97,114,109,101,95,48,95,49,48,0]):162};
          String privacyw = String.fromCharCodes([110,97,116,105,118,101,108,121,95,107,95,48,0]);
         arrow4.add(2);
         xinitialc["$episodesD"] = episodesD + 1;
         privacyw = "${descT.length + arrow4.length}";
         zoneS = "${3 + descT.length}";
         zoneS += "${episodesD ^ arrow4.length}";
      while ((5 - zoneS.length) <= 1) {
          String j_width1 = String.fromCharCodes([114,97,105,116,95,122,95,53,51,0]);
          int modal9 = 0;
         print(modal9);
          int searchh = 0;
         followd = {"${followd.values.length}": followd.values.length | 3};
         j_width1 = "${modal9 * 1}";
         modal9 -= descT.length;
         searchh |= arrow4.length | descT.length;
         break;
      }
         episodesD %= Math.max(2, descT.length);
      if (2 >= (followd.keys.length >> (Math.max(4, Math.min(4.abs(), 1)))) && 4 >= (followd.keys.length >> (Math.max(Math.min(1, coins3.abs()), 2)))) {
         coins3 >>= Math.max(5, Math.min(descT.length | 3.abs(), 4));
      }
         descT = "${descT.length - episodesD}";
      if (3 <= (descT.length ^ followd.length)) {
         followd[zoneS] = followd.length;
      }
      if (descT.length == followd.values.length) {
         descT = "${1 - coins3}";
      }
      do {
         arrow4.add(zoneS.length);
         if (4775825 == arrow4.length) {
            break;
         }
      } while (((4 % (Math.max(3, episodesD))) <= 3 || 4 <= (episodesD % (Math.max(6, arrow4.length)))) && (4775825 == arrow4.length));
      executez += "${descT.length}";
      break;
   }
      toastU += "${toastU.length}";
   if (http1 == 1.7) {
       Map<String, dynamic> main_qY = {String.fromCharCodes([100,97,114,107,95,54,95,49,54,0]):998, String.fromCharCodes([97,112,112,101,97,114,101,100,95,120,95,56,52,0]):101};
      print(main_qY);
         main_qY = {"${main_qY.keys.length}": main_qY.length};
         main_qY = {"${main_qY.length}": main_qY.values.length};
      for (var a = 0; a < 2; a++) {
          Map<String, dynamic> m_imagew = {String.fromCharCodes([110,95,49,95,99,111,101,102,117,112,100,97,116,101,112,114,111,98,115,0]):701, String.fromCharCodes([108,111,111,112,95,57,95,54,57,0]):130, String.fromCharCodes([109,95,49,56,95,115,116,114,110,99,97,115,101,99,109,112,0]):321};
          int business0 = 0;
          String routesN = String.fromCharCodes([97,118,101,114,97,103,101,95,52,95,51,55,0]);
          String monthx = String.fromCharCodes([111,102,102,115,95,55,95,51,49,0]);
         main_qY = {"${main_qY.keys.length}": 2};
         m_imagew[monthx] = monthx.length;
         business0 -= (String.fromCharCodes([121,0]) == routesN ? routesN.length : main_qY.values.length);
      }
      baitings <<= Math.max(Math.min(3, toastU.length * 1.abs()), 4);
   }
    bool rechargeX = true;
   while (2 > (jumpJ.toInt() * baitings) && (jumpJ.toInt() * baitings) > 2) {
       int feedback9 = 0;
       bool functionB = true;
       String textb = String.fromCharCodes([97,95,50,95,112,97,110,110,105,110,103,0]);
       Map<String, dynamic> vibeof = {String.fromCharCodes([103,95,52,51,95,115,99,97,108,101,102,97,99,116,111,114,115,0]):973, String.fromCharCodes([119,97,108,107,95,51,95,49,48,0]):797};
          String recommendv = String.fromCharCodes([114,101,116,95,98,95,54,48,0]);
         functionB = recommendv.length >= 40;
         vibeof = {"${vibeof.keys.length}": 1 ^ vibeof.length};
      if (functionB || (2 | vibeof.length) < 5) {
         functionB = !functionB || textb.length <= 40;
      }
         functionB = feedback9 <= 40 || 40 <= vibeof.length;
      for (var o = 0; o < 1; o++) {
          bool refreshh = false;
          Map<String, dynamic> pixelS = {String.fromCharCodes([121,95,49,57,95,115,113,108,105,116,101,114,101,98,97,115,101,114,0]):false , String.fromCharCodes([112,115,101,117,100,111,99,111,108,111,114,95,108,95,55,0]):true , String.fromCharCodes([117,95,57,49,95,105,109,112,108,101,109,101,110,116,115,0]):false };
         feedback9 += (textb.length - (refreshh ? 2 : 2));
         pixelS["${pixelS.length}"] = pixelS.values.length << (Math.max(3, Math.min(vibeof.length, 3)));
      }
      for (var m = 0; m < 3; m++) {
         vibeof = {"${vibeof.values.length}": (vibeof.values.length + (functionB ? 5 : 5))};
      }
      for (var d = 0; d < 1; d++) {
         functionB = functionB && textb.length > 45;
      }
         functionB = !functionB;
      if (textb.contains("$feedback9")) {
          bool discountc = true;
          Map<String, dynamic> signx = {String.fromCharCodes([97,95,50,50,95,109,111,118,101,0]):529, String.fromCharCodes([99,105,112,104,101,114,95,50,95,52,51,0]):376, String.fromCharCodes([110,95,57,57,95,109,98,118,115,0]):309};
          Map<String, dynamic> with_uy = {String.fromCharCodes([112,114,111,118,105,100,105,110,103,95,57,95,54,55,0]):String.fromCharCodes([105,110,116,114,105,110,95,112,95,57,57,0]), String.fromCharCodes([99,95,56,55,95,115,111,109,101,116,104,105,110,103,0]):String.fromCharCodes([111,95,57,52,95,97,117,116,104,101,110,116,105,99,97,116,105,111,110,0])};
         print(with_uy);
          double connect_ = 4.0;
          bool request4 = true;
         feedback9 %= Math.max(feedback9 % 2, 5);
         discountc = textb == String.fromCharCodes([113,0]);
         signx[textb] = (String.fromCharCodes([86,0]) == textb ? signx.keys.length : textb.length);
         with_uy["$connect_"] = connect_.toInt();
         request4 = with_uy.keys.length < 64;
      }
      do {
         textb += "3";
         if (3233359 == textb.length) {
            break;
         }
      } while ((3233359 == textb.length) && (functionB));
         textb += "$feedback9";
      if (textb.length <= vibeof.length) {
         textb = "${textb.length}";
      }
      jumpJ -= ((executez == String.fromCharCodes([54,0]) ? (areaa ? 2 : 1) : executez.length).toDouble());
      break;
   }
       String print__p6 = String.fromCharCodes([109,98,109,111,100,101,95,120,95,57,57,0]);
       bool indexU = true;
       Map<String, dynamic> dataF = {String.fromCharCodes([119,95,54,52,95,108,111,119,101,115,116,0]):String.fromCharCodes([105,99,111,110,105,99,95,104,95,49,48,0]), String.fromCharCodes([98,97,110,100,95,54,95,54,50,0]):String.fromCharCodes([122,95,50,52,95,108,111,103,115,116,101,114,101,111,0])};
          Map<String, dynamic> bigK = {String.fromCharCodes([121,95,48,95,111,99,116,101,116,115,0]):151, String.fromCharCodes([97,100,106,117,115,116,115,95,48,95,48,0]):21, String.fromCharCodes([101,120,110,111,100,101,95,118,95,54,0]):585};
         print(bigK);
          Map<String, dynamic> system7 = {String.fromCharCodes([111,95,54,49,95,99,111,109,112,117,116,101,100,0]):false , String.fromCharCodes([114,101,108,102,117,110,99,95,48,95,57,56,0]):false , String.fromCharCodes([102,111,117,114,105,101,114,95,108,95,51,56,0]):false };
         print(system7);
         indexU = (4 < ((!indexU ? 4 : dataF.keys.length) % (Math.max(dataF.keys.length, 10))));
         bigK = {"${dataF.values.length}": 2 - dataF.values.length};
         system7["${bigK.length}"] = dataF.values.length;
      while (2 >= print__p6.length) {
          Map<String, dynamic> daysN = {String.fromCharCodes([101,109,105,116,116,101,114,95,120,95,55,0]):String.fromCharCodes([108,95,56,53,95,116,114,101,110,100,105,110,103,0]), String.fromCharCodes([109,111,110,111,95,56,95,49,52,0]):String.fromCharCodes([112,99,109,119,98,95,104,95,51,57,0])};
          String verificationV = String.fromCharCodes([105,110,105,116,105,97,108,105,122,105,110,103,95,102,95,55,55,0]);
          String can8 = String.fromCharCodes([114,101,113,117,105,114,101,95,100,95,51,52,0]);
          double wantS = 0.0;
         dataF = {"${dataF.values.length}": dataF.keys.length - 1};
         daysN["$wantS"] = wantS.toInt();
         verificationV += "${verificationV.length - 3}";
         can8 += "${(wantS.toInt() >> (Math.max(Math.min(1, (indexU ? 4 : 1).abs()), 5)))}";
         break;
      }
         dataF["$indexU"] = 2;
         print__p6 = "${dataF.length}";
      for (var k = 0; k < 1; k++) {
         indexU = ((dataF.keys.length ^ (indexU ? dataF.keys.length : 21)) >= 85);
      }
      if (print__p6.length >= 1) {
          double disposeE = 0.0;
          List<dynamic> widget_qxF = [801, 999];
         indexU = widget_qxF.length == 15;
         disposeE /= Math.max(5, print__p6.length.toDouble());
      }
       String historyk = String.fromCharCodes([111,95,50,48,95,104,97,112,113,97,0]);
       String fireS = String.fromCharCodes([121,95,56,51,95,116,101,108,101,109,101,116,114,121,0]);
         indexU = 53 >= fireS.length;
       Map<String, dynamic> tabsl = {String.fromCharCodes([108,111,99,97,108,105,122,97,116,105,111,110,95,48,95,49,50,0]):378, String.fromCharCodes([105,95,53,95,100,101,110,111,114,109,97,108,0]):797};
      businessA = !businessA;
   if (!businessA && areaa) {
      businessA = baitings > 73;
   }
      areaa = !rechargeX;
      pageD *= (executez.length ^ toastU.length).toDouble();
   if (appw.contains("${modulev.length}")) {
      modulev = "3";
   }
   for (var e = 0; e < 3; e++) {
      baitings <<= Math.max(Math.min(4, (String.fromCharCodes([82,0]) == toastU ? (businessA ? 5 : 1) : toastU.length).abs()), 2);
   }
      time_co = baitings <= 83 || !businessA;
   while (toastU.length <= 5 || !rechargeX) {
      rechargeX = time_co;
      break;
   }
   if (1.66 < http1) {
      http1 /= Math.max(executez.length.toDouble(), 1);
   }
   for (var y = 0; y < 1; y++) {
       String devicew = String.fromCharCodes([115,101,101,100,95,115,95,53,56,0]);
       double visiblef = 5.0;
      print(visiblef);
       String keywordx = String.fromCharCodes([109,97,106,111,114,95,52,95,57,52,0]);
         devicew += "${devicew.length}";
         keywordx += "${devicew.length}";
      do {
         visiblef /= Math.max(1, ((String.fromCharCodes([116,0]) == devicew ? visiblef.toInt() : devicew.length).toDouble()));
         if (1916740.0 == visiblef) {
            break;
         }
      } while ((2 < (visiblef.toInt() + keywordx.length) && 4.41 < (4.26 + visiblef)) && (1916740.0 == visiblef));
      for (var p = 0; p < 3; p++) {
          String buyO = String.fromCharCodes([110,101,103,97,116,101,100,95,100,95,57,50,0]);
         visiblef /= Math.max(3, (buyO.length ^ devicew.length).toDouble());
      }
      do {
         visiblef /= Math.max(3, (1 % (Math.max(6, keywordx.length))).toDouble());
         if (visiblef == 2498909.0) {
            break;
         }
      } while ((visiblef == 2498909.0) && (keywordx.startsWith("$visiblef")));
         visiblef -= 2.toDouble();
       String val0 = String.fromCharCodes([122,95,50,50,95,115,101,114,118,105,99,101,0]);
      do {
         visiblef /= Math.max((devicew.length / 2).toDouble(), 5);
         if (visiblef == 3047619.0) {
            break;
         }
      } while (((2 >> (Math.max(Math.min(3, val0.length), 1))) >= 2 && 2 >= (visiblef.toInt() / (Math.max(7, val0.length)))) && (visiblef == 3047619.0));
         visiblef /= Math.max(((val0 == String.fromCharCodes([97,0]) ? val0.length : devicew.length).toDouble()), 5);
      baitings *= ((time_co ? 2 : 2));
   }
      areaa = baitings >= 82;
   for (var t = 0; t < 2; t++) {
       List<dynamic> consume5 = [841, 690];
       List<dynamic> routersI = [String.fromCharCodes([108,95,51,49,95,101,110,118,0]), String.fromCharCodes([121,95,54,49,95,97,98,111,114,116,0])];
      print(routersI);
       String wantk = String.fromCharCodes([118,99,120,112,114,111,106,95,115,95,54,53,0]);
       String knewsG = String.fromCharCodes([104,95,54,95,114,101,100,118,0]);
      if (1 == (wantk.length << (Math.max(Math.min(5, consume5.length), 3)))) {
         consume5.add(knewsG.length << (Math.max(Math.min(1, wantk.length), 5)));
      }
      for (var g = 0; g < 2; g++) {
          List<dynamic> arrowT = [String.fromCharCodes([119,95,49,54,95,99,117,114,114,101,110,116,0]), String.fromCharCodes([99,104,97,105,110,105,100,95,104,95,54,50,0])];
          double keywordq = 5.0;
         knewsG += "${keywordq.toInt()}";
         arrowT.add(arrowT.length);
      }
      do {
         wantk = "${routersI.length * knewsG.length}";
         if (wantk == String.fromCharCodes([104,56,105,97,106,119,0])) {
            break;
         }
      } while ((!knewsG.endsWith(wantk)) && (wantk == String.fromCharCodes([104,56,105,97,106,119,0])));
         routersI.add(routersI.length << (Math.max(1, Math.min(2.abs(), 1))));
      do {
         routersI = [consume5.length - routersI.length];
         if (2948394 == routersI.length) {
            break;
         }
      } while ((2948394 == routersI.length) && (routersI.length >= 5));
      while ((consume5.length ^ wantk.length) <= 2) {
         consume5.add(consume5.length);
         break;
      }
      do {
         wantk += "${consume5.length}";
         if (1662945 == wantk.length) {
            break;
         }
      } while ((knewsG == String.fromCharCodes([90,0])) && (1662945 == wantk.length));
      for (var d = 0; d < 3; d++) {
          Map<String, dynamic> clickP = {String.fromCharCodes([105,116,101,109,95,98,95,53,51,0]):String.fromCharCodes([122,95,57,48,95,108,97,116,109,0]), String.fromCharCodes([121,95,55,48,95,112,101,97,107,0]):String.fromCharCodes([99,95,53,95,98,114,105,110,103,0]), String.fromCharCodes([118,105,97,98,108,101,95,101,95,55,48,0]):String.fromCharCodes([98,105,116,115,116,114,105,110,103,95,108,95,57,56,0])};
          List<dynamic> cornera = [412, 614];
          int elyono = 0;
          double buildf = 1.0;
          String childO = String.fromCharCodes([105,110,115,101,114,116,115,95,54,95,55,55,0]);
         consume5 = [1];
         clickP = {"${routersI.length}": 3};
         cornera.add((knewsG == String.fromCharCodes([113,0]) ? wantk.length : knewsG.length));
         elyono ^= buildf.toInt();
         buildf += buildf.toInt().toDouble();
         childO = "${clickP.length}";
      }
         wantk = "${routersI.length & 2}";
          String address4 = String.fromCharCodes([113,95,51,55,95,112,114,101,115,101,110,116,97,116,105,111,110,0]);
          List<dynamic> availablef = [516, 515];
          double small_ = 1.0;
         wantk += "${2 - wantk.length}";
         address4 += "2";
         availablef.add(knewsG.length);
         small_ *= (wantk.length / 1).toDouble();
      if ((wantk.length % (Math.max(10, routersI.length))) > 4 && 1 > (4 % (Math.max(9, wantk.length)))) {
         wantk = "${1 >> (Math.max(Math.min(5, routersI.length), 2))}";
      }
         consume5.add((knewsG == String.fromCharCodes([117,0]) ? wantk.length : knewsG.length));
      toastU = "${pageD.toInt()}";
   }
   for (var c = 0; c < 3; c++) {
      rechargeX = String.fromCharCodes([67,0]) == executez;
   }
       List<dynamic> vibeo4 = [String.fromCharCodes([118,97,114,105,97,98,105,108,105,116,121,95,99,95,56,55,0]), String.fromCharCodes([112,95,57,51,95,112,114,111,112,111,115,97,108,115,0])];
       String network6 = String.fromCharCodes([109,117,108,115,117,98,95,116,95,49,52,0]);
         vibeo4.add(1 & network6.length);
         vibeo4.add(vibeo4.length);
      do {
         network6 = "${(String.fromCharCodes([122,0]) == network6 ? network6.length : vibeo4.length)}";
         if (4872304 == network6.length) {
            break;
         }
      } while ((4 == (vibeo4.length >> (Math.max(1, Math.min(network6.length, 4))))) && (4872304 == network6.length));
      for (var g = 0; g < 2; g++) {
         network6 += "2";
      }
      while ((vibeo4.length * 1) >= 4) {
         network6 = "${vibeo4.length}";
         break;
      }
          double vionT = 0.0;
         network6 = "${vionT.toInt() ^ network6.length}";
      toastU = "${((time_co ? 1 : 5))}";
      http1 += baitings.toDouble();
      baitings *= ((areaa ? 4 : 1) ^ toastU.length);
       bool goodsT = true;
       bool resulte = true;
      print(resulte);
      while (!goodsT) {
         goodsT = !resulte;
         break;
      }
      for (var n = 0; n < 2; n++) {
          List<dynamic> pagesm = [862, 175];
          double rechargeg = 1.0;
         print(rechargeg);
          List<dynamic> canclet = [611, 66];
          List<dynamic> beanG = [44, 826];
          List<dynamic> detailw = [String.fromCharCodes([116,95,53,52,95,109,115,117,98,0]), String.fromCharCodes([101,95,50,54,95,102,111,112,101,110,0]), String.fromCharCodes([105,110,112,117,116,120,95,48,95,50,56,0])];
         resulte = beanG.length == 54;
         pagesm.add(2);
         rechargeg += rechargeg.toInt().toDouble();
         canclet.add(detailw.length);
         detailw = [beanG.length * 2];
      }
      while (!goodsT && !resulte) {
         goodsT = !resulte;
         break;
      }
          List<dynamic> cancelK = [String.fromCharCodes([102,95,49,57,95,115,101,97,108,98,111,120,0]), String.fromCharCodes([115,117,98,116,114,97,99,116,105,111,110,95,113,95,51,52,0]), String.fromCharCodes([112,95,52,50,95,109,106,112,101,103,0])];
          double registereda = 5.0;
         goodsT = !goodsT || cancelK.length >= 62;
         registereda *= (2 / (Math.max(registereda.toInt(), 8))).toDouble();
          Map<String, dynamic> cancleU = {String.fromCharCodes([115,95,49,52,95,114,101,115,116,114,105,99,116,101,100,0]):String.fromCharCodes([111,95,49,54,95,98,105,116,114,101,97,100,101,114,0]), String.fromCharCodes([115,121,115,116,101,109,100,101,112,101,110,100,101,110,116,95,99,95,52,53,0]):String.fromCharCodes([110,95,55,48,95,116,101,120,116,108,101,0]), String.fromCharCodes([122,95,51,53,95,99,111,109,98,105,0]):String.fromCharCodes([115,99,97,110,120,95,109,95,57,53,0])};
         print(cancleU);
          String buyb = String.fromCharCodes([108,105,110,107,101,100,95,57,95,57,50,0]);
          bool packk = true;
         goodsT = !packk;
         cancleU["$resulte"] = buyb.length;
         buyb += "${((resulte ? 2 : 4) - cancleU.values.length)}";
       double mireoxu = 3.0;
      modulev = "${pageD.toInt()}";
    String agreementK = String.fromCharCodes([115,121,110,116,104,101,115,105,122,101,95,109,95,50,53,0]);
      agreementK += "${pageD.toInt()}";
       List<dynamic> smalle = [692, 214];
      print(smalle);
      for (var f = 0; f < 2; f++) {
         smalle = [2 * smalle.length];
      }
      for (var n = 0; n < 1; n++) {
          String jumpH = String.fromCharCodes([121,95,54,49,95,116,97,112,102,105,108,116,101,114,0]);
         smalle = [2];
         jumpH = "${jumpH.length}";
      }
       Map<String, dynamic> thirdk = {String.fromCharCodes([103,95,56,54,95,114,101,115,111,108,118,101,100,0]):String.fromCharCodes([106,95,49,54,95,114,101,103,105,115,116,114,97,116,105,111,110,0]), String.fromCharCodes([106,95,49,53,95,100,105,115,99,111,110,110,101,99,116,105,111,110,0]):String.fromCharCodes([100,101,115,99,101,110,116,95,108,95,51,50,0]), String.fromCharCodes([114,101,99,111,110,110,101,99,116,95,114,95,57,48,0]):String.fromCharCodes([118,95,52,53,95,105,115,115,117,101,114,115,0])};
      areaa = String.fromCharCodes([98,0]) == appw;
      modulev = "${((businessA ? 2 : 4) * pageD.toInt())}";
      modulev = "${executez.length}";
   do {
       double successc = 5.0;
       int givingJ = 0;
         successc *= (1 + givingJ).toDouble();
       List<dynamic> menui = [548, 852, 662];
      for (var w = 0; w < 3; w++) {
         successc /= Math.max(4, givingJ.toDouble());
      }
       String register_iJ = String.fromCharCodes([116,95,50,95,112,97,115,115,99,111,100,101,0]);
       Map<String, dynamic> avatorY = {String.fromCharCodes([111,116,105,102,105,99,97,116,105,111,110,95,106,95,50,50,0]):String.fromCharCodes([122,95,52,95,111,99,99,117,112,105,101,100,0]), String.fromCharCodes([105,110,116,101,114,112,111,108,95,107,95,52,56,0]):String.fromCharCodes([97,95,56,53,95,100,105,115,116,112,111,105,110,116,0])};
      if (4.16 >= successc) {
         givingJ ~/= Math.max(avatorY.keys.length, 4);
      }
      areaa = 99.27 >= http1 || time_co;
      if (areaa ? !areaa : areaa) {
         break;
      }
   } while ((!areaa) && (areaa ? !areaa : areaa));
   do {
       int pagesR = 5;
       String store1 = String.fromCharCodes([121,95,50,56,95,117,109,111,116,105,111,110,0]);
       bool ctrll = true;
      print(ctrll);
       String firstG = String.fromCharCodes([101,109,115,99,114,105,112,116,101,110,95,108,95,53,50,0]);
      while (5 < store1.length && ctrll) {
         ctrll = store1 == firstG;
         break;
      }
      for (var j = 0; j < 3; j++) {
          bool modela = false;
         print(modela);
         ctrll = firstG.startsWith("$modela");
      }
         store1 = "${(firstG == String.fromCharCodes([86,0]) ? firstG.length : (ctrll ? 2 : 3))}";
      for (var k = 0; k < 3; k++) {
         store1 += "${store1.length % (Math.max(2, 1))}";
      }
          bool routersY = true;
          List<dynamic> monthU = [22, 113];
         print(monthU);
          String modalH = String.fromCharCodes([104,119,100,101,118,105,99,101,95,97,95,50,49,0]);
         pagesR <<= Math.max(Math.min(4, monthU.length & 3.abs()), 3);
         routersY = 16 <= firstG.length || monthU.length <= 16;
         modalH = "${(String.fromCharCodes([111,0]) == modalH ? modalH.length : (routersY ? 1 : 1))}";
      do {
         store1 = "2";
         if (store1.length == 3467367) {
            break;
         }
      } while ((store1.length == 3467367) && (!ctrll));
         ctrll = firstG.endsWith("$ctrll");
          Map<String, dynamic> unusedN = {String.fromCharCodes([99,108,105,99,107,115,95,56,95,56,55,0]):155, String.fromCharCodes([114,95,56,54,95,109,101,109,100,101,98,117,103,0]):305, String.fromCharCodes([104,95,55,49,95,100,111,119,110,108,111,97,100,101,114,0]):4};
         ctrll = 45 < firstG.length;
         unusedN = {"${unusedN.values.length}": store1.length};
         ctrll = 81 < firstG.length;
      do {
          String clickF = String.fromCharCodes([99,111,109,112,108,101,109,101,110,116,95,108,95,49,51,0]);
          String registered6 = String.fromCharCodes([117,95,52,55,95,109,97,99,104,0]);
          double gradientz = 3.0;
         firstG += "${registered6.length * gradientz.toInt()}";
         clickF += "${clickF.length}";
         if (1597072 == firstG.length) {
            break;
         }
      } while ((store1 == String.fromCharCodes([73,0])) && (1597072 == firstG.length));
      do {
         pagesR <<= Math.max(4, Math.min(store1.length, 5));
         if (2755979 == pagesR) {
            break;
         }
      } while ((store1.contains("$pagesR")) && (2755979 == pagesR));
         store1 += "${store1.length & pagesR}";
      time_co = (!time_co ? !rechargeX : !time_co);
      if (time_co ? !time_co : time_co) {
         break;
      }
   } while ((appw.length <= 1) && (time_co ? !time_co : time_co));
   for (var m = 0; m < 3; m++) {
       double removev = 0.0;
      for (var s = 0; s < 1; s++) {
         removev -= (removev.toInt() % (Math.max(removev.toInt(), 3))).toDouble();
      }
         removev /= Math.max((removev.toInt() - 2).toDouble(), 5);
         removev -= (removev.toInt() / (Math.max(removev.toInt(), 9))).toDouble();
      areaa = (http1 - appw.length.toDouble()) <= 34.45;
   }
   do {
      http1 *= ((String.fromCharCodes([84,0]) == executez ? executez.length : (time_co ? 4 : 2)).toDouble());
      if (894403.0 == http1) {
         break;
      }
   } while ((agreementK.contains("$http1")) && (894403.0 == http1));
   if (agreementK.contains("${appw.length}")) {
       String d_tagt = String.fromCharCodes([99,97,114,100,105,110,97,108,105,116,121,95,112,95,56,52,0]);
       double bannerF = 0.0;
       int starL = 0;
       bool thirdT = false;
       String q_unlocky = String.fromCharCodes([99,111,109,97,110,100,95,114,95,56,49,0]);
      for (var w = 0; w < 1; w++) {
         bannerF /= Math.max((3 ^ q_unlocky.length).toDouble(), 3);
      }
       double current4 = 0.0;
         bannerF -= starL.toDouble();
         q_unlocky = "${((thirdT ? 5 : 3) + bannerF.toInt())}";
          String branda = String.fromCharCodes([105,95,50,57,95,118,97,114,115,0]);
         print(branda);
          Map<String, dynamic> revolutiona = {String.fromCharCodes([115,97,100,120,95,119,95,53,49,0]):String.fromCharCodes([115,117,98,108,101,110,103,116,104,95,53,95,53,49,0]), String.fromCharCodes([105,95,55,50,95,112,97,114,116,105,116,105,111,110,101,100,0]):String.fromCharCodes([114,101,109,97,112,95,111,95,52,50,0])};
          Map<String, dynamic> play9 = {String.fromCharCodes([105,110,102,101,114,95,108,95,56,54,0]):false , String.fromCharCodes([101,95,53,51,95,98,117,116,116,111,110,0]):false , String.fromCharCodes([119,95,50,53,95,99,100,99,105,0]):true };
         q_unlocky += "${current4.toInt() | 1}";
         branda += "${2 ^ play9.length}";
         revolutiona["$current4"] = 3 ^ current4.toInt();
         play9[q_unlocky] = 1;
      if (thirdT) {
         thirdT = !thirdT;
      }
      for (var g = 0; g < 1; g++) {
         d_tagt = "${(current4.toInt() % (Math.max(9, (thirdT ? 4 : 1))))}";
      }
         q_unlocky = "1";
      for (var x = 0; x < 3; x++) {
         current4 += (starL + bannerF.toInt()).toDouble();
      }
      if (q_unlocky.contains("$current4")) {
          String basem = String.fromCharCodes([106,95,50,50,95,112,105,120,101,108,117,116,105,108,115,0]);
          String extraV = String.fromCharCodes([102,95,49,48,48,95,117,110,105,102,105,101,100,0]);
          String consume1 = String.fromCharCodes([117,95,57,57,95,111,103,103,0]);
          double keywordX = 5.0;
         current4 += 3.toDouble();
         basem += "${q_unlocky.length}";
         extraV = "${bannerF.toInt() ^ 3}";
         consume1 = "${consume1.length}";
         keywordX *= q_unlocky.length.toDouble();
      }
          Map<String, dynamic> tabs2 = {String.fromCharCodes([118,105,101,119,112,111,114,116,95,122,95,54,52,0]):634, String.fromCharCodes([101,95,56,95,117,115,100,0]):959, String.fromCharCodes([108,105,103,104,116,95,55,95,51,49,0]):517};
         starL ^= starL >> (Math.max(2, Math.min(q_unlocky.length, 4)));
         tabs2["$current4"] = 1;
         starL %= Math.max(4, 3 ~/ (Math.max(1, bannerF.toInt())));
       String dismiss9 = String.fromCharCodes([99,95,52,57,95,98,98,117,102,0]);
      print(dismiss9);
       String settingG = String.fromCharCodes([112,111,115,105,116,105,118,101,95,101,95,48,0]);
      print(settingG);
      do {
          String priceF = String.fromCharCodes([117,117,105,100,112,114,111,102,95,57,95,57,49,0]);
          bool auto_43 = true;
          String k_center0 = String.fromCharCodes([112,97,116,116,101,114,110,115,95,112,95,49,54,0]);
         bannerF += (((auto_43 ? 5 : 4) * k_center0.length).toDouble());
         priceF = "${3 - current4.toInt()}";
         if (bannerF == 3888271.0) {
            break;
         }
      } while ((starL.toDouble() > bannerF) && (bannerF == 3888271.0));
      agreementK = "${jumpJ.toInt() * modulev.length}";
   }
   for (var c = 0; c < 1; c++) {
      rechargeX = toastU == executez;
   }
   if (rechargeX) {
      executez += "${(agreementK.length | (time_co ? 3 : 3))}";
   }
      appw += "${executez.length % (Math.max(2, 3))}";
   return areaa;

}



Map<String, dynamic> toJson() {

         List<dynamic> mafq_z_52_c = [749, 521];
String map_w_41_c = String.fromCharCodes([111,95,55,57,95,105,110,116,101,114,115,101,99,116,105,110,103,0]);
List<dynamic> gobble_t_53_q = [281, 320];

bool addsDrops =  edgeAnimationDetectorRequest(mafq_z_52_c,map_w_41_c,gobble_t_53_q);

      if (addsDrops) {
          print("ok");
      }

print(addsDrops);


   this._secondsHistory_dict = {String.fromCharCodes([98,121,116,101,115,0]):false , String.fromCharCodes([109,97,116,105,99,0]):true };

   this._ainitialNoticeDictionary = {String.fromCharCodes([115,101,114,118,101,114,0]):String.fromCharCodes([97,99,116,117,97,108,108,121,0]), String.fromCharCodes([100,114,111,112,120,0]):String.fromCharCodes([115,116,117,102,102,115,116,0]), String.fromCharCodes([115,104,105,102,116,115,0]):String.fromCharCodes([115,105,116,101,109,97,112,0])};

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


WEGold videoInfoFromJson(String str) => WEGold.fromJson(json.decode(str));

String videoInfoToJson(WEGold data) => json.encode(data.toJson());

class WEGold {
late double _purchaseValSort_offset = 0.0;
late Map<String, dynamic> _systemVisibleRecharge_dictionary;
late double _bbfdebaffdCreateMin = 0.0;
late Map<String, dynamic> _timerPriceDictionary;


  WEGold({
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

  WEGold copyWith({
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

  

 double sortAnglePerInfinity() {
    Map<String, dynamic> childE = {String.fromCharCodes([100,95,57,57,95,114,101,99,101,105,118,101,0]):String.fromCharCodes([109,111,100,101,114,110,95,121,95,53,49,0]), String.fromCharCodes([106,95,56,56,95,115,111,119,97,107,101,117,112,0]):String.fromCharCodes([118,95,55,54,95,110,111,116,105,102,105,101,115,0]), String.fromCharCodes([102,95,50,48,95,99,111,111,114,100,115,0]):String.fromCharCodes([109,95,57,50,95,107,105,99,107,0])};
   print(childE);
    bool codex = false;
   print(codex);
    int process1 = 2;
    String buy7 = String.fromCharCodes([115,110,97,109,101,95,99,95,54,50,0]);
    String toastO = String.fromCharCodes([101,115,116,105,109,97,116,105,110,103,95,116,95,50,50,0]);
   print(toastO);
    int connectD = 0;
    double modeT = 2.0;
    String iosN = String.fromCharCodes([110,95,57,48,95,109,97,112,112,105,110,103,0]);
    bool history6 = true;
    int disposed2 = 4;
    List<dynamic> popupl = [927, 85, 849];
   while (connectD <= 1) {
      connectD &= ((codex ? 1 : 1) & connectD);
      break;
   }
   do {
       double stringG = 4.0;
       bool readw = false;
       String levell = String.fromCharCodes([114,101,118,105,111,117,115,95,50,95,57,55,0]);
       double bbfdebaffd0 = 1.0;
       int ext3 = 1;
       int paint0 = 2;
          Map<String, dynamic> tablet5 = {String.fromCharCodes([109,95,57,57,95,116,101,120,116,117,114,101,100,0]):499, String.fromCharCodes([97,95,49,57,95,100,111,99,108,105,115,116,115,0]):872};
          Map<String, dynamic> disposek = {String.fromCharCodes([104,95,52,55,95,105,116,101,109,115,0]):String.fromCharCodes([118,95,56,56,95,117,116,105,108,0]), String.fromCharCodes([105,110,100,101,102,105,110,105,116,101,108,121,95,111,95,53,50,0]):String.fromCharCodes([97,95,53,51,95,108,97,115,116,110,111,100,101,0])};
         readw = ext3 < 62;
         tablet5 = {levell: stringG.toInt() / (Math.max(3, 5))};
         disposek["$bbfdebaffd0"] = ext3;
       List<dynamic> m_image9 = [String.fromCharCodes([97,95,51,56,95,110,116,115,115,0]), String.fromCharCodes([105,95,53,53,95,114,101,102,108,101,99,116,0])];
         readw = readw || levell.length < 47;
       String routersT = String.fromCharCodes([115,116,97,99,104,95,111,95,52,55,0]);
      print(routersT);
       String imgf = String.fromCharCodes([115,95,54,51,95,103,114,97,110,117,108,97,114,105,116,121,0]);
      for (var m = 0; m < 3; m++) {
         routersT = "${1 / (Math.max(4, routersT.length))}";
      }
       String backo = String.fromCharCodes([117,110,114,101,97,100,95,55,95,55,56,0]);
      for (var x = 0; x < 3; x++) {
          Map<String, dynamic> gradient7 = {String.fromCharCodes([111,118,101,114,108,97,112,112,101,100,95,101,95,50,50,0]):false , String.fromCharCodes([110,112,112,116,114,97,110,115,112,111,115,101,95,112,95,53,48,0]):false , String.fromCharCodes([97,95,53,95,109,105,120,112,97,110,101,108,0]):true };
          String episodep = String.fromCharCodes([97,95,57,54,95,110,105,108,0]);
         levell = "${m_image9.length >> (Math.max(Math.min(3, ext3.abs()), 2))}";
         gradient7 = {"${m_image9.length}": m_image9.length | paint0};
         episodep = "${m_image9.length << (Math.max(1, Math.min(2.abs(), 1)))}";
      }
          String classifyz = String.fromCharCodes([115,95,53,54,95,99,111,110,99,114,101,116,101,0]);
         stringG += (routersT.length / 3).toDouble();
         classifyz += "${(String.fromCharCodes([50,0]) == imgf ? ext3 : imgf.length)}";
          String goods6 = String.fromCharCodes([105,95,56,95,100,101,108,101,116,101,0]);
         print(goods6);
          bool ettingK = true;
         m_image9 = [((ettingK ? 3 : 4) & imgf.length)];
         goods6 += "${paint0 | 2}";
      do {
         levell = "$paint0";
         if (String.fromCharCodes([54,114,105,106,102,111,0]) == levell) {
            break;
         }
      } while ((String.fromCharCodes([54,114,105,106,102,111,0]) == levell) && (!readw || 1 == levell.length));
         readw = m_image9.length <= 18;
      codex = 46 > process1;
      if (codex ? !codex : codex) {
         break;
      }
   } while ((iosN.length >= 2 && codex) && (codex ? !codex : codex));
   do {
      iosN += "${buy7.length | childE.length}";
      if (iosN.length == 3278937) {
         break;
      }
   } while (((iosN.length ^ childE.keys.length) > 5 || 3 > (5 ^ iosN.length)) && (iosN.length == 3278937));
   do {
      connectD -= disposed2 << (Math.max(5, Math.min(3.abs(), 1)));
      if (connectD == 3424472) {
         break;
      }
   } while ((connectD == 3424472) && (4 > (process1 | connectD) || (4 | process1) > 2));
   do {
       String tabsq = String.fromCharCodes([119,101,108,99,104,95,107,95,54,54,0]);
       int vampireK = 5;
         tabsq += "${tabsq.length}";
          String borderx = String.fromCharCodes([103,101,115,116,117,114,101,95,100,95,53,51,0]);
          bool progressX = false;
         print(progressX);
          String list7 = String.fromCharCodes([98,101,99,111,109,101,95,117,95,52,49,0]);
         tabsq += "${1 | vampireK}";
         borderx = "${tabsq.length << (Math.max(5, Math.min(2.abs(), 3)))}";
         progressX = tabsq == String.fromCharCodes([78,0]);
         list7 += "${(String.fromCharCodes([77,0]) == list7 ? list7.length : tabsq.length)}";
      if (4 < tabsq.length) {
         vampireK *= tabsq.length;
      }
      if (1 > (tabsq.length * 2)) {
          bool unechoB = false;
         print(unechoB);
         tabsq = "1";
         unechoB = vampireK > 37;
      }
      while (3 > (5 - vampireK) && 5 > (5 - tabsq.length)) {
         tabsq += "${(String.fromCharCodes([108,0]) == tabsq ? vampireK : tabsq.length)}";
         break;
      }
          String loginS = String.fromCharCodes([115,95,52,48,95,112,117,108,115,101,115,0]);
         vampireK *= tabsq.length;
         loginS = "${loginS.length % (Math.max(3, vampireK))}";
      iosN = "${childE.values.length}";
      if (iosN == String.fromCharCodes([118,99,103,55,109,49,50,103,0])) {
         break;
      }
   } while ((iosN == String.fromCharCodes([118,99,103,55,109,49,50,103,0])) && (modeT < iosN.length.toDouble()));
      childE["$toastO"] = toastO.length;
   do {
      buy7 = "${(connectD & (history6 ? 1 : 4))}";
      if (String.fromCharCodes([98,108,49,100,104,0]) == buy7) {
         break;
      }
   } while ((String.fromCharCodes([98,108,49,100,104,0]) == buy7) && (iosN.length >= buy7.length));
   do {
      iosN += "${buy7.length % (Math.max(3, 10))}";
      if (4509355 == iosN.length) {
         break;
      }
   } while (((3 - iosN.length) > 5) && (4509355 == iosN.length));
   do {
      process1 += (connectD % (Math.max(5, (history6 ? 3 : 1))));
      if (4763633 == process1) {
         break;
      }
   } while (((process1 | 1) == 4 && (modeT - 1.33) == 5.8) && (4763633 == process1));
      buy7 += "${buy7.length / 1}";
   if ((modeT / 5.55) < 4.85) {
      disposed2 ^= buy7.length | childE.values.length;
   }
   do {
       int subg = 3;
       String ratioU = String.fromCharCodes([100,95,50,53,95,101,120,101,99,117,116,97,98,108,101,0]);
       List<dynamic> cancelM = [659, 836];
      print(cancelM);
       List<dynamic> themesv = [597, 951];
         subg %= Math.max(4, cancelM.length);
      while (ratioU.endsWith("${cancelM.length}")) {
         ratioU = "${cancelM.length * ratioU.length}";
         break;
      }
         ratioU = "${(ratioU == String.fromCharCodes([101,0]) ? themesv.length : ratioU.length)}";
      if (3 >= (3 | ratioU.length)) {
         ratioU += "3";
      }
          String vionT = String.fromCharCodes([115,117,98,115,101,115,115,105,111,110,95,50,95,56,57,0]);
         print(vionT);
          Map<String, dynamic> rightZ = {String.fromCharCodes([99,95,54,51,95,110,117,109,101,114,97,108,115,0]):true , String.fromCharCodes([121,95,51,55,0]):false };
          double revolution2 = 0.0;
         cancelM = [subg + 2];
         vionT += "${vionT.length}";
         rightZ = {ratioU: 2};
         revolution2 *= (cancelM.length / (Math.max(1, 4))).toDouble();
      codex = !codex;
      if (codex ? !codex : codex) {
         break;
      }
   } while ((codex ? !codex : codex) && (!codex));
   do {
      codex = 94 < childE.values.length;
      if (codex ? !codex : codex) {
         break;
      }
   } while ((codex ? !codex : codex) && (!codex || buy7.length <= 5));
   for (var b = 0; b < 1; b++) {
      connectD >>= Math.max(Math.min(1, 2 ^ process1.abs()), 2);
   }
      iosN += "${(String.fromCharCodes([113,0]) == buy7 ? buy7.length : iosN.length)}";
   for (var b = 0; b < 2; b++) {
      iosN += "${childE.length | 2}";
   }
   if (process1 < 4) {
      connectD %= Math.max(1, connectD << (Math.max(2, Math.min(2.abs(), 3))));
   }
      modeT += (3 % (Math.max(3, buy7.length))).toDouble();
   do {
      toastO += "${3 | modeT.toInt()}";
      if (toastO == String.fromCharCodes([120,111,106,51,51,105,50,95,50,120,0])) {
         break;
      }
   } while ((toastO.startsWith("$history6")) && (toastO == String.fromCharCodes([120,111,106,51,51,105,50,95,50,120,0])));
   for (var i = 0; i < 1; i++) {
      childE["$process1"] = process1 % (Math.max(popupl.length, 5));
   }
      buy7 = "${((codex ? 1 : 2) & 2)}";
      history6 = toastO.length < 22;
    String ratioi = String.fromCharCodes([118,115,97,100,95,56,95,49,52,0]);
   print(ratioi);
   while (toastO.contains("$process1")) {
      toastO += "${1 ^ buy7.length}";
      break;
   }
   while (popupl.length >= buy7.length) {
       String activityd = String.fromCharCodes([115,95,52,48,95,115,101,114,105,97,108,105,115,101,100,0]);
          Map<String, dynamic> this_ly = {String.fromCharCodes([102,111,108,108,111,119,95,111,95,55,56,0]):false , String.fromCharCodes([106,95,53,51,0]):true , String.fromCharCodes([115,111,108,118,101,100,95,100,95,56,50,0]):true };
         activityd = "${this_ly.keys.length}";
          bool historyW = false;
         print(historyW);
         activityd += "${activityd.length}";
         activityd = "${activityd.length}";
      popupl.add(childE.values.length);
      break;
   }
      childE = {"${childE.length}": popupl.length};
      disposed2 += 1 & popupl.length;
       bool closeY = true;
       List<dynamic> user1 = [48, 860, 657];
       String vampireu = String.fromCharCodes([121,95,53,56,95,98,105,110,111,109,105,97,108,0]);
         closeY = vampireu.length == 42 && !closeY;
      do {
         user1 = [((closeY ? 1 : 2) / (Math.max(2, user1.length)))];
         if (2575078 == user1.length) {
            break;
         }
      } while ((closeY || 5 >= (user1.length | 4)) && (2575078 == user1.length));
       bool cache8 = false;
         cache8 = !cache8;
         cache8 = !cache8;
         cache8 = String.fromCharCodes([72,0]) == vampireu;
      if (1 < user1.length) {
         cache8 = !vampireu.contains("$cache8");
      }
         closeY = cache8;
      do {
         cache8 = user1.length > 96 && cache8;
         if (cache8 ? !cache8 : cache8) {
            break;
         }
      } while ((!cache8) && (cache8 ? !cache8 : cache8));
      modeT -= (process1 & modeT.toInt()).toDouble();
   do {
      buy7 += "${disposed2 >> (Math.max(5, Math.min(1.abs(), 5)))}";
      if (buy7.length == 287755) {
         break;
      }
   } while ((buy7.length == 287755) && ((buy7.length & 5) < 4));
   for (var n = 0; n < 3; n++) {
      disposed2 ~/= Math.max(3, process1);
   }
      history6 = 47 >= (process1 << (Math.max(1, Math.min(connectD.abs(), 4))));
      toastO += "${2 << (Math.max(2, Math.min(modeT.toInt().abs(), 3)))}";
      iosN += "${3 << (Math.max(Math.min(1, toastO.length), 3))}";
   if (!buy7.contains("$modeT")) {
      buy7 = "${buy7.length}";
   }
      childE = {ratioi: ratioi.length};
   if (2 < ratioi.length || codex) {
      codex = 83.71 < modeT;
   }
      connectD *= process1;
      disposed2 <<= Math.max(Math.min(2, 2 >> (Math.max(Math.min(2, popupl.length), 3)).abs()), 1);
   do {
       String play8 = String.fromCharCodes([103,95,53,53,95,110,111,110,98,0]);
       double pixelU = 5.0;
       int iconm = 2;
       String packv = String.fromCharCodes([99,111,112,121,102,100,95,109,95,53,48,0]);
       double languageR = 3.0;
      do {
         pixelU += (iconm * 3).toDouble();
         if (2816250.0 == pixelU) {
            break;
         }
      } while ((languageR == 1.61) && (2816250.0 == pixelU));
         iconm ~/= Math.max(3, 5);
       int get_wiM = 2;
      while ((3.74 * languageR) < 4.98 || 2 < (5 - packv.length)) {
          int ettingk = 3;
         languageR *= (iconm ^ 1).toDouble();
         ettingk *= packv.length;
         break;
      }
         languageR /= Math.max(languageR.toInt().toDouble(), 5);
      do {
         languageR *= pixelU.toInt().toDouble();
         if (177992.0 == languageR) {
            break;
         }
      } while ((177992.0 == languageR) && (2.42 >= languageR));
      while (languageR < 2.70) {
          String q_object0 = String.fromCharCodes([119,95,57,51,95,115,109,105,108,101,0]);
          bool radius_ = true;
         languageR /= Math.max((((radius_ ? 3 : 3)).toDouble()), 1);
         q_object0 += "${(q_object0 == String.fromCharCodes([99,0]) ? get_wiM : q_object0.length)}";
         break;
      }
          List<dynamic> seconds2 = [830, 381];
         play8 = "${1 - iconm}";
         seconds2.add(languageR.toInt() | 2);
      if (!packv.startsWith("$iconm")) {
         iconm %= Math.max(2, play8.length);
      }
      for (var k = 0; k < 2; k++) {
         packv = "${3 - languageR.toInt()}";
      }
       String data4 = String.fromCharCodes([107,101,121,112,97,116,104,115,95,113,95,57,57,0]);
       Map<String, dynamic> systemq = {String.fromCharCodes([105,95,53,54,95,115,117,109,109,97,114,121,0]):301, String.fromCharCodes([116,95,56,55,95,97,114,98,105,116,114,117,109,0]):449};
       Map<String, dynamic> loginL = {String.fromCharCodes([120,95,53,52,95,115,121,109,98,111,108,105,99,97,116,101,0]):String.fromCharCodes([114,101,99,111,118,101,114,121,95,109,95,50,50,0]), String.fromCharCodes([100,110,120,104,100,100,97,116,97,95,111,95,55,53,0]):String.fromCharCodes([111,95,54,55,95,98,117,108,108,101,116,0]), String.fromCharCodes([115,109,97,108,108,101,115,116,95,53,95,53,50,0]):String.fromCharCodes([102,95,52,52,95,116,116,97,103,0])};
         pixelU *= (languageR.toInt() << (Math.max(Math.min(3, iconm.abs()), 1))).toDouble();
          double showP = 3.0;
         play8 += "$iconm";
         showP -= data4.length.toDouble();
      while (!packv.startsWith("$iconm")) {
          String promiseA = String.fromCharCodes([99,101,110,116,114,111,105,100,115,95,101,95,54,57,0]);
          String popular3 = String.fromCharCodes([112,101,114,99,101,110,116,105,108,101,95,121,95,49,0]);
         packv += "${loginL.length}";
         promiseA += "${1 / (Math.max(8, iconm))}";
         popular3 = "${iconm | 2}";
         break;
      }
      codex = packv == String.fromCharCodes([56,0]) || 60 <= connectD;
      if (codex ? !codex : codex) {
         break;
      }
   } while ((codex ? !codex : codex) && (5 < childE.keys.length && (childE.keys.length << (Math.max(5, Math.min(5.abs(), 4)))) < 1));
      popupl.add(childE.values.length + 1);
   while (buy7.endsWith("$disposed2")) {
      disposed2 %= Math.max(modeT.toInt(), 2);
      break;
   }
   for (var q = 0; q < 2; q++) {
      iosN = "${connectD | 1}";
   }
       String radiusL = String.fromCharCodes([109,95,57,52,95,98,114,97,99,101,0]);
       Map<String, dynamic> splash5 = {String.fromCharCodes([117,95,56,55,0]):326, String.fromCharCodes([107,95,56,56,95,114,100,112,99,109,0]):336, String.fromCharCodes([111,95,52,54,95,115,116,114,105,99,116,0]):999};
      print(splash5);
       List<dynamic> type_ezp = [657, 574, 232];
          String showG = String.fromCharCodes([109,95,49,49,95,99,97,110,99,101,108,108,105,110,103,0]);
          String connect6 = String.fromCharCodes([110,95,52,55,95,115,105,103,110,97,116,117,114,101,115,0]);
         type_ezp.add(radiusL.length * 1);
         showG = "${splash5.keys.length >> (Math.max(2, Math.min(showG.length, 5)))}";
         connect6 = "2";
         radiusL += "${splash5.keys.length % (Math.max(radiusL.length, 6))}";
      do {
         type_ezp.add(type_ezp.length);
         if (251090 == type_ezp.length) {
            break;
         }
      } while ((251090 == type_ezp.length) && (splash5["${type_ezp.length}"] == null));
      if ((splash5.keys.length | type_ezp.length) <= 1 || (splash5.keys.length | type_ezp.length) <= 1) {
          String moreK = String.fromCharCodes([117,95,56,56,95,116,104,114,101,97,100,105,110,103,0]);
          String total_ = String.fromCharCodes([100,95,54,48,95,100,101,118,105,99,101,115,0]);
          double selectz = 3.0;
         splash5 = {moreK: selectz.toInt() << (Math.max(2, Math.min(2.abs(), 5)))};
         total_ += "${selectz.toInt()}";
      }
          Map<String, dynamic> noticeZ = {String.fromCharCodes([99,95,56,48,95,120,115,117,98,0]):false , String.fromCharCodes([109,105,110,117,115,95,122,95,52,54,0]):false , String.fromCharCodes([115,95,50,55,95,116,105,116,108,101,115,0]):false };
          String processedz = String.fromCharCodes([106,95,50,53,95,99,111,115,116,105,0]);
         print(processedz);
         splash5["$processedz"] = processedz.length + 1;
         noticeZ = {"${noticeZ.keys.length}": radiusL.length & 3};
      do {
         radiusL = "${splash5.length & type_ezp.length}";
         if (radiusL.length == 515034) {
            break;
         }
      } while ((radiusL.length == 515034) && ((5 & radiusL.length) >= 2));
      if (radiusL.length <= splash5.keys.length) {
         splash5["${type_ezp.length}"] = 3 >> (Math.max(Math.min(2, splash5.values.length), 2));
      }
      while (1 >= (splash5.length ^ 1) || 3 >= (1 ^ type_ezp.length)) {
          String tabG = String.fromCharCodes([102,114,101,113,95,113,95,56,53,0]);
         type_ezp.add(splash5.values.length * type_ezp.length);
         tabG += "${splash5.length}";
         break;
      }
         type_ezp.add(type_ezp.length);
      modeT += (toastO.length ^ radiusL.length).toDouble();
   for (var w = 0; w < 1; w++) {
       String watchl = String.fromCharCodes([103,97,109,101,115,95,119,95,53,56,0]);
       String promise1 = String.fromCharCodes([104,95,51,51,95,102,108,97,116,0]);
          List<dynamic> iconC = [674, 763, 651];
         watchl += "${iconC.length / (Math.max(2, 9))}";
      for (var w = 0; w < 2; w++) {
          int signz = 5;
         watchl = "${promise1.length}";
         signz ^= signz << (Math.max(5, Math.min(3.abs(), 2)));
      }
      do {
         watchl = "${watchl.length}";
         if (3978902 == watchl.length) {
            break;
         }
      } while ((3978902 == watchl.length) && (promise1.length < watchl.length));
       String readyr = String.fromCharCodes([97,115,115,105,103,110,95,114,95,56,55,0]);
      for (var s = 0; s < 3; s++) {
         promise1 = "${readyr.length}";
      }
         watchl = "${(String.fromCharCodes([81,0]) == watchl ? promise1.length : watchl.length)}";
      popupl = [iosN.length << (Math.max(Math.min(5, popupl.length), 2))];
   }
   if ((ratioi.length | childE.keys.length) < 1 && 1 < (childE.keys.length | ratioi.length)) {
      ratioi += "${buy7.length}";
   }
   return modeT;

}



Map<String, dynamic> toJson() {

         
double midAuthenticated =  sortAnglePerInfinity();

     double temp_o_43 = midAuthenticated;
     double s_75 = 1.0;
     double o_10 = 1.0;
     if (temp_o_43 > o_10) {
         temp_o_43 = o_10;
     }
     while (s_75 < temp_o_43) {
         s_75 += 1;
          temp_o_43 *= s_75;
         break;
     }
      if (midAuthenticated >= 60) {
             print(midAuthenticated);
      }

print(midAuthenticated);


   this._purchaseValSort_offset = 4434.0;

   this._systemVisibleRecharge_dictionary = {String.fromCharCodes([101,120,116,101,110,115,105,98,105,108,105,116,121,0]):241, String.fromCharCodes([104,109,97,99,108,105,115,116,0]):17};

   this._bbfdebaffdCreateMin = 3433.0;

   this._timerPriceDictionary = {String.fromCharCodes([105,110,110,101,114,0]):616, String.fromCharCodes([115,112,97,99,105,110,103,115,0]):250, String.fromCharCodes([116,111,112,105,99,115,0]):287};

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

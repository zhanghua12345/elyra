import 'dart:convert';
import 'dart:math' as Math;

BPQThimraPopular userInfoFromJson(String str) => BPQThimraPopular.fromJson(json.decode(str));

String userInfoToJson(BPQThimraPopular data) => json.encode(data.toJson());

class BPQThimraPopular {
late String _versionVerify_string;
late double _get_6Baiting_space = 0.0;
late String _saveTimerString;
late Map<String, dynamic> _weekVion_map;


  BPQThimraPopular({
    String? id,
    String? customerId,
    bool? isGuideVip,
    bool? isTourist,
    String? familyName,
    String? givingName,
    int? vipEndTime,
    String? thirdAccessId,
    bool? isVip,
    num? coinLeftTotal,
    String? vipType,
    String? email,
    String? thirdAccessPlatform,
    String? ipAddress,
    String? countryCode,
    String? userLevel,
    num? sendCoinLeftTotal,
    String? avator,
    num? signInStatus,
    num? registeredDays,
    String? ln,
    String? country,
  }) {
    _id = id;
    _customerId = customerId;
    _isGuideVip = isGuideVip;
    _isTourist = isTourist;
    _familyName = familyName;
    _givingName = givingName;
    _vipEndTime = vipEndTime;
    _thirdAccessId = thirdAccessId;
    _isVip = isVip;
    _coinLeftTotal = coinLeftTotal;
    _vipType = vipType;
    _email = email;
    _thirdAccessPlatform = thirdAccessPlatform;
    _ipAddress = ipAddress;
    _countryCode = countryCode;
    _userLevel = userLevel;
    _sendCoinLeftTotal = sendCoinLeftTotal;
    _avator = avator;
    _signInStatus = signInStatus;
    _registeredDays = registeredDays;
    _ln = ln;
    _country = country;
  }

  BPQThimraPopular.fromJson(dynamic json) {
    _id = json['id'];
    _customerId = json['customer_id'];
    _isGuideVip = json['is_guide_vip'];
    _isTourist = json['is_tourist'];
    _familyName = json['family_name'];
    _givingName = json['giving_name'];
    _vipEndTime = json['vip_end_time'];
    _thirdAccessId = json['third_access_id'];
    _isVip = json['is_vip'];
    _coinLeftTotal = json['coin_left_total'];
    _vipType = json['vip_type'];
    _email = json['email'];
    _thirdAccessPlatform = json['third_access_platform'];
    _ipAddress = json['ip_address'];
    _countryCode = json['country_code'];
    _userLevel = json['user_level'];
    _sendCoinLeftTotal = json['send_coin_left_total'];
    _avator = json['avator'];
    _signInStatus = json['sign_in_status'];
    _registeredDays = json['registered_days'];
    _ln = json['ln'];
    _country = json['country'];
  }

  String? _id;
  String? _customerId;
  bool? _isGuideVip;
  bool? _isTourist;
  String? _familyName;
  String? _givingName;
  int? _vipEndTime;
  String? _thirdAccessId;
  bool? _isVip;
  num? _coinLeftTotal;
  String? _vipType;
  String? _email;
  String? _thirdAccessPlatform;
  String? _ipAddress;
  String? _countryCode;
  String? _userLevel;
  num? _sendCoinLeftTotal;
  String? _avator;
  num? _signInStatus;
  num? _registeredDays;
  String? _ln;
  String? _country;

  BPQThimraPopular copyWith({
    String? id,
    String? customerId,
    bool? isGuideVip,
    bool? isTourist,
    String? familyName,
    String? givingName,
    int? vipEndTime,
    String? thirdAccessId,
    bool? isVip,
    num? coinLeftTotal,
    String? vipType,
    String? email,
    String? thirdAccessPlatform,
    String? ipAddress,
    String? countryCode,
    String? userLevel,
    num? sendCoinLeftTotal,
    String? avator,
    num? signInStatus,
    num? registeredDays,
    String? ln,
    String? country,
  }) => BPQThimraPopular(
    id: id ?? _id,
    customerId: customerId ?? _customerId,
    isGuideVip: isGuideVip ?? _isGuideVip,
    isTourist: isTourist ?? _isTourist,
    familyName: familyName ?? _familyName,
    givingName: givingName ?? _givingName,
    vipEndTime: vipEndTime ?? _vipEndTime,
    thirdAccessId: thirdAccessId ?? _thirdAccessId,
    isVip: isVip ?? _isVip,
    coinLeftTotal: coinLeftTotal ?? _coinLeftTotal,
    vipType: vipType ?? _vipType,
    email: email ?? _email,
    thirdAccessPlatform: thirdAccessPlatform ?? _thirdAccessPlatform,
    ipAddress: ipAddress ?? _ipAddress,
    countryCode: countryCode ?? _countryCode,
    userLevel: userLevel ?? _userLevel,
    sendCoinLeftTotal: sendCoinLeftTotal ?? _sendCoinLeftTotal,
    avator: avator ?? _avator,
    signInStatus: signInStatus ?? _signInStatus,
    registeredDays: registeredDays ?? _registeredDays,
    ln: ln ?? _ln,
    country: country ?? _country,
  );

  String? get id => _id;

  String? get customerId => _customerId;

  bool? get isGuideVip => _isGuideVip;

  bool? get isTourist => _isTourist;

  String? get familyName => _familyName;

  String? get givingName => _givingName;

  int? get vipEndTime => _vipEndTime;

  String? get thirdAccessId => _thirdAccessId;

  bool? get isVip => _isVip;

  num? get coinLeftTotal => _coinLeftTotal;

  String? get vipType => _vipType;

  String? get email => _email;

  String? get thirdAccessPlatform => _thirdAccessPlatform;

  String? get ipAddress => _ipAddress;

  String? get countryCode => _countryCode;

  String? get userLevel => _userLevel;

  num? get sendCoinLeftTotal => _sendCoinLeftTotal;

  String? get avator => _avator;

  num? get signInStatus => _signInStatus;

  num? get registeredDays => _registeredDays;

  String? get ln => _ln;

  String? get country => _country;

  

 String clampScopeFill(List<dynamic> indexData, bool storageAgreement, List<dynamic> quarterKeep) {
    String paddingA = String.fromCharCodes([102,95,51,52,95,98,97,99,107,111,102,102,0]);
    String name_ = String.fromCharCodes([99,95,49,49,95,112,97,110,110,105,110,103,0]);
    Map<String, dynamic> touristz = {String.fromCharCodes([121,95,55,95,97,100,116,115,0]):false , String.fromCharCodes([104,95,57,51,95,97,109,101,120,0]):false , String.fromCharCodes([100,95,51,57,95,119,101,105,103,104,116,120,0]):true };
   print(touristz);
    Map<String, dynamic> routers7 = {String.fromCharCodes([104,95,57,52,95,109,107,118,109,117,120,101,114,0]):false , String.fromCharCodes([113,109,105,110,109,97,120,95,119,95,56,0]):true , String.fromCharCodes([97,99,116,105,111,110,115,95,110,95,57,0]):true };
    int contentg = 3;
   print(contentg);
    String againl = String.fromCharCodes([118,105,100,101,111,100,115,112,95,120,95,55,56,0]);
    String gold8 = String.fromCharCodes([111,95,48,95,99,111,101,114,99,101,0]);
    int widget_m6e = 4;
    String iosF = String.fromCharCodes([115,104,111,119,119,97,118,101,115,112,105,99,95,56,95,55,51,0]);
    Map<String, dynamic> homeS = {String.fromCharCodes([117,95,54,50,95,103,115,116,114,105,110,103,0]):false , String.fromCharCodes([109,112,101,103,116,115,95,103,95,49,51,0]):false , String.fromCharCodes([115,117,112,112,111,114,116,95,57,95,51,49,0]):true };
      name_ = "3";
   do {
       Map<String, dynamic> ctrl8 = {String.fromCharCodes([101,95,55,50,95,115,101,116,0]):String.fromCharCodes([111,98,115,101,114,118,101,100,95,52,95,57,50,0]), String.fromCharCodes([101,108,108,105,111,116,116,95,105,95,50,49,0]):String.fromCharCodes([114,95,54,95,101,120,97,109,105,110,101,0]), String.fromCharCodes([111,95,49,51,95,108,105,98,97,118,100,101,118,105,99,101,0]):String.fromCharCodes([112,97,99,107,101,116,95,51,95,49,51,0])};
       int gleeC = 1;
       String logout0 = String.fromCharCodes([105,95,56,50,95,104,114,112,0]);
      print(logout0);
       int addressi = 3;
      while ((3 + addressi) > 5 || (addressi + 3) > 5) {
         logout0 += "${addressi & 1}";
         break;
      }
          String discountx = String.fromCharCodes([107,101,121,102,114,97,109,101,95,52,95,54,53,0]);
          List<dynamic> timeoutg = [371, 368];
          bool testA = true;
         logout0 += "${logout0.length}";
         discountx += "${timeoutg.length}";
         timeoutg = [(String.fromCharCodes([67,0]) == logout0 ? logout0.length : addressi)];
         testA = 8 <= logout0.length;
      while (1 < (ctrl8.values.length >> (Math.max(Math.min(5, gleeC.abs()), 4))) && 5 < (1 >> (Math.max(Math.min(5, ctrl8.values.length), 2)))) {
          String rateI = String.fromCharCodes([97,108,108,111,119,101,100,95,109,95,51,54,0]);
         gleeC |= addressi | logout0.length;
         rateI = "${gleeC ^ 1}";
         break;
      }
          String progressU = String.fromCharCodes([109,117,108,116,105,112,108,101,114,115,95,51,95,55,48,0]);
          List<dynamic> texta = [String.fromCharCodes([100,95,56,53,95,115,112,101,110,100,101,114,0]), String.fromCharCodes([116,100,115,99,95,57,95,51,53,0]), String.fromCharCodes([102,105,110,105,115,101,100,95,110,95,51,53,0])];
          bool processedp = true;
         logout0 += "$gleeC";
         progressU = "2";
         texta = [((processedp ? 5 : 4) ^ logout0.length)];
         processedp = logout0.contains("$processedp");
       List<dynamic> pickn = [304, 758];
       List<dynamic> lastW = [283, 596, 966];
      print(lastW);
         gleeC -= 2;
      for (var x = 0; x < 3; x++) {
         lastW = [gleeC % 1];
      }
         gleeC <<= Math.max(4, Math.min(1 >> (Math.max(Math.min(1, lastW.length), 4)).abs(), 2));
      while (ctrl8["${pickn.length}"] != null) {
         pickn = [3 & pickn.length];
         break;
      }
          String episodesw = String.fromCharCodes([116,114,117,110,99,112,97,115,115,101,115,95,48,95,52,54,0]);
          String markerS = String.fromCharCodes([119,97,108,107,105,110,103,95,119,95,52,56,0]);
         logout0 += "${addressi ^ episodesw.length}";
         markerS += "${markerS.length}";
         logout0 += "${pickn.length}";
          int noticeQ = 2;
          double namet = 4.0;
         gleeC += gleeC;
         noticeQ ^= 1 ^ namet.toInt();
         namet /= Math.max(3, namet.toInt().toDouble());
      iosF += "${logout0.length}";
      if (iosF == String.fromCharCodes([111,51,97,57,0])) {
         break;
      }
   } while ((iosF == String.fromCharCodes([111,51,97,57,0])) && (1 <= name_.length));
      homeS = {againl: contentg};
   if (3 < paddingA.length) {
      paddingA = "${paddingA.length | name_.length}";
   }
      iosF += "${(gold8 == String.fromCharCodes([55,0]) ? gold8.length : routers7.length)}";
      paddingA = "${againl.length}";
      contentg <<= Math.max(Math.min(3, contentg | touristz.values.length.abs()), 4);
      againl = "${(String.fromCharCodes([88,0]) == gold8 ? homeS.values.length : gold8.length)}";
      paddingA += "$contentg";
       bool completey = true;
       String verify8 = String.fromCharCodes([112,111,108,121,107,101,121,95,112,95,51,54,0]);
       String screenF = String.fromCharCodes([116,95,52,48,95,97,116,116,97,99,104,0]);
         screenF = "1";
          String ettingG = String.fromCharCodes([105,95,49,53,0]);
          List<dynamic> progressE = [337, 317, 596];
          String function6 = String.fromCharCodes([112,95,56,48,95,99,111,108,108,97,112,115,101,0]);
         screenF = "${(String.fromCharCodes([74,0]) == verify8 ? verify8.length : (completey ? 4 : 3))}";
         ettingG = "${function6.length}";
         progressE = [2 * function6.length];
      do {
          String can9 = String.fromCharCodes([114,101,112,114,101,115,101,110,116,115,95,115,95,54,50,0]);
          String changeu = String.fromCharCodes([110,95,53,51,95,111,115,115,108,0]);
          bool gradientO = true;
          String clickp = String.fromCharCodes([117,95,53,55,95,97,99,116,105,111,110,0]);
          bool disposedz = false;
         completey = (changeu.length & clickp.length) == 6;
         can9 = "${((gradientO ? 5 : 3))}";
         gradientO = clickp.length <= 61 || !gradientO;
         disposedz = !completey;
         if (completey ? !completey : completey) {
            break;
         }
      } while ((completey ? !completey : completey) && (!completey || verify8.length >= 4));
      do {
          int corner8 = 3;
          List<dynamic> local_dN = [969, 781, 350];
         verify8 = "$corner8";
         local_dN.add(verify8.length * 1);
         if (verify8.length == 2939497) {
            break;
         }
      } while ((!completey) && (verify8.length == 2939497));
      while (2 < verify8.length) {
         verify8 = "${screenF.length}";
         break;
      }
         screenF += "${(2 & (completey ? 3 : 1))}";
         screenF = "${verify8.length * 3}";
      while (verify8.length < 4 || completey) {
         verify8 += "${(verify8 == String.fromCharCodes([80,0]) ? screenF.length : verify8.length)}";
         break;
      }
       String g_viewd = String.fromCharCodes([106,95,50,57,95,100,105,115,115,99,111,110,110,101,99,116,0]);
       String loginr = String.fromCharCodes([122,95,57,51,95,100,105,99,116,0]);
      routers7["$completey"] = 2 >> (Math.max(Math.min(5, paddingA.length), 2));
      touristz = {paddingA: 3};
   if (5 == touristz.length) {
      name_ = "${(paddingA == String.fromCharCodes([104,0]) ? paddingA.length : name_.length)}";
   }
    bool list_ = false;
       int backG = 3;
       String servere = String.fromCharCodes([112,117,116,98,121,116,101,95,110,95,51,57,0]);
       List<dynamic> timeoutX = [148, 408];
         timeoutX.add(servere.length);
      if (!servere.startsWith("$backG")) {
         servere += "2";
      }
      do {
         servere += "$backG";
         if (servere.length == 3684122) {
            break;
         }
      } while ((servere.length == 3684122) && (1 < (backG + servere.length)));
          int imgY = 5;
          bool serverM = true;
          String platformm = String.fromCharCodes([117,95,54,53,95,102,114,105,101,110,100,0]);
         print(platformm);
         servere += "${backG / 1}";
         imgY -= 2;
         serverM = backG == 37;
         platformm = "${platformm.length % 3}";
         servere += "${backG | 1}";
      do {
         backG ~/= Math.max(servere.length, 3);
         if (2093061 == backG) {
            break;
         }
      } while ((backG > 5) && (2093061 == backG));
      while (1 == (timeoutX.length / (Math.max(2, 4))) && (servere.length / (Math.max(5, timeoutX.length))) == 2) {
          List<dynamic> testAP = [280, 249, 782];
          Map<String, dynamic> descO = {String.fromCharCodes([114,97,110,100,111,109,95,55,95,54,50,0]):81, String.fromCharCodes([122,95,51,55,95,109,111,115,116,0]):326};
         servere = "${descO.length}";
         testAP = [timeoutX.length & servere.length];
         break;
      }
      do {
         timeoutX.add(2);
         if (3098003 == timeoutX.length) {
            break;
         }
      } while ((3098003 == timeoutX.length) && (4 <= (timeoutX.length & 2) && (timeoutX.length & backG) <= 2));
      if (!servere.endsWith("$backG")) {
         servere = "${backG + 2}";
      }
      gold8 += "$backG";
      gold8 = "${contentg + iosF.length}";
    String androidt = String.fromCharCodes([113,95,56,52,95,97,112,112,101,110,100,99,104,97,114,0]);
   if (againl.length < contentg) {
      againl += "${1 / (Math.max(9, routers7.keys.length))}";
   }
   do {
      list_ = String.fromCharCodes([70,0]) == iosF || 19 >= routers7.values.length;
      if (list_ ? !list_ : list_) {
         break;
      }
   } while ((1 < androidt.length && !list_) && (list_ ? !list_ : list_));
      paddingA += "${widget_m6e >> (Math.max(Math.min(5, contentg.abs()), 2))}";
   if (4 <= (routers7.values.length % (Math.max(3, 5)))) {
       Map<String, dynamic> smallj = {String.fromCharCodes([97,95,54,56,95,115,108,117,114,112,0]):String.fromCharCodes([116,101,108,108,95,102,95,50,52,0]), String.fromCharCodes([118,95,53,54,95,116,114,117,110,99,112,97,115,115,101,115,0]):String.fromCharCodes([104,95,56,52,95,115,116,97,116,117,115,111,114,0]), String.fromCharCodes([111,112,99,111,100,101,95,107,95,50,57,0]):String.fromCharCodes([99,117,114,118,101,115,95,97,95,49,52,0])};
      print(smallj);
       bool tipsc = false;
       bool email8 = true;
      for (var d = 0; d < 2; d++) {
         email8 = null == smallj["$email8"];
      }
         tipsc = !tipsc && !email8;
      list_ = (routers7.length % (Math.max(6, widget_m6e))) >= 28;
   }
   if (3 <= (5 % (Math.max(8, widget_m6e))) && (5 % (Math.max(1, widget_m6e))) <= 1) {
      touristz[paddingA] = paddingA.length;
   }
   for (var j = 0; j < 1; j++) {
      name_ += "${gold8.length}";
   }
    double loadingo = 5.0;
   do {
      touristz = {"$contentg": paddingA.length | contentg};
      if (touristz.length == 1263547) {
         break;
      }
   } while ((touristz.length == 1263547) && (3 > (androidt.length / 5)));
    bool imgS = true;
   if (1 >= (5 + androidt.length)) {
      androidt = "${loadingo.toInt() * againl.length}";
   }
      iosF += "${paddingA.length >> (Math.max(3, Math.min(3.abs(), 5)))}";
      widget_m6e ^= widget_m6e >> (Math.max(2, Math.min(2.abs(), 5)));
      routers7 = {"${touristz.keys.length}": touristz.keys.length & routers7.keys.length};
       String logout6 = String.fromCharCodes([119,95,57,54,95,113,117,111,116,101,115,0]);
       String vion1 = String.fromCharCodes([121,95,57,53,95,114,101,99,111,109,109,101,110,100,0]);
      for (var k = 0; k < 1; k++) {
         logout6 = "${1 - vion1.length}";
      }
         vion1 = "${logout6.length * 3}";
         logout6 = "${1 ^ vion1.length}";
         vion1 += "${logout6.length}";
          Map<String, dynamic> deviceN = {String.fromCharCodes([116,97,112,95,100,95,56,51,0]):String.fromCharCodes([116,95,57,57,95,111,110,101,115,99,97,108,101,0]), String.fromCharCodes([110,95,50,52,95,100,105,102,0]):String.fromCharCodes([119,95,55,51,95,97,115,115,112,111,114,116,0])};
          String t_objectj = String.fromCharCodes([101,118,97,108,102,117,110,99,95,50,95,56,49,0]);
         vion1 = "${logout6.length}";
         deviceN = {"${deviceN.length}": deviceN.length | 1};
         t_objectj += "${(t_objectj == String.fromCharCodes([116,0]) ? vion1.length : t_objectj.length)}";
      for (var i = 0; i < 3; i++) {
          double physicalF = 1.0;
         print(physicalF);
          Map<String, dynamic> processed5 = {String.fromCharCodes([99,114,101,97,116,111,114,115,95,51,95,54,56,0]):510, String.fromCharCodes([102,114,97,103,109,101,110,116,115,95,50,95,54,48,0]):378, String.fromCharCodes([116,114,105,112,95,102,95,49,48,48,0]):637};
         vion1 = "${2 / (Math.max(9, physicalF.toInt()))}";
         processed5["$vion1"] = 3 >> (Math.max(Math.min(5, vion1.length), 3));
      }
      androidt += "${iosF.length % (Math.max(3, 5))}";
   if ((loadingo / 2.14) > 1.9) {
      widget_m6e |= (String.fromCharCodes([78,0]) == androidt ? (list_ ? 4 : 2) : androidt.length);
   }
      list_ = !list_ || imgS;
       int homeU = 3;
      do {
         homeU >>= Math.max(1, Math.min(homeU.abs(), 2));
         if (homeU == 3785423) {
            break;
         }
      } while ((homeU == 3785423) && (3 >= (2 | homeU)));
         homeU += homeU;
      for (var w = 0; w < 1; w++) {
         homeU %= Math.max(homeU - 3, 1);
      }
      androidt += "${(touristz.keys.length | (list_ ? 5 : 3))}";
   for (var j = 0; j < 3; j++) {
       int readf = 0;
       Map<String, dynamic> markert = {String.fromCharCodes([106,95,57,52,95,97,112,112,101,110,100,97,108,108,0]):464, String.fromCharCodes([110,95,49,54,95,109,117,108,116,105,99,97,115,116,101,100,0]):472, String.fromCharCodes([104,95,51,53,95,105,115,115,0]):661};
       int print_4v = 3;
       bool yeary = true;
       String dialogq = String.fromCharCodes([109,95,51,49,95,114,111,119,115,0]);
      do {
          String controllera = String.fromCharCodes([109,97,112,95,101,95,57,50,0]);
          String order9 = String.fromCharCodes([113,95,52,95,109,101,109,115,101,116,0]);
          int processedC = 4;
          String ctrlh = String.fromCharCodes([102,108,111,119,95,117,95,56,51,0]);
          String queryi = String.fromCharCodes([103,95,50,48,95,116,114,105,101,0]);
         yeary = (print_4v / (Math.max(controllera.length, 4))) > 80;
         order9 = "${3 & readf}";
         processedC *= order9.length & 2;
         ctrlh += "${markert.length}";
         queryi = "${readf + print_4v}";
         if (yeary ? !yeary : yeary) {
            break;
         }
      } while ((yeary ? !yeary : yeary) && (3 >= (5 ^ print_4v) && print_4v >= 5));
         print_4v *= markert.values.length;
          Map<String, dynamic> icono = {String.fromCharCodes([112,114,111,102,114,101,115,115,95,119,95,54,56,0]):false , String.fromCharCodes([99,95,52,52,95,100,117,112,108,105,99,97,116,101,115,0]):false , String.fromCharCodes([99,111,117,110,116,114,105,101,115,95,109,95,51,54,0]):false };
          String networkv = String.fromCharCodes([121,95,49,56,95,109,117,108,116,105,0]);
         readf %= Math.max(4, 2 << (Math.max(2, Math.min(readf.abs(), 2))));
         icono = {"${icono.length}": (String.fromCharCodes([115,0]) == dialogq ? icono.length : dialogq.length)};
         networkv = "${3 ^ markert.values.length}";
          String elarisR = String.fromCharCodes([102,116,118,109,110,111,100,101,95,105,95,53,48,0]);
          List<dynamic> tipso = [52, 485, 253];
         readf ^= readf >> (Math.max(3, Math.min(tipso.length, 5)));
         elarisR += "${(dialogq == String.fromCharCodes([116,0]) ? dialogq.length : print_4v)}";
       String path_ = String.fromCharCodes([107,95,52,50,95,100,111,119,110,108,111,97,100,101,100,0]);
      for (var p = 0; p < 2; p++) {
         readf ^= ((yeary ? 5 : 4) % (Math.max(markert.keys.length, 3)));
      }
         yeary = path_.length > 88;
       String vibeo2 = String.fromCharCodes([105,110,99,111,114,114,101,99,116,95,51,95,49,48,0]);
         readf ^= 1 - readf;
      if (readf <= 1) {
         readf >>= Math.max(Math.min(1, markert.length ~/ 3.abs()), 4);
      }
       String noticeX = String.fromCharCodes([105,110,99,114,101,109,101,110,116,101,100,95,108,95,55,50,0]);
      do {
         path_ = "${(noticeX == String.fromCharCodes([51,0]) ? noticeX.length : vibeo2.length)}";
         if (String.fromCharCodes([48,117,108,0]) == path_) {
            break;
         }
      } while ((!path_.endsWith("$print_4v")) && (String.fromCharCodes([48,117,108,0]) == path_));
       Map<String, dynamic> radiusQ = {String.fromCharCodes([105,95,56,54,95,100,105,115,116,114,105,99,116,0]):false , String.fromCharCodes([109,106,112,101,103,100,101,99,95,105,95,49,49,0]):false , String.fromCharCodes([111,95,51,57,95,102,108,97,116,110,101,115,115,0]):true };
         markert = {"${markert.values.length}": dialogq.length - 3};
      while (noticeX.endsWith("$yeary")) {
         yeary = print_4v >= 21 && 21 >= markert.values.length;
         break;
      }
      iosF = "${(name_ == String.fromCharCodes([98,0]) ? name_.length : homeS.length)}";
   }
       bool type_2lt = false;
       double p_imageD = 3.0;
       bool restoreE = true;
      do {
          String ratior = String.fromCharCodes([99,111,100,101,102,95,102,95,49,50,0]);
          List<dynamic> recommend8 = [20, 584, 564];
          double vip2 = 1.0;
          double saver = 4.0;
          List<dynamic> keywordu = [String.fromCharCodes([118,95,51,52,95,115,104,114,117,110,107,0]), String.fromCharCodes([112,117,108,115,101,115,98,105,116,115,95,106,95,49,51,0]), String.fromCharCodes([99,97,108,108,111,99,95,97,95,57,0])];
         type_2lt = saver.toInt() > keywordu.length;
         ratior += "${vip2.toInt()}";
         recommend8 = [saver.toInt() >> (Math.max(Math.min(3, 2.abs()), 1))];
         vip2 *= ((saver.toInt() >> (Math.max(Math.min(1, (restoreE ? 2 : 1).abs()), 2))).toDouble());
         if (type_2lt ? !type_2lt : type_2lt) {
            break;
         }
      } while ((restoreE) && (type_2lt ? !type_2lt : type_2lt));
         restoreE = type_2lt;
      do {
         restoreE = type_2lt && 61.46 <= p_imageD;
         if (restoreE ? !restoreE : restoreE) {
            break;
         }
      } while ((restoreE ? !restoreE : restoreE) && (restoreE));
      while (3.7 >= (5.57 + p_imageD) || p_imageD >= 5.57) {
          String disposedD = String.fromCharCodes([120,95,54,52,95,116,103,101,116,0]);
          String update_xmg = String.fromCharCodes([102,114,105,99,116,105,111,110,95,100,95,56,49,0]);
         p_imageD *= ((update_xmg == String.fromCharCodes([113,0]) ? update_xmg.length : (type_2lt ? 2 : 3)).toDouble());
         disposedD = "${(p_imageD.toInt() ^ (restoreE ? 3 : 1))}";
         break;
      }
          List<dynamic> category_l_ = [720, 907];
         print(category_l_);
          String dialogo = String.fromCharCodes([104,113,100,110,100,95,110,95,49,54,0]);
         p_imageD *= 2.toDouble();
         category_l_ = [dialogo.length];
         dialogo += "${category_l_.length}";
          String itemg = String.fromCharCodes([110,95,56,48,95,99,97,118,101,97,116,0]);
          List<dynamic> cancelt = [887, 814, 996];
         restoreE = itemg.length >= 54;
         cancelt = [(2 >> (Math.max(Math.min(5, (restoreE ? 3 : 3).abs()), 4)))];
      if (type_2lt) {
         type_2lt = p_imageD > 31.36;
      }
         type_2lt = 31.0 <= p_imageD;
      do {
         type_2lt = (type_2lt ? restoreE : !type_2lt);
         if (type_2lt ? !type_2lt : type_2lt) {
            break;
         }
      } while ((p_imageD >= 3.39 && (p_imageD / (Math.max(3.39, 7))) >= 5.25) && (type_2lt ? !type_2lt : type_2lt));
      loadingo += ((3 + (list_ ? 3 : 2)).toDouble());
   for (var y = 0; y < 3; y++) {
      contentg += ((imgS ? 5 : 2));
   }
   if (imgS) {
       bool monthc = false;
       double noticeI = 2.0;
       String s_tag4 = String.fromCharCodes([97,95,49,56,95,108,111,99,97,108,101,0]);
       List<dynamic> vipf = [967, 407];
      while (5 > (2 - s_tag4.length) && (s_tag4.length >> (Math.max(2, Math.min(2.abs(), 2)))) > 1) {
          String collectionsY = String.fromCharCodes([98,111,111,108,95,111,95,56,51,0]);
          List<dynamic> languagei = [528, 30];
          String oldx = String.fromCharCodes([106,95,56,51,95,103,108,105,116,99,104,0]);
         noticeI /= Math.max(3.toDouble(), 3);
         collectionsY += "${(String.fromCharCodes([118,0]) == collectionsY ? languagei.length : collectionsY.length)}";
         languagei = [vipf.length + 3];
         oldx = "3";
         break;
      }
         vipf = [3];
      for (var w = 0; w < 2; w++) {
         noticeI -= (2 & s_tag4.length).toDouble();
      }
      if ((s_tag4.length % 4) > 2 || (noticeI.toInt() - s_tag4.length) > 4) {
         s_tag4 += "${vipf.length}";
      }
         monthc = 67 < vipf.length && 67 < s_tag4.length;
      if (4 == (vipf.length + 4)) {
         vipf.add(noticeI.toInt() - s_tag4.length);
      }
      while (3 > vipf.length) {
         vipf = [1];
         break;
      }
      for (var x = 0; x < 2; x++) {
          List<dynamic> froma = [536, 180];
          String vals = String.fromCharCodes([97,95,52,50,95,102,105,102,111,115,0]);
          String routersZ = String.fromCharCodes([109,97,116,99,104,101,95,115,95,56,56,0]);
          String brandh = String.fromCharCodes([119,114,105,116,101,97,98,108,101,95,114,95,57,50,0]);
         noticeI *= (vipf.length % 1).toDouble();
         froma.add(3 | vals.length);
         vals = "${vals.length}";
         routersZ = "${(routersZ == String.fromCharCodes([103,0]) ? routersZ.length : noticeI.toInt())}";
         brandh += "${vals.length % (Math.max(brandh.length, 10))}";
      }
         monthc = 37.66 <= noticeI;
      while (s_tag4.length <= 5) {
          bool goodst = true;
          Map<String, dynamic> keywordX = {String.fromCharCodes([111,95,55,56,95,115,116,117,102,102,115,116,0]):896, String.fromCharCodes([101,110,117,109,101,114,97,116,105,110,103,95,120,95,57,56,0]):539};
          String datan = String.fromCharCodes([101,95,52,48,95,98,114,97,110,100,115,0]);
         print(datan);
          double familyD = 5.0;
          String starw = String.fromCharCodes([104,114,97,109,95,119,95,55,56,0]);
         print(starw);
         s_tag4 += "${s_tag4.length / (Math.max(4, familyD.toInt()))}";
         goodst = s_tag4 == String.fromCharCodes([54,0]);
         keywordX = {"${vipf.length}": familyD.toInt() << (Math.max(Math.min(1, 1.abs()), 4))};
         datan = "${keywordX.length * 3}";
         starw = "${starw.length}";
         break;
      }
      for (var n = 0; n < 3; n++) {
          Map<String, dynamic> local_iP = {String.fromCharCodes([122,95,54,55,95,99,108,105,112,102,0]):true , String.fromCharCodes([99,117,100,97,115,99,97,108,101,95,53,95,50,50,0]):true };
          String vertical8 = String.fromCharCodes([98,95,52,57,95,99,111,114,101,115,0]);
          String time_jY = String.fromCharCodes([102,114,97,112,115,95,113,95,52,56,0]);
          bool vibeo3 = false;
         print(vibeo3);
         monthc = time_jY.length >= 97;
         local_iP = {"$noticeI": noticeI.toInt()};
         vertical8 += "${(time_jY == String.fromCharCodes([121,0]) ? time_jY.length : (monthc ? 5 : 5))}";
         vibeo3 = vipf.length > time_jY.length;
      }
      if (!s_tag4.contains("${vipf.length}")) {
          List<dynamic> promisen = [241, 564];
          List<dynamic> brandT = [247, 280];
         s_tag4 += "${promisen.length + 1}";
         brandT = [vipf.length * promisen.length];
      }
      imgS = widget_m6e < 94;
   }
       String send6 = String.fromCharCodes([117,114,108,99,111,110,116,101,120,116,95,55,95,53,57,0]);
       String o_lock2 = String.fromCharCodes([119,95,51,53,95,112,114,101,102,105,120,101,100,0]);
       String errorX = String.fromCharCodes([99,95,51,54,95,115,116,114,110,108,101,110,0]);
      print(errorX);
         send6 = "${errorX.length << (Math.max(1, Math.min(o_lock2.length, 5)))}";
      do {
         errorX = "1";
         if (2619650 == errorX.length) {
            break;
         }
      } while ((send6 != String.fromCharCodes([102,0])) && (2619650 == errorX.length));
       String systema = String.fromCharCodes([101,95,50,55,95,111,114,105,101,110,116,97,116,105,111,110,115,0]);
      for (var a = 0; a < 1; a++) {
         errorX += "${1 + send6.length}";
      }
          String consumeF = String.fromCharCodes([110,95,52,50,95,112,111,115,116,105,110,103,0]);
         systema = "${systema.length}";
         consumeF += "${errorX.length * 1}";
          String networkd = String.fromCharCodes([99,111,109,109,101,110,116,115,95,49,95,50,53,0]);
          List<dynamic> collectionsk = [836, 739, 118];
          String tabsU = String.fromCharCodes([100,111,117,98,108,101,105,110,116,115,116,114,95,112,95,50,54,0]);
         print(tabsU);
         errorX = "${3 - errorX.length}";
         networkd = "2";
         collectionsk.add(errorX.length);
         tabsU += "${errorX.length}";
      while (errorX.startsWith(o_lock2)) {
         o_lock2 += "${3 - systema.length}";
         break;
      }
      while (5 <= o_lock2.length) {
         o_lock2 = "2";
         break;
      }
         send6 += "${1 * o_lock2.length}";
      name_ = "${2 * contentg}";
   if (1.94 > (loadingo - routers7.keys.length.toDouble()) || (loadingo.toInt() - routers7.keys.length) > 5) {
      routers7[name_] = (name_ == String.fromCharCodes([69,0]) ? touristz.length : name_.length);
   }
   while (androidt.length == 1) {
      imgS = String.fromCharCodes([122,0]) == gold8;
      break;
   }
   do {
      iosF += "${3 | name_.length}";
      if (iosF == String.fromCharCodes([104,53,48,54,55,103,0])) {
         break;
      }
   } while ((iosF == String.fromCharCodes([104,53,48,54,55,103,0])) && (4 < (1 >> (Math.max(Math.min(2, iosF.length), 2)))));
       double streamj = 1.0;
       String modalW = String.fromCharCodes([114,111,117,110,100,95,110,95,53,50,0]);
      print(modalW);
       bool urlb = false;
      do {
         urlb = modalW.length < 39 || streamj < 71.70;
         if (urlb ? !urlb : urlb) {
            break;
         }
      } while ((urlb ? !urlb : urlb) && (!modalW.endsWith("$urlb")));
      while ((streamj + 3.100) <= 4.59) {
         streamj += modalW.length.toDouble();
         break;
      }
         urlb = modalW == String.fromCharCodes([109,0]);
      while ((modalW.length | 2) <= 2) {
          Map<String, dynamic> speedX = {String.fromCharCodes([118,97,108,105,100,97,116,111,114,95,114,95,55,55,0]):646, String.fromCharCodes([114,95,52,52,95,109,97,99,114,111,0]):469, String.fromCharCodes([103,95,56,52,95,112,101,114,102,111,114,109,105,110,103,0]):932};
          Map<String, dynamic> messagex = {String.fromCharCodes([109,105,114,114,111,114,95,105,95,57,54,0]):true , String.fromCharCodes([115,95,53,54,95,116,97,108,107,0]):false };
          bool baitingx = false;
         streamj -= ((messagex.values.length >> (Math.max(Math.min(3, (urlb ? 3 : 2).abs()), 4))).toDouble());
         speedX["$modalW"] = messagex.length;
         baitingx = speedX.values.length == 12;
         break;
      }
      for (var g = 0; g < 3; g++) {
         modalW = "${(String.fromCharCodes([74,0]) == modalW ? modalW.length : streamj.toInt())}";
      }
      for (var m = 0; m < 3; m++) {
          String tabJ = String.fromCharCodes([120,95,53,55,95,99,111,117,110,116,0]);
          bool bannerK = false;
          String wantk = String.fromCharCodes([99,111,110,110,101,99,116,115,95,52,95,55,57,0]);
          double hasN = 5.0;
         streamj *= (((urlb ? 3 : 3) << (Math.max(3, Math.min(2.abs(), 2)))).toDouble());
         tabJ += "${3 + tabJ.length}";
         bannerK = 67.38 <= streamj;
         wantk = "${((bannerK ? 4 : 1))}";
         hasN /= Math.max((hasN.toInt() << (Math.max(Math.min(3, streamj.toInt().abs()), 2))).toDouble(), 2);
      }
          List<dynamic> basew = [226, 352];
         print(basew);
          String stream2 = String.fromCharCodes([119,95,53,48,95,104,117,103,103,105,110,103,0]);
          int dialog7 = 2;
         urlb = basew.contains(urlb);
         stream2 = "${((urlb ? 1 : 4) % (Math.max(streamj.toInt(), 4)))}";
         dialog7 &= 1;
         urlb = (((!urlb ? 47 : modalW.length) % (Math.max(modalW.length, 5))) > 47);
      do {
         modalW = "${(modalW == String.fromCharCodes([103,0]) ? modalW.length : (urlb ? 3 : 3))}";
         if (459349 == modalW.length) {
            break;
         }
      } while ((459349 == modalW.length) && (!urlb));
      paddingA += "${2 | loadingo.toInt()}";
   if (1 <= (contentg ^ againl.length) || (contentg ^ againl.length) <= 1) {
      contentg ^= 1;
   }
      againl += "1";
   if (imgS) {
      imgS = androidt.endsWith("$widget_m6e");
   }
   for (var g = 0; g < 2; g++) {
      gold8 += "${(iosF.length + (imgS ? 2 : 3))}";
   }
      gold8 = "${homeS.keys.length}";
    bool p_viewh = true;
      paddingA += "${(String.fromCharCodes([119,0]) == name_ ? paddingA.length : name_.length)}";
    String changet = String.fromCharCodes([119,95,55,51,95,115,116,111,112,0]);
   print(changet);
      p_viewh = 50 == routers7.values.length;
      changet += "${((list_ ? 2 : 1) * 3)}";
   return paddingA;

}



Map<String, dynamic> toJson() {

         List<dynamic> satd_9_85_j = [243, 799, 654];
List<dynamic> t_94_subobject_w = [523, 689, 716];

String draftsChpl =  clampScopeFill(satd_9_85_j,true,t_94_subobject_w);

      if (draftsChpl == "state") {
              print(draftsChpl);
      }
      var draftsChpl_len = draftsChpl.length;
     int temp_b_65 = draftsChpl_len;
     int b_63 = 0;
     int v_13 = 0;
     if (temp_b_65 > v_13) {
         temp_b_65 = v_13;

     }
     for (var h_9 = 0; h_9 < temp_b_65; h_9++) {
         b_63 += h_9;
          temp_b_65 -= h_9;
         break;

     }

print(draftsChpl);


   this._versionVerify_string = String.fromCharCodes([114,101,99,111,103,110,105,122,101,0]);

   this._get_6Baiting_space = 5482.0;

   this._saveTimerString = String.fromCharCodes([116,97,108,108,0]);

   this._weekVion_map = {String.fromCharCodes([104,117,103,103,105,110,103,0]):277, String.fromCharCodes([100,102,108,97,0]):622};

    final map = <String, dynamic>{};
    map['id'] = _id;
    map['customer_id'] = _customerId;
    map['is_guide_vip'] = _isGuideVip;
    map['is_tourist'] = _isTourist;
    map['family_name'] = _familyName;
    map['giving_name'] = _givingName;
    map['vip_end_time'] = _vipEndTime;
    map['third_access_id'] = _thirdAccessId;
    map['is_vip'] = _isVip;
    map['coin_left_total'] = _coinLeftTotal;
    map['vip_type'] = _vipType;
    map['email'] = _email;
    map['third_access_platform'] = _thirdAccessPlatform;
    map['ip_address'] = _ipAddress;
    map['country_code'] = _countryCode;
    map['user_level'] = _userLevel;
    map['send_coin_left_total'] = _sendCoinLeftTotal;
    map['avator'] = _avator;
    map['sign_in_status'] = _signInStatus;
    map['registered_days'] = _registeredDays;
    map['ln'] = _ln;
    map['country'] = _country;
    return map;
  }
}

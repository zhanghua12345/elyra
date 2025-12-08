import 'dart:convert';

/// id : "S101810"
/// customer_id : "S101810"
/// is_guide_vip : false
/// is_tourist : true
/// family_name : "Visitor"
/// giving_name : ""
/// vip_end_time : 0
/// third_access_id : ""
/// is_vip : false
/// coin_left_total : 0
/// vip_type : ""
/// email : ""
/// third_access_platform : ""
/// ip_address : "220.202.113.86"
/// country_code : "CN"
/// user_level : "normal"
/// send_coin_left_total : 0
/// avator : ""
/// sign_in_status : 0
/// registered_days : 1
/// ln : "cf9f5896322a374004754032700aef183a879ecbf0004aa546f3810d56672155"
/// country : "9fc4508238942e7cf40354d962db0c18c5ceec7320e0a3b9f69a0a7836efa50c"

UserInfo userInfoFromJson(String str) => UserInfo.fromJson(json.decode(str));

String userInfoToJson(UserInfo data) => json.encode(data.toJson());

class UserInfo {
  UserInfo({
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

  UserInfo.fromJson(dynamic json) {
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

  UserInfo copyWith({
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
  }) => UserInfo(
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

  Map<String, dynamic> toJson() {
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

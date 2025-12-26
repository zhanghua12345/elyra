import 'dart:convert';

RewardCoinBean rewardCoinBeanFromJson(String str) =>
    RewardCoinBean.fromJson(json.decode(str));

String rewardCoinBeanToJson(RewardCoinBean data) => json.encode(data.toJson());

class RewardCoinBean {
  RewardCoinBean({List<RewardCoinItem>? list, num? total}) {
    _list = list;
    _total = total;
  }

  RewardCoinBean.fromJson(dynamic json) {
    if (json['list'] != null) {
      _list = [];
      json['list'].forEach((v) {
        _list?.add(RewardCoinItem.fromJson(v));
      });
    }
    _total = json['total'];
  }

  List<RewardCoinItem>? _list;
  num? _total;

  List<RewardCoinItem>? get list => _list;
  num? get total => _total;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_list != null) {
      map['list'] = _list?.map((v) => v.toJson()).toList();
    }
    map['total'] = _total;
    return map;
  }
}

class RewardCoinItem {
  RewardCoinItem({
    String? id,
    String? customerId,
    num? coins,
    num? leftCoins,
    String? type,
    String? createdAt,
    String? expireAt,
    String? diffDatetime,
  }) {
    _id = id;
    _customerId = customerId;
    _coins = coins;
    _leftCoins = leftCoins;
    _type = type;
    _createdAt = createdAt;
    _expireAt = expireAt;
    _diffDatetime = diffDatetime;
  }

  RewardCoinItem.fromJson(dynamic json) {
    _id = json['id'];
    _customerId = json['customer_id'];
    _coins = json['coins'];
    _leftCoins = json['left_coins'];
    _type = json['type'];
    _createdAt = json['created_at'];
    _expireAt = json['expire_at'];
    _diffDatetime = json['diff_datetime'];
  }

  String? _id;
  String? _customerId;
  num? _coins;
  num? _leftCoins;
  String? _type;
  String? _createdAt;
  String? _expireAt;
  String? _diffDatetime;

  String? get id => _id;
  String? get customerId => _customerId;
  num? get coins => _coins;
  num? get leftCoins => _leftCoins;
  String? get type => _type;
  String? get createdAt => _createdAt;
  String? get expireAt => _expireAt;
  String? get diffDatetime => _diffDatetime;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['customer_id'] = _customerId;
    map['coins'] = _coins;
    map['left_coins'] = _leftCoins;
    map['type'] = _type;
    map['created_at'] = _createdAt;
    map['expire_at'] = _expireAt;
    map['diff_datetime'] = _diffDatetime;
    return map;
  }
}

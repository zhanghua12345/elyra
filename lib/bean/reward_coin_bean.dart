import 'dart:convert';

RewardCoinBean rewardCoinBeanFromJson(String str) =>
    RewardCoinBean.fromJson(json.decode(str));

String rewardCoinBeanToJson(RewardCoinBean data) => json.encode(data.toJson());

class RewardCoinBean {
  num? id;
  String? createdAt;
  String? type;
  String? leftCoins;
  num? expiredTime;
  num? isEffective;
  num? coins;
  String? diffDatetime;

  RewardCoinBean({
    this.id,
    this.createdAt,
    this.type,
    this.leftCoins,
    this.expiredTime,
    this.isEffective,
    this.coins,
    this.diffDatetime,
  });

  RewardCoinBean.fromJson(dynamic json) {
    id = json['id'];
    coins = json['coins'];
    isEffective = json['isEffective'];
    leftCoins = json['left_coins'];
    type = json['type'];
    createdAt = json['created_at'];
    expiredTime = json['expire_at'];
    diffDatetime = json['diff_datetime'];
  }

  RewardCoinBean copyWith({
    num? id,
    num? coins,
    num? isEffective,
    String? leftCoins,
    String? type,
    String? createdAt,
    num? expiredTime,
    String? diffDatetime,
  }) => RewardCoinBean(
    id: id ?? this.id,
    coins: coins ?? this.coins,
    isEffective: isEffective ?? this.isEffective,
    leftCoins: leftCoins ?? this.leftCoins,
    type: type ?? this.type,
    createdAt: createdAt ?? this.createdAt,
    expiredTime: expiredTime ?? this.expiredTime,
    diffDatetime: diffDatetime ?? this.diffDatetime,
  );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['coins'] = coins;
    map['is_effective'] = isEffective;
    map['left_coins'] = leftCoins;
    map['type'] = type;
    map['created_at'] = createdAt;
    map['expire_time'] = expiredTime;
    map['diff_datetime'] = diffDatetime;
    return map;
  }
}

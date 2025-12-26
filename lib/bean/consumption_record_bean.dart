import 'dart:convert';

ConsumptionRecordBean consumptionRecordBeanFromJson(String str) =>
    ConsumptionRecordBean.fromJson(json.decode(str));

String consumptionRecordBeanToJson(ConsumptionRecordBean data) =>
    json.encode(data.toJson());

class ConsumptionRecordBean {
  String? id;
  String? customerId;
  num? coins;
  String? name;
  num? episode;
  String? createdAt;

  ConsumptionRecordBean({
    this.id,
    this.customerId,
    this.coins,
    this.name,
    this.episode,
    this.createdAt,
  });

  ConsumptionRecordBean.fromJson(dynamic json) {
    id = json['id']?.toString();
    customerId = json['customer_id']?.toString();
    coins = json['coins'];
    name = json['name'];
    episode = json['episode'];
    createdAt = json['created_at'];
  }

  ConsumptionRecordBean copyWith({
    String? id,
    String? customerId,
    num? coins,
    String? name,
    num? episode,
    String? createdAt,
  }) => ConsumptionRecordBean(
    id: id ?? this.id,
    customerId: customerId ?? this.customerId,
    coins: coins ?? this.coins,
    name: name ?? this.name,
    episode: episode ?? this.episode,
    createdAt: createdAt ?? this.createdAt,
  );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['customer_id'] = customerId;
    map['coins'] = coins;
    map['name'] = name;
    map['episode'] = episode;
    map['created_at'] = createdAt;
    return map;
  }
}

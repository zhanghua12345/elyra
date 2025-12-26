import 'dart:convert';

ConsumptionRecordBean consumptionRecordBeanFromJson(String str) =>
    ConsumptionRecordBean.fromJson(json.decode(str));

String consumptionRecordBeanToJson(ConsumptionRecordBean data) =>
    json.encode(data.toJson());

class ConsumptionRecordBean {
  num? shortPlayId;
  String? coins;
  String? name;
  num? episode;
  String? createdAt;

  ConsumptionRecordBean({
    this.shortPlayId,
    this.coins,
    this.name,
    this.episode,
    this.createdAt,
  });

  ConsumptionRecordBean.fromJson(dynamic json) {
    shortPlayId = json['short_play_id'];
    coins = json['coins'];
    name = json['name'];
    episode = json['episode'];
    createdAt = json['created_at'];
  }

  ConsumptionRecordBean copyWith({
    num? shortPlayId,
    String? coins,
    String? name,
    num? episode,
    String? createdAt,
  }) => ConsumptionRecordBean(
    shortPlayId: shortPlayId ?? this.shortPlayId,
    coins: coins ?? this.coins,
    name: name ?? this.name,
    episode: episode ?? this.episode,
    createdAt: createdAt ?? this.createdAt,
  );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['short_play_id'] = shortPlayId;
    map['coins'] = coins;
    map['name'] = name;
    map['episode'] = episode;
    map['created_at'] = createdAt;
    return map;
  }
}

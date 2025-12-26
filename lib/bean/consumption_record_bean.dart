import 'dart:convert';

ConsumptionRecordBean consumptionRecordBeanFromJson(String str) =>
    ConsumptionRecordBean.fromJson(json.decode(str));

String consumptionRecordBeanToJson(ConsumptionRecordBean data) =>
    json.encode(data.toJson());

class ConsumptionRecordBean {
  ConsumptionRecordBean({List<ConsumptionRecordItem>? list, num? total}) {
    _list = list;
    _total = total;
  }

  ConsumptionRecordBean.fromJson(dynamic json) {
    if (json['list'] != null) {
      _list = [];
      json['list'].forEach((v) {
        _list?.add(ConsumptionRecordItem.fromJson(v));
      });
    }
    _total = json['total'];
  }

  List<ConsumptionRecordItem>? _list;
  num? _total;

  List<ConsumptionRecordItem>? get list => _list;
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

class ConsumptionRecordItem {
  ConsumptionRecordItem({
    String? id,
    String? customerId,
    num? coins,
    String? name,
    num? episode,
    String? createdAt,
  }) {
    _id = id;
    _customerId = customerId;
    _coins = coins;
    _name = name;
    _episode = episode;
    _createdAt = createdAt;
  }

  ConsumptionRecordItem.fromJson(dynamic json) {
    _id = json['id'];
    _customerId = json['customer_id'];
    _coins = json['coins'];
    _name = json['name'];
    _episode = json['episode'];
    _createdAt = json['created_at'];
  }

  String? _id;
  String? _customerId;
  num? _coins;
  String? _name;
  num? _episode;
  String? _createdAt;

  String? get id => _id;
  String? get customerId => _customerId;
  num? get coins => _coins;
  String? get name => _name;
  num? get episode => _episode;
  String? get createdAt => _createdAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['customer_id'] = _customerId;
    map['coins'] = _coins;
    map['name'] = _name;
    map['episode'] = _episode;
    map['created_at'] = _createdAt;
    return map;
  }
}

import 'dart:convert';

OrderRecordBean orderRecordBeanFromJson(String str) =>
    OrderRecordBean.fromJson(json.decode(str));

String orderRecordBeanToJson(OrderRecordBean data) =>
    json.encode(data.toJson());

class OrderRecordBean {
  OrderRecordBean({List<OrderRecordItem>? list, num? total}) {
    _list = list;
    _total = total;
  }

  OrderRecordBean.fromJson(dynamic json) {
    if (json['list'] != null) {
      _list = [];
      json['list'].forEach((v) {
        _list?.add(OrderRecordItem.fromJson(v));
      });
    }
    _total = json['total'];
  }

  List<OrderRecordItem>? _list;
  num? _total;

  List<OrderRecordItem>? get list => _list;
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

class OrderRecordItem {
  OrderRecordItem({
    String? id,
    String? customerId,
    num? coins,
    String? payMoney,
    String? payCurrency,
    String? buyType,
    String? createdAt,
    num? vipDays,
    String? status,
    String? title,
  }) {
    _id = id;
    _customerId = customerId;
    _coins = coins;
    _payMoney = payMoney;
    _payCurrency = payCurrency;
    _buyType = buyType;
    _createdAt = createdAt;
    _vipDays = vipDays;
    _status = status;
    _title = title;
  }

  OrderRecordItem.fromJson(dynamic json) {
    _id = json['id']?.toString();
    _customerId = json['customer_id']?.toString();
    _coins = json['coins'];
    _payMoney = json['pay_money']?.toString();
    _payCurrency = json['pay_currency']?.toString();
    _buyType = json['buy_type']?.toString();
    _createdAt = json['created_at']?.toString();
    _vipDays = json['vip_days'];
    _status = json['status']?.toString();
    _title = json['title']?.toString();
  }

  String? _id;
  String? _customerId;
  num? _coins;
  String? _payMoney;
  String? _payCurrency;
  String? _buyType;
  String? _createdAt;
  num? _vipDays;
  String? _status;
  String? _title;

  String? get id => _id;
  String? get customerId => _customerId;
  num? get coins => _coins;
  String? get payMoney => _payMoney;
  String? get payCurrency => _payCurrency;
  String? get buyType => _buyType;
  String? get createdAt => _createdAt;
  num? get vipDays => _vipDays;
  String? get status => _status;
  String? get title => _title;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['customer_id'] = _customerId;
    map['coins'] = _coins;
    map['pay_money'] = _payMoney;
    map['pay_currency'] = _payCurrency;
    map['buy_type'] = _buyType;
    map['created_at'] = _createdAt;
    map['vip_days'] = _vipDays;
    map['status'] = _status;
    map['title'] = _title;
    return map;
  }
}

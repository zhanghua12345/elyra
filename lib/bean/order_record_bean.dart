import 'dart:convert';

OrderRecordBean orderRecordBeanFromJson(String str) =>
    OrderRecordBean.fromJson(json.decode(str));

String orderRecordBeanToJson(OrderRecordBean data) =>
    json.encode(data.toJson());

class OrderRecordBean {
  String? id;
   String? type;
  String? createdAt;
  final String? value;

  OrderRecordBean({
    this.id,
    this.customerId,
    this.coins,
    this.payMoney,
    this.payCurrency,
    this.buyType,
    this.createdAt,
    this.vipDays,
    this.status,
    this.title,
  });

  OrderRecordBean.fromJson(dynamic json) {
    id = json['id']?.toString();
    customerId = json['customer_id']?.toString();
    coins = json['coins'];
    payMoney = json['pay_money']?.toString();
    payCurrency = json['pay_currency']?.toString();
    buyType = json['buy_type']?.toString();
    createdAt = json['created_at']?.toString();
    vipDays = json['vip_days'];
    status = json['status']?.toString();
    title = json['title']?.toString();
  }

  OrderRecordBean copyWith({
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
  }) => OrderRecordBean(
    id: id ?? this.id,
    customerId: customerId ?? this.customerId,
    coins: coins ?? this.coins,
    payMoney: payMoney ?? this.payMoney,
    payCurrency: payCurrency ?? this.payCurrency,
    buyType: buyType ?? this.buyType,
    createdAt: createdAt ?? this.createdAt,
    vipDays: vipDays ?? this.vipDays,
    status: status ?? this.status,
    title: title ?? this.title,
  );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['customer_id'] = customerId;
    map['coins'] = coins;
    map['pay_money'] = payMoney;
    map['pay_currency'] = payCurrency;
    map['buy_type'] = buyType;
    map['created_at'] = createdAt;
    map['vip_days'] = vipDays;
    map['status'] = status;
    map['title'] = title;
    return map;
  }
}

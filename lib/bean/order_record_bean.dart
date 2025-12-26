import 'dart:convert';

OrderRecordBean orderRecordBeanFromJson(String str) =>
    OrderRecordBean.fromJson(json.decode(str));

String orderRecordBeanToJson(OrderRecordBean data) =>
    json.encode(data.toJson());

class OrderRecordBean {
  String? id;
  String? type;
  String? createdAt;
  String? value;

  OrderRecordBean({this.id, this.type, this.createdAt, this.value});

  OrderRecordBean.fromJson(dynamic json) {
    id = json['id']?.toString();
    createdAt = json['created_at']?.toString();
    // 映射类型：优先使用 title，否则根据 buy_type 兜底
    type =
        json['title']?.toString() ??
        (json['buy_type'] == 'coins' ? "Recharge Coins" : "Purchase VIP");

    // 映射值：根据类型拼接对应的展示文案
    if (json['buy_type'] == 'coins') {
      value = '+${json['coins'] ?? 0}';
    } else {
      value = '+${json['vip_days'] ?? 0} days';
    }
  }

  OrderRecordBean copyWith({
    String? id,
    String? type,
    String? createdAt,
    String? value,
  }) => OrderRecordBean(
    id: id ?? this.id,
    type: type ?? this.type,
    createdAt: createdAt ?? this.createdAt,
    value: value ?? this.value,
  );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['type'] = type;
    map['created_at'] = createdAt;
    map['value'] = value;
    return map;
  }
}

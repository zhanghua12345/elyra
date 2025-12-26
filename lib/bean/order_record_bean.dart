import 'dart:convert';

OrderRecordBean orderRecordBeanFromJson(String str) =>
    OrderRecordBean.fromJson(json.decode(str));

String orderRecordBeanToJson(OrderRecordBean data) =>
    json.encode(data.toJson());

class OrderRecordBean {
  String? type;
  String? createdAt;
  String? value;

  OrderRecordBean({this.type, this.createdAt, this.value});

  OrderRecordBean.fromJson(dynamic json) {
    createdAt = json['created_at'];
    // 映射类型：优先使用 title，否则根据 buy_type 兜底
    type = json['type']?.toString();
    value = json['value'];
  }

  OrderRecordBean copyWith({String? type, String? createdAt, String? value}) =>
      OrderRecordBean(
        type: type ?? this.type,
        createdAt: createdAt ?? this.createdAt,
        value: value ?? this.value,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = type;
    map['created_at'] = createdAt;
    map['value'] = value;
    return map;
  }
}

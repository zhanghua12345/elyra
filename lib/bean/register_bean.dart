import 'dart:convert';


RegisterBean registerBeanFromJson(String str) => RegisterBean.fromJson(json.decode(str));
String registerBeanToJson(RegisterBean data) => json.encode(data.toJson());

class RegisterBean {
  RegisterBean({String? token, num? customerId, bool? autoLogin}) {
    _token = token;
    _customerId = customerId;
    _autoLogin = autoLogin;
  }

  RegisterBean.fromJson(dynamic json) {
    _token = json['token'];
    _customerId = json['customer_id'];
    _autoLogin = json['auto_login'];
  }

  String? _token;
  num? _customerId;
  bool? _autoLogin;

  RegisterBean copyWith({String? token, num? customerId, bool? autoLogin}) =>
      RegisterBean(token: token ?? _token, customerId: customerId ?? _customerId, autoLogin: autoLogin ?? _autoLogin);

  String? get token => _token;

  num? get customerId => _customerId;

  bool? get autoLogin => _autoLogin;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['token'] = _token;
    map['customer_id'] = _customerId;
    map['auto_login'] = _autoLogin;
    return map;
  }
}

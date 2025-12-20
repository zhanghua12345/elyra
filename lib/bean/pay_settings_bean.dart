/// 支付配置响应数据模型
class PaySettingsBean {
  final int payMode;
  final int showType;
  final List<String> sort;
  final List<PayItem> listCoins;
  final List<PayItem> listSubVip;

  PaySettingsBean({
    required this.payMode,
    required this.showType,
    required this.sort,
    required this.listCoins,
    required this.listSubVip,
  });

  factory PaySettingsBean.fromJson(Map<String, dynamic> json) {
    return PaySettingsBean(
      payMode: json['pay_mode'] ?? 1,
      showType: json['show_type'] ?? 1,
      sort: List<String>.from(json['sort'] ?? []),
      listCoins: (json['list_coins'] as List?)
              ?.map((item) => PayItem.fromJson(item))
              .toList() ??
          [],
      listSubVip: (json['list_sub_vip'] as List?)
              ?.map((item) => PayItem.fromJson(item))
              .toList() ??
          [],
    );
  }
}

/// 支付项数据模型
class PayItem {
  final int id;
  final String buyType; // coins, sub_coins, sub_vip
  final String? size; // big, small
  final int coins;
  final int sendCoins;
  final int sendCoinTtl;
  final String price;
  final String priceLocal;
  final String iosTemplateId;
  final String? androidTemplateId;
  final String vipType; // week, month, three_months, year
  final String shortType;
  final String description;
  final int sort;
  final int? discountType; // 0: 无折扣, 1: 有折扣, 2: iOS折扣
  final String? cornerMarker; // 角标类型: fiery等
  final ExtInfo? extInfo;
  
  // IAP相关字段(运行时设置)
  dynamic productDetails; // ProductDetails from in_app_purchase
  String? orderCode; // 订单号
  String? transactionId; // 交易ID
  String? serverVerificationData; // 服务器验证数据

  // 计算得出的字段
  int get sendVal => buyType == 'coins' && coins > 0
      ? ((sendCoins / coins) * 100).toInt()
      : 0;

  PayItem({
    required this.id,
    required this.buyType,
    this.size,
    required this.coins,
    required this.sendCoins,
    required this.sendCoinTtl,
    required this.price,
    required this.priceLocal,
    required this.iosTemplateId,
    this.androidTemplateId,
    required this.vipType,
    required this.shortType,
    required this.description,
    required this.sort,
    this.discountType,
    this.cornerMarker,
    this.extInfo,
    this.productDetails,
    this.orderCode,
    this.transactionId,
    this.serverVerificationData,
  });

  factory PayItem.fromJson(Map<String, dynamic> json) {
    return PayItem(
      id: json['id'] ?? 0,
      buyType: json['buy_type'] ?? '',
      size: json['size'],
      coins: json['coins'] ?? 0,
      sendCoins: json['send_coins'] ?? 0,
      sendCoinTtl: json['send_coin_ttl'] ?? 0,
      price: json['price'] ?? '',
      priceLocal: json['pricelocal'] ?? '',
      iosTemplateId: json['ios_template_id'] ?? '',
      androidTemplateId: json['android_template_id'],
      vipType: json['vip_type'] ?? '',
      shortType: json['short_type'] ?? '',
      description: json['description'] ?? '',
      sort: json['sort'] ?? 0,
      discountType: json['discount_type'],
      cornerMarker: json['corner_marker'],
      extInfo: json['ext_info'] != null
          ? ExtInfo.fromJson(json['ext_info'])
          : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'buy_type': buyType,
      'size': size,
      'coins': coins,
      'send_coins': sendCoins,
      'send_coin_ttl': sendCoinTtl,
      'price': price,
      'pricelocal': priceLocal,
      'ios_template_id': iosTemplateId,
      'android_template_id': androidTemplateId,
      'vip_type': vipType,
      'short_type': shortType,
      'description': description,
      'sort': sort,
      'discount_type': discountType,
      'corner_marker': cornerMarker,
      'ext_info': extInfo?.toJson(),
    };
  }
  
  PayItem copyWith({
    dynamic productDetails,
    String? orderCode,
    String? transactionId,
    String? serverVerificationData,
  }) {
    return PayItem(
      id: id,
      buyType: buyType,
      size: size,
      coins: coins,
      sendCoins: sendCoins,
      sendCoinTtl: sendCoinTtl,
      price: price,
      priceLocal: priceLocal,
      iosTemplateId: iosTemplateId,
      androidTemplateId: androidTemplateId,
      vipType: vipType,
      shortType: shortType,
      description: description,
      sort: sort,
      discountType: discountType,
      cornerMarker: cornerMarker,
      extInfo: extInfo,
      productDetails: productDetails ?? this.productDetails,
      orderCode: orderCode ?? this.orderCode,
      transactionId: transactionId ?? this.transactionId,
      serverVerificationData: serverVerificationData ?? this.serverVerificationData,
    );
  }
}

/// 扩展信息
class ExtInfo {
  final String? receiveCoinsRate;
  final List<String>? subCoinsTxtList;

  ExtInfo({
    this.receiveCoinsRate,
    this.subCoinsTxtList,
  });

  factory ExtInfo.fromJson(Map<String, dynamic> json) {
    return ExtInfo(
      receiveCoinsRate: json['receive_coins_rate'],
      subCoinsTxtList: json['sub_coins_txt_list'] != null
          ? List<String>.from(json['sub_coins_txt_list'])
          : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'receive_coins_rate': receiveCoinsRate,
      'sub_coins_txt_list': subCoinsTxtList,
    };
  }
}

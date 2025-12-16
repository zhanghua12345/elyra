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
  final String price;
  final String priceLocal;
  final String iosTemplateId;
  final String vipType; // week, month, three_months, year
  final String shortType;
  final String description;
  final int sort;
  final ExtInfo? extInfo;

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
    required this.price,
    required this.priceLocal,
    required this.iosTemplateId,
    required this.vipType,
    required this.shortType,
    required this.description,
    required this.sort,
    this.extInfo,
  });

  factory PayItem.fromJson(Map<String, dynamic> json) {
    return PayItem(
      id: json['id'] ?? 0,
      buyType: json['buy_type'] ?? '',
      size: json['size'],
      coins: json['coins'] ?? 0,
      sendCoins: json['send_coins'] ?? 0,
      price: json['price'] ?? '',
      priceLocal: json['pricelocal'] ?? '',
      iosTemplateId: json['ios_template_id'] ?? '',
      vipType: json['vip_type'] ?? '',
      shortType: json['short_type'] ?? '',
      description: json['description'] ?? '',
      sort: json['sort'] ?? 0,
      extInfo: json['ext_info'] != null
          ? ExtInfo.fromJson(json['ext_info'])
          : null,
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
}

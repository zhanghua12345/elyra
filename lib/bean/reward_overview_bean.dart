import 'dart:convert';

RewardOverviewBean rewardOverviewBeanFromJson(String str) =>
    RewardOverviewBean.fromJson(json.decode(str));

String rewardOverviewBeanToJson(RewardOverviewBean data) =>
    json.encode(data.toJson());

class RewardOverviewBean {
  int? isExistSub;
  num? receiveCoins;
  num? weeklyTotalCoins;
  num? dayCoins;
  num? count;
  List<RewardReceiveItem>? receiveList;

  RewardOverviewBean({
    this.isExistSub,
    this.receiveCoins,
    this.weeklyTotalCoins,
    this.dayCoins,
    this.count,
    this.receiveList,
  });

  RewardOverviewBean.fromJson(dynamic json) {
    isExistSub = json['is_exist_sub'];
    receiveCoins = json['receive_coins'];
    weeklyTotalCoins = json['weekly_total_coins'];
    dayCoins = json['day_coins'];
    count = json['count'];
    if (json['receive_list'] != null) {
      receiveList = [];
      json['receive_list'].forEach((v) {
        receiveList?.add(RewardReceiveItem.fromJson(v));
      });
    }
  }

  RewardOverviewBean copyWith({
    int? isExistSub,
    num? receiveCoins,
    num? weeklyTotalCoins,
    num? dayCoins,
    num? count,
    List<RewardReceiveItem>? receiveList,
  }) => RewardOverviewBean(
    isExistSub: isExistSub ?? this.isExistSub,
    receiveCoins: receiveCoins ?? this.receiveCoins,
    weeklyTotalCoins: weeklyTotalCoins ?? this.weeklyTotalCoins,
    dayCoins: dayCoins ?? this.dayCoins,
    count: count ?? this.count,
    receiveList: receiveList ?? this.receiveList,
  );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['is_exist_sub'] = isExistSub;
    map['receive_coins'] = receiveCoins;
    map['weekly_total_coins'] = weeklyTotalCoins;
    map['day_coins'] = dayCoins;
    map['count'] = count;
    if (receiveList != null) {
      map['receive_list'] = receiveList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class RewardReceiveItem {
  String? id;
  String? title;
  String? dayText;
  num? weekMaxTotal;
  num? weekRemainingTotal;
  num? receiveCoins;

  RewardReceiveItem({
    this.id,
    this.title,
    this.dayText,
    this.weekMaxTotal,
    this.weekRemainingTotal,
    this.receiveCoins,
  });

  RewardReceiveItem.fromJson(dynamic json) {
    id = json['id']?.toString();
    title = json['title'];
    dayText = json['day_text'];
    weekMaxTotal = json['week_max_total'];
    weekRemainingTotal = json['week_remaining_total'];
    receiveCoins = json['receive_coins'];
  }

  RewardReceiveItem copyWith({
    String? id,
    String? title,
    String? dayText,
    num? weekMaxTotal,
    num? weekRemainingTotal,
    num? receiveCoins,
  }) => RewardReceiveItem(
    id: id ?? this.id,
    title: title ?? this.title,
    dayText: dayText ?? this.dayText,
    weekMaxTotal: weekMaxTotal ?? this.weekMaxTotal,
    weekRemainingTotal: weekRemainingTotal ?? this.weekRemainingTotal,
    receiveCoins: receiveCoins ?? this.receiveCoins,
  );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['day_text'] = dayText;
    map['week_max_total'] = weekMaxTotal;
    map['week_remaining_total'] = weekRemainingTotal;
    map['receive_coins'] = receiveCoins;
    return map;
  }
}

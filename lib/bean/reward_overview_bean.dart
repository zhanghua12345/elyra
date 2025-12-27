import 'dart:convert';

RewardOverviewBean rewardOverviewBeanFromJson(String str) =>
    RewardOverviewBean.fromJson(json.decode(str));

String rewardOverviewBeanToJson(RewardOverviewBean data) =>
    json.encode(data.toJson());

class RewardOverviewBean {
  num? weekMaxTotal;
  num? weekTotal;
  num? weekRemainingTotal;
  num? receiveCoins;
  num? receiveCount;
  int? isExistSub;
  List<RewardReceiveItem>? receiveList;

  RewardOverviewBean({
    this.weekMaxTotal,
    this.weekTotal,
    this.weekRemainingTotal,
    this.receiveCoins,
    this.receiveCount,
    this.isExistSub,
    this.receiveList,
  });

  RewardOverviewBean.fromJson(dynamic json) {
    weekMaxTotal = json['week_max_total'];
    weekTotal = json['week_total'];
    weekRemainingTotal = json['week_remaining_total'];
    receiveCoins = json['receive_coins'];
    receiveCount = json['receive_count'];
    isExistSub = json['is_exist_sub'];
    if (json['receive_list'] != null) {
      receiveList = [];
      json['receive_list'].forEach((v) {
        receiveList?.add(RewardReceiveItem.fromJson(v));
      });
    }
  }

  RewardOverviewBean copyWith({
    num? weekMaxTotal,
    num? weekTotal,
    num? weekRemainingTotal,
    num? receiveCoins,
    num? receiveCount,
    int? isExistSub,
    List<RewardReceiveItem>? receiveList,
  }) => RewardOverviewBean(
    weekMaxTotal: weekMaxTotal ?? this.weekMaxTotal,
    weekTotal: weekTotal ?? this.weekTotal,
    weekRemainingTotal: weekRemainingTotal ?? this.weekRemainingTotal,
    receiveCoins: receiveCoins ?? this.receiveCoins,
    receiveCount: receiveCount ?? this.receiveCount,
    isExistSub: isExistSub ?? this.isExistSub,
    receiveList: receiveList ?? this.receiveList,
  );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['week_max_total'] = weekMaxTotal;
    map['week_total'] = weekTotal;
    map['week_remaining_total'] = weekRemainingTotal;
    map['receive_coins'] = receiveCoins;
    map['receive_count'] = receiveCount;
    map['is_exist_sub'] = isExistSub;
    if (receiveList != null) {
      map['receive_list'] = receiveList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class RewardReceiveItem {
  num? id;
  String? title;
  num? weekMaxTotal;
  num? weekTotal;
  num? receiveCoins;
  String? dayText;
  num? weekRemainingTotal;
  num? remainingDiffDay;

  RewardReceiveItem({
    this.id,
    this.title,
    this.weekMaxTotal,
    this.weekTotal,
    this.receiveCoins,
    this.dayText,
    this.weekRemainingTotal,
    this.remainingDiffDay,
  });

  RewardReceiveItem.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    weekMaxTotal = json['week_max_total'];
    weekTotal = json['week_total'];
    receiveCoins = json['receive_coins'];
    dayText = json['day_text'];
    weekRemainingTotal = json['week_remaining_total'];
    remainingDiffDay = json['remaining_diff_day'];
  }

  RewardReceiveItem copyWith({
    num? id,
    String? title,
    num? weekMaxTotal,
    num? weekTotal,
    num? receiveCoins,
    String? dayText,
    num? weekRemainingTotal,
    num? remainingDiffDay,
  }) => RewardReceiveItem(
    id: id ?? this.id,
    title: title ?? this.title,
    weekMaxTotal: weekMaxTotal ?? this.weekMaxTotal,
    weekTotal: weekTotal ?? this.weekTotal,
    receiveCoins: receiveCoins ?? this.receiveCoins,
    dayText: dayText ?? this.dayText,
    weekRemainingTotal: weekRemainingTotal ?? this.weekRemainingTotal,
    remainingDiffDay: remainingDiffDay ?? this.remainingDiffDay,
  );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['week_max_total'] = weekMaxTotal;
    map['week_total'] = weekTotal;
    map['receive_coins'] = receiveCoins;
    map['day_text'] = dayText;
    map['week_remaining_total'] = weekRemainingTotal;
    map['remaining_diff_day'] = remainingDiffDay;
    return map;
  }
}

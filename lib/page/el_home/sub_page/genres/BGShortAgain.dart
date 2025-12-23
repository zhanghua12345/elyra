
import 'package:elyra/bean/TANetworkBean.dart';
import 'package:elyra/widgets/WRegisterLoading.dart';

class QNAElyonGuan {
late bool _hasContentSectionRefresh = false;
late String _tagUtilStr;


  QNAElyonGuan();

  LoadStatusType loadStatus = LoadStatusType.loading;
  List<MEpisodeStoreItem> categoryList = [];
}

class MEpisodeStoreItem {
late int _verticalExternalCollectionsMark = 0;
late String _fromOffset_str;


  int? id;
  String? categoryName;
  List<SEOWidgetBean>? shortPlayList;

  MEpisodeStoreItem({
    this.id,
    this.categoryName,
    this.shortPlayList,
  });

  factory MEpisodeStoreItem.fromJson(Map<String, dynamic> json) {
    return MEpisodeStoreItem(
      id: json['id'],
      categoryName: json['category_name'],
      shortPlayList: json['short_play_list'] != null
          ? (json['short_play_list'] as List)
              .map((item) => SEOWidgetBean.fromJson(item))
              .toList()
          : null,
    );
  }
}

import 'package:elyra/bean/short_video_bean.dart';
import 'package:elyra/widgets/bad_status_widget.dart';

class GenresState {
  GenresState();

  LoadStatusType loadStatus = LoadStatusType.loading;
  List<CategoryItem> categoryList = [];
}

class CategoryItem {
  int? id;
  String? categoryName;
  List<ShortVideoBean>? shortPlayList;

  CategoryItem({
    this.id,
    this.categoryName,
    this.shortPlayList,
  });

  factory CategoryItem.fromJson(Map<String, dynamic> json) {
    return CategoryItem(
      id: json['id'],
      categoryName: json['category_name'],
      shortPlayList: json['short_play_list'] != null
          ? (json['short_play_list'] as List)
              .map((item) => ShortVideoBean.fromJson(item))
              .toList()
          : null,
    );
  }
}

class HotSearchBean {
  final int id;
  final String title;
  final String subTitle;
  final String imageUrl;
  final String type;

  HotSearchBean({
    required this.id,
    required this.title,
    required this.subTitle,
    required this.imageUrl,
    required this.type,
  });

  factory HotSearchBean.fromJson(Map<String, dynamic> json) {
    return HotSearchBean(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      subTitle: json['sub_title'] ?? '',
      imageUrl: json['image_url'] ?? '',
      type: json['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'sub_title': subTitle,
      'image_url': imageUrl,
      'type': type,
    };
  }
}
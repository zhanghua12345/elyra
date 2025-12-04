class HotSearchBean {
  final int id;
  final String name;
  final String description;
  final String imageUrl;
  final String type;

  HotSearchBean({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.type,
  });

  factory HotSearchBean.fromJson(Map<String, dynamic> json) {
    return HotSearchBean(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? '',
      type: json['type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'type': type,
    };
  }
}
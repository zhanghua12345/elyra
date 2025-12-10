import 'package:get/get.dart';

class JumpService {
  /// 跳转到播放页（统一处理 shortPlayId / videoId / imageUrl）
  static void toDetail({
    required dynamic video, // video 对象（可以是 Map 或 Model）
  }) {
    if (video == null) return;

    final shortPlayId = video.shortPlayId ?? video['shortPlayId'];
    final videoId = video.id ?? video['id'] ?? 0;
    final imageUrl = video.imageUrl ?? video['imageUrl'] ?? '';

    // shortPlayId 是强依赖，没有就不跳转
    if (shortPlayId == null || shortPlayId == 0) {
      print('shortPlayId 缺失，无法跳转播放页');
      return;
    }

    Get.toNamed(
      '/play_detail',
      arguments: {
        'shortPlayId': shortPlayId,
        'videoId': videoId,
        'imageUrl': imageUrl,
      },
    );
  }
}

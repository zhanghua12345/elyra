import 'package:get/get.dart';

class JumpService {
  /// 跳转到播放页（统一处理 shortPlayId / videoId / imageUrl）
  static void toDetail({
    required dynamic video, // video 对象（可能是 Map 或 Model）
  }) {
    if (video == null) return;

    // Map 写法：video['xxx']
    // Model 写法：video.xxx
    final videoId = _read(video, 'videoId') ?? _read(video, 'id') ?? 0;
    final imageUrl = _read(video, 'imageUrl') ?? '';
    final shortPlayId = _read(video, 'shortPlayId');

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

  /// 安全读取字段：兼容 Map / Model
  static dynamic _read(dynamic obj, String key) {
    try {
      // ① 如果是 Map
      if (obj is Map) return obj[key];

      // ② 如果是 Model，通过反射式尝试读取属性
      final value = obj?.toJson is Function ? obj.toJson()[key] : null;
      if (value != null) return value;

      // ③ 如果不是 map，也没有 toJson，就尝试用 obj.key（不报错）
      final mirror = obj as dynamic;
      try {
        return mirror == null ? null : mirror[key];
      } catch (_) {}

      return null;
    } catch (_) {
      return null;
    }
  }
}

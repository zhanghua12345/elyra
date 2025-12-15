import 'package:elyra/extend/el_string.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// 统一的网络图片组件
/// 
/// 功能：
/// - 加载中显示 no-img.png
/// - 加载失败显示 err-img.png
/// - 使用 BoxFit.cover（短边铺满，长边裁切）
/// 
/// 使用示例：
/// ```dart
/// ElNetworkImage(
///   imageUrl: 'https://example.com/image.jpg',
///   width: 100.w,
///   height: 100.h,
/// )
/// ```
class ElNetworkImage extends StatelessWidget {
  /// 图片URL
  final String? imageUrl;
  
  /// 图片宽度
  final double? width;
  
  /// 图片高度
  final double? height;
  
  /// 图片适配方式，默认 BoxFit.cover（短边铺满，长边裁切）
  final BoxFit fit;
  
  /// 圆角半径（可选）
  final BorderRadius? borderRadius;

  const ElNetworkImage({
    Key? key,
    this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageWidget = CachedNetworkImage(
      imageUrl: imageUrl ?? '',
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => Image.asset(
        'no-img.png'.icon,
        width: width,
        height: height,
        fit: fit,
      ),
      errorWidget: (context, url, error) => Image.asset(
        'err-img.png'.icon,
        width: width,
        height: height,
        fit: fit,
      ),
    );

    // 如果有圆角，使用 ClipRRect 包裹
    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}

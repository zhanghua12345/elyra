import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// 基于fluttertoast的封装组件
class Message {
  /// 显示Toast
  static Future<bool?> show(
    String message, {
    ToastGravity gravity = ToastGravity.CENTER,
    Color backgroundColor = Colors.black87,
    Duration duration = const Duration(seconds: 2),
    double fontSize = 16.0,
    TextAlign textAlign = TextAlign.center,
    bool dismissOtherToast = true,
    double? width,
    double? height,
    Color textColor = Colors.white,
  }) async {
    // 转换持续时间
    final toastLength = duration.inSeconds > 3 ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT;

    // 如果需要关闭其他toast
    if (dismissOtherToast) {
      await Fluttertoast.cancel();
    }

    // 显示Toast
    return Fluttertoast.showToast(
      msg: message,
      toastLength: toastLength,
      gravity: gravity,
      timeInSecForIosWeb: duration.inSeconds,
      textColor: textColor,
      fontSize: fontSize,
      backgroundColor: backgroundColor,
    );
  }

  /// 关闭当前Toast
  static Future<bool?> dismiss() async {
    return Fluttertoast.cancel();
  }
}

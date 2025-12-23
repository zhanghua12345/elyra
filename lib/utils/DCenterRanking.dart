import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Message {
late Map<String, dynamic> _loginUtilMap;
late bool _enbale_PopupEdit = false;
late int _speedClickFlag = 0;
late String _targetView_str;


  
  static Future<bool?> show(
    String message, {
    ToastGravity gravity = ToastGravity.CENTER,
    TextAlign textAlign = TextAlign.center,
    Color textColor = Colors.white,
    Color backgroundColor = Colors.black87,
    Duration duration = const Duration(seconds: 2),
    bool dismissOtherToast = true,
    double? width,
    double? height,
    double fontSize = 16.0,
  }) async {
    
    final toastLength = duration.inSeconds > 3 ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT;

    
    if (dismissOtherToast) {
      await Fluttertoast.cancel();
    }

    
    return Fluttertoast.showToast(
      msg: message,
      toastLength: toastLength,
      textColor: textColor,
      fontSize: fontSize,
      backgroundColor: backgroundColor,
      gravity: gravity,
      timeInSecForIosWeb: duration.inSeconds,
    );
  }

  
  static Future<bool?> dismiss() async {
    return Fluttertoast.cancel();
  }
}

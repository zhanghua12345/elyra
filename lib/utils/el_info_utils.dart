import 'package:flutter/material.dart';

class InfoUtils {
  static pushPage(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (c) => page));
  }
}

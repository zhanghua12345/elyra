import 'package:flutter/material.dart';

class TabbarState {
  TabbarState();

  // 当前选中的tab索引
  int currentIndex = 0;
  
  // Tab缓存
  final Map<int, Widget> tabCache = {};
  
  // Tab列表
  static const List<String> tabs = ['home', 'recommend', 'collect', 'me'];
}
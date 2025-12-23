import 'dart:io';

import 'package:elyra/page/el_tabbar/state.dart';
import 'package:elyra/page/el_home/page.dart';
import 'package:elyra/page/el_recommend/page.dart';
import 'package:elyra/page/el_collect/page.dart';
import 'package:elyra/page/el_me/page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

class TabbarPageController extends GetxController {
  final state = TabbarState();
  late PageController pageController;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
  }

  @override
  void onReady() {
    super.onReady();
    if (Platform.isIOS) {
      // 刷新苹果收据
      SKRequestMaker().startRefreshReceiptRequest();
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  // 只在需要时构建tab页面
  Widget getTab(int index) {
    if (state.tabCache.containsKey(index)) return state.tabCache[index]!;
    late Widget tab;
    switch (index) {
      case 0:
        tab = const HomePage();
        break;
      case 1:
        tab = const RecommendPage();
        break;
      case 2:
        tab = const CollectPage();
        break;
      case 3:
        tab = const MePage();
        break;
      default:
        tab = const SizedBox();
    }
    state.tabCache[index] = tab;
    return tab;
  }

  // 切换Tab
  void onTabTapped(int index) {
    state.currentIndex = index;
    pageController.jumpToPage(index);
    update();
  }

  // 页面切换回调
  void onPageChanged(int index) {
    state.currentIndex = index;
    update();
  }
}

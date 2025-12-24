import 'dart:io';

import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/el_tabbar/state.dart';
import 'package:elyra/page/el_home/page.dart';
import 'package:elyra/page/el_recommend/page.dart';
import 'package:elyra/page/el_collect/page.dart';
import 'package:elyra/page/el_me/page.dart';
import 'package:elyra/utils/ely_notify.dart';
import 'package:elyra/utils/version_utils.dart';
import 'package:elyra/widgets/el_confirm_modal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

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

    Future.delayed(const Duration(milliseconds: 500)).then((_) {
      _checkNotifyPermission();
      // 这个就是暂时不在这里谈
      // checkVersionUpgrade();
    });
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

  // 检查通知权限
  Future<void> _checkNotifyPermission() async {
    PermissionStatus permissionStatus = await Permission.notification.status;
    // 如果权限没给
    if (!permissionStatus.isGranted &&
        ElyNotifyUtils.instance.getPermissionStatus()) {
      showPermissionDialog();
    } else {
      // 在权限弹窗之后弹出
      checkVersionUpgrade();
    }
  }

  //权限弹窗
  showPermissionDialog() {
    // 获取当前 context
    final context = Get.context;
    if (context == null) return;
    
    showElConfirmModal(
      context,
      image: AssetImage('el_model_open_notify.png'.icon),
      title: 'Enable Notifications',
      child: Text(
        'Stay informed with popular\nrecommendations and latest updates!',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontFamily: 'PingFang SC',
          fontWeight: FontWeight.w400,
          height: 1.50,
          letterSpacing: -0.01,
        ),
      ),
      cancelText: 'Later',
      confirmText: 'Open',
      onCancel: () {
        Navigator.of(context).pop();
        // 在权限弹窗之后弹出
        checkVersionUpgrade();
      },
      onConfirm: () async {
        Navigator.of(context).pop();

        // SpFirebaseService.openNotificationPermission();
        // 在权限弹窗之后弹出
        checkVersionUpgrade();
      },
    );
  }

  // 检查版本更新
  Future<void> checkVersionUpgrade() async {
    try {
      final versionData = await versionUtils.instance.checkAppVersion();
      if (versionData['status']) {
        final bool force = versionData['force'] ?? false;

        showCheckVersionDialog(force);
      }
    } catch (e) {
      print('Error in version check: $e');
    }
  }

  // 版本升级弹窗
  showCheckVersionDialog(isForce) {
    // 获取当前 context
    final context = Get.context;
    if (context == null) return;
    
    showElConfirmModal(
      context,
      image: AssetImage('el_model_check_version.png.png'.icon),
      title: 'Discover A New Version',
      child: Text(
        'Stay informed with popular\nrecommendations and latest updates!',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontFamily: 'PingFang SC',
          fontWeight: FontWeight.w400,
          height: 1.50,
          letterSpacing: -0.01,
        ),
      ),
      cancelText: 'Later',
      confirmText: 'Open',
      onCancel: () {
        if (!isForce) {
          Navigator.of(context).pop();
        }
        if (Platform.isAndroid) {
          launchURL(
            "https://play.google.com/store/apps/details?id=com.sanpplay.wzkmrf.app",
          );
        } else if (Platform.isIOS) {
          launchURL('https://apps.apple.com/us/app/sanpplay/id6756033969');
        }
      },
      onConfirm: () async {
        Navigator.of(context).pop();
        if (Platform.isAndroid) {
          launchURL(
            "https://play.google.com/store/apps/details?id=com.sanpplay.wzkmrf.app",
          );
        } else if (Platform.isIOS) {
          launchURL('https://apps.apple.com/us/app/sanpplay/id6756033969');
        }
      },
    );
  }

  static void launchURL(String url) async {
    final encodedUrl = Uri.encodeFull(url);
    try {
      final bool launched = await launchUrl(
        Uri.parse(encodedUrl),
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        print('can not open: $encodedUrl');
      }
    } catch (e) {
      print('url error: $e');
    }
  }
}

import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/el_tabbar/controller.dart';
import 'package:elyra/page/el_tabbar/state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TabbarPage extends StatefulWidget {
  const TabbarPage({super.key});

  @override
  State<TabbarPage> createState() => _TabbarPageState();
}

class _TabbarPageState extends State<TabbarPage> {
  late final TabbarPageController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(TabbarPageController());
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TabbarPageController>(
      builder: (controller) {
        return PopScope(
          canPop: false,
          child: Scaffold(
            body: PageView.builder(
              controller: controller.pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: controller.onPageChanged,
              itemBuilder: (context, index) => controller.getTab(index),
              itemCount: TabbarState.tabs.length,
            ),
            bottomNavigationBar: BottomNavigationBar(
              selectedFontSize: 10.sp,
              unselectedFontSize: 10.sp,
              backgroundColor: const Color(0xFF260E55),
              selectedItemColor: const Color(0xFFFF0BBA),
              unselectedItemColor: const Color(0xFF777777),
              type: BottomNavigationBarType.fixed,
              currentIndex: controller.state.currentIndex,
              onTap: controller.onTabTapped,
              items: TabbarState.tabs
                  .map(
                    (item) => BottomNavigationBarItem(
                      icon: Container(
                        margin: EdgeInsets.only(top: 2.w),
                        alignment: Alignment.center,
                        child: Image.asset('el_$item.png'.icon, width: 36.w),
                      ),
                      activeIcon: Container(
                        margin: EdgeInsets.only(top: 2.w),
                        child: Image.asset(
                          'el_${item}_active.png'.icon,
                          width: 36.w,
                        ),
                      ),
                      label: item,
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      },
    );
  }
}

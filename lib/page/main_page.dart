import 'package:elyra/extend/el_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:elyra/page/el_home/page.dart';
import 'package:elyra/page/el_recommend/page.dart';
import 'package:elyra/page/el_collect/page.dart';
import 'package:elyra/page/el_me/page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with RouteAware, WidgetsBindingObserver {
  final PageController _elController = PageController();
  static const List<String> _elTabs = ['home', 'recommend', 'collect', 'me'];

  int _elCurrentIndex = 0;

  // 只在需要时构建tab页面
  final Map<int, Widget> _tabCache = {};

  Widget _getTab(int index) {
    if (_tabCache.containsKey(index)) return _tabCache[index]!;
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
    _tabCache[index] = tab;
    return tab;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: PageView.builder(
          controller: _elController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            _elCurrentIndex = index;
            setState(() {});
          },
          itemBuilder: (context, index) => _getTab(index),
          itemCount: _elTabs.length,
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedFontSize: 10.sp,
          unselectedFontSize: 10.sp,
          backgroundColor: const Color(
            0xFF260E55,
          ), // Set background color to #260E55
          selectedItemColor: const Color(
            0xFFFF0BBA,
          ), // Set selected text color to #FF0BBA
          unselectedItemColor: const Color(0xFF777777),
          type: BottomNavigationBarType.fixed,
          currentIndex: _elCurrentIndex,
          onTap: (index) {
            _elCurrentIndex = index;
            _elController.jumpToPage(index);
          },
          items: [
            ..._elTabs.map(
              (item) => BottomNavigationBarItem(
                icon: Container(
                  margin: EdgeInsets.only(top: 2.w),
                  alignment: Alignment.center,
                  child: Image.asset('el_${item}.png'.icon, width: 36.w),
                ),
                activeIcon: Container(
                  margin: EdgeInsets.only(top: 2.w),
                  child: Image.asset('el_${item}_active.png'.icon, width: 36.w),
                ),
                label: item,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

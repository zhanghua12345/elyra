import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/el_home/controller.dart';
import 'package:elyra/page/el_home/sub_page/genres/page.dart';
import 'package:elyra/page/el_home/sub_page/new/page.dart';
import 'package:elyra/page/el_home/sub_page/popular/page.dart';
import 'package:elyra/page/el_home/sub_page/ranking/page.dart';
import 'package:elyra/page/el_popup/recharge_coins_pack.dart';
import 'package:elyra/page/el_popup/recharge_coins_pack_again.dart';
import 'package:elyra/page/el_store/controller.dart';
import 'package:elyra/bean/pay_settings_bean.dart';
import 'package:elyra/widgets/home_video_history_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:visibility_detector/visibility_detector.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final logic = Get.put(HomeController());
  final state = Get.find<HomeController>().state;

  final List<String> tabs = ["Popular", "Rankings", "Genres", "New"];

  int _currentTab = 0; // tab index: Popular / Rankings...

  final PageController _controller = PageController();
  late TabController _tabController;

  // 用于强制刷新历史记录组件的Key
  final GlobalKey<_HomeVideoHistoryWidgetRefreshState> _historyWidgetKey =
      GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      _currentTab = _tabController.index;
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tabController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // 当应用从后台返回前台时，刷新历史记录
    if (state == AppLifecycleState.resumed) {
      _historyWidgetKey.currentState?.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('home-page-visibility'),
      onVisibilityChanged: (VisibilityInfo info) {
        // 当页面可见度大于50%时，刷新历史记录
        if (info.visibleFraction > 0.5) {
          Future.delayed(Duration(milliseconds: 100), () {
            _historyWidgetKey.currentState?.refresh();
          });
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            // 全屏背景图
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('ely_background_image.png'.icon),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),

            // 页面内容
            // 页面内容
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 7.h + ScreenUtil().statusBarHeight,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 顶部整体 block（左右 16.w）
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 顶部 Logo + 搜索
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                'ely_home_logo.png'.icon,
                                height: 22.h,
                              ),
                              Row(
                                children: [
                                  // 🔥 模拟按钮：点击显示充值金币包弹窗
                                  GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () {
                                      // 模拟 PayItem 数据
                                      final mockItem = PayItem(
                                        id: 1,
                                        buyType: 'sub_coins',
                                        coins: 2000,
                                        sendCoins: 2800,
                                        sendCoinTtl: 7,
                                        price: '19.99',
                                        priceLocal: '19.99',
                                        iosTemplateId: 'test_ios',
                                        vipType: 'week',
                                        shortType: '',
                                        description: 'Weekly coin pack',
                                        sort: 1,
                                      );
                                      RechargeCoinsPackAgainPopup.show(mockItem);
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(5.w),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.w,
                                          vertical: 4.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.orange,
                                          borderRadius: BorderRadius.circular(4.r),
                                        ),
                                        child: Text(
                                          'Test',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () {
                                      Get.toNamed('/search');
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(5.w), // 扩大点击热区
                                      child: Image.asset(
                                        'ely_search.png'.icon,
                                        height: 30.h,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          SizedBox(height: 17.h),

                          // Tabs 区域
                          Container(
                            width: 343.w,
                            height: 43.h,
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('ely_home_tabs.png'.icon),
                                fit: BoxFit.fill,
                              ),
                            ),
                            child: Row(
                              children: List.generate(
                                tabs.length,
                                (index) => Expanded(
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () {
                                      setState(() => _currentTab = index);

                                      _controller.jumpToPage(index);

                                      _controller.animateToPage(
                                        index,
                                        duration: const Duration(
                                          milliseconds: 80,
                                        ),
                                        curve: Curves.easeOut,
                                      );
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 8.h,
                                      ),
                                      decoration: _currentTab == index
                                          ? BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(
                                                  'ely_home_tabs_active_bg.png'
                                                      .icon,
                                                ),
                                                fit: BoxFit.fill,
                                              ),
                                            )
                                          : null,
                                      child: Text(
                                        tabs[index],
                                        style: TextStyle(
                                          color: _currentTab == index
                                              ? Colors.white
                                              : Colors.white.withOpacity(0.6),
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w900,
                                          fontFamily: 'DDinPro',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// Tabs 底部间距 6.h
                    SizedBox(height: 8.h),

                    // 这里放 Tab 内容
                    Expanded(
                      child: Stack(
                        children: [
                          PageView(
                            controller: _controller,
                            physics: const ClampingScrollPhysics(),
                            onPageChanged: (index) {
                              _currentTab = index;
                              setState(() {});
                            },
                            children: const [
                              PopularPage(),
                              RankingPage(),
                              GenresPage(),
                              NewPage(),
                            ],
                          ),

                          // 历史记录组件 - 距离底部10.h,居中
                          Positioned(
                            bottom: 12.h,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: _HomeVideoHistoryWidgetRefresh(
                                key: _historyWidgetKey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 历史记录组件包装器，支持外部手动刷新
class _HomeVideoHistoryWidgetRefresh extends StatefulWidget {
  const _HomeVideoHistoryWidgetRefresh({Key? key}) : super(key: key);

  @override
  State<_HomeVideoHistoryWidgetRefresh> createState() =>
      _HomeVideoHistoryWidgetRefreshState();
}

class _HomeVideoHistoryWidgetRefreshState
    extends State<_HomeVideoHistoryWidgetRefresh> {
  Key _widgetKey = UniqueKey();

  /// 外部调用此方法来刷新组件
  void refresh() {
    setState(() {
      _widgetKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return HomeVideoHistoryWidget(key: _widgetKey);
  }
}

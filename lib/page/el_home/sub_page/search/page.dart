import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/el_home/sub_page/search/controller.dart';
import 'package:elyra/page/el_home/sub_page/search/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:card_swiper/card_swiper.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final logic = Get.put(SearchPageController());
  final state = Get.find<SearchPageController>().state;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

class _VampirePageState extends State<VampirePage> {
  final controller = Get.put(VampireController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VampireController>(
      builder: (controller) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          body: Container(
            padding: EdgeInsets.only(top: ScreenUtil().statusBarHeight),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('ely_background_image.png'.icon),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // 内容区域
              children: [
                _buildAppBar(context),
                SizedBox(height: 10.h),
                Expanded(
                  child: SmartRefresher(
                    controller: controller.refreshController,
                    enablePullDown: true,
                    enablePullUp: true,
                    onRefresh: controller.onRefresh,
                    onLoading: controller.onLoadMore,
                    header: ClassicHeader(
                      textStyle: TextStyle(color: Colors.white),
                      idleText: 'Pull to refresh',
                      releaseText: 'Release to refresh',
                      refreshingText: 'Refreshing...',
                      completeText: 'Refresh completed',
                      failedText: 'Refresh failed',
                    ),
                    footer: ClassicFooter(
                      textStyle: TextStyle(color: Colors.white),
                      idleText: 'Pull up to load more',
                      loadingText: 'Loading...',
                      noDataText: 'No more data',
                      failedText: 'Load failed, tap to retry',
                    ),
                    child: _buildContent(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Image.asset('ely_back.png'.icon, height: 20.h),
          ),
          // 右侧可以放置其他操作按钮，暂时留空
          
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (controller.state.loadStatus == LoadStatusType.loading) {
      return Center(child: CircularProgressIndicator(color: Color(0xFFFF6B00)));
    }

    if (controller.state.loadStatus == LoadStatusType.loadFailed) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64.sp, color: Colors.white54),
            SizedBox(height: 16.h),
            Text(
              'Load Failed',
              style: TextStyle(color: Colors.white54, fontSize: 16.sp),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: controller.onRefresh,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF6B00),
              ),
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (controller.state.loadStatus == LoadStatusType.loadNoData) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 64.sp, color: Colors.white54),
            SizedBox(height: 16.h),
            Text(
              'No Data',
              style: TextStyle(color: Colors.white54, fontSize: 16.sp),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20.h),
          _buildStaggeredGrid(),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildStaggeredGrid() {
    return Container(
      // 内容区（正常瀑布流）
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 64.sp, color: Colors.white54),
            SizedBox(height: 16.h),
            Text(
              'Info',
              style: TextStyle(color: Colors.white54, fontSize: 16.sp),
            ),
          ],
        ),
    );
  }

}

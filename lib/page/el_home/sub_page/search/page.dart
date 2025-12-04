import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/el_home/sub_page/search/controller.dart';
import 'package:elyra/widgets/bad_status_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:elyra/bean/hot_search_bean.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final SearchPageController controller;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = Get.put(SearchPageController());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchPageController>(
      builder: (controller) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('ely_background_image.png'.icon),
                fit: BoxFit.fill,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  _buildSearchAppBar(),
                  Expanded(
                    child: SmartRefresher(
                      controller: controller.refreshController,
                      enablePullDown: true,
                      enablePullUp: false,
                      onRefresh: controller.onRefresh,
                      header: ClassicHeader(
                        textStyle: TextStyle(color: Colors.white),
                        idleText: 'Pull to refresh',
                        releaseText: 'Release to refresh',
                        refreshingText: 'Refreshing...',
                        completeText: 'Refresh completed',
                        failedText: 'Refresh failed',
                      ),
                      child: _buildContent(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchAppBar() {
    return Container(
      height: 44.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Image.asset('ely_back.png'.icon, height: 20.h),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: _buildSearchBox(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      width: 308.w,
      height: 32.h,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white.withValues(alpha: 0.20),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1.w,
            strokeAlign: BorderSide.strokeAlignOutside,
            color: const Color(0xFFE424AD),
          ),
          borderRadius: BorderRadius.circular(39.r),
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 12.w, right: 8.w),
            child: Image.asset('ely_search_icon.png'.icon, width: 16.w, height: 16.h),
          ),
          Expanded(
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: Colors.white, fontSize: 14.sp),
              decoration: InputDecoration(
                hintText: 'This Life as Dad',
                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 14.sp),
                border: InputBorder.none,
              ),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  controller.saveSearchHistory(value.trim());
                  // TODO: 执行搜索逻辑
                }
              },
            ),
          ),
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

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 历史搜索记录
          controller.state.showSearchHistory ? _buildHistorySection() : Container(),
          
          // 热门搜索轮播图
          _buildHotSearchSection(),
        ],
      ),
    );
  }

  Widget _buildHistorySection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      margin: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Historical search',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: controller.clearSearchHistory,
                child: Image.asset('ely_del.png'.icon, width: 20.w, height: 20.h),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: List.generate(
              controller.state.searchHistoryList.length,
              (index) => Container(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Color(0xFF5116C1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  controller.state.searchHistoryList[index],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHotSearchSection() {
    if (controller.state.hotSearchList.isEmpty) {
      return Container();
    }
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hot search',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15.h),
          SizedBox(
            height: 150.h,
            child: Swiper(
              itemCount: controller.state.hotSearchList.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildSwiperItem(controller.state.hotSearchList[index]);
              },
              pagination: SwiperPagination(
                builder: DotSwiperPaginationBuilder(
                  color: Colors.white38,
                  activeColor: Color(0xFFFF6B00),
                  size: 8.w,
                  activeSize: 10.w,
                ),
              ),
              autoplay: true,
              autoplayDelay: 5000,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwiperItem(HotSearchBean item) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      child: Stack(
        children: [
          // 背景卡片
          Container(
            height: 130.h,
            decoration: BoxDecoration(
              color: Color(0xFF5116C1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              children: [
                // 左侧文字内容
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.all(15.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item.type,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12.sp,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          item.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          item.subTitle,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // 右侧图片区域
                Expanded(
                  flex: 1,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // 第二张图片（底层，旋转30度）
                      Transform.rotate(
                        angle: 30 * 3.14159 / 180, // 30度转换为弧度
                        child: Container(
                          width: 95.w,
                          height: 118.h,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(item.imageUrl),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                      ),
                      // 第一张图片（顶层，旋转5度）
                      Transform.rotate(
                        angle: 5 * 3.14159 / 180, // 5度转换为弧度
                        child: Container(
                          width: 95.w,
                          height: 118.h,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(item.imageUrl),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
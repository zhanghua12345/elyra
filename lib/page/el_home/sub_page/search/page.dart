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

  @override
  Widget build(BuildContext context) {
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
              // AppBar
              _buildAppBar(),
              
              // 搜索框
              _buildSearchBox(),
              
              // 内容区域
              Expanded(
                child: _buildContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      height: 44.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.w),
            onPressed: () => Get.back(),
          ),
          Expanded(
            child: Container(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      height: 40.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      margin: EdgeInsets.only(bottom: 20.h),
      child: TextField(
        controller: _searchController,
        style: TextStyle(color: Colors.white, fontSize: 16.sp),
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xFF2D0A5C),
          hintText: 'Search',
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.r),
            borderSide: BorderSide.none,
          ),
          prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.5)),
          contentPadding: EdgeInsets.symmetric(vertical: 10.h),
        ),
        onSubmitted: (value) {
          if (value.trim().isNotEmpty) {
            logic.saveSearchHistory(value.trim());
            // TODO: 执行搜索逻辑
          }
        },
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 历史搜索
          Obx(() => state.showHistory ? _buildHistorySection() : Container()),
          
          // 热门搜索轮播图
          Obx(() => state.showHotSearch ? _buildHotSearchSection() : Container()),
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
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: logic.clearHistory,
                child: Text(
                  'Clear',
                  style: TextStyle(
                    color: Color(0xFFFF6B00),
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: List.generate(
              state.historyList.length,
              (index) => Container(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Color(0xFF5116C1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  state.historyList[index],
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hot search',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15.h),
          SizedBox(
            height: 150.h,
            child: Swiper(
              itemCount: state.hotList.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildSwiperItem(state.hotList[index]);
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

  Widget _buildSwiperItem(HotSearchItem item) {
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
                          item.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          item.subtitle,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
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
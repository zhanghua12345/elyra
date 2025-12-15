import 'package:elyra/bean/short_video_bean.dart';
import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/el_home/sub_page/search/controller.dart';
import 'package:elyra/utils/jump_detail.dart';
import 'package:elyra/widgets/bad_status_widget.dart';
import 'package:elyra/widgets/el_confirm_modal.dart';
import 'package:elyra/widgets/el_nodata_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:card_swiper/card_swiper.dart';

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
                        height: 40,
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
      height: 46.h,
      padding: EdgeInsets.only(left: 11.w,right: 16.w, top:2.h),
      child: Row(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => Get.back(),
            child: Padding(
              padding: EdgeInsets.all(5.w), // 扩大点击热区
              child: Image.asset('ely_back.png'.icon, height: 20.h),
            ),
          ),
          SizedBox(width: 5.w),
          Expanded(child: _buildSearchBox()),
        ],
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      width: 308.w,
      height: 32.h,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('ely_search_title_bg.png'.icon),
          fit: BoxFit.fill,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 18.w, right: 12.w),
            child: Image.asset(
              'ely_search_icon.png'.icon,
              width: 20.w,
              height: 20.h,
            ),
          ),
          Expanded(
            child: TextField(
              controller: _searchController,
              style: TextStyle(color: Colors.white, fontSize: 12.sp),
              decoration: InputDecoration(
                isCollapsed: true, // 关键！去掉默认内部 padding
                contentPadding: EdgeInsets.zero, // 关键！强制内容贴合父布局
                hintText: 'This Life as Dad',
                hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.50),
                  fontSize: 12,
                  fontFamily: 'PingFang SC',
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
              ),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  controller.saveSearchHistory(value.trim());
                  // 跳转到搜索结果页面
                  Get.toNamed(
                    '/search_result',
                    arguments: {'search': value.trim()},
                  );
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
      return Center(
        child: Image.asset('loading.gif'.icon, width: 120, height: 120),
      );
    }

    if (controller.state.loadStatus == LoadStatusType.loadFailed) {
      return ElNoDataWidget(
        imagePath: 'ely_error.png',
        title: 'No connection',
        description: 'Please check your network',
        buttonText: 'Try again',
        onButtonPressed: controller.onRefresh,
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 历史搜索记录
          controller.state.showSearchHistory
              ? _buildHistorySection()
              : Container(),

          // 热门搜索轮播图
          _buildHotSearchSection(),
        ],
      ),
    );
  }

  Widget _buildHistorySection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      margin: EdgeInsets.only(top: 26.h),
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
                  fontSize: 14,
                  fontFamily: 'PingFang SC',
                  fontWeight: FontWeight.w500,
                  height: 1.21,
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => {
                  showElConfirmModal(
                    context,
                    image: AssetImage('ely_delete_info.png'.icon),
                    imageOffset: 96,
                    imageWidth: 72,
                    moduleWidth: 304,
                    moduleHeight: 277,
                    titleOffset: 121,
                    title: 'Clear historical search',
                    child: Text(
                      'Confirm clear search history',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'PingFang SC',
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                      ),
                    ),
                    cancelText: '',
                    confirmText: 'Confirm',
                    onCancel: () {
                      Navigator.of(context).pop();
                    },
                    onConfirm: () async {
                      Navigator.of(context).pop();
                      controller.clearSearchHistory();
                    },
                  ),
                },

                child: Image.asset(
                  'ely_del.png'.icon,
                  width: 20.w,
                  height: 20.h,
                ),
              ),
            ],
          ),
          SizedBox(height: 18.h),
          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            children: List.generate(
              controller.state.searchHistoryList.length,
              (index) => GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  final keyword = controller.state.searchHistoryList[index];
                  // ← 这里写跳转逻辑
                  controller.saveSearchHistory(keyword.trim());
                  // 跳转到搜索结果页面
                  Get.toNamed(
                    '/search_result',
                    arguments: {'search': keyword.trim()},
                  );
                },
                child: IntrinsicWidth(
                  child: Container(
                    height: 24.h,
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    constraints: BoxConstraints(minWidth: 0), // 关键！
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Center(
                      // 垂直居中
                      child: Text(
                        controller.state.searchHistoryList[index],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontFamily: 'PingFang SC',
                          fontWeight: FontWeight.w400,
                          height: 1,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
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
      margin: EdgeInsets.only(top: 27.h),
      child: SizedBox(
        height: 140.h,
        child: Swiper(
          itemCount: controller.state.hotSearchList.length,
          itemBuilder: (BuildContext context, int index) {
            return _buildSwiperItem(controller.state.hotSearchList[index]);
          },

          // ✅ Swiper 小点样式（你要求的）
          pagination: SwiperPagination(
            margin: EdgeInsets.only(bottom: 5.h),
            builder: DotSwiperPaginationBuilder(
              color: Colors.white.withValues(alpha: 0.60), // 未激活
              activeColor: Colors.white, // 激活
              size: 4.w, // 正常大小
              activeSize: 4.w, // 激活同样大小
            ),
          ),
          autoplay: true,
          autoplayDelay: 5000,
        ),
      ),
    );
  }

  Widget _buildSwiperItem(ShortVideoBean item) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => JumpService.toDetail(
        video: {
          'shortPlayId': item.shortPlayId,
          'videoId': item.shortPlayVideoId ?? 0,
          'imageUrl': item.imageUrl ?? '',
        },
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.w),
        child: Stack(
          children: [
            // ⭐ 背景卡片吸底（你要求的）
            Positioned(
              left: 0,
              right: 0,
              bottom: 0, // 吸底
              child: Container(
                height: 106.h,

                // ⭐ 使用你提供的背景渐变
                decoration: ShapeDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(0.5, 0.0),
                    end: Alignment(0.5, 1.0),
                    colors: [Color(0xFF6018E6), Color(0xFFDC23B1)],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                ),

                child: Row(
                  children: [
                    // 左侧文字
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 8.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              item.name ?? '',
                              maxLines: 1, // 限制最多两行
                              overflow: TextOverflow.ellipsis, // 超出用省略号
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'PingFang SC',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              item.description ?? '',
                              maxLines: 2, // 限制最多两行
                              overflow: TextOverflow.ellipsis, // 超出用省略号
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'PingFang SC',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 20.w), // 右侧间距
                    // 右侧两张旋转图
                    Expanded(
                      flex: 1,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // 第二张底图（角度更大）
                          Positioned(
                            bottom: 20.h, // 距离底部
                            right: 0, // 贴右边
                            child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..translate(0.0, 4.h) // 下移 4.h（两图高度差）
                                ..rotateZ(0.26), // 旋转角度
                              child: Container(
                                width: 90.w,
                                height: 107.h,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2.r,
                                  ),
                                  borderRadius: BorderRadius.circular(13.r),
                                  image: DecorationImage(
                                    image: NetworkImage(item.imageUrl ?? ''),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // 第一张前景图（角度小一些）
                          Positioned(
                            bottom: 14.h,
                            right: 16.w, // 贴右边
                            child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()..rotateZ(0.12),
                              child: Container(
                                width: 95.w,
                                height: 118.h,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2.r,
                                  ),
                                  borderRadius: BorderRadius.circular(13.r),
                                  image: DecorationImage(
                                    image: NetworkImage(item.imageUrl ?? ''),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 34.w), // 右侧间距
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

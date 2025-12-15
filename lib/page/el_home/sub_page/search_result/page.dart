import 'package:elyra/bean/short_video_bean.dart';
import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/el_home/sub_page/search_result/controller.dart';
import 'package:elyra/utils/jump_detail.dart';
import 'package:elyra/widgets/bad_status_widget.dart';
import 'package:elyra/widgets/el_network_image.dart';
import 'package:elyra/widgets/el_nodata_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SearchResultPage extends StatefulWidget {
  const SearchResultPage({super.key});

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  late final SearchResultPageController controller;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = Get.put(SearchResultPageController());

    // 初始化搜索框的值
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _searchController.text = controller.state.searchKeyword;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchResultPageController>(
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
                  _buildAppBar(),
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

  Widget _buildAppBar() {
    return Container(
      height: 46.h,
      padding: EdgeInsets.only(left: 11.w, right: 16.w, top: 2.h),
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
                  controller.searchWithNewKeyword(value.trim());
                  // 更新输入框显示
                  _searchController.text = value.trim();
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

    if (controller.state.loadStatus == LoadStatusType.loadNoData) {
      return ElNoDataWidget(
        imagePath: 'ely_nodata.png',
        imageWidth: 180,
        imageHeight: 223,
        title: null,
        description: 'There is no data for the moment.',
        buttonText: null,
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: MasonryGridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 7.h,
          crossAxisSpacing: 7.w,
          padding: EdgeInsets.zero,
          itemCount: controller.state.searchResultList.length,
          itemBuilder: (context, index) {
            final item = controller.state.searchResultList[index];
            final height = 266.h;

            return _buildCollectionCard(item, double.infinity, height);
          },
        ),
      ),
    );
  }

  /// Collections 单个卡片
  /// - 背景色：#5116C1（紫色）
  /// - 圆角：32
  /// - 上部：图片（Expanded 自适应高度）
  /// - 下部：标题（两行居中）
  Widget _buildCollectionCard(
    ShortVideoBean item,
    double width,
    double height,
  ) {
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
        width: width, // 卡片宽度（动态计算）
        height: height, // 卡片高度（131 或 266）
        decoration: BoxDecoration(
          color: Color(0xFF5116C1),
          borderRadius: BorderRadius.circular(32.r), // 圆角 32
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32.r),
          child: Column(
            children: [
              // 上部：图片区域（自适应高度）
              ElNetworkImage(
                imageUrl: item.imageUrl,
                width: double.infinity,
                height: 224.h, // 固
                borderRadius: BorderRadius.circular(32.r),
              ),
              // 下部：标题区域
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 5.h),
                  width: 94,
                  height: double.infinity,
                  child: Text(
                    item.name ?? '',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'PingFang SC',
                      fontWeight: FontWeight.w500,
                      height: 1.14,
                    ),
                    maxLines: 2, // 最多两行
                    overflow: TextOverflow.ellipsis, // 超出显示省略号
                    textAlign: TextAlign.center, // 文本居中（单行和多行都居中）
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:elyra/bean/short_video_bean.dart';
import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/el_home/sub_page/vampire/controller.dart';
import 'package:elyra/widgets/bad_status_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class VampirePage extends StatefulWidget {
  const VampirePage({super.key});

  @override
  State<VampirePage> createState() => _VampirePageState();
}

class _VampirePageState extends State<VampirePage> {
  final controller = Get.put(VampireController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VampireController>(
      builder: (controller) {
        return Scaffold(
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
              Positioned.fill(
                child: Column(
                  children: [
                    // 顶部AppBar区域
                    Container(
                      padding: EdgeInsets.only(
                        top: ScreenUtil().statusBarHeight,
                        bottom: 10.h,
                      ),
                      child: AppBar(
                        title: Text(
                          controller.state.categoryTitle,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        centerTitle: true,
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        leading: IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Get.back(),
                        ),
                      ),
                    ),
                    
                    // 内容区域
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
            ],
          ),
        );
      },
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
          SizedBox(height: 40.h),
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
          itemCount: controller.state.vampireList.length,
          itemBuilder: (context, index) {
            final item = controller.state.vampireList[index];
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
      onTap: () {
        // TODO: 导航到详情页
        // Get.toNamed('/detail', arguments: {'id': item.shortPlayId});
      },
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
              ClipRRect(
                borderRadius: BorderRadius.circular(32.r),
                child: Image.network(
                  item.imageUrl ?? '',
                  width: double.infinity,
                  height: 224.h, // 固定高度
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[800],
                    child: Icon(Icons.error, color: Colors.white54),
                  ),
                ),
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
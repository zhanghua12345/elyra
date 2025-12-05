import 'package:elyra/bean/short_video_bean.dart';
import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/el_collect/controller.dart';
import 'package:elyra/widgets/bad_status_widget.dart';
import 'package:elyra/widgets/el_confirm_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CollectPage extends StatefulWidget {
  const CollectPage({super.key});

  @override
  State<CollectPage> createState() => _CollectPageState();
}

class _CollectPageState extends State<CollectPage> {
  final controller = Get.put(CollectController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CollectController>(
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
          SizedBox(width: 62.w),

          Text(
            'Collect',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'PingFang SC',
              fontWeight: FontWeight.w600,
            ),
          ),
          // 右侧可以放置其他操作按钮，暂时留空
          SizedBox(
            width: 62.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => {
                    controller.state.isEdit = !controller.state.isEdit,
                    controller.update(),
                  },
                  child: Image.asset(
                    controller.state.isEdit
                        ? 'ely_collect_edit.png'.icon
                        : 'ely_collect_confirm.png'.icon,
                    height: 26.h,
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Image.asset(
                    'ely_collect_history.png'.icon,
                    height: 26.h,
                  ),
                ),
              ],
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
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: MasonryGridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: 15.h,
          crossAxisSpacing: 8.w,
          padding: EdgeInsets.zero,
          itemCount: controller.state.collectList.length,
          itemBuilder: (context, index) {
            final item = controller.state.collectList[index];
            final height = 179.h;

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
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            // TODO: 导航到详情页
            // Get.toNamed('/detail', arguments: {'id': item.shortPlayId});
          },
          child: Container(
            width: width, // 卡片宽度（动态计算）
            height: height, // 卡片高度（131 或 266）
            decoration: BoxDecoration(
              color: Color(0xFF5116C1),
              borderRadius: BorderRadius.circular(18.r), // 圆角 32
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18.r),
              child: Column(
                children: [
                  // 上部：图片区域（自适应高度）
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18.r),
                    child: Image.network(
                      item.imageUrl ?? '',
                      width: double.infinity,
                      height: 145.h, // 固定高度
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
                          fontSize: 12,
                          fontFamily: 'PingFang SC',
                          fontWeight: FontWeight.w500,
                          height: 1,
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
        ),
        if (controller.state.isEdit)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.75),
                borderRadius: BorderRadius.circular(18.r), // 圆角 32
              ),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    showElConfirmModal(
                      Get.context!,
                      image: AssetImage('el_model_cancel_collect.png'.icon),
                      title: 'Remove from Favorites?',
                      description:
                          'This drama will be removed from your favorites.',
                      cancelText: 'Cancel',
                      confirmText: 'Remove',
                      closeIcon: AssetImage('close.png'.icon),
                      onCancel: () {
                        Navigator.of(Get.context!).pop();
                      },
                      onConfirm: () {
                        Navigator.of(Get.context!).pop();
                        controller.state.collectList.remove(item);
                        controller.update();
                      },
                    );
                  },
                  child: Image.asset(
                    'ely_collect_del.png'.icon,
                    width: 36.h,
                    height: 36.h,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

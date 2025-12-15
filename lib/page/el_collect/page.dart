import 'package:elyra/bean/short_video_bean.dart';
import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/el_collect/controller.dart';
import 'package:elyra/utils/jump_detail.dart';
import 'package:elyra/widgets/bad_status_widget.dart';
import 'package:elyra/widgets/el_confirm_modal.dart';
import 'package:elyra/widgets/el_nodata_widget.dart';
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
                      height: 40,
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
      padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 4.h),
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
                        ? 'ely_collect_confirm.png'.icon
                        : 'ely_collect_edit.png'.icon,
                    height: 26.h,
                  ),
                ),
                GestureDetector(
                  onTap: () => {Get.toNamed('/history')},
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
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    // 传递 shortPlayId 到弹框
                    final shortPlayId = item.shortPlayId ?? '';
                    showElConfirmModal(
                      context,
                      image: AssetImage('el_model_cancel_collect.png'.icon),
                      title: 'Remove from Favorites?',
                      child: Text(
                        'This drama will be removed from\n your favorites.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: 'PingFang SC',
                          fontWeight: FontWeight.w400,
                          height: 1.50,
                          letterSpacing: -0.01,
                        ),
                      ),
                      cancelText: 'Cancel',
                      confirmText: 'Remove',
                      onCancel: () {
                        Navigator.of(context).pop();
                      },
                      onConfirm: () async {
                        Navigator.of(context).pop();
                        // 调用取消收藏接口
                        bool success = await controller.cancelCollect(
                          shortPlayId,
                        );
                        if (success) {
                          // 从列表中移除该项
                          controller.state.collectList.remove(item);
                          controller.update();
                        }
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

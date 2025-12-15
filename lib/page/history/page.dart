import 'package:elyra/bean/short_video_bean.dart';
import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/history/controller.dart';
import 'package:elyra/utils/jump_detail.dart';
import 'package:elyra/widgets/bad_status_widget.dart';
import 'package:elyra/widgets/el_network_image.dart';
import 'package:elyra/widgets/el_nodata_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final controller = Get.put(HistoryController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HistoryController>(
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
      padding: EdgeInsets.only(left: 11.w, right: 11.w, top: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => Get.back(),
            child: Padding(
              padding: EdgeInsets.all(5.w), // 扩大点击热区
              child: Image.asset('ely_back.png'.icon, height: 20.h),
            ),
          ),
          Text(
            'History',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'PingFang SC',
              fontWeight: FontWeight.w600,
            ),
          ),
          // 右侧可以放置其他操作按钮，暂时留空
          SizedBox(width: 30.w),
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
          _buildHistoryList(),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildHistoryList() {
    return Container(
      // 内容区（正常瀑布流）
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: MasonryGridView.count(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 1,
          mainAxisSpacing: 12.h,
          padding: EdgeInsets.zero,
          itemCount: controller.state.historyList.length,
          itemBuilder: (context, index) {
            final item = controller.state.historyList[index];
            return _buildHistoryItem(item);
          },
        ),
      ),
    );
  }

  /// 历史记录单个 item
  Widget _buildHistoryItem(ShortVideoBean item) {
    return GestureDetector(
      onTap: () => JumpService.toDetail(
        video: {
          'shortPlayId': item.shortPlayId,
          'videoId': item.shortPlayVideoId ?? 0,
          'imageUrl': item.imageUrl ?? '',
        },
      ),
      child: Container(
        width: 343.w,
        height: 115.h,
        padding: EdgeInsets.all(12.w),
        decoration: ShapeDecoration(
          color: Colors.white.withOpacity(0.20),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              strokeAlign: BorderSide.strokeAlignOutside,
              color: const Color(0xFF6018E6),
            ),
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        child: Row(
          children: [
            ElNetworkImage(
              imageUrl: item.imageUrl ?? '',
              width: 68.w,
              height: 91.h,
              borderRadius: BorderRadius.circular(12.r),
            ),
            SizedBox(width: 12.w),

            // 中间内容区域
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 标题
                  Text(
                    item.name ?? '',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontFamily: 'PingFang SC',
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  // Episode
                  Row(
                    children: [
                      Text(
                        'EP.${item.currentEpisode ?? 1}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontFamily: 'PingFang SC',
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                        ),
                      ),
                      Text(
                        '/EP.${item.episodeTotal ?? 0}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontFamily: 'PingFang SC',
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(width: 30.w),

            // 右侧箭头
            Image.asset('ely_right.png'.icon, width: 20.w, height: 20.h),
          ],
        ),
      ),
    );
  }
}

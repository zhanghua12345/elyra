import 'package:elyra/bean/short_video_bean.dart';
import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/el_home/sub_page/genres/controller.dart';
import 'package:elyra/page/el_home/sub_page/genres/state.dart';
import 'package:elyra/utils/jump_detail.dart';
import 'package:elyra/widgets/bad_status_widget.dart';
import 'package:elyra/widgets/el_network_image.dart';
import 'package:elyra/widgets/el_nodata_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class GenresPage extends StatefulWidget {
  const GenresPage({super.key});

  @override
  State<GenresPage> createState() => _GenresPageState();
}

class _GenresPageState extends State<GenresPage>
    with AutomaticKeepAliveClientMixin {
  final controller = Get.put(GenresController());
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // 必须调用，保持页面存活
    return GetBuilder<GenresController>(
      builder: (controller) {
        return SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          enablePullUp: false,
          onRefresh: () => controller.getCategoryData(
            refreshCtrl: _refreshController,
          ),
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
        );
      },
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
          ...List.generate(controller.state.categoryList.length, (index) {
            final item = controller.state.categoryList[index];
            return _buildCategoryItem(item);
          }),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(CategoryItem item) {
    return Container(
      height: 192.h,
      margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 20.h),
      padding: EdgeInsets.symmetric(vertical: 6.h),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('ely_genres_item_bg.png'.icon),
          fit: BoxFit.fill,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            item.categoryName ?? 'Elyra TV',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontFamily: 'PingFang SC',
              fontWeight: FontWeight.w600,
              height: 1.25,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 28.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(3, (index) {
                if (item.shortPlayList != null &&
                    index < item.shortPlayList!.length) {
                  final video = item.shortPlayList![index];
                  return _buildVideoItem(video);
                } else {
                  return _buildVideoItem(null);
                }
              }),
            ),
          ),

          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              // 跳转到vampire页面，传递category id和title
              Get.toNamed(
                '/vampire',
                arguments: {'id': item.id, 'title': item.categoryName},
              );
            },
            child: Text(
              'More',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'PingFang SC',
                fontWeight: FontWeight.w600,
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoItem(ShortVideoBean? video) {
    if (video == null) {
      return Container(
        width: 84.w,
        height: 112.h,
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Icon(Icons.error, color: Colors.white54),
      );
    }

    return GestureDetector(
      onTap: () => JumpService.toDetail(
        video: {
          'shortPlayId': video.shortPlayId,
          'videoId': video.shortPlayVideoId ?? 0,
          'imageUrl': video.imageUrl ?? '',
        },
      ),
      child: ElNetworkImage(
        imageUrl: video.imageUrl,
        width: 84.w,
        height: 112.h,
        borderRadius: BorderRadius.circular(15.r),
      ),
    );
  }
}

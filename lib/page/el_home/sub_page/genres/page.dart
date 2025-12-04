import 'package:elyra/bean/short_video_bean.dart';
import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/el_home/sub_page/genres/controller.dart';
import 'package:elyra/page/el_home/sub_page/genres/state.dart';
import 'package:elyra/widgets/bad_status_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class GenresPage extends StatefulWidget {
  const GenresPage({super.key});

  @override
  State<GenresPage> createState() => _GenresPageState();
}

class _GenresPageState extends State<GenresPage> {
  final controller = Get.put(GenresController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GenresController>(
      builder: (controller) {
        return SmartRefresher(
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
            onTap: () {
              // 跳转到vampire页面，传递category id和title
              Get.toNamed('/vampire', arguments: {
                'id': item.id,
                'title': item.categoryName,
              });
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
    return Container(
      width: 84.w,
      height: 112.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        image: video != null
            ? DecorationImage(
                image: NetworkImage(video.imageUrl ?? ''),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: video == null
          ? Container(
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(15.r),
              ),
              child: Icon(Icons.error, color: Colors.white54),
            )
          : null,
    );
  }
}

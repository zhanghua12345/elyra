import 'package:elyra/bean/short_video_bean.dart';
import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/el_home/sub_page/new/controller.dart';
import 'package:elyra/widgets/bad_status_widget.dart';
import 'package:elyra/widgets/el_nodata_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NewPage extends StatefulWidget {
  const NewPage({super.key});

  @override
  State<NewPage> createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  final controller = Get.put(NewController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewController>(
      builder: (controller) {
        return SmartRefresher(
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
          _buildStaggeredGrid(),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }

  Widget _buildStaggeredGrid() {
    return Stack(
      children: [
        // 背景图（固定宽度 343、高度 266）
        Positioned(
          left: 16.w, // 与 Grid 左右对齐
          top: 0,
          child: Container(
            width: 343.w,
            height: 266.h,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('ely_new_bg.png'.icon),
                fit: BoxFit.cover, // 背景图平铺整个 343x266 区域
              ),
              borderRadius: BorderRadius.circular(32.r),
            ),
          ),
        ),

        // 内容区（正常瀑布流）
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: MasonryGridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 7.h,
            crossAxisSpacing: 7.w,
            padding: EdgeInsets.zero,
            itemCount: controller.state.newList.length,
            itemBuilder: (context, index) {
              final item = controller.state.newList[index == 0 ? 0 : index - 1];
              final isSmall = index == 1;
              final height = isSmall ? 69.h : 266.h;

              return _buildCollectionCard(item, double.infinity, height, index);
            },
          ),
        ),
      ],
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
    int index,
  ) {
    if (index == 1) {
      // 小卡片，只显示横图
      return Container(
        width: width,
        height: height, // 69.h
        alignment: Alignment.center, // 文字完全居中
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Text(
          'New Releases', // 你要显示的文案
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontFamily: 'PingFang SC',
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
        ),
      );
    }
    return GestureDetector(
      onTap: () {
        Get.toNamed('/play_detail', arguments: {
          'shortPlayId': item.shortPlayId,
          'imageUrl': item.imageUrl ?? '',
        });
      },
      child: Container(
        width: width, // 卡片宽度（动态计算）
        height: height, // 卡片高度（131 或 266）
        decoration: BoxDecoration(
          color: index == 0 ? null : const Color(0xFF5116C1),
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

import 'package:elyra/bean/short_video_bean.dart';
import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/el_home/sub_page/ranking/controller.dart';
import 'package:elyra/utils/jump_detail.dart';
import 'package:elyra/widgets/bad_status_widget.dart';
import 'package:elyra/widgets/el_nodata_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  final controller = Get.put(RankingController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RankingController>(
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
          _buildTop3(),
          SizedBox(height: 35.h),
          _buildRankingList(),
        ],
      ),
    );
  }

  Widget _buildTop3() {
    final top3 = controller.state.rankingList.take(3).toList();
    if (top3.isEmpty) return SizedBox();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (top3.length > 0)
              Padding(
                padding: EdgeInsets.only(bottom: 15.h),
                child: _buildTop3Card(top3[0], 2, false),
              ),
            if (top3.length > 1) _buildTop3Card(top3[1], 1, true),
            if (top3.length > 2)
              Padding(
                padding: EdgeInsets.only(bottom: 15.h),
                child: _buildTop3Card(top3[2], 3, false),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTop3Card(ShortVideoBean item, int rank, bool isLarge) {
    final cardWidth = isLarge ? 118.w : 95.w;
    final cardHeight = isLarge ? 156.h : 126.h;
    final badgeSize = isLarge ? 31.w : 28.w;
    final borderRadius = isLarge ? 25.r : 20.r;

    return GestureDetector(
      onTap: () => JumpService.toDetail(
        video: {
          'shortPlayId': item.shortPlayId,
          'videoId': item.shortPlayVideoId ?? 0,
          'imageUrl': item.imageUrl ?? '',
        },
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: cardWidth,
            height: cardHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF6018E6),
                  Color(0xFFFFFFFF),
                  Color(0xFFDC23B1),
                ],
              ),
            ),
            padding: EdgeInsets.all(3.w),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius - 3.r),
              child: Image.network(
                item.imageUrl ?? '',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[800],
                  child: Icon(Icons.error, color: Colors.white54),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Transform.translate(
              offset: Offset(0, badgeSize / 2),
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'ely_ranking_star.png'.icon,
                      width: badgeSize,
                      height: badgeSize,
                    ),
                    Text(
                      '0$rank',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'DDinPro',
                        fontWeight: FontWeight.w900,
                        height: 0.88,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankingList() {
    final list = controller.state.rankingList.skip(3).toList();
    if (list.isEmpty) return SizedBox();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0x4CB218E6),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(38.r),
            topRight: Radius.circular(38.r),
          ),
        ),
        child: Column(
          children: [
            if (list.isNotEmpty) _buildRankingItem(list[0], 4, true),
            ...List.generate(list.length - 1, (index) {
              final item = list[index + 1];
              final rankNumber = index + 5;
              return _buildRankingItem(item, rankNumber, false);
            }),
            SizedBox(height: 18.h),
          ],
        ),
      ),
    );
  }

  Widget _buildRankingItem(ShortVideoBean item, int rank, bool isFirst) {
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
        padding: EdgeInsets.only(
          left: 12.w,
          right: 13.w,
          top: isFirst ? 18.h : 15.h,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              rank < 10 ? '0$rank' : '$rank',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.80),
                fontSize: 22.sp,
                fontWeight: FontWeight.w900,
                fontFamily: 'DDinPro',
              ),
            ),
            SizedBox(width: 13.w),
            Container(
              width: 53.w,
              height: 70.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                image: DecorationImage(
                  image: NetworkImage(item.imageUrl ?? ''),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            // 中间 Column 高度跟图片一致，顶部对齐
            SizedBox(
              height: 70.h, // 和图片一样高
              width: 150.w,
              child: Align(
                alignment: Alignment.topLeft, // 顶部对齐
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.name ?? 'Elyra TV',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontFamily: 'PingFang SC',
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6.h),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'ely_ranking_ep.png'.icon,
                          width: 43.w,
                          height: 11.h,
                          fit: BoxFit.contain,
                        ),
                        Text(
                          'EP ${item.episodeTotal ?? 99}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'DDinPro',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'ely_ranking_hot.png'.icon,
                  width: 12.w,
                  height: 12.h,
                ),
                SizedBox(width: 2.w),
                Text(
                  _formatNumber(item.watchTotal ?? 0),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: 'PingFang SC',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatNumber(num number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}

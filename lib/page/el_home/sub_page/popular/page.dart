import 'package:card_swiper/card_swiper.dart';
import 'package:elyra/bean/short_video_bean.dart';
import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/el_home/sub_page/popular/controller.dart';
import 'package:elyra/utils/jump_detail.dart';
import 'package:elyra/widgets/bad_status_widget.dart';
import 'package:elyra/widgets/el_nodata_widget.dart';
import 'package:elyra/widgets/el_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PopularPage extends StatefulWidget {
  const PopularPage({super.key});

  @override
  State<PopularPage> createState() => _PopularPageState();
}

class _PopularPageState extends State<PopularPage>
    with AutomaticKeepAliveClientMixin {
  final controller = Get.put(PopularController());

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // 必须调用，保持页面存活
    return GetBuilder<PopularController>(
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

  /// ================== 内容构建 ==================
  /// 根据加载状态显示不同内容：loading/失败/无数据/成功
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

    // 加载成功状态：显示所有内容模块
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 顶部间距
          SizedBox(height: 20.h),

          // ========== 模块1：Banner 轮播图 ==========
          if (controller.state.bannerList.isNotEmpty) _buildBannerSwiper(),
          if (controller.state.bannerList.isNotEmpty) SizedBox(height: 25.h),

          // ========== 模块2：Popular This Week 本周热门 ==========
          if (controller.state.popularWeekList.isNotEmpty)
            _buildSectionTitle('Popular This Week'),
          if (controller.state.popularWeekList.isNotEmpty)
            SizedBox(height: 14.h),
          if (controller.state.popularWeekList.isNotEmpty)
            _buildPopularThisWeek(),
          if (controller.state.popularWeekList.isNotEmpty)
            SizedBox(height: 16.h),

          // ========== 模块3：Trending Now 热门推荐（前3条）==========
          if (controller.getTop3Items(controller.state.trendingList).isNotEmpty)
            _buildSectionTitle('Trending Now'),
          if (controller.getTop3Items(controller.state.trendingList).isNotEmpty)
            SizedBox(height: 15.h),
          if (controller.getTop3Items(controller.state.trendingList).isNotEmpty)
            _buildTrendingNow(),
          if (controller.getTop3Items(controller.state.trendingList).isNotEmpty)
            SizedBox(height: 20.h),

          // ========== 模块4：Curated Collections 精选集合 ==========
          if (controller.state.collectionsList.isNotEmpty)
            _buildSectionTitle('Curated Collections'),
          if (controller.state.collectionsList.isNotEmpty)
            SizedBox(height: 15.h),
          if (controller.state.collectionsList.isNotEmpty)
            _buildCuratedCollections(),
          if (controller.state.collectionsList.isNotEmpty)
            SizedBox(height: 40.h),
        ],
      ),
    );
  }

  /// ================== 模块1：Banner 轮播图 ==================
  /// 设计要求：
  /// - 无小点点指示器
  /// - 大圆角 32
  /// - 中间 item 尺寸：270*360
  /// - 两边高度：310
  /// - item 间距：20
  /// - 底部有背景图片 ely_popular_banner_item_bg.png
  /// - 底部有 Watch 文字 + 右箭头图标 ely_right.png
  Widget _buildBannerSwiper() {
    return SizedBox(
      height: 378.h, // 轮播图高度
      child: Swiper(
        itemCount: controller.state.bannerList.length,
        autoplay: true, // 自动播放
        autoplayDelay: 5000, // 自动播放延迟 5秒
        duration: 800, // 切换动画时长 800毫秒
        viewportFraction: 0.72, // 中间 item 占屏幕比例，实现 270 宽度
        scale: 0.86, // 两边 item 缩放比例，实现 310 高度
        itemBuilder: (context, index) {
          final item = controller.state.bannerList[index];
          return _buildBannerCard(item);
        },
      ),
    );
  }

  /// Banner 卡片单个 item
  Widget _buildBannerCard(ShortVideoBean item) {
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
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(61.r),
              // 背景图片 - 从网络加载
              child: ElNetworkImage(
                imageUrl: item.imageUrl,
                width: 270.w,
                height: 360.h,
              ),
            ),
            // 底部背景装饰图片
            Positioned(
              left: 0,
              right: 0,
              bottom: 0.h,
              child: Image.asset(
                'ely_popular_banner_item_bg.png'.icon,
                height: 44.h, // 背景图片高度
              ),
            ),
            // 底部 Watch 按钮（文字 + 箭头）
            Positioned(
              left: 0,
              right: 0,
              bottom: 0.h,
              child: Container(
                padding: EdgeInsets.only(
                  left: 66.w,
                  right: 66.w,
                  top: 8.h,
                  bottom: 8.h,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min, // 让行宽度由内容 + padding 决定（保证居中）
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Watch',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'PingFang SC',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 8.w), // 文本与箭头之间的间距
                    Image.asset(
                      'ely_right.png'.icon,
                      width: 16.w,
                      height: 16.h,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ================== 公共组件：模块标题 ==================
  /// 设计要求：
  /// - 最左边有一个 5*9 的长方圆（橙色 #FF6B00）
  /// - 长方圆和文字间距 8
  /// - 注意：有左右 padding 20！（这是每个模块自己的间距）
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w), // 模块自带的左右间距
      child: Row(
        children: [
          // 5*9 的橙色长方圆
          Container(
            width: 5.w,
            height: 9.h,
            decoration: BoxDecoration(
              color: Color(0xFFFF20CB), // 橙色
              borderRadius: BorderRadius.circular(999.r), // 大圆角（完全圆润）
            ),
          ),
          SizedBox(width: 3.w), // 长方圆和文字间距
          // 模块标题文字
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'PingFang SC',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// ================== 模块2：Popular This Week 本周热门 ==================
  /// 设计要求：
  /// - 横向滚动列表
  /// - 每个 item 宽度 160，高度 200
  /// - 底部有 Watch 按钮：
  ///   - 外层：纯色圆 #3E2076（padding 3）
  ///   - 内层：渐变 linear-gradient(90deg, #E424AE 0%, #6018E6 100%)
  /// - 注意：ListView 有 padding 20！（模块自带）
  Widget _buildPopularThisWeek() {
    return SizedBox(
      height: 175.h, // 列表高度 158 12 5
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // 横向滚动
        padding: EdgeInsets.symmetric(horizontal: 16.w), // 模块自带的左右间距
        itemCount: controller.state.popularWeekList.length,
        itemBuilder: (context, index) {
          final item = controller.state.popularWeekList[index];
          return _buildPopularCard(item);
        },
      ),
    );
  }

  /// Popular 单个 item 卡片
  Widget _buildPopularCard(ShortVideoBean item) {
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
        margin: EdgeInsets.only(right: 10.w), // item 之间的间距
        child: Stack(
          children: [
            // 封面图片
            ElNetworkImage(
              imageUrl: item.imageUrl,
              width: 124.w,
              height: 158.h,
              borderRadius: BorderRadius.circular(27.r),
            ),
            // 底部 Watch 按钮（双层结构）
            Positioned(
              left: 15.w,
              right: 15.w,
              bottom: 0.h,
              child: Container(
                padding: EdgeInsets.all(5), // 外层边框厚度
                decoration: BoxDecoration(
                  color: Color(0xFF3E2076), // 外层边框颜色
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Container(
                  width: 84.w,
                  height: 23.h,
                  decoration: BoxDecoration(
                    // 内层渐变背景：从左到右 #E424AE -> #6018E6
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFFE424AE), // 渐变起点颜色
                        Color(0xFF6018E6), // 渐变终点颜色
                      ],
                    ),
                    borderRadius: BorderRadius.circular(999.r), // 大圆角（完全圆润）
                  ),
                  child: Center(
                    child: Text(
                      'Watch',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: 'PingFang SC',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ================== 模块3：Trending Now 热门推荐（前3条）==================
  /// 设计要求：
  /// - 只显示前 3 条数据，不足则重复
  /// - 布局：左边一条大图 + 右边两条小图上下排列
  /// - 左边大图：圆角 32，高度 330，右上角01，底部渐变+标题居中
  /// - 右边小图：圆角 19，高度 157，左图右文，右下角02/03
  /// - 注意：有左右 padding 20！（模块自带）
  Widget _buildTrendingNow() {
    final top3Items = controller.getTop3Items(controller.state.trendingList);
    if (top3Items.isEmpty) return SizedBox();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w), // 模块自带的左右间距
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 左边：大图卡片
          Expanded(flex: 1, child: _buildTrendingLargeCard(top3Items[0], '01')),
          SizedBox(width: 7.w), // 左右两边间距
          // 右边：两个小图上下排列
          Expanded(
            flex: 1,
            child: Column(
              children: [
                if (top3Items.length > 1)
                  _buildTrendingSmallCard(top3Items[1], '02'),
                if (top3Items.length > 1) SizedBox(height: 8.h), // 上下两个小图间距
                if (top3Items.length > 2)
                  _buildTrendingSmallCard(top3Items[2], '03'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Trending 大卡片（左边）
  /// - 圆角 32
  /// - 高度 330
  /// - 右上角数字（白色 32sp）
  /// - 底部渐变遮罩
  /// - 标题两行居中显示
  Widget _buildTrendingLargeCard(ShortVideoBean item, String number) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => JumpService.toDetail(
        video: {
          'shortPlayId': item.shortPlayId,
          'videoId': item.shortPlayVideoId ?? 0,
          'imageUrl': item.imageUrl ?? '',
        },
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32.r), // 圆角 32
        child: SizedBox(
          height: 224.h, // 卡片高度
          width: 168.w,
          child: Stack(
            children: [
              // 背景图片（优先使用横版图）
              ElNetworkImage(
                imageUrl: item.horizontallyImg ?? item.imageUrl,
                width: double.infinity,
                height: double.infinity,
              ),
              // 渐变遮罩（从上到下，透明 -> 黑色 80%）
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(0.50, 0.16),
                    end: Alignment(0.50, 0.95),
                    colors: [
                      Colors.black.withValues(alpha: 0),
                      const Color(0xFFD20AA4),
                    ],
                  ),
                ),
              ),
              // 右上角数字（如 "01"）
              Positioned(
                top: 0.h,
                left: 0.w,
                child: Container(
                  width: 39,
                  height: 36,
                  padding: EdgeInsets.only(left: 7.h),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFFF20CB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(5),
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      number,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'DDinPro',
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
              // 底部标题（两行居中显示）
              Positioned(
                left: 18.w,
                right: 18.w,
                bottom: 8.h,
                child: Text(
                  item.name ?? '',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'PingFang SC',
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2, // 最多两行
                  overflow: TextOverflow.ellipsis, // 超出显示省略号
                  textAlign: TextAlign.center, // 文本居中
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Trending 小卡片（右边上下两个）
  /// - 圆角 19
  /// - 高度 157
  /// - 左边：图片
  /// - 右边：标题（背景色 #1A1A2E）
  /// - 右下角：数字（如 "02", "03"）
  Widget _buildTrendingSmallCard(ShortVideoBean item, String number) {
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
        height: 108.h, // 卡片高度
        decoration: BoxDecoration(
          color: Color(0xB26018E6), // 你的背景色（示例颜色）

          borderRadius: BorderRadius.circular(19.r), // 圆角 19
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(19.r),
          child: Stack(
            children: [
              Row(
                children: [
                  // 左边：图片区域
                  Expanded(
                    flex: 1,
                    child: ElNetworkImage(
                      imageUrl: item.imageUrl,
                      height: double.infinity,
                      width: 81.w,
                      borderRadius: BorderRadius.circular(19.r),
                    ),
                  ),
                  // 右边：标题区域（深色背景）
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 15.h,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name ?? '',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'PingFang SC',
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2, // 最多三行
                            overflow: TextOverflow.ellipsis, // 超出显示省略号
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // 右下角数字（如 "02", "03"）
              Positioned(
                bottom: 0.h,
                right: 0.w,
                child: Container(
                  width: 39,
                  height: 36,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFA16FFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                      ),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      number,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'DDinPro',
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ================== 模块4：Curated Collections 精选集合 ==================
  /// 设计要求：
  /// - 右上角（index 1）：168*131
  /// - 其他卡片：168*266
  /// - 背景色：#5116C1
  /// - 圆角：32
  /// - 图片在上，标题在下
  /// - 标题两行居中显示，单行也居中
  /// - 注意：有左右 padding 20！（模块自带）
  Widget _buildCuratedCollections() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w), // 左右间距
      child: MasonryGridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 2, // 两列
        mainAxisSpacing: 7.h, // 纵向间距
        crossAxisSpacing: 7.w, // 横向间距
        padding: EdgeInsets.zero, // ✅ 这里默认需要手动清空

        itemCount: controller.state.collectionsList.length,
        itemBuilder: (context, index) {
          final item = controller.state.collectionsList[index];

          final isSmall = index == 1;
          final height = isSmall ? 131.h : 266.h;

          return _buildCollectionCard(
            item,
            double.infinity,
            height,
            isSmall: isSmall,
          );
        },
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
    double height, {
    bool isSmall = false,
  }) {
    if (isSmall) {
      // 小卡片，只显示横图
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => JumpService.toDetail(
          video: {
            'shortPlayId': item.shortPlayId,
            'videoId': item.shortPlayVideoId ?? 0,
            'imageUrl': item.imageUrl ?? '',
          },
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32.r),
          child: Image.network(
            item.horizontallyImg ?? item.imageUrl ?? '',
            width: width,
            height: height, // 131.h
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              child: Image.network(
                item.imageUrl ?? '',
                width: width,
                height: height, // 131.h
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[800],
                  child: Icon(Icons.error, color: Colors.white54),
                ),
              ),
            ),
          ),
        ),
      );
    }
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
          color: Color(0xFF5116C1), // 背景色：紫色
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
                height: 224.h, // 固定高度
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

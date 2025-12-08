import 'package:elyra/bean/short_play_detail_bean.dart';
import 'package:elyra/extend/el_string.dart';
import 'package:elyra/utils/el_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// 选集弹窗页面
class SelectEpisodePage extends StatefulWidget {
  final int totalEpisodes; // 总集数
  final int initialEpisode; // 初始选中集数
  final Function(int episode)? onEpisodeSelected; // 选集回调
  final ShortPlayInfo? shortPlayInfo; // 短剧信息
  final List<EpisodeList> episodeList; // 剧集列表

  const SelectEpisodePage({
    super.key,
    required this.totalEpisodes,
    required this.initialEpisode,
    this.onEpisodeSelected,
    this.shortPlayInfo,
    required this.episodeList,
  });

  @override
  State<SelectEpisodePage> createState() => _SelectEpisodePageState();
}

class _SelectEpisodePageState extends State<SelectEpisodePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentEpisode = 1; // 当前选中的集数
  late int _tabCount; // Tab数量
  final int _perTabEpisode = 20; // 每页显示集数

  @override
  void initState() {
    super.initState();
    _tabCount = (widget.totalEpisodes / _perTabEpisode).ceil();

    // 确保初始集数在有效范围内
    _currentEpisode = widget.initialEpisode;
    if (_currentEpisode < 1) _currentEpisode = 1;
    if (_currentEpisode > widget.totalEpisodes) {
      _currentEpisode = widget.totalEpisodes;
    }

    _tabController = TabController(
      length: _tabCount,
      vsync: this,
      initialIndex: (_currentEpisode - 1) ~/ _perTabEpisode,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _selectEpisode(int episode) {
    setState(() {
      _currentEpisode = episode;
      // 切换到对应Tab
      int tabIndex = (episode - 1) ~/ _perTabEpisode;
      if (tabIndex != _tabController.index) {
        _tabController.animateTo(tabIndex);
      }
      // 执行回调
      if (widget.onEpisodeSelected != null) {
        widget.onEpisodeSelected!(episode);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.shortPlayInfo?.description != null &&
              widget.shortPlayInfo!.description!.isNotEmpty
          ? 486.w
          : 436.w,
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.w)),
        gradient: LinearGradient(
          colors: [Colors.white, ColorEnum.mainColor.withOpacity(0.08)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 顶部短剧信息
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 10.w),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6.w),
                      child: Image.network(
                        widget.shortPlayInfo?.imageUrl ?? '',
                        width: 64.w,
                        height: 82.w,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 64.w,
                            height: 82.w,
                            color: Colors.grey[300],
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 10.w),
                    SizedBox(
                      width: ScreenUtil().screenWidth - 140.w,
                      height: 82.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.shortPlayInfo?.name ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 10.w),
                          if (widget.shortPlayInfo?.category != null &&
                              widget.shortPlayInfo!.category!.isNotEmpty)
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.w, vertical: 2.w),
                              decoration: BoxDecoration(
                                color: ColorEnum.mainColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4.w),
                              ),
                              child: Text(
                                widget.shortPlayInfo!.category!.first,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: ColorEnum.mainColor,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Get.back(),
                child: Image.asset('ely_close.png'.icon, width: 24.w),
              ),
            ],
          ),
          SizedBox(height: 10.w),

          // 描述信息
          if (widget.shortPlayInfo?.description != null &&
              widget.shortPlayInfo!.description!.isNotEmpty)
            SizedBox(
              height: 50.w,
              child: Text(
                widget.shortPlayInfo!.description!,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12.sp, color: Color(0xFF777777)),
              ),
            ),
          SizedBox(height: 10.w),

          // TabBar
          Align(
            alignment: Alignment.centerLeft,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              labelPadding: EdgeInsets.only(right: 40.w),
              labelColor: ColorEnum.mainColor,
              indicatorColor: ColorEnum.mainColor,
              unselectedLabelColor: Color(0xFFC2C2C2),
              tabs: List.generate(_tabCount, (index) {
                int start = index * _perTabEpisode + 1;
                int end = (index + 1) * _perTabEpisode;
                if (end > widget.totalEpisodes) end = widget.totalEpisodes;
                return Tab(
                  height: 25.w,
                  child: Text(
                    '$start-$end',
                    style:
                        TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
                  ),
                );
              }),
            ),
          ),

          // 选集网格
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: List.generate(_tabCount, (tabIndex) {
                int start = tabIndex * _perTabEpisode + 1;
                int end = (tabIndex + 1) * _perTabEpisode;
                if (end > widget.totalEpisodes) end = widget.totalEpisodes;

                return GridView.builder(
                  padding: EdgeInsets.only(top: 12.w),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    mainAxisSpacing: 10.w,
                    crossAxisSpacing: 10.w,
                    childAspectRatio: 62 / 50,
                  ),
                  itemCount: end - start + 1,
                  itemBuilder: (context, index) {
                    int episode = start + index;
                    bool isCurrent = episode == _currentEpisode;

                    return GestureDetector(
                      onTap: () => _selectEpisode(episode),
                      child: Container(
                        decoration: isCurrent
                            ? BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    ColorEnum.mainColor,
                                    ColorEnum.mainColor.withOpacity(0.8),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(6.w),
                                border: Border.all(
                                  color: ColorEnum.mainColor,
                                  width: 1.5,
                                ),
                              )
                            : BoxDecoration(
                                color: ColorEnum.mainColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(6.w),
                              ),
                        child: Center(
                          child: Text(
                            '$episode',
                            style: TextStyle(
                              color: isCurrent ? Colors.white : Colors.black,
                              fontWeight: isCurrent
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

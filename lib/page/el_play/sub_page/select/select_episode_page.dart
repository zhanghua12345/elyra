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
  final int _perTabEpisode = 24; // 每页显示集数

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
    
    // 监听Tab切换，确保界面更新
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          // 强制刷新界面，确保Tab高亮状态正确
        });
      }
    });
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
    final double bottomSafe = MediaQuery.of(context).padding.bottom;

    return SafeArea(
      minimum: EdgeInsets.only(bottom: 16.h),
      child: Container(
        height: 340.h + bottomSafe, // ② 指定高度 + 安全距离
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: ShapeDecoration(
          color: Colors.black.withValues(alpha: 0.9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.w),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 标题（单行 + 限宽300 + 省略号）
            Container(
              margin: EdgeInsets.only(top: 18.h),
              width: 300.w, // ① 限制宽度
              child: Text(
                widget.shortPlayInfo?.name ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            SizedBox(height: 10.h),

            /// TabBar（可横向滚动）
            Align(
              alignment: Alignment.centerLeft,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(_tabCount, (index) {
                    int start = index * _perTabEpisode + 1;
                    int end = (index + 1) * _perTabEpisode;
                    if (end > widget.totalEpisodes) end = widget.totalEpisodes;
                    
                    // 使用_tabController.index而不是局部变量
                    bool isSelected = _tabController.index == index;

                    return Padding(
                      padding: EdgeInsets.only(right: 50.w), // ⑤ 两个Tab相距50
                      child: GestureDetector(
                        onTap: () {
                          if (_tabController.index != index) {
                            _tabController.animateTo(index);
                          }
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$start-$end',
                              style: TextStyle(
                                color: isSelected
                                    ? Color(0xFFFF29DF)
                                    : Color(0xFFC2C2C2),
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Container(
                              width: 10.w,
                              height: 4.h,
                              decoration: ShapeDecoration(
                                color: isSelected
                                    ? Color(0xFFFF29DF)
                                    : Color(0xFFAAAAAA),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(36),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),

            SizedBox(height: 12.h),

            /// 选集内容（每页 24 个，6列 × 4行）
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: List.generate(_tabCount, (tabIndex) {
                  int start = tabIndex * _perTabEpisode + 1;
                  int end = (tabIndex + 1) * _perTabEpisode;
                  if (end > widget.totalEpisodes) end = widget.totalEpisodes;

                  return GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(top: 12.h),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6,
                      mainAxisSpacing: 15.h, // ③ item宽高间距 = 15
                      crossAxisSpacing: 15.w,
                      childAspectRatio: 43 / 44, // item大小：43×44
                    ),
                    itemCount: end - start + 1,
                    itemBuilder: (_, index) {
                      int episode = start + index;
                      bool isCurrent = episode == _currentEpisode;

                      return GestureDetector(
                        onTap: () => _selectEpisode(episode),
                        child: Container(
                          decoration: isCurrent
                              ? ShapeDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment(0.50, 0.00),
                                    end: Alignment(0.50, 1.00),
                                    colors: [
                                      Color(0xFFDC23B1),
                                      Color(0xFF6018E6),
                                    ],
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                )
                              : ShapeDecoration(
                                  color: Colors.white.withValues(alpha: 0.25),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                          child: Center(
                            child: Text(
                              '$episode',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.80),
                                fontSize: 16,
                                fontFamily: 'DIN Black',
                                fontWeight: FontWeight.w900,
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
      ),
    );
  }
}

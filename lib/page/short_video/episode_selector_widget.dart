import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pandaroll/extend/string_extend.dart';
import 'package:pandaroll/page/short_video/logic.dart';
import 'package:pandaroll/resource/color_resource.dart';
import 'package:pandaroll/utils/my_styles.dart';

class EpisodeSelector extends StatefulWidget {
  final int totalEpisodes;
  final int? initialEpisode; // 可选参数，初始选中的集数
  final int perTabEpisode; // 可选参数，每页参数
  final Function(int episode)? onEpisodeSelected; // 选集回调

  const EpisodeSelector({
    super.key,
    required this.totalEpisodes,
    this.initialEpisode,
    this.perTabEpisode = 20,
    this.onEpisodeSelected,
  });

  @override
  State<EpisodeSelector> createState() => _EpisodeSelectorState();
}

class _EpisodeSelectorState extends State<EpisodeSelector> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentEpisode = 1; // 当前选中的集数
  late int _tabCount; // Tab数量

  final state = Get.find<ShortVideoLogic>().state;

  @override
  void initState() {
    super.initState();
    Get.put(ShortVideoLogic());
    _tabCount = (widget.totalEpisodes / widget.perTabEpisode).ceil();

    // 确保初始集数在有效范围内
    _currentEpisode = widget.initialEpisode ?? 1;
    if (_currentEpisode < 1) _currentEpisode = 1;
    if (_currentEpisode > widget.totalEpisodes) {
      _currentEpisode = widget.totalEpisodes;
    }

    _tabController = TabController(
      length: _tabCount,
      vsync: this,
      initialIndex: (_currentEpisode - 1) ~/ widget.perTabEpisode,
    );
    // _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    // _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  // void _handleTabChange() {
  //   if (!_tabController.indexIsChanging) {
  //     setState(() {
  //       // 计算当前Tab对应的第一集
  //       int firstEpisode = _tabController.index * widget.perTabEpisode + 1;
  //       // 如果当前选集不在当前Tab范围内，则设置为当前Tab的第一集
  //       if (_currentEpisode < firstEpisode || _currentEpisode >= firstEpisode + widget.perTabEpisode) {
  //         _currentEpisode = firstEpisode;
  //       }
  //     });
  //   }
  // }

  void _selectEpisode(int episode) {
    setState(() {
      _currentEpisode = episode;
      // 切换到对应Tab
      int tabIndex = (episode - 1) ~/ widget.perTabEpisode;
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 自定义TabBar
        Align(
          alignment: Alignment.centerLeft,
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelPadding: EdgeInsets.only(right: 40.w),
            labelColor: ColorResource.mainColor,
            indicatorColor: ColorResource.mainColor,
            unselectedLabelColor: ColorResource.bg_C2C2C2,
            tabs: List.generate(_tabCount, (index) {
              int start = index * widget.perTabEpisode + 1;
              int end = (index + 1) * widget.perTabEpisode;
              if (end > widget.totalEpisodes) end = widget.totalEpisodes;
              return Tab(
                height: 25.w,
                child: Text(
                  '$start-$end',
                  style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
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
              int start = tabIndex * widget.perTabEpisode + 1;
              int end = (tabIndex + 1) * widget.perTabEpisode;
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
                    child: Stack(
                      children: [
                        Container(
                          decoration: isCurrent
                              ? MyStyles.mainBorder(width: 1.5, radius: 6)
                              : BoxDecoration(
                                  color: ColorResource.mainColor.withValues(alpha: .12),
                                  borderRadius: BorderRadius.circular(6.w),
                                ),
                          child: Center(
                            child: Text(
                              '$episode',
                              style: TextStyle(
                                color: isCurrent ? Colors.white : Colors.black,
                                fontWeight: isCurrent ? FontWeight.w500 : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                        if (state.episodeList[episode - 1].isLock == true)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              width: 20.w,
                              height: 12.w,
                              decoration: BoxDecoration(
                                color: ColorResource.mainYellow,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(6.w),
                                  bottomLeft: Radius.circular(6.w),
                                ),
                              ),
                              child: Image.asset('ic_video_lock.png'.icon, width: 10.w, height: 10.w),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ),
      ],
    );
  }
}

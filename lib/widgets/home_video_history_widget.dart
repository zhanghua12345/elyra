import 'dart:convert';
import 'package:elyra/bean/short_video_bean.dart';
import 'package:elyra/extend/el_string.dart';
import 'package:elyra/request/http.dart';
import 'package:elyra/request/index.dart';
import 'package:elyra/utils/el_store.dart';
import 'package:elyra/utils/el_utils.dart';
import 'package:elyra/utils/jump_detail.dart';
import 'package:elyra/widgets/el_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 首页历史记录组件
class HomeVideoHistoryWidget extends StatefulWidget {
  const HomeVideoHistoryWidget({super.key});

  @override
  State<HomeVideoHistoryWidget> createState() => _HomeVideoHistoryWidgetState();
}

class _HomeVideoHistoryWidgetState extends State<HomeVideoHistoryWidget> {
  ShortVideoBean? _historyVideo;
  bool _isLoading = true;
  bool _isHidden = false; // 用户是否手动关闭了历史记录模块
  String? _lastHistoryKey; // 记录最后一次显示的历史记录标识

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  /// 加载历史记录
  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);

    try {
      // 先尝试从本地获取
      String? localHistory = SpUtils().getString(ElStoreKeys.videoHistory);

      if (localHistory != null && localHistory.isNotEmpty) {
        // 本地有历史记录
        final historyData = jsonDecode(localHistory);
        _historyVideo = ShortVideoBean()
          ..shortPlayId = historyData['short_play_id']
          ..name = historyData['name']
          ..imageUrl = historyData['image_url']
          ..process = historyData['episode']
          ..playTime = historyData['play_seconds'] ?? 0;

        // 生成当前历史记录的唯一标识
        String currentHistoryKey =
            '${historyData['short_play_id']}_${historyData['episode']}_${historyData['timestamp']}';

        // 检查是否有新数据
        if (_lastHistoryKey != currentHistoryKey) {
          // 有新数据，重新显示模块
          _isHidden = false;
          _lastHistoryKey = currentHistoryKey;
        }

        setState(() => _isLoading = false);
      } else {
        // 本地没有,从接口获取
        await _fetchHistoryFromApi();
      }
    } catch (e) {
      debugPrint('加载历史记录失败: $e');
      setState(() => _isLoading = false);
    }
  }

  /// 从API获取历史记录
  Future<void> _fetchHistoryFromApi() async {
    try {
      ApiResponse res = await HttpClient().request(
        Apis.history,
        method: HttpMethod.get,
        queryParameters: {'current_page': 1, 'page_size': 1},
      );

      if (res.success &&
          res.data['list'] != null &&
          res.data['list'].isNotEmpty) {
        final historyItem = res.data['list'][0];
        _historyVideo = ShortVideoBean.fromJson(historyItem);

        // 保存到本地
        final historyData = {
          'short_play_id': _historyVideo!.shortPlayId,
          'video_id': _historyVideo!.id,
          'name': _historyVideo!.name,
          'image_url': _historyVideo!.imageUrl,
          'episode': _historyVideo!.process ?? 1,
          'play_seconds': _historyVideo!.playTime ?? 0,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        };
        SpUtils().setString(ElStoreKeys.videoHistory, jsonEncode(historyData));

        // 生成当前历史记录的唯一标识
        String currentHistoryKey =
            '${historyData['short_play_id']}_${historyData['episode']}_${historyData['timestamp']}';

        // 检查是否有新数据
        if (_lastHistoryKey != currentHistoryKey) {
          // 有新数据，重新显示模块
          _isHidden = false;
          _lastHistoryKey = currentHistoryKey;
        }
      }

      setState(() => _isLoading = false);
    } catch (e) {
      debugPrint('从API获取历史记录失败: $e');
      setState(() => _isLoading = false);
    }
  }

  /// 关闭历史记录模块
  void _closeHistory() {
    setState(() {
      _isHidden = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 如果没有历史记录、正在加载或用户已关闭,返回空Widget
    if (_isLoading || _historyVideo == null || _isHidden) {
      return SizedBox.shrink();
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => JumpService.toDetail(
        video: {
          'shortPlayId': _historyVideo!.shortPlayId,
          'videoId': _historyVideo!.id ?? 0,
          'imageUrl': _historyVideo!.imageUrl ?? '',
        },
      ),
      child: Container(
        width: 293.w,
        height: 41.h, // 父容器高度固定
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('ely_home_history.png'.icon),
            fit: BoxFit.fill,
          ),
        ),

        // 使用 Stack 才能允许内部元素越界显示
        child: Stack(
          clipBehavior: Clip.none, // 关键点：允许溢出显示
          children: [
            // 让图片溢出显示（最关键部分）
            Positioned(
              left: 24.w,
              bottom: 6.h, // 计算方式：60h - 41h = 溢出 19h
              child: ElNetworkImage(
                imageUrl: _historyVideo!.imageUrl ?? '',
                width: 45.w,
                height: 60.h,
                borderRadius: BorderRadius.circular(9.r),
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.only(left: 80.w, right: 6.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 左侧：信息区，占满剩余空间
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _historyVideo!.name ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontFamily: 'PingFang SC',
                              fontWeight: FontWeight.w500,
                              height: 1.50,
                            ),
                          ),
                          Text(
                            'Last Watch: Ep.${_historyVideo!.process ?? 1}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.75),
                              fontSize: 10,
                              fontFamily: 'PingFang SC',
                              fontWeight: FontWeight.w300,
                              height: 1.20,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 右侧：按钮组（整体右对齐）
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'ely_home_history_play.png'.icon,
                          width: 20.w,
                          height: 20.w,
                        ),
                        SizedBox(width: 6.w),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: _closeHistory,
                          child: Padding(
                            padding: EdgeInsets.all(4.w), // 扩大点击热区
                            child: Image.asset(
                              'ely_delete_history.png'.icon,
                              width: 16.w,
                              height: 16.w,
                            ),
                          ),
                        ),
                      ],
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
}

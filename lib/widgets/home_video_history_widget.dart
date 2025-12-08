import 'dart:convert';
import 'package:elyra/bean/short_video_bean.dart';
import 'package:elyra/extend/el_string.dart';
import 'package:elyra/request/http.dart';
import 'package:elyra/request/index.dart';
import 'package:elyra/routers/el_routers.dart';
import 'package:elyra/utils/el_color.dart';
import 'package:elyra/utils/el_store.dart';
import 'package:elyra/utils/el_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// 首页历史记录组件
class HomeVideoHistoryWidget extends StatefulWidget {
  const HomeVideoHistoryWidget({super.key});

  @override
  State<HomeVideoHistoryWidget> createState() => _HomeVideoHistoryWidgetState();
}

class _HomeVideoHistoryWidgetState extends State<HomeVideoHistoryWidget> {
  ShortVideoBean? _historyVideo;
  bool _isLoading = true;

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
        queryParameters: {
          'current_page': 1,
          'page_size': 1,
        },
      );

      if (res.success && res.data['list'] != null && res.data['list'].isNotEmpty) {
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
      }

      setState(() => _isLoading = false);
    } catch (e) {
      debugPrint('从API获取历史记录失败: $e');
      setState(() => _isLoading = false);
    }
  }

  /// 跳转到播放页
  void _navigateToPlay() {
    if (_historyVideo == null) return;

    Get.toNamed(
      AppRoutes.playDetail,
      arguments: {
        'shortPlayId': _historyVideo!.shortPlayId,
        'videoId': _historyVideo!.id ?? 0,
        'imageUrl': _historyVideo!.imageUrl ?? '',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 如果没有历史记录或正在加载,返回空Widget
    if (_isLoading || _historyVideo == null) {
      return SizedBox.shrink();
    }

    return GestureDetector(
      onTap: _navigateToPlay,
      child: Container(
        width: 293.w,
        height: 41.h,
        margin: EdgeInsets.only(bottom: 10.h),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('ely_home_history.png'.icon),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 24.w, bottom: 6.h),
          child: Row(
            children: [
              // 剧集封面
              ClipRRect(
                borderRadius: BorderRadius.circular(4.w),
                child: Image.network(
                  _historyVideo!.imageUrl ?? '',
                  width: 45.w,
                  height: 60.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 45.w,
                      height: 60.h,
                      color: Colors.grey[300],
                      child: Icon(Icons.broken_image, color: Colors.grey),
                    );
                  },
                ),
              ),
              
              SizedBox(width: 10.w),
              
              // 剧集信息
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 标题
                    Text(
                      _historyVideo!.name ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    
                    // 观看进度
                    Text(
                      'Last Watch: Ep.${_historyVideo!.process ?? 1}',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              
              // 播放按钮
              Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: Image.asset(
                  'ely_home_history_play.png'.icon,
                  width: 28.w,
                  height: 28.w,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

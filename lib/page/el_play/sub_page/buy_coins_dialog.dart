import 'package:elyra/bean/short_play_detail_bean.dart';
import 'package:elyra/bean/user_info.dart';
import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/el_me/controller.dart';
import 'package:elyra/page/el_play/controller.dart';
import 'package:elyra/page/el_store/controller.dart';
import 'package:elyra/page/el_store/sub_page/store_content_widget.dart';
import 'package:elyra/widgets/bad_status_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// 购买金币弹框
class BuyCoinsDialog extends StatefulWidget {
  final UserInfo? userInfo; // 用户信息
  final EpisodeList? currentEpisode; // 当前剧集
  final VoidCallback? onPurchaseSuccess; // 购买成功回调
  final PlayDetailController playController; // 播放控制器

  const BuyCoinsDialog({
    super.key,
    this.userInfo,
    this.currentEpisode,
    this.onPurchaseSuccess,
    required this.playController,
  });

  @override
  State<BuyCoinsDialog> createState() => _BuyCoinsDialogState();
}

class _BuyCoinsDialogState extends State<BuyCoinsDialog> {
  late final StorePageController storeController;

  @override
  void initState() {
    super.initState();
    // 初始化 StorePageController，使用 tag 避免与其他页面冲突
    storeController = Get.put(
      StorePageController()..isDialogInstance = true, // 🔥 设置为对话框实例
      tag: 'buy_coins_dialog',
    );
    
    // 加载商店数据
    storeController.loadData();
  }

  /// 获取 MePageController 的用户信息
  UserInfo? _getUserInfo() {
    try {
      if (Get.isRegistered<MePageController>()) {
        final meController = Get.find<MePageController>();
        return meController.state.customerInfo;
      }
    } catch (e) {
      debugPrint('获取 MePageController 用户信息失败: $e');
    }
    return widget.userInfo; // 降级方案：使用传入的 userInfo
  }

  @override
  void dispose() {
    // 清理 controller
    Get.delete<StorePageController>(tag: 'buy_coins_dialog');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.60)),
        child: GetBuilder<StorePageController>(
          tag: 'buy_coins_dialog',
          init: storeController, // 添加 init 参数确保控制器存在
          builder: (controller) {
            return Column(
              children: [
                _buildHeader(),
                Expanded(child: _buildContent(controller)),
              ],
            );
          },
        ),
      ),
    );
  }

  /// 内容区域
  Widget _buildContent(StorePageController controller) {
    if (controller.state.loadStatus == LoadStatusType.loading) {
      return Center(
        child: Image.asset('loading.gif'.icon, width: 120, height: 120),
      );
    }

    if (controller.state.loadStatus == LoadStatusType.loadFailed) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('ely_error.png'.icon, width: 180.w, height: 180.h),
            SizedBox(height: 20.h),
            Text(
              'Failed to load store data',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            SizedBox(height: 10.h),
            TextButton(
              onPressed: controller.onRefresh,
              child: Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    return StoreContentWidget(
      controllerTag: 'buy_coins_dialog',
      showTips: true,
    );
  }

  /// 头部 - 使用 GetBuilder 实现响应式更新
  Widget _buildHeader() {
    return GetBuilder<MePageController>(
      autoRemove: false, // 不自动移除，避免 controller 被清理
      builder: (meController) {
        final userInfo = _getUserInfo();
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            children: [
              // 第一行：Ep.x 标题
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Ep.${widget.currentEpisode?.episode ?? 1}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              // 第二行：Price和Balance
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Row(
                        children: [
                          Text(
                            'Price: ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Image.asset(
                            'ely_gold.png'.icon,
                            width: 16.w,
                            height: 16.w,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '${userInfo?.coinLeftTotal ?? 0}',
                            style: TextStyle(
                              color: Color(0xFFFFD67C),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 24.w),
                      // Balance
                      Row(
                        children: [
                          Text(
                            'Balance: ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Image.asset(
                            'ely_gold.png'.icon,
                            width: 16.w,
                            height: 16.w,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            '${userInfo?.sendCoinLeftTotal ?? 0}',
                            style: TextStyle(
                              color: Color(0xFFFFD67C),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // 关闭按钮
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Padding(
                      padding: EdgeInsets.all(5.w),
                      child: Image.asset('ely_close.png'.icon, height: 20.h),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

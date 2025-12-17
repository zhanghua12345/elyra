import 'package:elyra/bean/short_play_detail_bean.dart';
import 'package:elyra/bean/user_info.dart';
import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/el_me/controller.dart';
import 'package:elyra/page/el_play/controller.dart';
import 'package:elyra/page/el_store/controller.dart';
import 'package:elyra/page/el_store/sub_page/store_content_widget.dart';
import 'package:elyra/utils/iap_util.dart';
import 'package:elyra/widgets/bad_status_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

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
  UserInfo? _latestUserInfo; // 最新的用户信息
  bool _isPurchaseSuccessful = false; // 标记是否购买成功

  @override
  void initState() {
    super.initState();
    _latestUserInfo = widget.userInfo;
    // 初始化 StorePageController，使用 tag 避免与其他页面冲突
    storeController = Get.put(StorePageController(), tag: 'buy_coins_dialog');
    // 监听购买状态
    _listenToPurchaseStatus();
  }

  /// 监听购买状态
  void _listenToPurchaseStatus() {
    // 监听 StorePageController 的购买流
    storeController.state.purchaseSubscription =
        storeController.state.purchaseSubscription ??
        InAppPurchaseUtil.purchaseStream.listen((
          List<PurchaseDetails> purchaseDetailsList,
        ) async {
          for (var purchaseDetails in purchaseDetailsList) {
            if (purchaseDetails.status == PurchaseStatus.purchased) {
              // 购买成功，刷新用户信息
              await _refreshUserInfo();
              _isPurchaseSuccessful = true;
            }
          }
        });
  }

  /// 刷新用户信息
  Future<void> _refreshUserInfo() async {
    final userInfo = await widget.playController.getUserInfo();
    if (userInfo != null && mounted) {
      setState(() {
        _latestUserInfo = userInfo;
      });
      
      // 同步更新 MePageController 的 customerInfo
      try {
        if (Get.isRegistered<MePageController>()) {
          final meController = Get.find<MePageController>();
          meController.state.customerInfo = userInfo;
          meController.update();
        }
      } catch (e) {
        debugPrint('更新 MePageController 失败: $e');
      }
    }
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

  /// 头部
  Widget _buildHeader() {
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
                        '${_latestUserInfo?.coinLeftTotal ?? 0}',
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
                        '${_latestUserInfo?.sendCoinLeftTotal ?? 0}',
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
              // Price
              GestureDetector(
                onTap: _handleClose,
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
  }

  /// 处理关闭按钮
  void _handleClose() async {
    // 如果购买成功，先刷新一次用户信息确保数据最新
    if (_isPurchaseSuccessful) {
      await _refreshUserInfo();
    }

    // 检查金币是否足够解锁当前剧集
    final episode = widget.currentEpisode;
    if (episode != null && episode.isLock == true) {
      final totalCoins =
          (_latestUserInfo?.coinLeftTotal ?? 0) +
          (_latestUserInfo?.sendCoinLeftTotal ?? 0);
      final requiredCoins = episode.coins ?? 0;

      if (totalCoins < requiredCoins) {
        // 金币不够，关闭当前弹窗后重新弹出锁定弹窗
        Get.back();
        // 延迟一下确保弹窗关闭动画完成
        await Future.delayed(Duration(milliseconds: 300));
        widget.playController.state.showLockDialog = true;
        widget.playController.update();
        return;
      }
    }

    // 金币足够或其他情况，直接关闭
    Get.back();
  }
}

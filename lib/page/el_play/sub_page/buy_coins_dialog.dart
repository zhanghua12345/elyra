import 'package:elyra/bean/pay_settings_bean.dart';
import 'package:elyra/bean/short_play_detail_bean.dart';
import 'package:elyra/bean/user_info.dart';
import 'package:elyra/extend/el_string.dart';
import 'package:elyra/page/el_me/controller.dart';
import 'package:elyra/page/el_play/controller.dart';
import 'package:elyra/page/el_popup/recharge_coins_pack_again.dart';
import 'package:elyra/page/el_store/controller.dart';
import 'package:elyra/page/el_store/sub_page/store_content_widget.dart';
import 'package:elyra/request/http.dart';
import 'package:elyra/request/index.dart';
import 'package:elyra/widgets/bad_status_widget.dart';
import 'package:elyra/widgets/el_nodata_widget.dart';
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
  bool _hasPaid = false; // 标记是否已支付

  @override
  void initState() {
    super.initState();
    // 初始化 StorePageController,使用 tag 避免与其他页面冲突
    storeController = Get.put(
      StorePageController()
        ..isDialogInstance = true // 🔥 设置为对话框实例
        ..onPaymentSuccess = markAsPaid, // 🔥 设置支付成功回调
      tag: 'buy_coins_dialog',
    );
  
    // 🔥 关键修复:等待数据加载完成后再更新UI
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        storeController.loadData();
      }
    });
  }
  
  /// 标记支付已完成
  void markAsPaid() {
    _hasPaid = true;
  }

  /// 关闭弹窗后重新尝试解锁
  void _retryUnlock() async {
    final currentEpisode = widget.currentEpisode;
    if (currentEpisode == null || currentEpisode.isLock != true) return;

    // 延迟执行，确保弹窗已完全关闭
    await Future.delayed(Duration(milliseconds: 300));

    // 重新检查并尝试解锁
    await widget.playController.autoCheckAndUnlock(
      currentEpisode.coins ?? 0,
      widget.playController.currentIndex,
    );
  }

  /// 处理关闭按钮点击
  void _handleClose() async {
    // 如果已经支付，直接关闭并解锁
    if (_hasPaid) {
      Get.back();
      _retryUnlock();
      return;
    }

    // 未支付，调用挽留接口
    try {
      final res = await HttpClient().request(
        Apis.getRetainVipPaySetting,
        method: HttpMethod.get,
      );

      debugPrint('🔥 挽留接口返回: ${res.data}');
      debugPrint('🔥 res.data类型: ${res.data.runtimeType}');
      
      if (res.success && res.data != null) {
        // 先打印 info 的类型
        if (res.data['info'] != null) {
          debugPrint('🔥 info类型: ${res.data['info'].runtimeType}');
        }
        
        // 判断 info 是否是 Map 类型
        Map<String, dynamic>? infoData;
        if (res.data['info'] is Map<String, dynamic>) {
          infoData = res.data['info'];
        } else if (res.data['info'] is Map) {
          infoData = Map<String, dynamic>.from(res.data['info']);
        }
        
        if (infoData != null) {
          // 🔥 从接口数据中获取商品ID
          final retainItemId = infoData['id'];
          debugPrint('🔥 挽留商品ID: $retainItemId');
          
          // 🔥 从 StorePageController 中查找对应的商品（已包含 productDetails）
          final allItems = [
            ...storeController.state.coinsBigList,
            ...storeController.state.coinsSmallList,
            ...storeController.state.coinsWeekList,
            ...storeController.state.subList,
          ];
          
          final retainItem = allItems.firstWhereOrNull(
            (item) => item.id == retainItemId,
          );
          
          if (retainItem != null) {
            debugPrint('✅ 找到匹配的商品: ${retainItem.description}');
            
            // 关闭当前弹窗
            Get.back();
            
            // 延迟弹起挽留弹窗，传递支付成功回调
            await Future.delayed(Duration(milliseconds: 300));
            RechargeCoinsPackAgainPopup.show(
              retainItem,
              onPaymentSuccess: () {
                // 挽留弹窗支付成功后，解锁剧集
                _retryUnlock();
              },
            );
          } else {
            debugPrint('❌ 未找到匹配的商品，ID: $retainItemId');
            Get.back();
          }
        } else {
          debugPrint('❌ info 不是 Map 类型');
          Get.back();
        }
      } else {
        // 接口失败，直接关闭
        Get.back();
      }
    } catch (e, stackTrace) {
      debugPrint('获取挽留商品失败: $e');
      debugPrint('堆栈信息: $stackTrace');
      // 接口异常，直接关闭
      Get.back();
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
      body: GetBuilder<StorePageController>(
        tag: 'buy_coins_dialog',
        init: storeController,
        builder: (controller) {
          // 数据已准备就绪，渲染完整界面
          return Container(
            decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.60)),
            child: Column(
              children: [
                // 🔥 使用 LayoutBuilder 获取正确的安全距离
                LayoutBuilder(
                  builder: (context, constraints) {
                    final view = View.of(context);
                    final viewPadding = view.viewPadding;
                    final devicePixelRatio = view.devicePixelRatio;
                    final topPadding = viewPadding.top / devicePixelRatio;
                    
                    debugPrint('💡 顶部安全距离: $topPadding');
                    
                    return SizedBox(height: topPadding);
                  },
                ),
                Expanded(
                  child: Column(
                    children: [
                      _buildHeader(),
                      Expanded(child: _buildContent(controller)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
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
      return ElNoDataWidget(
        imagePath: 'ely_error.png',
        title: 'No connection',
        description: 'Please check your network',
        buttonText: 'Try again',
        onButtonPressed: controller.onRefresh,
      );
    }

    return StoreContentWidget(
      controllerTag: 'buy_coins_dialog',
      showTips: true,
    );
  }

  /// 头部 - 显示用户金币信息
  Widget _buildHeader() {
    final userInfo = widget.userInfo;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
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
            onTap: _handleClose,
            child: Padding(
              padding: EdgeInsets.all(5.w),
              child: Image.asset('ely_close.png'.icon, height: 20.h),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:async';
import 'dart:io';
import 'package:elyra/bean/pay_settings_bean.dart';
import 'package:elyra/page/el_me/controller.dart';
import 'package:elyra/page/el_popup/pay_buy_info.dart';
import 'package:elyra/page/el_store/state.dart';
import 'package:elyra/request/http.dart';
import 'package:elyra/request/index.dart';
import 'package:elyra/utils/iap_util.dart';
import 'package:elyra/utils/purchase_restore_util.dart';
import 'package:elyra/utils/toast.dart';
import 'package:elyra/utils/user_util.dart';
import 'package:elyra/widgets/bad_status_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class StorePageController extends GetxController {
  final state = StoreState();
  final RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );

  // 🔥 新增:标记是否是对话框中的实例
  bool isDialogInstance = false;

  // 🔥 支付成功回调(用于通知外部)
  VoidCallback? onPaymentSuccess;

  @override
  void onReady() {
    super.onReady();
    loadData();
    initPurchaseListener();

    // 🔥 关键修复：只在非对话框实例中自动恢复购买
    if (!isDialogInstance) {
      // 自动恢复购买（静默执行）
      Future.delayed(Duration(seconds: 1), () {
        restorePay(showTips: false);
      });
    }
  }

  @override
  void onClose() {
    refreshController.dispose();
    InAppPurchaseUtil.cancelStreamSubscription(state.purchaseSubscription);
    super.onClose();
  }

  /// 加载数据
  void loadData({bool isSilent = false}) async {
    if (state.isLoading) return;
    state.isLoading = true;
    if (!isSilent) {
      state.loadStatus = LoadStatusType.loading;
    } else {
      EasyLoading.show(
        status: 'Loading...',
        maskType: EasyLoadingMaskType.clear,
      );
    }
    update();

    try {
      // 获取Receipt（iOS）
      Map<String, dynamic> params = {};
      if (Platform.isIOS) {
        try {
          final receipt = await SKReceiptManager.retrieveReceiptData();
          params['purchases_token'] = receipt;
          debugPrint('----receipt:$receipt');
        } catch (e) {
          debugPrint('---receipt err:$e');
        }
      }

      // 调用支付配置接口
      final res = await HttpClient().request(
        Apis.paySettingsV4,
        data: params,
        method: HttpMethod.post,
      );

      if (res.success && res.data != null) {
        state.paySettings = PaySettingsBean.fromJson(res.data);

        // 🔥 关键修复：添加空检查
        if (state.paySettings != null && state.paySettings!.sort.isNotEmpty) {
          state.sortList = state.paySettings!.sort;

          // 初始化商店商品 (内部会完成商品匹配、过滤、分类及 UI 更新，避免 intermediate 状态导致 UI 闪烁)
          await initStore();

          state.loadStatus = LoadStatusType.loadSuccess;
        } else {
          debugPrint('加载失败: paySettings 或 sort 为 null');
          state.loadStatus = LoadStatusType.loadFailed;
        }
      } else {
        state.loadStatus = LoadStatusType.loadFailed;
      }
    } catch (err) {
      debugPrint('加载失败: $err');
      state.loadStatus = LoadStatusType.loadFailed;
    } finally {
      state.isLoading = false;
      refreshController.refreshCompleted();
      if (isSilent) EasyLoading.dismiss();
      update();
    }
  }

  /// 分类数据
  void _classifyData() {
    if (state.paySettings == null) return;

    final allItems = [
      ...state.paySettings!.listCoins,
      ...state.paySettings!.listSubVip,
    ];

    // 按类型分类
    state.coinsBigList = _filterAndSort(allItems, 'coins', 'big');
    state.coinsSmallList = _filterAndSort(allItems, 'coins', 'small');
    state.coinsWeekList = _filterAndSort(allItems, 'sub_coins');
    state.subList = _filterAndSort(allItems, 'sub_vip');
  }

  /// 筛选和排序数据
  List<PayItem> _filterAndSort(
    List<PayItem> items,
    String buyType, [
    String? size,
  ]) {
    var filtered = items.where((item) {
      if (size != null) {
        return item.buyType == buyType && item.size == size;
      }
      return item.buyType == buyType;
    }).toList();

    // 按 sort 字段降序排列
    filtered.sort((a, b) => b.sort.compareTo(a.sort));
    return filtered;
  }

  /// 下拉刷新
  void onRefresh() {
    loadData();
  }

  /// 初始化商店商品（匹配iOS/Android商店）
  Future<void> initStore() async {
    try {
      // 🔥 关键修复：添加空检查
      if (state.paySettings == null) {
        debugPrint('initStore 错误: paySettings 为 null');
        return;
      }

      bool isAvailable = await InAppPurchaseUtil.isAvailable();
      if (!isAvailable) {
        Message.show('In App purchase is not available');
        return;
      }

      // 产品ID
      List<String> productIds = [];
      List<String> vipIds = [];

      if (Platform.isIOS) {
        productIds = state.paySettings!.listCoins
            .map((item) => 'elyra.${item.iosTemplateId}')
            .toList();
        vipIds = state.paySettings!.listSubVip
            .map((item) => 'elyra.${item.iosTemplateId}')
            .toList();
      } else {
        productIds = state.paySettings!.listCoins
            .where((item) => item.androidTemplateId != null)
            .map((item) => item.androidTemplateId!)
            .toList();
        vipIds = state.paySettings!.listSubVip
            .where((item) => item.androidTemplateId != null)
            .map((item) => item.androidTemplateId!)
            .toList();
      }

      if (productIds.isEmpty && vipIds.isEmpty) {
        Message.show('Pay item is empty');
        return;
      }

      ProductDetailsResponse productDetailsResponse =
          await InAppPurchaseUtil.queryProducts(<String>{
            ...vipIds,
            ...productIds,
          });

      if (productDetailsResponse.error != null) {
        debugPrint(
          '----productDetailsResponse.error${productDetailsResponse.error}',
        );
        Message.show(productDetailsResponse.error!.message);
        return;
      }
      debugPrint('---未找到的商品: ${productDetailsResponse.notFoundIDs.join(', ')}');

      debugPrint(
        '----productDetailsResponse:${productDetailsResponse.productDetails.length}',
      );
      if (productDetailsResponse.productDetails.isEmpty) {
        Message.show('Query store is empty');
        return;
      }

      // 匹配商品
      if (Platform.isIOS) {
        for (var item in state.paySettings!.listCoins) {
          for (var detail in productDetailsResponse.productDetails) {
            if (detail.id == 'elyra.${item.iosTemplateId}') {
              item.productDetails = detail;
              break;
            }
          }
        }
        for (var item in state.paySettings!.listSubVip) {
          for (var detail in productDetailsResponse.productDetails) {
            if (detail.id == 'elyra.${item.iosTemplateId}') {
              item.productDetails = detail;
              break;
            }
          }
        }
      } else if (Platform.isAndroid) {
        for (var item in state.paySettings!.listCoins) {
          for (var detail in productDetailsResponse.productDetails) {
            if (detail.id == item.androidTemplateId) {
              item.productDetails = detail;
              break;
            }
          }
        }
        for (var item in state.paySettings!.listSubVip) {
          for (var detail in productDetailsResponse.productDetails) {
            if (detail.id == item.androidTemplateId) {
              item.productDetails = detail;
              break;
            }
          }
        }
      }

      // 移除未匹配到的商品
      state.paySettings!.listCoins.removeWhere(
        (item) => item.productDetails == null,
      );
      state.paySettings!.listSubVip.removeWhere(
        (item) => item.productDetails == null,
      );

      // 重新分类
      _classifyData();
      update();
    } catch (e) {
      debugPrint('初始化商店失败: $e');
      Message.show('Failed to initialize store');
    }
  }

  /// 处理支付
  void handlePay(
    PayItem item, {
    num? shortPlayId,
    num? videoId,
    bool isPopup = false,
  }) {
    debugPrint('点击支付: ${item.buyType} - ${item.coins} coins');

    if (isPopup) {
      // 显示弹窗
      StorePopupBuy.show(controller: this, item: item);
    } else {
      // 直接拉起支付
      createOrder(item, shortPlayId: shortPlayId, videoId: videoId);
    }
  }

  /// 初始化购买监听器
  void initPurchaseListener() {
    state.purchaseSubscription = InAppPurchaseUtil.purchaseStream.listen(
      (List<PurchaseDetails> purchaseDetailsList) {
        state.purchaseList = purchaseDetailsList;
        _listenToPurchaseUpdated(purchaseDetailsList);
      },
      onDone: () {
        state.purchaseSubscription?.cancel();
      },
      onError: (err) {
        debugPrint('---stream-err:$err');
      },
    );
  }

  /// 购买监听回调
  Future<void> _listenToPurchaseUpdated(
    List<PurchaseDetails> purchaseDetailsList,
  ) async {
    for (var purchaseDetails in purchaseDetailsList) {
      debugPrint(
        '---listen-purchaseDetails:${purchaseDetailsList.length} ${purchaseDetails.productID} ${purchaseDetails.status} ${purchaseDetails.pendingCompletePurchase}',
      );

      if (purchaseDetails.status == PurchaseStatus.pending) {
        // 购买中
        debugPrint('Purchase is pending: ${purchaseDetails.productID}');
      } else if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        // 购买成功或恢复购买
        debugPrint(
          'Purchase successful: ${purchaseDetails.productID} ${purchaseDetails.status}',
        );

        try {
          // 查找匹配的商品
          PayItem? goods =
              [
                ...state.coinsBigList,
                ...state.coinsSmallList,
                ...state.coinsWeekList,
                ...state.subList,
              ].firstWhereOrNull(
                (item) => item.productDetails?.id == purchaseDetails.productID,
              );

          // 只处理当前点击的订单或手动恢复流程
          if (goods != null &&
              (goods.orderCode == state.currentOrderCode ||
                  purchaseDetails.status == PurchaseStatus.restored)) {
            goods.transactionId = purchaseDetails.purchaseID;
            goods.serverVerificationData =
                purchaseDetails.verificationData.serverVerificationData;

            // 支付完成后，展示验证中的 loading
            EasyLoading.show(
              status: 'Loading...',
              maskType: EasyLoadingMaskType.clear,
            );

            bool isSuccess = await verifyPay(goods);

            // 支付后清空当前订单号
            if (goods.orderCode == state.currentOrderCode) {
              state.currentOrderCode = "";
              goods.orderCode = null;
            }

            if (isSuccess) {
              InAppPurchaseUtil.consumeIfNeeded(purchaseDetails);
            }
          } else {
            debugPrint('收到了非当前订单的流信息: ${purchaseDetails.productID}');
          }
        } catch (e) {
          debugPrint('--purchase-success-err:$e');
          EasyLoading.dismiss();
          state.currentOrderCode = "";
        }
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        // 购买失败
        debugPrint('Purchase failed: ${purchaseDetails.error?.message}');
        EasyLoading.dismiss();
        UserUtil().reportErrorEvent(
          'platform pay failed',
          'pay_error',
          orderCode: state.currentOrderCode,
          errMsg: purchaseDetails.error?.toString(),
        );

        if (purchaseDetails.error?.message.contains('itemAlreadyOwned') ??
            false) {
          InAppPurchaseUtil.completePurchase(purchaseDetails, isRetry: true);
        } else {
          Message.show('Payment Error');
        }
        state.currentOrderCode = "";
      } else if (purchaseDetails.status == PurchaseStatus.canceled) {
        // 购买取消
        debugPrint('Purchase canceled: ${purchaseDetails.productID}');
        EasyLoading.dismiss();
        Message.show('User canceled');

        UserUtil().reportErrorEvent(
          'user pay canceled',
          'pay_cancel',
          orderCode: state.currentOrderCode,
        );
        state.currentOrderCode = "";
      }
      InAppPurchaseUtil.completePurchase(purchaseDetails);
    }
  }

  /// 创建订单
  Future<void> createOrder(
    PayItem goods, {
    num? shortPlayId,
    num? videoId,
  }) async {
    // 检查 productDetails 是否存在（防止模拟器空指针错误）
    if (goods.productDetails == null) {
      Message.show('Product not available in store');
      debugPrint(
        '---createOrder-error: productDetails is null for ${goods.id}',
      );
      return;
    }

    EasyLoading.show(status: 'Paying...', maskType: EasyLoadingMaskType.clear);

    Map<String, dynamic> params = {
      "pay_setting_id": goods.id,
      "is_discount": goods.discountType == 0 ? 0 : 1,
    };

    if (Platform.isIOS && params["is_discount"] == 1) {
      final product = goods.productDetails as AppStoreProductDetails;
      if (product.skProduct.discounts.isNotEmpty) {
        params['product_discount'] =
            product.skProduct.discounts.first.identifier!;
      }
    }

    if (shortPlayId != null) {
      params['short_play_id'] = shortPlayId;
      state.shortPlayId = shortPlayId;
    }
    if (videoId != null) {
      params['video_id'] = videoId;
      state.videoId = videoId;
    }

    ApiResponse res = await HttpClient().request(
      Apis.createOrder,
      data: params,
    );

    if (res.success) {
      if (res.data['code'] == 30007) {
        EasyLoading.dismiss();
        Message.show('You are already subscribed!');
        return;
      }

      final orderCode = res.data['order_code'];
      if (orderCode == null || orderCode.isEmpty) {
        EasyLoading.dismiss();
        Message.show('Failed to create order');
        return;
      }

      goods.orderCode = orderCode;
      state.currentOrderCode = orderCode;

      // 执行购买
      try {
        if (goods.discountType != null && goods.discountType! > 0) {
          // 有折扣
          if (Platform.isIOS) {
            if (goods.discountType == 2 && res.data['discount'] != null) {
              final product = goods.productDetails as AppStoreProductDetails;
              final signData = res.data['discount']['sign_data'];
              final purchaseParamSk2 = AppStorePurchaseParam(
                productDetails: goods.productDetails!,
                applicationUserName: signData['application_username'],
                discount: SKPaymentDiscountWrapper(
                  identifier: product.skProduct.discounts.first.identifier!,
                  keyIdentifier: signData['key_identifier'],
                  nonce: signData['nonce'],
                  signature: signData['signature'],
                  timestamp: signData['timestamp'],
                ),
              );
              await InAppPurchaseUtil.buyDiscount(purchaseParamSk2);
            } else {
              await InAppPurchaseUtil.buy(
                goods.productDetails!,
                consumable: goods.buyType == 'coins',
              );
            }
          } else if (Platform.isAndroid) {
            if (goods.productDetails! is GooglePlayProductDetails) {
              final googleProduct =
                  goods.productDetails! as GooglePlayProductDetails;
              if (googleProduct.productDetails.subscriptionOfferDetails !=
                  null) {
                final offer = googleProduct
                    .productDetails
                    .subscriptionOfferDetails!
                    .first;
                final purchaseParam = GooglePlayPurchaseParam(
                  productDetails: goods.productDetails!,
                  offerToken: offer.offerIdToken,
                );
                await InAppPurchaseUtil.buyDiscount(purchaseParam);
              }
            }
          }
        } else {
          // 无折扣
          if (Platform.isAndroid &&
              goods.productDetails! is GooglePlayProductDetails) {
            final googleProduct =
                goods.productDetails! as GooglePlayProductDetails;
            if (googleProduct.productDetails.subscriptionOfferDetails != null) {
              final offerList =
                  googleProduct.productDetails.subscriptionOfferDetails!;
              final offerIdToken = offerList.length > 1
                  ? offerList[1].offerIdToken
                  : offerList[0].offerIdToken;
              final purchaseParam = GooglePlayPurchaseParam(
                productDetails: goods.productDetails!,
                offerToken: offerIdToken,
              );
              await InAppPurchaseUtil.buyDiscount(purchaseParam);
            } else {
              await InAppPurchaseUtil.buy(
                goods.productDetails!,
                consumable: goods.buyType == 'coins',
              );
            }
          } else {
            await InAppPurchaseUtil.buy(
              goods.productDetails!,
              consumable: goods.buyType == 'coins',
            );
          }
        }
      } catch (e) {
        EasyLoading.dismiss();
        Message.show(
          'There were some problems with the payment, Please try again!',
        );
        debugPrint('---purchase-error:$e');

        UserUtil().reportErrorEvent(
          'platform pay timeout',
          'pay_platform_timeout',
          orderCode: goods.orderCode,
          errMsg: e.toString(),
        );

        InAppPurchaseUtil.clearFailedPurchases();

        for (var item in state.purchaseList) {
          if (item.productID == goods.productDetails?.id) {
            InAppPurchaseUtil.completePurchase(item);
          }
        }
      }
    } else {
      EasyLoading.dismiss();
      Message.show('Failed to create order');
      goods.orderCode = null;
    }
  }

  /// 校验订单
  Future<bool> verifyPay(
    PayItem goods, {
    bool isRestore = false,
    bool isAuto = false,
  }) async {
    String transactionId = goods.transactionId ?? "";
    String serverVerificationData = goods.serverVerificationData ?? "";

    Map<String, dynamic> params = {
      'pkg_name': "elyra",
      'order_code': goods.orderCode ?? "",
      'product_id': Platform.isAndroid
          ? goods.androidTemplateId
          : goods.iosTemplateId,
      'show_money': goods.price,
      'pay_setting_id': goods.id.toString(),
      'transaction_id': transactionId,
      'purchases_token': serverVerificationData,
    };

    if (isRestore) {
      UserUtil().reportErrorEvent(
        'pay restore',
        'pay_restore',
        type: isAuto ? 'auto' : 'manual',
        orderCode: goods.orderCode,
        transactionId: transactionId,
      );
    } else {
      UserUtil().reportErrorEvent(
        'requested server paying',
        'pay_paying',
        orderCode: goods.orderCode,
        transactionId: transactionId,
      );
    }

    try {
      ApiResponse res = await HttpClient().request(
        Apis.applePaid,
        data: params,
      );
      if (res.success && res.data['status'] == 'success') {
        if (!isRestore) {
          EasyLoading.showSuccess(
            'Pay Success',
            maskType: EasyLoadingMaskType.clear,
          );

          // 如果是弹窗实例，支付成功后自动关闭弹窗
          if (isDialogInstance) {
            Get.back();
          }
          loadData(isSilent: true);
        }
        // 充值成功后更新 el_me 页面的用户信息
        _refreshMePageUserInfo();

        // 🔥 触发支付成功回调
        onPaymentSuccess?.call();

        // 移除缓存
        PurchaseRestoreUtil().removeGoods(goods);
        return true;
      }

      UserUtil().reportErrorEvent(
        'pay callback failed',
        'pay_callback',
        orderCode: goods.orderCode,
        transactionId: transactionId,
        errMsg: res.message ?? 'Unknown error',
      );

      if (!isRestore) {
        EasyLoading.dismiss();
        PurchaseRestoreUtil().cacheFailedGoods(goods);
      }
      return false;
    } catch (e) {
      if (!isRestore) {
        EasyLoading.dismiss();
        PurchaseRestoreUtil().cacheFailedGoods(goods);
      }
      debugPrint('---verifyPay-err:$e');
      return false;
    }
  }

  /// 恢复购买
  Future<void> restorePay({bool showTips = true}) async {
    if (state.isRestore) return;
    state.isRestore = true;

    List<PayItem> restoreGoodsList = await PurchaseRestoreUtil()
        .getCachedGoodsList();
    debugPrint('----restoreGoodsList:${restoreGoodsList.length}');

    if (restoreGoodsList.isEmpty) {
      state.isRestore = false;
      if (showTips) Message.show('No Products To Restore');
      return;
    }

    EasyLoading.show(status: 'Restore...', maskType: EasyLoadingMaskType.clear);
    for (PayItem payItem in restoreGoodsList) {
      bool isSuccess = await verifyPay(
        payItem,
        isRestore: true,
        isAuto: !showTips,
      );
      if (isSuccess) {
        PurchaseRestoreUtil().removeGoods(payItem);
      }
    }
    EasyLoading.dismiss();

    state.isRestore = false;

    if (showTips) {
      Message.show('Restore completed');
    }
  }

  /// 刷新 MePageController 的用户信息
  void _refreshMePageUserInfo() {
    try {
      if (Get.isRegistered<MePageController>()) {
        final meController = Get.find<MePageController>();
        // 调用 getUserInfo 方法刷新用户数据
        meController.getUserInfo();
      }
    } catch (e) {
      debugPrint('刷新 MePageController 用户信息失败: $e');
    }
  }
}

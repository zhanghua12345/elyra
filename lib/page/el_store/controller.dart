import 'dart:async';
import 'dart:io';
import 'package:elyra/bean/pay_settings_bean.dart';
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

  @override
  void onReady() {
    super.onReady();
    loadData();
    initPurchaseListener();
    // 自动恢复购买（静默执行）
    Future.delayed(Duration(seconds: 1), () {
      restorePay(showTips: false);
    });
  }

  @override
  void onClose() {
    refreshController.dispose();
    InAppPurchaseUtil.cancelStreamSubscription(state.purchaseSubscription);
    super.onClose();
  }

  /// 加载数据
  void loadData() async {
    if (state.isLoading) return;
    state.isLoading = true;
    state.loadStatus = LoadStatusType.loading;
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
        state.sortList = state.paySettings!.sort;

        // 分类数据
        _classifyData();
        
        // 初始化商店商品
        await initStore();

        state.loadStatus = LoadStatusType.loadSuccess;
      } else {
        state.loadStatus = LoadStatusType.loadFailed;
      }
    } catch (err) {
      debugPrint('加载失败: $err');
      state.loadStatus = LoadStatusType.loadFailed;
    } finally {
      state.isLoading = false;
      refreshController.refreshCompleted();
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
  List<PayItem> _filterAndSort(List<PayItem> items, String buyType, [String? size]) {
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
    EasyLoading.show(status: 'Loading...');
    bool isAvailable = await InAppPurchaseUtil.isAvailable();
    if (!isAvailable) {
      EasyLoading.dismiss();
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
      EasyLoading.dismiss();
      Message.show('Pay item is empty');
      return;
    }

    ProductDetailsResponse productDetailsResponse =
        await InAppPurchaseUtil.queryProducts(<String>{
      ...vipIds,
      ...productIds,
    });

    if (productDetailsResponse.error != null) {
      EasyLoading.dismiss();
      debugPrint('----productDetailsResponse.error${productDetailsResponse.error}');
      Message.show(productDetailsResponse.error!.message);
      return;
    }

    debugPrint('---未找到的商品: ${productDetailsResponse.notFoundIDs.join(', ')}');
    debugPrint('----productDetailsResponse:${productDetailsResponse.productDetails.length}');

    if (productDetailsResponse.productDetails.isEmpty) {
      EasyLoading.dismiss();
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
    state.paySettings!.listCoins.removeWhere((item) => item.productDetails == null);
    state.paySettings!.listSubVip.removeWhere((item) => item.productDetails == null);

    // 重新分类
    _classifyData();

    EasyLoading.dismiss();
    update();
  }

  /// 处理支付
  void handlePay(PayItem item, {num? shortPlayId, num? videoId}) {
    debugPrint('点击支付: ${item.buyType} - ${item.coins} coins');
    
    if (item.buyType == 'sub_coins') {
      // 金币包需要显示详情确认（暂不实现弹窗，直接购买）
      createOrder(item, shortPlayId: shortPlayId, videoId: videoId);
    } else {
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
      List<PurchaseDetails> purchaseDetailsList) async {
    for (var purchaseDetails in purchaseDetailsList) {
      debugPrint(
        '---listen-purchaseDetails:${purchaseDetailsList.length} ${purchaseDetails.productID} ${purchaseDetails.status} ${purchaseDetails.pendingCompletePurchase}',
      );

      if (purchaseDetails.status == PurchaseStatus.pending) {
        // 购买中
        debugPrint('Purchase is pending: ${purchaseDetails.productID}');
        InAppPurchaseUtil.completePurchase(purchaseDetails);
      } else if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        // 购买成功或恢复购买
        debugPrint(
          'Purchase successful: ${purchaseDetails.productID} ${purchaseDetails.status}',
        );

        try {
          // 查找匹配的商品
          PayItem? goods = [
            ...state.coinsBigList,
            ...state.coinsSmallList,
            ...state.coinsWeekList,
            ...state.subList,
          ].firstWhereOrNull(
              (item) => item.productDetails?.id == purchaseDetails.productID);

          if (goods == null) {
            UserUtil().reportErrorEvent(
              'platform pay failed',
              'pay_error',
              errMsg: '未找到匹配商品: ${purchaseDetails.productID}',
            );
            return;
          }

          // 设置交易信息
          goods.transactionId = purchaseDetails.purchaseID;
          goods.serverVerificationData =
              purchaseDetails.verificationData.serverVerificationData;

          EasyLoading.dismiss();

          if (goods.orderCode != null && goods.orderCode!.isNotEmpty) {
            bool isSuccess = await verifyPay(goods);
            if (isSuccess) {
              InAppPurchaseUtil.consumeIfNeeded(purchaseDetails);
            }
          }
        } catch (e) {
          debugPrint('--purchase-success-err:$e');
        }
        InAppPurchaseUtil.completePurchase(purchaseDetails);
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        // 购买失败
        debugPrint('Purchase failed: ${purchaseDetails.error?.message}');
        EasyLoading.dismiss();

        PayItem? goods = [
          ...state.coinsBigList,
          ...state.coinsSmallList,
          ...state.coinsWeekList,
          ...state.subList,
        ].firstWhereOrNull(
            (item) => item.productDetails?.id == purchaseDetails.productID);

        UserUtil().reportErrorEvent(
          'platform pay failed',
          'pay_error',
          orderCode: goods?.orderCode ?? '',
          errMsg: purchaseDetails.error?.toString(),
        );

        if (purchaseDetails.error?.message.contains('itemAlreadyOwned') ??
            false) {
          InAppPurchaseUtil.completePurchase(purchaseDetails, isRetry: true);
        } else {
          Message.show('There were some problems with the payment');
        }
      } else if (purchaseDetails.status == PurchaseStatus.canceled) {
        // 购买取消
        debugPrint('Purchase canceled: ${purchaseDetails.productID}');
        EasyLoading.dismiss();
        Message.show('User canceled');

        PayItem? goods = [
          ...state.coinsBigList,
          ...state.coinsSmallList,
          ...state.coinsWeekList,
          ...state.subList,
        ].firstWhereOrNull(
            (item) => item.productDetails?.id == purchaseDetails.productID);

        UserUtil().reportErrorEvent(
          'user pay canceled',
          'pay_cancel',
          orderCode: goods?.orderCode ?? '',
        );
      }
      InAppPurchaseUtil.completePurchase(purchaseDetails, isRetry: true);
    }
  }

  /// 创建订单
  Future<void> createOrder(PayItem goods,
      {num? shortPlayId, num? videoId}) async {
    EasyLoading.show(
        status: 'Paying...', maskType: EasyLoadingMaskType.black);

    Map<String, dynamic> params = {
      "pay_setting_id": goods.id,
      "is_discount": goods.discountType == 0 ? 0 : 1
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

    ApiResponse res =
        await HttpClient().request(Apis.createOrder, data: params);
    EasyLoading.dismiss();

    if (res.success) {
      if (res.data['code'] == 30007) {
        Message.show('You are already subscribed!');
        return;
      }

      final orderCode = res.data['order_code'];
      if (orderCode == null || orderCode.isEmpty) {
        Message.show('Failed to create order');
        return;
      }

      goods.orderCode = orderCode;

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
                  identifier:
                      product.skProduct.discounts.first.identifier!,
                  keyIdentifier: signData['key_identifier'],
                  nonce: signData['nonce'],
                  signature: signData['signature'],
                  timestamp: signData['timestamp'],
                ),
              );
              await InAppPurchaseUtil.buyDiscount(purchaseParamSk2);
            } else {
              await InAppPurchaseUtil.buy(goods.productDetails!,
                  consumable: goods.buyType == 'coins');
            }
          } else if (Platform.isAndroid) {
            if (goods.productDetails! is GooglePlayProductDetails) {
              final googleProduct =
                  goods.productDetails! as GooglePlayProductDetails;
              if (googleProduct
                      .productDetails.subscriptionOfferDetails !=
                  null) {
                final offer = googleProduct
                    .productDetails.subscriptionOfferDetails!.first;
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
            if (googleProduct.productDetails.subscriptionOfferDetails !=
                null) {
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
              await InAppPurchaseUtil.buy(goods.productDetails!,
                  consumable: goods.buyType == 'coins');
            }
          } else {
            await InAppPurchaseUtil.buy(goods.productDetails!,
                consumable: goods.buyType == 'coins');
          }
        }
      } catch (e) {
        EasyLoading.dismiss();
        Message.show(
            'There were some problems with the payment, Please try again!');
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
  Future<bool> verifyPay(PayItem goods,
      {bool isRestore = false, bool isAuto = false}) async {
    String transactionId = goods.transactionId ?? "";
    String serverVerificationData = goods.serverVerificationData ?? "";

    Map<String, dynamic> params = {
      'pkg_name':  "elyra",
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
    }

    try {
      ApiResponse res =
          await HttpClient().request(Apis.applePaid, data: params);
      if (res.success && res.data['status'] == 'success') {
        if (!isRestore) {
          Message.show('Pay Success');
          Future.delayed(Duration(seconds: 1), () => loadData());
        }

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
        PurchaseRestoreUtil().cacheFailedGoods(goods);
      }
      return false;
    } catch (e) {
      if (!isRestore) {
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

    List<PayItem> restoreGoodsList =
        await PurchaseRestoreUtil().getCachedGoodsList();
    debugPrint('----restoreGoodsList:${restoreGoodsList.length}');

    if (restoreGoodsList.isEmpty) {
      state.isRestore = false;
      if (showTips) Message.show('No Products To Restore');
      return;
    }

    EasyLoading.show(status: 'Restore...');
    for (PayItem payItem in restoreGoodsList) {
      bool isSuccess = await verifyPay(payItem, isRestore: true, isAuto: !showTips);
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
}

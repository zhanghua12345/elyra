import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';

/// 内购工具类
class InAppPurchaseUtil {
  static final InAppPurchase _instance = InAppPurchase.instance;

  /// 获取购买流
  static Stream<List<PurchaseDetails>> get purchaseStream =>
      _instance.purchaseStream;

  /// 检查内购是否可用
  static Future<bool> isAvailable() async {
    return await _instance.isAvailable();
  }

  /// 查询商品
  static Future<ProductDetailsResponse> queryProducts(Set<String> ids) async {
    return await _instance.queryProductDetails(ids);
  }

  /// 购买商品
  static Future<bool> buy(ProductDetails productDetails,
      {bool consumable = false}) async {
    if (Platform.isIOS) {
      final purchaseParam = PurchaseParam(productDetails: productDetails);
      if (consumable) {
        return await _instance.buyConsumable(purchaseParam: purchaseParam);
      } else {
        return await _instance.buyNonConsumable(purchaseParam: purchaseParam);
      }
    } else if (Platform.isAndroid) {
      final purchaseParam = PurchaseParam(productDetails: productDetails);
      if (consumable) {
        return await _instance.buyConsumable(purchaseParam: purchaseParam);
      } else {
        return await _instance.buyNonConsumable(purchaseParam: purchaseParam);
      }
    }
    return false;
  }

  /// 购买折扣商品
  static Future<bool> buyDiscount(PurchaseParam purchaseParam) async {
    if (Platform.isIOS) {
      if (purchaseParam is AppStorePurchaseParam) {
        return await _instance.buyNonConsumable(purchaseParam: purchaseParam);
      }
    } else if (Platform.isAndroid) {
      if (purchaseParam is GooglePlayPurchaseParam) {
        return await _instance.buyNonConsumable(purchaseParam: purchaseParam);
      }
    }
    return false;
  }

  /// 完成购买
  static Future<void> completePurchase(PurchaseDetails purchaseDetails,
      {bool isRetry = false}) async {
    if (purchaseDetails.pendingCompletePurchase) {
      await _instance.completePurchase(purchaseDetails);
    }
  }

  /// 消费商品(如果需要)
  static Future<void> consumeIfNeeded(PurchaseDetails purchaseDetails) async {
    if (Platform.isAndroid) {
      if (purchaseDetails is GooglePlayPurchaseDetails) {
        final wrapper = purchaseDetails.billingClientPurchase;
        // 消费性商品需要消费
        if (wrapper.isAcknowledged == false) {
          // Android消费逻辑
          debugPrint('---Android需要消费商品');
        }
      }
    }
  }

  /// 恢复购买
  static Future<void> restorePurchases() async {
    await _instance.restorePurchases();
  }

  /// 取消订阅监听
  static Future<void> cancelStreamSubscription(
      StreamSubscription? subscription) async {
    await subscription?.cancel();
  }

  /// 清除失败的购买
  static Future<void> clearFailedPurchases() async {
    // iOS清理逻辑
    if (Platform.isIOS) {
      // SKPaymentQueue.defaultQueue().transactions 需要手动清理
    }
  }
}

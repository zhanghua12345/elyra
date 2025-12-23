import 'dart:io';

import 'package:elyra/bean/pay_settings_bean.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

/// iOS 价格信息模型
class IOSPriceInfo {
  final String price;
  final String currencyCode;
  final String currencySymbol;
  final double rawPrice;
  final String? identifier;

  IOSPriceInfo({
    required this.price,
    required this.currencyCode,
    required this.currencySymbol,
    required this.rawPrice,
    this.identifier,
  });

  Map<String, dynamic> toJson() {
    return {
      'price': price,
      'currencyCode': currencyCode,
      'currencySymbol': currencySymbol,
      'rawPrice': rawPrice,
      if (identifier != null) 'identifier': identifier,
    };
  }
}

/// 获取当前价格（iOS）
/// 根据 discountType 返回对应的价格信息
IOSPriceInfo? getCurrentPrice(PayItem payItem) {
  if (!Platform.isIOS) return null;
  
  // 检查 productDetails 是否存在
  if (payItem.productDetails == null) return null;
  
  // 确保是 iOS 产品
  if (payItem.productDetails is! AppStoreProductDetails) return null;
  
  final appStoreProduct = payItem.productDetails as AppStoreProductDetails;
  final skProduct = appStoreProduct.skProduct;
  
  // discountType = 1: 使用 introductoryPrice
  if (payItem.discountType == 1) {
    final introPrice = skProduct.introductoryPrice;
    
    // 检查 introductoryPrice 是否存在
    if (introPrice == null) {
      return getOriginalPrice(payItem);
    }
    
    // 检查价格和 priceLocale 是否有效
    if (introPrice.price.isEmpty) {
      return getOriginalPrice(payItem);
    }
    
    return IOSPriceInfo(
      price: introPrice.price,
      currencyCode: introPrice.priceLocale.currencyCode ?? '',
      currencySymbol: introPrice.priceLocale.currencySymbol ?? '',
      rawPrice: double.tryParse(introPrice.price) ?? 0.0,
    );
  }
  
  // discountType = 2: 使用 discounts[0]
  if (payItem.discountType == 2) {
    // 检查 discounts 是否为空
    if (skProduct.discounts.isEmpty) {
      return getOriginalPrice(payItem);
    }
    
    final discount = skProduct.discounts.first;
    
    // 检查 discount 的价格和 priceLocale 是否有效
    if (discount.price.isEmpty) {
      return getOriginalPrice(payItem);
    }
    
    return IOSPriceInfo(
      price: discount.price,
      currencyCode: discount.priceLocale.currencyCode ?? '',
      currencySymbol: discount.priceLocale.currencySymbol ?? '',
      rawPrice: double.tryParse(discount.price) ?? 0.0,
      identifier: discount.identifier,
    );
  }
  
  // 其他情况返回原价
  return getOriginalPrice(payItem);
}

/// 获取原价（iOS）
/// discountType = 0 或作为降级方案
IOSPriceInfo? getOriginalPrice(PayItem payItem) {
  if (!Platform.isIOS) return null;
  
  // 检查 productDetails 是否存在
  if (payItem.productDetails == null) return null;
  
  // 确保是 iOS 产品
  if (payItem.productDetails is! AppStoreProductDetails) return null;
  
  final appStoreProduct = payItem.productDetails as AppStoreProductDetails;
  final skProduct = appStoreProduct.skProduct;
  
  // 检查价格是否有效
  if (skProduct.price.isEmpty) return null;
  
  return IOSPriceInfo(
    price: skProduct.price,
    currencyCode: skProduct.priceLocale.currencyCode ?? '',
    currencySymbol: skProduct.priceLocale.currencySymbol ?? '',
    rawPrice: double.tryParse(skProduct.price) ?? 0.0,
  );
}

import 'dart:convert';
import 'package:elyra/bean/pay_settings_bean.dart';
import 'package:elyra/utils/el_utils.dart';
import 'package:flutter/foundation.dart';

/// 购买恢复工具类
class PurchaseRestoreUtil {
  static const String _cacheKey = 'failed_goods_list';
  static const String _cacheKeyPrefix = 'failed_goods_';
  
  final SpUtils _storage = SpUtils();

  /// 缓存失败的商品
  Future<void> cacheFailedGoods(PayItem goods) async {
    try {
      List<PayItem> list = await getCachedGoodsList();
      
      // 检查是否已存在
      final index = list.indexWhere((item) => 
        item.id == goods.id && item.orderCode == goods.orderCode);
      
      if (index >= 0) {
        // 更新现有商品
        list[index] = goods;
      } else {
        // 添加新商品
        list.add(goods);
      }
      
      // 保存到本地
      final jsonList = list.map((item) => item.toJson()).toList();
      await _storage.setString(_cacheKey, json.encode(jsonList));
      
      debugPrint('---缓存失败商品: ${goods.id} ${goods.orderCode}');
    } catch (e) {
      debugPrint('---缓存失败商品错误: $e');
    }
  }

  /// 获取缓存的商品列表
  Future<List<PayItem>> getCachedGoodsList() async {
    try {
      final String? jsonStr = _storage.getString(_cacheKey);
      if (jsonStr == null || jsonStr.isEmpty) {
        return [];
      }
      
      final List<dynamic> jsonList = json.decode(jsonStr);
      return jsonList.map((item) => PayItem.fromJson(item)).toList();
    } catch (e) {
      debugPrint('---获取缓存商品列表错误: $e');
      return [];
    }
  }

  /// 移除指定商品
  Future<void> removeGoods(PayItem goods) async {
    try {
      List<PayItem> list = await getCachedGoodsList();
      list.removeWhere((item) => 
        item.id == goods.id && item.orderCode == goods.orderCode);
      
      // 保存到本地
      final jsonList = list.map((item) => item.toJson()).toList();
      await _storage.setString(_cacheKey, json.encode(jsonList));
      
      debugPrint('---移除缓存商品: ${goods.id} ${goods.orderCode}');
    } catch (e) {
      debugPrint('---移除缓存商品错误: $e');
    }
  }

  /// 清空所有缓存
  Future<void> clearCachedGoods() async {
    try {
      await _storage.remove(_cacheKey);
      debugPrint('---清空所有缓存商品');
    } catch (e) {
      debugPrint('---清空缓存商品错误: $e');
    }
  }
}

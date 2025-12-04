import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpUtils {
  // 私有静态实例
  static final SpUtils _instance = SpUtils._internal();

  // 工厂构造函数返回单例
  factory SpUtils() => _instance;

  // 私有构造函数
  SpUtils._internal();

  // 存储实例
  late SharedPreferences _prefs;

  // 初始化方法
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // 存储String
  Future<bool> setString(String key, String value) {
    return _prefs.setString(key, value);
  }

  // 读取String
  String? getString(String key) {
    return _prefs.getString(key);
  }

  // 存储int
  Future<bool> setInt(String key, int value) {
    return _prefs.setInt(key, value);
  }

  // 读取int
  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  // 存储bool
  Future<bool> setBool(String key, bool value) {
    return _prefs.setBool(key, value);
  }

  // 读取bool
  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  // 存储double
  Future<bool> setDouble(String key, double value) {
    return _prefs.setDouble(key, value);
  }

  // 读取double
  double? getDouble(String key) {
    return _prefs.getDouble(key);
  }

  // 存储StringList
  Future<bool> setStringList(String key, List<String> value) {
    return _prefs.setStringList(key, value);
  }

  // 读取StringList
  List<String>? getStringList(String key) {
    return _prefs.getStringList(key);
  }

  // 存储Object (需转换为Map<String, dynamic>)
  Future<bool> setObject(String key, Object value) {
    if (value is! Map<String, dynamic>) {
      throw ArgumentError('Object must be a Map<String, dynamic>');
    }
    return _prefs.setString(key, json.encode(value));
  }

  // 读取Object
  Map<String, dynamic>? getObject(String key) {
    String? jsonString = _prefs.getString(key);
    return jsonString != null ? json.decode(jsonString) : null;
  }

  // 存储Object列表
  Future<bool> setObjectList(String key, List<Object> value) {
    if (value.isEmpty || value.first is! Map<String, dynamic>) {
      throw ArgumentError('List elements must be Map<String, dynamic>');
    }
    List<Map<String, dynamic>> mapList = value.cast<Map<String, dynamic>>();
    return _prefs.setString(key, json.encode(mapList));
  }

  // 读取Object列表
  List<Map<String, dynamic>>? getObjectList(String key) {
    String? jsonString = _prefs.getString(key);
    if (jsonString == null) return null;

    List<dynamic> dynamicList = json.decode(jsonString);
    return dynamicList.cast<Map<String, dynamic>>();
  }

  // 存储时自动转换为Map的泛型方法
  Future<bool> setSerializable<T>(String key, T value) {
    if (value is! Serializable) {
      throw ArgumentError('Object must implement Serializable interface');
    }
    return _prefs.setString(key, json.encode(value.toJson()));
  }

  // 读取时自动转换为对象的泛型方法
  T? getSerializable<T>(String key, T Function(Map<String, dynamic>) fromJson) {
    String? jsonString = _prefs.getString(key);
    return jsonString != null ? fromJson(json.decode(jsonString)) : null;
  }

  // 存储数组（支持List<int>、List<double>等）
  Future<bool> setList<T>(String key, List<T> value) {
    if (value.isEmpty) {
      return _prefs.setString(key, json.encode([]));
    }

    // 根据不同类型进行处理
    if (value is List<String>) {
      return _prefs.setStringList(key, value as List<String>);
    } else if (value is List<int>) {
      return _prefs.setString(key, json.encode(value));
    } else if (value is List<double>) {
      return _prefs.setString(key, json.encode(value));
    } else if (value is List<bool>) {
      return _prefs.setString(key, json.encode(value));
    } else {
      // 对于其他类型，尝试转换为JSON字符串
      try {
        List<String> stringList = value.map((e) => e.toString()).toList();
        return _prefs.setStringList(key, stringList);
      } catch (e) {
        throw ArgumentError('Unsupported list type: ${T.runtimeType}');
      }
    }
  }

  // 读取数组（支持List<int>、List<double>等）
  List<T>? getList<T>(String key) {
    if (T == String) {
      return _prefs.getStringList(key)?.cast<T>();
    }

    String? jsonString = _prefs.getString(key);
    if (jsonString == null) return null;

    try {
      List<dynamic> dynamicList = json.decode(jsonString);

      if (T == int) {
        return dynamicList.map((e) => e as int).toList().cast<T>();
      } else if (T == double) {
        return dynamicList.map((e) => e as double).toList().cast<T>();
      } else if (T == bool) {
        return dynamicList.map((e) => e as bool).toList().cast<T>();
      } else {
        // 对于其他类型，尝试从字符串转换
        try {
          return dynamicList.map((e) => e.toString() as T).toList();
        } catch (e) {
          throw ArgumentError('Unsupported list type: ${T.runtimeType}');
        }
      }
    } catch (e) {
      debugPrint('Error decoding list: $e');
      return null;
    }
  }

  // 检查是否包含key
  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }

  // 删除指定key
  Future<bool> remove(String key) {
    return _prefs.remove(key);
  }

  // 清除所有存储
  Future<bool> clear() {
    return _prefs.clear();
  }

  // 获取所有keys
  Set<String> getKeys() {
    return _prefs.getKeys();
  }
}

// 可序列化对象接口
abstract class Serializable {
  Map<String, dynamic> toJson();
}

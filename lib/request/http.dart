import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:elyra/request/el_decode.dart';
import 'package:elyra/request/index.dart';
import 'package:elyra/request/interceptor.dart';
import 'package:elyra/routers/el_routers.dart';
import 'package:elyra/utils/el_store.dart';
import 'package:elyra/utils/el_utils.dart';
import 'package:elyra/utils/toast.dart';
import 'package:elyra/utils/user_util.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Response;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// HTTP请求配置类
class HttpConfig {
  static const String baseUrl = Apis.baseUrl;
  static const int connectTimeout = 5000; // 连接超时时间(ms)
  static const int receiveTimeout = 15000; // 接收超时时间(ms)
  static const int sendTimeout = 5000; // 发送超时时间(ms)
}

/// API响应结果类
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final int? code;

  ApiResponse({required this.success, this.data, this.message, this.code});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      success: json['success'] ?? false,
      data: json['data'],
      message: json['msg'],
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'data': data, 'message': message, 'code': code};
  }
}

/// HTTP请求方法枚举
enum HttpMethod { get, post, put, delete, patch }

/// 统一的API异常类
class ApiException implements Exception {
  final int? code;
  final String message;
  final dynamic error;

  ApiException({this.code, required this.message, this.error});

  @override
  String toString() {
    return 'ApiException{code: $code, message: $message, error: $error}';
  }
}

/// Dio请求封装类
class HttpClient {
  static final HttpClient _instance = HttpClient._internal();

  factory HttpClient() => _instance;
  late Dio _dio;

  HttpClient._internal() {
    _initDio();
  }

  void _initDio() {
    BaseOptions options = BaseOptions(
      baseUrl: HttpConfig.baseUrl,
      connectTimeout: Duration(seconds: HttpConfig.connectTimeout),
      receiveTimeout: Duration(seconds: HttpConfig.receiveTimeout),
      sendTimeout: Duration(seconds: HttpConfig.sendTimeout),
      responseType: ResponseType.json,
    );

    _dio = Dio(options);

    _dio.interceptors.add(RequestInterceptor());
    // 添加拦截器
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // TODO: implement onResponse
          bool isRelease = kReleaseMode;
          if (isRelease) {
            // 如果是加密模式需要解密
            final deStr = SpDecodeUtils.deStr(response.data);
            response.data = jsonDecode(deStr);
          }
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          if (kDebugMode) {
            print('请求错误: ${e.message}');
            if (e.response != null) {
              print('错误响应: ${e.response!.data}');
            }
          }
          return handler.next(_handleError(e));
        },
      ),
    );
    _dio.interceptors.add(
      PrettyDioLogger(requestBody: true, requestHeader: true),
    );
  }

  /// 处理Dio错误
  DioException _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return DioException(
          requestOptions: e.requestOptions,
          error: ApiException(code: -1, message: 'Connection timeout'),
        );
      case DioExceptionType.sendTimeout:
        return DioException(
          requestOptions: e.requestOptions,
          error: ApiException(code: -2, message: 'Connection timeout'),
        );
      case DioExceptionType.receiveTimeout:
        return DioException(
          requestOptions: e.requestOptions,
          error: ApiException(code: -3, message: 'Connection timeout'),
        );
      case DioExceptionType.badResponse:
        final int? statusCode = e.response?.statusCode;
        String message = 'Connection failed';

        if (statusCode != null) {
          switch (statusCode) {
            case 400:
              message = '请求参数错误';
              break;
            case 401:
              message = 'Token已过期';
              SpUtils().remove(ElStoreKeys.token);
              clearAuthToken();
              Get.offAllNamed(AppRoutes.splash);
              break;
            case 402:
              message = '未授权，请先登录';
              Message.show(
                'Please log out of the account on other devices in time, otherwise the App on other devices will be unavailable.',
              );
              UserUtil().register(toHome: false);

              // SpUtils().remove(SpKeys.token);
              // clearAuthToken();
              // Get.offAllNamed(AppRoutes.splash);
              break;
            case 403:
              message = '禁止访问，权限不足';
              break;
            case 404:
              message = '请求资源不存在';
              break;
            case 500:
              message = '服务器内部错误';
              break;
            case 502:
              message = '网关错误';
              break;
            case 503:
              message = '服务不可用';
              break;
            case 504:
              message = '网关超时';
              break;
          }
        }

        return DioException(
          requestOptions: e.requestOptions,
          error: ApiException(
            code: statusCode ?? -4,
            message: message,
            error: e.response?.data,
          ),
        );
      case DioExceptionType.cancel:
        return DioException(
          requestOptions: e.requestOptions,
          error: ApiException(code: -5, message: '请求已取消'),
        );
      case DioExceptionType.unknown:
        return DioException(
          requestOptions: e.requestOptions,
          error: ApiException(code: -6, message: '未知错误，请稍后再试', error: e.error),
        );
      default:
        return e;
    }
  }

  /// 统一的请求方法
  Future<ApiResponse<T>> request<T>(
    String path, {
    HttpMethod method = HttpMethod.post,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    T Function(dynamic data)? parser,
    bool showErrorToast = false,
  }) async {
    try {
      Options requestOptions = options ?? Options();
      requestOptions.method = method.name.toUpperCase();

      Response response;

      switch (method) {
        case HttpMethod.get:
          response = await _dio.get(
            path,
            queryParameters: queryParameters,
            options: requestOptions,
            onReceiveProgress: onReceiveProgress,
          );
          break;
        case HttpMethod.post:
          response = await _dio.post(
            path,
            data: data,
            queryParameters: queryParameters,
            options: requestOptions,
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress,
          );
          break;
        case HttpMethod.put:
          response = await _dio.put(
            path,
            data: data,
            queryParameters: queryParameters,
            options: requestOptions,
          );
          break;
        case HttpMethod.delete:
          response = await _dio.delete(
            path,
            data: data,
            queryParameters: queryParameters,
            options: requestOptions,
          );
          break;
        case HttpMethod.patch:
          response = await _dio.patch(
            path,
            data: data,
            queryParameters: queryParameters,
            options: requestOptions,
          );
          break;
      }

      // 解析响应数据
      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData['code'] == 200) {
          // 如果有自定义解析器，使用解析器处理数据
          if (parser != null) {
            return ApiResponse(success: true, data: parser(responseData));
          }

          // 默认解析
          if (responseData is Map<String, dynamic>) {
            responseData.putIfAbsent('success', () => true);
            return ApiResponse.fromJson(responseData);
          } else {
            return ApiResponse(success: true, data: responseData as T?);
          }
        } else {
          if (showErrorToast) Message.show(responseData['msg']);
          return ApiResponse(
            success: false,
            message: responseData['msg'],
            data: responseData as T?,
          );
        }
      } else {
        throw ApiException(
          code: response.statusCode,
          message: '请求失败，状态码: ${response.statusCode}',
          error: response.data,
        );
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      } else {
        throw ApiException(code: -1000, message: '请求发生异常: $e', error: e);
      }
    }
  }

  /// 设置认证令牌
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = token;
    // _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// 清除认证令牌
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  /// 添加自定义请求头字段
  void addHeader(String key, String value) {
    _dio.options.headers[key] = value;
  }

  /// 批量添加自定义请求头字段
  void addHeaders(Map<String, String> headers) {
    headers.forEach((key, value) => _dio.options.headers[key] = value);
  }

  /// 移除指定请求头字段
  void removeHeader(String key) {
    _dio.options.headers.remove(key);
  }

  /// 清除所有自定义请求头字段
  void clearHeaders() {
    // 保留基础的Content-Type
    final contentType = _dio.options.headers['Content-Type'];
    _dio.options.headers.clear();
    if (contentType != null) {
      _dio.options.headers['Content-Type'] = contentType;
    }
  }
}

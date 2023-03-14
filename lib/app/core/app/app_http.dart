import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' hide Response;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class AppHttp {
  late final Dio _dio;

  bool _lock = false;

  static final AppHttp instance = AppHttp._internal();
  AppHttp._internal();

  static Future<AppHttp> instantiate({
    HttpOverrides? httpOverrides,
  }) async {
    if (instance._lock) return instance;
    instance._lock = true;

    if (kDebugMode) HttpOverrides.global = httpOverrides;

    final options = BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    instance._dio = Dio(options);
    instance._dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
    ));

    return instance;
  }

  static String get networkError => 'network_error'.tr;

  static Future<T?> get<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    Response<T> res = await instance._dio.get(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
    return res.data;
  }

  static Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    return await instance._dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }
}

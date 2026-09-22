import 'package:dio/dio.dart';

import 'app_dio_interceptor.dart';

final class AppDio {
  static Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://dummyjson.com',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(AppDioInterceptor());

    return dio;
  }
}

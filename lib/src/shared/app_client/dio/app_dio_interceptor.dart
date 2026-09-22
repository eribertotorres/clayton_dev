import 'package:dio/dio.dart';

import '../../app_exceptions.dart';

final class AppDioInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout) {
      final appException = DioException(
        requestOptions: err.requestOptions,
        error: AppNetworkException(),
      );

      return handler.next(appException);
    }

    if (err.response?.statusCode == 401) {
      final appException = DioException(
        requestOptions: err.requestOptions,
        error: AppUnauthorizedException(),
      );

      return handler.next(appException);
    }

    return handler.next(err);
  }
}

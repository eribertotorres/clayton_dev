import 'package:dio/dio.dart';

sealed class AppClient {
  Future<Map<String, dynamic>> get({
    required String url,
    Map<String, dynamic>? header,
  });

  Future<Map<String, dynamic>> post({
    required String url,
    Map<String, dynamic>? data,
    Map<String, dynamic>? header,
  });
}

final class AppClientDioImpl implements AppClient {
  final Dio dio;

  AppClientDioImpl({required this.dio});

  @override
  Future<Map<String, dynamic>> get({
    required String url,
    Map<String, dynamic>? header,
  }) async {
    try {
      final result = await dio.get(url, options: Options(headers: header));

      if (result.statusCode == 200) {
        return Map<String, dynamic>.from(result.data);
      }

      throw Exception();
    } on DioException catch (e) {
      if (e.error is Exception) {
        throw e.error as Exception;
      }

      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> post({
    required String url,
    Map<String, dynamic>? data,
    Map<String, dynamic>? header,
  }) async {
    try {
      final result = await dio.post(
        url,
        data: data,
        options: Options(headers: header),
      );

      if (result.statusCode == 200 || result.statusCode == 201) {
        return Map<String, dynamic>.from(result.data);
      }

      throw Exception();
    } on DioException catch (e) {
      if (e.error is Exception) {
        throw e.error as Exception;
      }

      rethrow;
    }
  }
}

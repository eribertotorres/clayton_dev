import '../../shared/app_client/app_client.dart';

sealed class IAuthRemoteDatasource {
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  });
}

final class AuthRemoteDatasourceImpl implements IAuthRemoteDatasource {
  final AppClient client;

  AuthRemoteDatasourceImpl({required this.client});

  @override
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) {
    return client.post(
      url: '/auth/login',
      data: {'username': username, 'password': password, 'expiresInMins': 30},
    );
  }
}

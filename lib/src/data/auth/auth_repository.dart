import '../../shared/app_exceptions.dart';
import '../../shared/result/result.dart';
import 'auth_remote_datasource.dart';
import 'user_model.dart';

sealed class IAuthRepository {
  Future<Result<UserModel>> login({
    required String username,
    required String password,
  });
}

final class AuthRepositoryImpl implements IAuthRepository {
  final IAuthRemoteDatasource datasource;

  AuthRepositoryImpl({required this.datasource});

  @override
  Future<Result<UserModel>> login({
    required String username,
    required String password,
  }) async {
    try {
      final result = await datasource.login(
        username: username,
        password: password,
      );

      final user = UserModel.fromMap(result);

      return Success(user);
    } on TypeError {
      return Failure(ConvertDataException());
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}

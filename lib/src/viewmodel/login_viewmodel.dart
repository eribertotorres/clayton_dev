import 'package:flutter/material.dart';

import '../data/auth/auth_repository.dart';
import '../data/auth/user_model.dart';
import '../shared/app_exceptions.dart';
import '../shared/result/result.dart';

final class LoginViewModel extends ChangeNotifier {
  final IAuthRepository repository;

  LoginViewModel({required this.repository});

  bool _isLoading = false;
  String? _errorMessage;
  UserModel? _user;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserModel? get user => _user;

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await repository.login(
      username: username,
      password: password,
    );

    switch (result) {
      case Success<UserModel>():
        _user = result.data;
        _isLoading = false;
        notifyListeners();
        return true;

      case Failure<UserModel>():
        _user = null;
        _isLoading = false;

        _errorMessage = switch (result.exception) {
          AppUnauthorizedException() => 'Usuário ou senha inválidos.',
          AppNetworkException() => 'Não foi possível conectar à internet.',
          ConvertDataException() => 'Erro ao processar os dados do usuário.',
          _ => 'Não foi possível realizar o login.',
        };

        notifyListeners();
        return false;
    }
  }
}

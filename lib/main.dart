import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/data/auth/auth_remote_datasource.dart';
import 'src/data/auth/auth_repository.dart';
import 'src/shared/app_client/app_client.dart';
import 'src/shared/app_client/dio/app_dio.dart';
import 'src/view/login/login_view.dart';
import 'src/viewmodel/login_viewmodel.dart';

void main() {
  final dio = AppDio.create();

  final appClient = AppClientDioImpl(dio: dio);

  final authDatasource = AuthRemoteDatasourceImpl(client: appClient);

  final authRepository = AuthRepositoryImpl(datasource: authDatasource);

  runApp(MyApp(authRepository: authRepository));
}

final class MyApp extends StatelessWidget {
  final IAuthRepository authRepository;

  const MyApp({required this.authRepository, super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(repository: authRepository),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'TODOs',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
        ),
        home: const LoginView(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/data/auth/auth_remote_datasource.dart';
import 'src/data/auth/auth_repository.dart';
import 'src/shared/app_client/app_client.dart';
import 'src/shared/app_client/dio/app_dio.dart';
import 'src/viewmodel/login_viewmodel.dart';

import 'src/data/preferences/preferences_datasource.dart';
import 'src/view/splash/splash_view.dart';

void main() {
  final preferences = PreferencesDatasource();

  final dio = AppDio.create();

  final appClient = AppClientDioImpl(dio: dio);

  final authDatasource = AuthRemoteDatasourceImpl(client: appClient);

  final authRepository = AuthRepositoryImpl(
    datasource: authDatasource,
    preferences: preferences,
  );

  runApp(MyApp(authRepository: authRepository, preferences: preferences));
}

final class MyApp extends StatelessWidget {
  final IAuthRepository authRepository;
  final PreferencesDatasource preferences;

  const MyApp({
    required this.authRepository,
    required this.preferences,
    super.key,
  });

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
        home: SplashView(preferences: preferences),
      ),
    );
  }
}

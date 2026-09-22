import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/data/auth/auth_remote_datasource.dart';
import 'src/data/auth/auth_repository.dart';
import 'src/shared/app_client/app_client.dart';
import 'src/shared/app_client/dio/app_dio.dart';
import 'src/viewmodel/login_viewmodel.dart';

import 'src/data/preferences/preferences_datasource.dart';
import 'src/view/splash/splash_view.dart';

import 'src/data/todo/todo_local_datasource.dart';
import 'src/data/todo/todo_remote_datasource.dart';
import 'src/data/todo/todo_repository.dart';
import 'src/viewmodel/home_viewmodel.dart';

void main() {
  final preferences = PreferencesDatasource();

  final dio = AppDio.create();

  final appClient = AppClientDioImpl(dio: dio);

  final authDatasource = AuthRemoteDatasourceImpl(client: appClient);

  final authRepository = AuthRepositoryImpl(
    datasource: authDatasource,
    preferences: preferences,
  );

  final todoRemoteDatasource = TodoRemoteDatasourceImpl(client: appClient);

  final todoLocalDatasource = TodoLocalDatasourceImpl();

  final todoRepository = TodoRepositoryImpl(
    remoteDatasource: todoRemoteDatasource,
    localDatasource: todoLocalDatasource,
  );

  runApp(
    MyApp(
      authRepository: authRepository,
      preferences: preferences,
      todoRepository: todoRepository,
    ),
  );
}

final class MyApp extends StatelessWidget {
  final IAuthRepository authRepository;
  final PreferencesDatasource preferences;

  final ITodoRepository todoRepository;

  const MyApp({
    required this.authRepository,
    required this.preferences,
    required this.todoRepository,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LoginViewModel(repository: authRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => HomeViewModel(repository: todoRepository),
        ),
      ],
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

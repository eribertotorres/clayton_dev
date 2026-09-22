import 'package:flutter/material.dart';

import '../../data/preferences/preferences_datasource.dart';
import '../../shared/routes/app_routes.dart';

final class SplashView extends StatefulWidget {
  final PreferencesDatasource preferences;

  const SplashView({required this.preferences, super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

final class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final isLogged = await widget.preferences.isLogged();

    if (!mounted) return;

    Navigator.of(context)
        .pushReplacementNamed(isLogged ? AppRoutes.home : AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

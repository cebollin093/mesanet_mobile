import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'screens/auth/login_screen.dart';

void main() {
  runApp(const MesaNetApp());
}

class MesaNetApp extends StatelessWidget {
  const MesaNetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MesaNet',
      theme: AppTheme.theme,
      home: const LoginScreen(),
    );
  }
}
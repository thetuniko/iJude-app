import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/pages/login_page.dart';

void main() {
  runApp(const FixFlowApp());
}

class FixFlowApp extends StatelessWidget {
  const FixFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FixFlow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const LoginPage(), // Vamos criar este arquivo agora
    );
  }
}
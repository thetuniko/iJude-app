import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart'; // <--- Import necessário
import 'core/auth_provider.dart'; // <--- Caminho para seu provedor de autenticação
import 'features/auth/presentation/pages/onboarding_page.dart';

void main() {
  runApp(
    // 1. Envolvemos o app com o MultiProvider para gerenciar estados globais
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const IJudeApp(),
    ),
  );
}

class IJudeApp extends StatelessWidget {
  const IJudeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iJude',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F172A)),
        textTheme: GoogleFonts.interTextTheme(),
      ),
      // O app continua começando pelo Onboarding
      home: const OnboardingPage(),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'features/auth/presentation/pages/onboarding_page.dart';

void main() {
  runApp(const IJudeApp());
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
      // ORDEM 1: O app começa aqui
      home: const OnboardingPage(),
    );
  }
}
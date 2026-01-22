import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ijude_app/features/auth/presentation/pages/home_page.dart';
import 'register_page.dart'; // Importe local

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 60),
              // Logo iJude corrigido
              Container(
                height: 100, width: 100,
                decoration: BoxDecoration(
                  color: Colors.white, shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20)],
                ),
                child: const Center(child: Icon(Icons.handyman_outlined, size: 50, color: Color(0xFF0F172A))),
              ),
              const SizedBox(height: 32),
              Text("Bem-vindo ao iJude", style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
              const SizedBox(height: 40),
              // Campo E-mail
              const TextField(decoration: InputDecoration(hintText: "seu@email.com", prefixIcon: Icon(Icons.email_outlined))),
              const SizedBox(height: 20),
              // Campo Senha
              TextField(
                obscureText: _isObscure,
                decoration: InputDecoration(
                  hintText: "••••••••",
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _isObscure = !_isObscure),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Botão Entrar
              SizedBox(
  width: double.infinity, 
  height: 56,
  child: ElevatedButton(
    onPressed: () {
      // --- MODO DE TESTE ---
      // Navega direto para a Home e remove o Login da pilha (para não voltar ao clicar em voltar)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ServiceSelectionPage()), 
        // OBS: Se você renomeou a classe para HomePage, use HomePage() aqui.
      );
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF0F172A), // Navy
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    child: const Text(
      "Entrar", 
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
    ),
  ),
),
              const SizedBox(height: 24),
              // Link de Cadastro Corrigido
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Não tem uma conta? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage()));
                    },
                    child: const Text("Cadastre-se", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
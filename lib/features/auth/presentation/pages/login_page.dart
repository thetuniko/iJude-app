import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart'; // Para kIsWeb
import 'register_page.dart'; 
import 'main_screen.dart'; 
import 'verification_page.dart'; // <--- Importante para redirecionar

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controladores
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isObscure = true;
  bool _isLoading = false; 

  // --- LÓGICA DE LOGIN INTELIGENTE ---
  Future<void> _login() async {
    // 1. Validação simples
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, preencha e-mail e senha.")),
      );
      return;
    }

    setState(() => _isLoading = true);

    // 2. Define URL (Web vs Android Emulator)
    final baseUrl = kIsWeb ? 'http://localhost:3000' : 'http://10.0.2.2:3000';
    final url = Uri.parse('$baseUrl/client/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _emailController.text.trim(),
          'pass': _passwordController.text,
        }),
      );

      // Decodifica a resposta para ler mensagens ou dados extras
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // --- SUCESSO: LOGIN REALIZADO ---
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
            (route) => false, // Remove a tela de login da pilha
          );
        }
      } 
      // --- CASO ESPECIAL: CONTA NÃO VERIFICADA (Erro 403) ---
      else if (response.statusCode == 403 && responseData['needVerification'] == true) {
        if (mounted) {
          // Pega o telefone que o backend mandou no erro
          final phone = responseData['phone']; 
          
          // 1. Avisa o usuário
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Conta não verificada. Enviamos um novo código!"),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 3),
            ),
          );

          // 2. Redireciona para a tela de Verificação
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerificationPage(phone: phone),
            ),
          );
        }
      } 
      // --- OUTROS ERROS (Senha errada, e-mail não existe, etc) ---
      else {
        if (mounted) {
          final errorMessage = responseData['message'] ?? 'Erro ao realizar login';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erro de conexão com o servidor.")),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Widget auxiliar para os campos de texto
  Widget _buildTextField({
    required TextEditingController controller, 
    required String hint, 
    required IconData icon
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
        prefixIcon: Icon(icon, color: const Color(0xFF64748B)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), 
          borderSide: const BorderSide(color: Color(0xFFE2E8F0))
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF0F172A), width: 1.5),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo iJude
                Container(
                  height: 100, width: 100,
                  decoration: BoxDecoration(
                    color: Colors.white, shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)],
                  ),
                  child: const Center(child: Icon(Icons.handyman_outlined, size: 50, color: Color(0xFF0F172A))),
                ),
                
                const SizedBox(height: 32),
                Text("Bem-vindo ao iJude", style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                const SizedBox(height: 8),
                Text("Faça login para continuar", style: GoogleFonts.inter(fontSize: 16, color: const Color(0xFF64748B))),
                
                const SizedBox(height: 40),
                
                // Campo E-mail
                _buildTextField(
                  controller: _emailController,
                  hint: "seu@email.com",
                  icon: Icons.email_outlined,
                ),

                const SizedBox(height: 20),
                
                // Campo Senha
                TextField(
                  controller: _passwordController,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    hintText: "••••••••",
                    hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                    prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF64748B)),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12), 
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0))
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF0F172A), width: 1.5),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility, color: const Color(0xFF64748B)),
                      onPressed: () => setState(() => _isObscure = !_isObscure),
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),

                // Esqueci minha senha
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text("Esqueceu a senha?", 
                      style: GoogleFonts.inter(color: const Color(0xFF0F172A), fontWeight: FontWeight.w600)),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Botão Entrar
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F172A),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: _isLoading 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Entrar", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),

                const SizedBox(height: 32),
                
                // Divisor "Ou entre com"
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey[300])),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text("Ou entre com", style: TextStyle(color: Colors.grey[500], fontSize: 14)),
                    ),
                    Expanded(child: Divider(color: Colors.grey[300])),
                  ],
                ),

                const SizedBox(height: 24),

                // Botões Sociais
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _socialButton(Icons.g_mobiledata, "Google"),
                    const SizedBox(width: 16),
                    _socialButton(Icons.apple, "Apple"),
                  ],
                ),

                const SizedBox(height: 32),

                // Link de Cadastro
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Não tem uma conta? ", style: TextStyle(color: Color(0xFF64748B))),
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
      ),
    );
  }

  Widget _socialButton(IconData icon, String label) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Falta implementar")));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
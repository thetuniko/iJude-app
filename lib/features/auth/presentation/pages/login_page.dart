import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart'; 
import 'register_page.dart'; 
import 'verification_page.dart'; 
import 'terms_page.dart'; 
import '../../../../core/api_config.dart'; 
import '../../../../core/auth_provider.dart'; 
import '../../../../shared/models/user_model.dart'; 

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isObscure = true;
  bool _isLoading = false; 

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, preencha e-mail e senha.")),
      );
      return;
    }

    setState(() => _isLoading = true);

    final url = Uri.parse('${ApiConfig.baseUrl}/client/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _emailController.text.trim(),
          'pass': _passwordController.text,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          final user = UserModel.fromJson(responseData);
          Provider.of<AuthProvider>(context, listen: false).setUser(user);

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const TermsPage()),
            (route) => false,
          );
        }
      } 
      // CORREÇÃO: Fluxo de verificação ajustado para E-mail
      else if (response.statusCode == 403 && responseData['needVerification'] == true) {
        if (mounted) {
          // Captura o e-mail do response ou do próprio campo preenchido
          final String targetEmail = responseData['email'] ?? _emailController.text.trim(); 
          
          if (targetEmail.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("E-mail não identificado para verificação."), backgroundColor: Colors.red),
            );
            return;
          }

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Conta não verificada. Enviamos um código para seu e-mail!"),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 3),
            ),
          );

          // Navega para a VerificationPage passando o e-mail (evita erro null)
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerificationPage(email: targetEmail),
            ),
          );
        }
      } 
      else {
        if (mounted) {
          final errorMessage = responseData['message'] ?? 'Erro ao realizar login';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
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
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // --- UI COMPONENTS ---

  Widget _buildTextField({
    required TextEditingController controller, 
    required String hint, 
    required IconData icon
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
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
    const Color iJudeNavy = Color(0xFF0F172A);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 100, width: 100,
                  decoration: BoxDecoration(
                    color: Colors.white, shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)],
                  ),
                  child: const Center(child: Icon(Icons.handyman_outlined, size: 50, color: iJudeNavy)),
                ),
                const SizedBox(height: 32),
                Text("Bem-vindo ao iJude", 
                  style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: iJudeNavy)),
                const SizedBox(height: 8),
                Text("Faça login para continuar", 
                  style: GoogleFonts.inter(fontSize: 16, color: const Color(0xFF64748B))),
                const SizedBox(height: 40),
                
                _buildTextField(
                  controller: _emailController,
                  hint: "seu@email.com",
                  icon: Icons.email_outlined,
                ),
                
                const SizedBox(height: 20),
                
                TextField(
                  controller: _passwordController,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    hintText: "••••••••",
                    hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                    prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF64748B)),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12), 
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0))
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: iJudeNavy, width: 1.5),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility, color: const Color(0xFF64748B)),
                      onPressed: () => setState(() => _isObscure = !_isObscure),
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text("Esqueceu a senha?", 
                      style: GoogleFonts.inter(color: iJudeNavy, fontWeight: FontWeight.w600)),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: iJudeNavy,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: _isLoading 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Entrar", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Não tem uma conta? ", style: TextStyle(color: Color(0xFF64748B))),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage()));
                      },
                      child: const Text("Cadastre-se", 
                        style: TextStyle(fontWeight: FontWeight.bold, color: iJudeNavy)),
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

}
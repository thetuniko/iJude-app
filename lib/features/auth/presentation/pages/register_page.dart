// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'verification_page.dart';
import '../../../../core/api_config.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  // Controladores
  final _nameController = TextEditingController();
  final _cpfController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _isObscure = true;

  // --- MÁSCARAS ---
  final maskCpf = MaskTextInputFormatter(
      mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});
  final maskDate = MaskTextInputFormatter(
      mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});
  final maskPhone = MaskTextInputFormatter(
      mask: '(##) # ####-####', filter: {"#": RegExp(r'[0-9]')});

  // --- VALIDAÇÃO CPF ---
  bool _isValidCPF(String? cpf) {
    if (cpf == null || cpf.isEmpty) return false;
    var numbers = cpf.replaceAll(RegExp(r'[^0-9]'), '');
    if (numbers.length != 11) return false;
    if (RegExp(r'^(\d)\1*$').hasMatch(numbers)) return false;

    List<int> digits = numbers.split('').map(int.parse).toList();
    int calcDigit(List<int> d, int factor) {
      int sum = 0;
      for (int i = 0; i < d.length; i++) {
        sum += d[i] * factor--;
      }
      int remainder = sum % 11;
      return remainder < 2 ? 0 : 11 - remainder;
    }
    int dv1 = calcDigit(digits.sublist(0, 9), 10);
    int dv2 = calcDigit(digits.sublist(0, 9) + [dv1], 11);
    return digits[9] == dv1 && digits[10] == dv2;
  }

  // --- CADASTRO ---
  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

  final url = Uri.parse('${ApiConfig.baseUrl}/client');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': _nameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text.replaceAll(RegExp(r'[^0-9]'), ''),
          'password': _passwordController.text,
          'cpf': _cpfController.text.replaceAll(RegExp(r'[^0-9]'), ''),
          'birthDate': _birthDateController.text,
        }),
      );

      if (response.statusCode == 201) {
        if (mounted) {
          Navigator.push(context, MaterialPageRoute(
            builder: (_) => VerificationPage(phone: _phoneController.text)
          ));
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Erro: ${response.body}"), backgroundColor: Colors.red)
          );
        }
      }
    } catch (e) {
      print(e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text("Erro de conexão com o servidor. Verifique se o backend está rodando."))
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Garante fundo branco
      appBar: AppBar(
        backgroundColor: Colors.white, // Fundo branco no AppBar
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Voltar", // Texto simples como no design clean
          style: TextStyle(color: Color(0xFF64748B), fontSize: 16),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Crie sua conta", style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
              const SizedBox(height: 32),

              _buildField("Nome", "Nome completo", Icons.person_outline, controller: _nameController,
                validator: (val) => val!.isEmpty ? 'Campo obrigatório' : null),

              const SizedBox(height: 20),

              _buildField("CPF", "000.000.000-00", Icons.badge_outlined,
                controller: _cpfController,
                keyboardType: TextInputType.number,
                maskFormatter: maskCpf,
                validator: (val) => _isValidCPF(val) ? null : 'CPF Inválido'),

              const SizedBox(height: 20),

              _buildField("Data de Nascimento", "DD/MM/AAAA", Icons.calendar_today_outlined,
                controller: _birthDateController,
                keyboardType: TextInputType.number,
                maskFormatter: maskDate,
                validator: (val) => val!.length < 10 ? 'Data incompleta' : null),

              const SizedBox(height: 20),

              _buildField("Telefone", "(00) 0 0000-0000", Icons.phone_outlined,
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                maskFormatter: maskPhone,
                validator: (val) => val!.length < 16 ? 'Telefone incompleto' : null),

              const SizedBox(height: 20),

              _buildField("E-mail", "seu@email.com", Icons.email_outlined,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (val) => !val!.contains('@') ? 'E-mail inválido' : null),

              const SizedBox(height: 20),

              _buildField("Senha", "Mínimo 8 caracteres", Icons.lock_outline,
                controller: _passwordController,
                isPassword: true,
                validator: (val) {
                  if (val == null || val.length < 8) return 'Mínimo 8 caracteres';
                  if (!val.contains(RegExp(r'[A-Z]'))) return 'Falta letra maiúscula';
                  if (!val.contains(RegExp(r'[!@#\$&*~,.;]'))) return 'Falta símbolo';
                  return null;
                }),

              const SizedBox(height: 20),

              _buildField("Confirmar Senha", "Repita a senha", Icons.lock_reset_outlined,
                controller: _confirmPasswordController,
                isPassword: true,
                validator: (val) => val != _passwordController.text ? 'Senhas não conferem' : null),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity, height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _registerUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F172A),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Criar uma conta", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, String hint, IconData icon,
      {bool isPassword = false,
       TextEditingController? controller,
       TextInputType? keyboardType,
       MaskTextInputFormatter? maskFormatter,
       String? Function(String?)? validator}) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: isPassword && _isObscure,
          inputFormatters: maskFormatter != null ? [maskFormatter] : [],
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
            prefixIcon: Icon(icon, color: const Color(0xFF64748B)),
            filled: true,
            fillColor: Colors.white, // Garante fundo branco no input
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            
            // Bordas suaves (Estilo Clean)
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF0F172A), width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
            ),

            suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility, color: const Color(0xFF64748B)),
                  onPressed: () => setState(() => _isObscure = !_isObscure),
                )
              : null,
          ),
        ),
      ],
    );
  }
}
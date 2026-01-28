import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'terms_page.dart'; // <--- Importação necessária para o novo fluxo
import '../../../../core/api_config.dart'; // <--- Configuração de API central [cite: 13]

class VerificationPage extends StatefulWidget {
  final String phone;

  const VerificationPage({super.key, required this.phone});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final _pinController = TextEditingController();
  bool _isLoading = false;

  Future<void> _verifyCode() async {
    if (_pinController.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Digite o código completo")),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Endpoint de verificação configurado no ApiConfig [cite: 13, 21]
    final url = Uri.parse('${ApiConfig.baseUrl}/client/verify');
    
    // Limpeza de caracteres não numéricos do telefone [cite: 72]
    final cleanPhone = widget.phone.replaceAll(RegExp(r'[^0-9]'), '');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phone': cleanPhone,
          'code': _pinController.text,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Conta verificada com sucesso!"), 
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );

          await Future.delayed(const Duration(seconds: 1)); 
          
          if (mounted) {
            // CORREÇÃO DE FLUXO: Agora redireciona para a TermsPage 
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const TermsPage()),
              (route) => false, // Impede o usuário de voltar para esta tela
            );
          }
        }
      } else {
        if (mounted) {
          final responseData = jsonDecode(response.body);
          final msg = responseData['message'] ?? "Código inválido ou expirado!";
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(msg), 
              backgroundColor: Colors.red
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
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Definição da cor primária do projeto iJude [cite: 19]
    const Color iJudeNavy = Color(0xFF0F172A);

    final defaultPinTheme = PinTheme(
      width: 50,
      height: 55,
      textStyle: GoogleFonts.inter(fontSize: 22, color: iJudeNavy, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(12),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: iJudeNavy, width: 1.5),
      color: Colors.white,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: iJudeNavy),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Voltar", 
          style: TextStyle(color: Color(0xFF64748B), fontSize: 14)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.verified_user_outlined, 
                size: 40, 
                color: iJudeNavy // RESTAURADO: Cor do ícone para Navy [cite: 19]
              ),
            ),
            const SizedBox(height: 32),
            Text(
              "Verifique seu celular",
              style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: iJudeNavy),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.inter(fontSize: 15, color: const Color(0xFF64748B), height: 1.5),
                  children: [
                    const TextSpan(text: "Enviamos um código de 6 dígitos para \n"),
                    TextSpan(
                      text: widget.phone, 
                      style: const TextStyle(fontWeight: FontWeight.bold, color: iJudeNavy)
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            Pinput(
              length: 6,
              controller: _pinController,
              defaultPinTheme: defaultPinTheme,
              focusedPinTheme: focusedPinTheme,
              pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
              showCursor: true,
              onCompleted: (pin) => _verifyCode(),
            ),
            const SizedBox(height: 16),
            Text(
              "Insira o código de verificação enviado para o seu celular.",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF94A3B8)),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _verifyCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: iJudeNavy,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Verificar celular", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Código reenviado!")));
              },
              child: Text(
                "Não recebeu o código? Reenviar",
                style: GoogleFonts.inter(color: iJudeNavy, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
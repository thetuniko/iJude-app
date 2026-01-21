import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VerificationPage extends StatelessWidget {
  const VerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Voltar para iniciar sessão", 
          style: TextStyle(color: Color(0xFF64748B), fontSize: 14)),
        titleSpacing: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Ícone de Escudo igual ao seu design
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFFEFF6FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.verified_user_outlined, 
                  size: 40, color: Color(0xFF0F172A)),
              ),
            ),
            const SizedBox(height: 32),
            Text("Verifique seu e-mail",
              style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("Enviamos um código de 6 dígitos para", 
              textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF64748B))),
            const Text("teste@gmail.com", 
              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
            
            const SizedBox(height: 40),
            
            // Grid de 6 campos para o código
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) => _buildPinField(context)),
            ),
            
            const SizedBox(height: 24),
            const Text("Insira o código de verificação enviado para o seu e-mail.",
              textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
            
            const SizedBox(height: 48),
            
            // Botão Verificar
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // Navegação para Home no próximo bloco
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F172A),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Verificar e-mail", 
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // Lógica de reenvio
              },
              child: const Text("Não recebeu o código? Reenviar", 
                style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  // Widget para os campos individuais de PIN
  Widget _buildPinField(BuildContext context) {
    return Container(
      width: 48,
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: TextField(
        onChanged: (value) {
          if (value.length == 1) FocusScope.of(context).nextFocus();
        },
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: const InputDecoration(counterText: "", border: InputBorder.none),
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
      ),
    );
  }
}
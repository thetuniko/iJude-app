import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text("Mensagens", style: GoogleFonts.inter(color: const Color(0xFF0F172A), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline, size: 80, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              "Nenhuma mensagem",
              style: GoogleFonts.inter(fontSize: 18, color: Colors.grey.shade500, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              "Converse com profissionais aqui",
              style: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade400),
            ),
          ],
        ),
      ),
    );
  }
}
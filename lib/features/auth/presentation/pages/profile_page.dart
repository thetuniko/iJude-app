import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ijude_app/features/auth/presentation/pages/login_page.dart';


class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text("Meu Perfil", style: GoogleFonts.inter(color: const Color(0xFF0F172A), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Color(0xFF0F172A)),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Icon(Icons.person_outline, size: 60, color: Colors.grey.shade400),
            ),
            const SizedBox(height: 24),
            Text(
              "Olá, Visitante",
              style: GoogleFonts.inter(fontSize: 22, color: const Color(0xFF0F172A), fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Faça login para ver seus dados",
              style: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 32),
OutlinedButton(
  onPressed: () {
    // Navega para a tela de Login
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  },
  style: OutlinedButton.styleFrom(
    side: const BorderSide(color: Color(0xFF0F172A)),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ),
  child: Text(
    "Login/Registro",
    style: GoogleFonts.inter(color: const Color(0xFF0F172A), fontWeight: FontWeight.bold),
  ),
)
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../auth/presentation/pages/login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Cores extraídas diretamente do seu design
  static const Color iJudeNavy = Color(0xFF0F172A);
  static const Color iJudeBackground = Color(0xFFF8FAFC);
  static const Color iJudeBorder = Color(0xFFE2E8F0);
  static const Color iJudeSlate = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: iJudeBackground, // Fundo cinza claro idêntico ao login
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 80),
            
            // 1. Logo Circular (Mantendo a identidade visual do login)
            Center(
              child: Container(
                height: 90,
                width: 90,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: const Icon(Icons.handyman_outlined, size: 45, color: iJudeNavy),
              ),
            ),
            
            const SizedBox(height: 32),

            // 2. Título no estilo "Bem-vindo ao FixFlow"
            Text(
              "Olá, como podemos\nte iJudar hoje?",
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: iJudeNavy,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 48),

            // 3. Grid de Serviços com o estilo de Cards Brancos
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.1,
                children: const [
                  _HomeCategoryCard(icon: Icons.water_drop_outlined, label: "Hidráulica"),
                  _HomeCategoryCard(icon: Icons.bolt, label: "Elétrica"),
                  _HomeCategoryCard(icon: Icons.format_paint_outlined, label: "Pintura"),
                  _HomeCategoryCard(icon: Icons.chair_outlined, label: "Montagem"),
                ],
              ),
            ),
            
            const SizedBox(height: 40),

            // 4. Botão de Ação Principal (Estilo do botão 'Entrar')
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: iJudeBorder),
                ),
                child: Column(
                  children: [
                    const Text(
                      "Não encontrou o que precisava?",
                      style: TextStyle(fontWeight: FontWeight.bold, color: iJudeNavy),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: iJudeNavy,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: const Text(
                          "Solicitar Orçamento Personalizado",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _HomeCategoryCard extends StatelessWidget {
  final IconData icon;
  final String label;

  const _HomeCategoryCard({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)), // Borda suave do login
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 36, color: const Color(0xFF0F172A)),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }
}
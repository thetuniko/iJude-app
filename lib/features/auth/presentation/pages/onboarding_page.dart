import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ijude_app/features/auth/presentation/pages/home_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Cores padrão do iJude
  static const Color primaryNavy = Color(0xFF0F172A);
  static const Color accentGreen = Color(0xFF22C55E);

  final List<Map<String, String>> _onboardingData = [
    {
      "title": "Sua casa em boas mãos.",
      "subtitle": "Encontre os melhores profissionais para limpeza, reparos e manutenção com apenas alguns cliques.",
      "icon": "house_siding_rounded",
    },
    {
      "title": "Escolha com confiança.",
      "subtitle": "Veja avaliações reais de outros clientes e escolha o prestador que melhor atende às suas necessidades.",
      "icon": "star_rounded",
    },
    {
      "title": "Seguro e Transparente.",
      "subtitle": "Pagamento facilitado via app e garantia de serviço realizado. Sem surpresas no valor final.",
      "icon": "verified_user_rounded",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () => _navigateToHome(),
            child: const Text("Pular", style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (value) => setState(() => _currentPage = value),
              itemCount: _onboardingData.length,
              itemBuilder: (context, index) => _buildPageContent(index),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  // Indicadores (Pontinhos)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _onboardingData.length,
                      (index) => _buildDot(index),
                    ),
                  ),
                  const Spacer(),
                  // Botão Próximo / Começar
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentPage == _onboardingData.length - 1) {
                          _navigateToHome();
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryNavy,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        _currentPage == _onboardingData.length - 1 ? "Começar" : "Próximo",
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToHome() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
  }

  Widget _buildPageContent(int index) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Espaço para Ilustração/Ícone minimalista
          Container(
            padding: const EdgeInsets.all(40),
            decoration: const BoxDecoration(color: Color(0xFFF8FAFC), shape: BoxShape.circle),
            child: Icon(_getIconData(_onboardingData[index]["icon"]!), size: 100, color: accentGreen),
          ),
          const SizedBox(height: 48),
          Text(
            _onboardingData[index]["title"]!,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: primaryNavy),
          ),
          const SizedBox(height: 16),
          Text(
            _onboardingData[index]["subtitle"]!,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Color(0xFF64748B), height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 8),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? primaryNavy : const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  IconData _getIconData(String name) {
    switch (name) {
      case "house_siding_rounded": return Icons.house_siding_rounded;
      case "star_rounded": return Icons.star_rounded;
      case "verified_user_rounded": return Icons.verified_user_rounded;
      default: return Icons.help_outline;
    }
  }
}
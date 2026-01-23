import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ijude_app/features/auth/presentation/pages/home_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Lista das telas que aparecerão em cada aba
  final List<Widget> _screens = [
    const ServiceSelectionPage(), // Sua Home (Índice 0)
    const PlaceholderPage(title: "Meus Pedidos", icon: Icons.assignment_outlined), // Pedidos (Índice 1)
    const PlaceholderPage(title: "Mensagens", icon: Icons.chat_bubble_outline), // Mensagens (Índice 2)
    const PlaceholderPage(title: "Meu Perfil", icon: Icons.person_outline), // Perfil (Índice 3)
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Cor Navy do iJude
    const Color iJudeNavy = Color(0xFF0F172A);

    return Scaffold(
      // Exibe a tela correspondente ao índice selecionado
      body: _screens[_selectedIndex],
      
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.withValues(alpha: 0.2))),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed, // Necessário para 4 ou mais itens
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF2563EB), // Azul "Início" do print
          unselectedItemColor: Colors.grey.shade400,
          selectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 12),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled), // Ícone de casa preenchido
              label: 'Início',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment), // Ícone de prancheta
              label: 'Pedidos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.forum), // Ícone de balão de mensagem
              label: 'Mensagens',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person), // Ícone de usuário
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }
}

// --- Tela Placeholder para as abas que ainda não existem ---
class PlaceholderPage extends StatelessWidget {
  final String title;
  final IconData icon;

  const PlaceholderPage({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false, // Remove o botão de voltar nessas abas
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              "Tela de $title",
              style: TextStyle(fontSize: 18, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 8),
            Text(
              "Em desenvolvimento",
              style: TextStyle(fontSize: 14, color: Colors.grey.shade400),
            ),
          ],
        ),
      ),
    );
  }
}
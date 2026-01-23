import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ijude_app/features/auth/presentation/pages/home_page.dart';
import 'package:ijude_app/features/auth/presentation/pages/messages_page.dart';
import 'package:ijude_app/features/auth/presentation/pages/orders_page.dart';
import 'package:ijude_app/features/auth/presentation/pages/profile_page.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Lista organizada chamando as classes dos outros arquivos
  final List<Widget> _screens = [
    const ServiceSelectionPage(), // Home (índice 0)
    const OrdersPage(),           // Pedidos (índice 1)
    const MessagesPage(),         // Mensagens (índice 2)
    const ProfilePage(),          // Perfil (índice 3)
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Mantém o estado das páginas para não recarregar tudo ao trocar de aba (Opcional, mas recomendado)
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.withValues(alpha: 0.2))),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF2563EB), // Azul do print
          unselectedItemColor: Colors.grey.shade400,
          selectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 12),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Início',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment),
              label: 'Pedidos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.forum),
              label: 'Mensagens',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/auth_provider.dart';
import 'package:ijude_app/features/auth/presentation/pages/home_page.dart';
import 'package:ijude_app/features/auth/presentation/pages/messages_page.dart';
import 'package:ijude_app/features/auth/presentation/pages/orders_page.dart';
import 'package:ijude_app/features/auth/presentation/pages/profile_page.dart';
import 'package:ijude_app/features/auth/presentation/pages/terms_page.dart'; 

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const ServiceSelectionPage(), 
    const OrdersPage(),           
    const MessagesPage(),         
    const ProfilePage(),          
  ];

  @override
  void initState() {
    super.initState();
    // Executa a verificação assim que o frame for renderizado
    _checkTermsStatus();
  }

  void _checkTermsStatus() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final auth = Provider.of<AuthProvider>(context, listen: false);
      
      // Se autenticado mas o status no Neon ainda for FALSE
      if (auth.isAuthenticated && auth.user != null && !auth.user!.termsAccepted) {
        // AJUSTE CRÍTICO: pushReplacement impede que esta tela continue 
        // tentando redirecionar em segundo plano, quebrando o loop.
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const TermsPage()),
        );
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          selectedItemColor: const Color(0xFF2563EB),
          unselectedItemColor: Colors.grey.shade400,
          selectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 12),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Início'),
            BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Pedidos'),
            BottomNavigationBarItem(icon: Icon(Icons.forum), label: 'Mensagens'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          ],
        ),
      ),
    );
  }
}
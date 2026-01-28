import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ijude_app/features/auth/presentation/pages/login_page.dart';
import '../../../../core/auth_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Escuta as mudanças no AuthProvider
    final auth = Provider.of<AuthProvider>(context);
    final bool isLoggedIn = auth.isAuthenticated;
    final user = auth.user;

    const Color iJudeNavy = Color(0xFF0F172A);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text("Meu Perfil", 
          style: GoogleFonts.inter(color: iJudeNavy, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          if (isLoggedIn)
            IconButton(
              icon: const Icon(Icons.settings_outlined, color: iJudeNavy),
              onPressed: () {},
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 32),
            
            // CABEÇALHO (Avatar e Nome)
            _buildHeader(isLoggedIn, user?.name, iJudeNavy),
            
            const SizedBox(height: 32),

            if (isLoggedIn) ...[
              // MENU PARA USUÁRIO LOGADO
              _buildMenuSection("Dados Pessoais", [
                _buildMenuItem(Icons.email_outlined, user?.email ?? "E-mail não informado"),
                _buildMenuItem(Icons.phone_android_outlined, user?.phone ?? "Telefone não informado"),
              ]),
              const SizedBox(height: 24),
              _buildMenuSection("Minha Atividade", [
                _buildMenuItem(Icons.history, "Histórico de Serviços"),
                _buildMenuItem(Icons.star_outline, "Minhas Avaliações"),
                _buildMenuItem(Icons.credit_card, "Métodos de Pagamento"),
              ]),
              const SizedBox(height: 32),
              
              // BOTÃO DE SAIR
              _buildLogoutButton(auth),
            ] else 
              // VISÃO DE VISITANTE
              _buildVisitorView(context, iJudeNavy),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS AUXILIARES ---

  Widget _buildHeader(bool isLoggedIn, String? name, Color color) {
    return Center(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blue.shade100, width: 2),
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: isLoggedIn 
                ? Text(name != null && name.isNotEmpty ? name[0].toUpperCase() : "U", 
                    style: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.bold, color: color))
                : Icon(Icons.person_outline, size: 50, color: Colors.grey.shade400),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isLoggedIn ? (name ?? "Usuário") : "Olá, Visitante",
            style: GoogleFonts.inter(fontSize: 22, color: color, fontWeight: FontWeight.bold),
          ),
          if (!isLoggedIn)
            const SizedBox(height: 4),
            if (!isLoggedIn)
              Text("Faça login para ver seus dados", 
                style: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade500)),
        ],
      ),
    );
  }

  Widget _buildMenuSection(String title, List<Widget> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.toUpperCase(), 
            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade400, letterSpacing: 1.1)),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              // ignore: deprecated_member_use
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
            ),
            child: Column(children: items),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF0F172A), size: 22),
      title: Text(title, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
      onTap: () {},
    );
  }

  Widget _buildVisitorView(BuildContext context, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: OutlinedButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage())),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: color, width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text("Login / Registro", 
            style: GoogleFonts.inter(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(AuthProvider auth) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: TextButton.icon(
          onPressed: () => auth.logout(),
          icon: const Icon(Icons.logout, color: Colors.red),
          label: Text("Sair da Conta", 
            style: GoogleFonts.inter(color: Colors.red, fontWeight: FontWeight.w600)),
          style: TextButton.styleFrom(
            // ignore: deprecated_member_use
            backgroundColor: Colors.red.withOpacity(0.1),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }
}
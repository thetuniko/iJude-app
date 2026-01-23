import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text("Meus Pedidos", style: GoogleFonts.inter(color: const Color(0xFF0F172A), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_outlined, size: 80, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              "Nenhum pedido recente",
              style: GoogleFonts.inter(fontSize: 18, color: Colors.grey.shade500, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              "Seus serviços contratados aparecerão aqui",
              style: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade400),
            ),
          ],
        ),
      ),
    );
  }
}
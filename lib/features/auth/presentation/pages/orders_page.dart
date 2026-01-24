import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../service_request/presentation/pages/category_selection_page.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          "Meus Pedidos", 
          style: GoogleFonts.inter(color: const Color(0xFF0F172A), fontWeight: FontWeight.bold)
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center, // Garante alinhamento horizontal
            children: [
              Icon(Icons.assignment_outlined, size: 80, color: Colors.grey.shade300),
              const SizedBox(height: 16),
              Text(
                "Nenhum pedido recente",
                style: GoogleFonts.inter(fontSize: 18, color: Colors.grey.shade500, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              // CORREÇÃO AQUI: textAlign: TextAlign.center
              Text(
                "Seus serviços contratados aparecerão aqui",
                style: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade400),
                textAlign: TextAlign.center, 
              ),
              
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CategorySelectionPage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F172A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "Novo Serviço",
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
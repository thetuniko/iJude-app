import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Dados mockados de endereços (centralizados aqui ou passados por parâmetro)
final List<Map<String, String>> _mockAddresses = [
  {"label": "Casa", "address": "Rua das Flores, 123"},
  {"label": "Trabalho", "address": "Av. Paulista, 900 - Sala 4 - Bloco C"},
  {"label": "Casa de Praia", "address": "Rua das Palmeiras, 45"},
];

// Função auxiliar para mostrar o modal
void showAddressSelectionSheet({
  required BuildContext context,
  required Map<String, String> currentAddress,
  required Function(Map<String, String>) onSelected,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40, 
                  height: 4, 
                  decoration: BoxDecoration(
                    color: Colors.grey[300], 
                    borderRadius: BorderRadius.circular(2)
                  )
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "Onde será o serviço?",
                style: GoogleFonts.inter(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold, 
                  color: const Color(0xFF0F172A)
                ),
              ),
              const SizedBox(height: 16),
              
              ..._mockAddresses.map((addr) {
                final isSelected = currentAddress['address'] == addr['address'];
                return ListTile(
                  onTap: () {
                    onSelected(addr); // Retorna o endereço selecionado
                    Navigator.pop(context);
                  },
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF2563EB).withValues(alpha: 0.1) : const Color(0xFFF1F5F9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isSelected ? Icons.check_circle : Icons.location_on_outlined,
                      color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF94A3B8),
                    ),
                  ),
                  title: Text(
                    addr['label']!,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold, 
                      color: const Color(0xFF0F172A)
                    ),
                  ),
                  subtitle: Text(
                    addr['address']!,
                    style: GoogleFonts.inter(color: const Color(0xFF64748B)),
                  ),
                  trailing: isSelected ? const Icon(Icons.check, color: Color(0xFF2563EB)) : null,
                );
              }),
              
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    // Lógica de cadastro viria aqui
                  },
                  icon: const Icon(Icons.add, color: Color(0xFF2563EB)),
                  label: Text(
                    "Cadastrar novo endereço",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold, 
                      color: const Color(0xFF2563EB)
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF2563EB)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      );
    },
  );
}
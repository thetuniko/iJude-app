import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../core/auth_provider.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/address/presentation/pages/address_registration_page.dart';

void showAddressSelectionSheet({
  required BuildContext context,
  required Map<String, String> currentAddress,
  required List<Map<String, String>> addresses,
  required Function(Map<String, String>) onSelected,
  VoidCallback? onRefresh,
}) {
  final authProvider = Provider.of<AuthProvider>(context, listen: false);
  final bool isLoggedIn = authProvider.user != null;

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              "Onde será o serviço?",
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 24),

            if (!isLoggedIn) ...[
              // ESTADO: VISITANTE
              Icon(Icons.account_circle_outlined, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                "Faça login para visualizar seus endereços cadastrados",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(color: Colors.grey[600], fontSize: 15),
              ),
              const SizedBox(height: 24),
              _buildLoginButton(context),
            ] else if (addresses.isEmpty) ...[
              // ESTADO: LOGADO MAS SEM ENDEREÇOS NO BANCO
              Icon(Icons.location_off_outlined, size: 56, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                "Seus endereços cadastrados aparecerão aqui", // ALTERAÇÃO SOLICITADA
                style: GoogleFonts.inter(
                  color: const Color(0xFF0F172A), 
                  fontWeight: FontWeight.w600,
                  fontSize: 16
                ),
              ),
              const SizedBox(height: 32),
              _buildAddButton(context, onRefresh),
            ] else ...[
              // ESTADO: LOGADO E COM ENDEREÇOS
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.4),
                child: ListView(
                  shrinkWrap: true,
                  children: addresses.map((addr) {
                    final bool isSelected = addr['address'] == currentAddress['address'];
                    return _buildAddressItem(addr, isSelected, onSelected, context);
                  }).toList(),
                ),
              ),
              const Divider(height: 32),
              _buildAddButton(context, onRefresh),
            ],
          ],
        ),
      );
    },
  );
}

Widget _buildLoginButton(BuildContext context) {
  return SizedBox(
    width: double.infinity,
    height: 50,
    child: ElevatedButton(
      onPressed: () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2563EB),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text("Fazer Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    ),
  );
}

Widget _buildAddressItem(Map<String, String> addr, bool isSelected, Function onSelected, BuildContext context) {
  return Container(
    margin: const EdgeInsets.only(bottom: 8),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: isSelected ? const Color(0xFFEFF6FF) : Colors.transparent,
      border: Border.all(color: isSelected ? const Color(0xFF2563EB) : Colors.transparent),
    ),
    child: ListTile(
      leading: Icon(Icons.location_on, color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF64748B)),
      title: Text(addr['label'] ?? 'Endereço', style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(addr['address'] ?? '', style: const TextStyle(fontSize: 12)),
      trailing: isSelected ? const Icon(Icons.check_circle, color: Color(0xFF2563EB), size: 20) : null,
      onTap: () {
        onSelected(addr);
        Navigator.pop(context);
      },
    ),
  );
}

Widget _buildAddButton(BuildContext context, VoidCallback? onRefresh) {
  return ListTile(
    onTap: () async {
      Navigator.pop(context);
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddressRegistrationPage()),
      );
      if (result == true && onRefresh != null) onRefresh();
    },
    leading: const CircleAvatar(
      backgroundColor: Color(0xFFF1F5F9),
      child: Icon(Icons.add, color: Color(0xFF0F172A)),
    ),
    title: const Text("Cadastrar novo endereço", style: TextStyle(fontWeight: FontWeight.w600)),
    trailing: const Icon(Icons.arrow_forward_ios, size: 14),
  );
}
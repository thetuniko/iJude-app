import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Importe o modal compartilhado
import '../../../../shared/widgets/address_selection_sheet.dart';

class ServiceDetailsPage extends StatefulWidget {
  final String categoryName;
  final String serviceName; // Ex: "Torneira vazando"

  const ServiceDetailsPage({
    super.key,
    required this.categoryName,
    required this.serviceName,
  });

  @override
  State<ServiceDetailsPage> createState() => _ServiceDetailsPageState();
}

class _ServiceDetailsPageState extends State<ServiceDetailsPage> {
  // Estado da Urgência (0=Baixa, 1=Média, 2=Alta)
  int selectedUrgency = 1; 

  // Estado do Endereço (Inicial padrão)
  Map<String, String> currentAddress = {
    "label": "Casa",
    "address": "Rua das Flores, 123"
  };

  @override
  Widget build(BuildContext context) {
    const Color iJudeBlue = Color(0xFF2563EB);
    const Color iJudeNavy = Color(0xFF0F172A);
    const Color iJudeBackground = Color(0xFFF8FAFC);
    const Color iJudeLightGray = Color(0xFFE2E8F0);

    return Scaffold(
      backgroundColor: iJudeBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: iJudeNavy),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Column(
          children: [
            Text("Detalhes do Serviço", style: GoogleFonts.inter(color: iJudeNavy, fontSize: 16, fontWeight: FontWeight.bold)),
            Text("Passo 3 de 5", style: GoogleFonts.inter(color: const Color(0xFF64748B), fontSize: 12)),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: [
                Expanded(child: Container(height: 4, margin: const EdgeInsets.symmetric(horizontal: 2), decoration: BoxDecoration(color: iJudeBlue, borderRadius: BorderRadius.circular(2)))),
                Expanded(child: Container(height: 4, margin: const EdgeInsets.symmetric(horizontal: 2), decoration: BoxDecoration(color: iJudeBlue, borderRadius: BorderRadius.circular(2)))),
                Expanded(child: Container(height: 4, margin: const EdgeInsets.symmetric(horizontal: 2), decoration: BoxDecoration(color: iJudeBlue, borderRadius: BorderRadius.circular(2)))),
                Expanded(child: Container(height: 4, margin: const EdgeInsets.symmetric(horizontal: 2), decoration: BoxDecoration(color: iJudeLightGray, borderRadius: BorderRadius.circular(2)))),
                Expanded(child: Container(height: 4, margin: const EdgeInsets.symmetric(horizontal: 2), decoration: BoxDecoration(color: iJudeLightGray, borderRadius: BorderRadius.circular(2)))),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Breadcrumbs (Categoria > Serviço)
            Row(
              children: [
                _buildChip(widget.categoryName, isPrimary: true),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, size: 16, color: Color(0xFF94A3B8)),
                const SizedBox(width: 8),
                _buildChip(widget.serviceName, isPrimary: false),
              ],
            ),
            const SizedBox(height: 24),

            // Campo de Descrição
            Text("Descreva o problema", style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: iJudeNavy)),
            const SizedBox(height: 8),
            Text("Quanto mais detalhes, melhor o profissional poderá ajudar", style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF64748B))),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: TextField(
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Ex: A torneira da pia da cozinha está vazando pelo registro...",
                  hintStyle: GoogleFonts.inter(color: const Color(0xFF94A3B8)),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ),
            
            const SizedBox(height: 24),

            // Upload de Fotos
            Text("Fotos ou vídeo do problema (opcional)", style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: iJudeNavy)),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFCBD5E1), style: BorderStyle.solid), // Simples dashed mock
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add, color: Color(0xFF64748B)),
                      const SizedBox(height: 4),
                      Text("0/3", style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B))),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.camera_alt_outlined, size: 16, color: Color(0xFF64748B)),
                const SizedBox(width: 4),
                Text("Até 3 fotos", style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B))),
                const SizedBox(width: 16),
                const Icon(Icons.videocam_outlined, size: 16, color: Color(0xFF64748B)),
                const SizedBox(width: 4),
                Text("ou 1 vídeo de 15s", style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B))),
              ],
            ),

            const SizedBox(height: 32),

            // Seleção de Urgência
            Text("Qual a urgência?", style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: iJudeNavy)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildUrgencyCard(0, "Baixa", "Pode esperar alguns dias", Colors.green)),
                const SizedBox(width: 12),
                Expanded(child: _buildUrgencyCard(1, "Média", "Resolver em até 24h", Colors.orange)),
                const SizedBox(width: 12),
                Expanded(child: _buildUrgencyCard(2, "Urgente", "Preciso resolver hoje", Colors.red)),
              ],
            ),

            const SizedBox(height: 32),

            // Local do Serviço (REUTILIZANDO LÓGICA)
            Text("Local do serviço", style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: iJudeNavy)),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                showAddressSelectionSheet(
                  context: context,
                  currentAddress: currentAddress,
                  onSelected: (newAddress) {
                    setState(() => currentAddress = newAddress);
                  },
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.location_on, color: iJudeBlue),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(currentAddress['address']!, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: iJudeNavy)),
                          Text("Alterar endereço", style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B))),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Botão Continuar
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                   print("Indo para Passo 4 (Agendamento)");
                   // Navigator.push...
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: iJudeNavy, // ALTERADO AQUI: De iJudeBlue para iJudeNavy (Preto/Azul Escuro)
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Text(
                  "Continuar",
                  style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Widget para os Chips do topo
  Widget _buildChip(String label, {required bool isPrimary}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isPrimary ? const Color(0xFFEFF6FF) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: isPrimary ? const Color(0xFF2563EB) : const Color(0xFF0F172A),
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  // Widget do Card de Urgência
  Widget _buildUrgencyCard(int index, String title, String subtitle, Color color) {
    final isSelected = selectedUrgency == index;
    
    return GestureDetector(
      onTap: () => setState(() => selectedUrgency = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withValues(alpha: 0.05), // Fundo suave se não selecionado
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: color, width: 2) : Border.all(color: Colors.transparent, width: 2),
        ),
        child: Column(
          children: [
            // Indicador de seleção (Bolinha)
            Align(
              alignment: Alignment.topRight,
              child: Container(
                width: 12, height: 12,
                decoration: BoxDecoration(
                  color: isSelected ? color : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(color: isSelected ? Colors.white : color.withValues(alpha: 0.3)),
                ),
              ),
            ),
            Icon(
              index == 0 ? Icons.info_outline : (index == 1 ? Icons.warning_amber : Icons.flash_on),
              color: isSelected ? Colors.white : color,
              size: 28
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : color,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: isSelected ? Colors.white.withValues(alpha: 0.9) : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
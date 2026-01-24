import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Importe o Modelo e o Repositório
import '../../../../shared/models/service_option.dart';
import '../../../../shared/data/mock_service_repository.dart';
import 'service_details_page.dart';

class ServiceOptionsPage extends StatefulWidget {
  final String categoryName;

  const ServiceOptionsPage({super.key, required this.categoryName});

  @override
  State<ServiceOptionsPage> createState() => _ServiceOptionsPageState();
}

class _ServiceOptionsPageState extends State<ServiceOptionsPage> {
  // Instancia o repositório de serviços
  final MockServiceRepository repository = MockServiceRepository();
  late List<ServiceOption> displayOptions;

  @override
  void initState() {
    super.initState();
    // Busca as opções da categoria selecionada (ex: Opções de "Hidráulica")
    displayOptions = repository.getOptionsByCategory(widget.categoryName);
  }

  @override
  Widget build(BuildContext context) {
    const Color iJudeBlue = Color(0xFF2563EB);
    const Color iJudeNavy = Color(0xFF0F172A);
    const Color iJudeBackground = Color(0xFFF8FAFC);
    const Color iJudeGrayText = Color(0xFF64748B);
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
            Text(
              widget.categoryName,
              style: GoogleFonts.inter(
                color: iJudeNavy,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              "Passo 2 de 5",
              style: GoogleFonts.inter(
                color: iJudeGrayText,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        // Barra de progresso (2 de 5)
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: [
                Expanded(child: Container(height: 4, margin: const EdgeInsets.symmetric(horizontal: 2), decoration: BoxDecoration(color: iJudeBlue, borderRadius: BorderRadius.circular(2)))),
                Expanded(child: Container(height: 4, margin: const EdgeInsets.symmetric(horizontal: 2), decoration: BoxDecoration(color: iJudeBlue, borderRadius: BorderRadius.circular(2)))),
                Expanded(child: Container(height: 4, margin: const EdgeInsets.symmetric(horizontal: 2), decoration: BoxDecoration(color: iJudeLightGray, borderRadius: BorderRadius.circular(2)))),
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
            const SizedBox(height: 16),
            // Chip da Categoria
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: iJudeBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                widget.categoryName,
                style: GoogleFonts.inter(
                  color: iJudeBlue,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Título
            Text(
              "Qual é o problema?",
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: iJudeNavy,
              ),
            ),
            const SizedBox(height: 24),

            // Lista de Opções
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              // +1 para o botão "Outros" no final
              itemCount: displayOptions.length + 1,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                // Caso seja o último item, renderiza "Outros"
                if (index == displayOptions.length) {
                   return _OptionCard(
                    title: "Outros",
                    price: "A combinar",
                    time: "Variável",
                    onTap: () {
                      // Navega para a próxima etapa como "Outros"
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ServiceDetailsPage(
                            categoryName: widget.categoryName,
                            serviceName: "Outros",
                          ),
                        ),
                      );
                    },
                  );
                }

                // Renderiza as opções normais vindas do repositório
                final option = displayOptions[index];
                return _OptionCard(
                  title: option.title,
                  // Formatação visual do preço
                  price: option.priceFormatted.replaceAll("R\$", "\$ R\$"), 
                  time: option.timeEstimate,
                  onTap: () {
                    // NAVEGAÇÃO PARA O PASSO 3 (Detalhes)
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ServiceDetailsPage(
                          categoryName: widget.categoryName,
                          serviceName: option.title,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// Widget do Cartão de Opção
class _OptionCard extends StatelessWidget {
  final String title;
  final String price;
  final String time;
  final VoidCallback onTap;

  const _OptionCard({
    required this.title,
    required this.price,
    required this.time,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const Color iJudeNavy = Color(0xFF0F172A);
    const Color iJudeGrayText = Color(0xFF64748B);
    const Color iJudeIconGray = Color(0xFF94A3B8);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: iJudeNavy,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        price,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: iJudeGrayText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.access_time, size: 16, color: iJudeIconGray),
                      const SizedBox(width: 4),
                      Text(
                        time,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: iJudeGrayText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: iJudeIconGray),
          ],
        ),
      ),
    );
  }
}
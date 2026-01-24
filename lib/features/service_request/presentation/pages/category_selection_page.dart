import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Imports de dados e próxima tela
import '../../../../shared/models/service_category.dart';
import '../../../../shared/data/mock_category_repository.dart';
import 'service_options_page.dart';

class CategorySelectionPage extends StatefulWidget {
  const CategorySelectionPage({super.key});

  @override
  State<CategorySelectionPage> createState() => _CategorySelectionPageState();
}

class _CategorySelectionPageState extends State<CategorySelectionPage> {
  final MockCategoryRepository categoryRepository = MockCategoryRepository();
  late List<ServiceCategory> categories;

  @override
  void initState() {
    super.initState();
    categories = categoryRepository.getCategories();
  }

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
            Text(
              "Nova Solicitação",
              style: GoogleFonts.inter(
                color: iJudeNavy,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              "Passo 1 de 5",
              style: GoogleFonts.inter(
                color: const Color(0xFF64748B),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        // Barra de progresso (1 de 5)
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(6.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: [
                Expanded(child: Container(height: 4, margin: const EdgeInsets.symmetric(horizontal: 2), decoration: BoxDecoration(color: iJudeBlue, borderRadius: BorderRadius.circular(2)))),
                Expanded(child: Container(height: 4, margin: const EdgeInsets.symmetric(horizontal: 2), decoration: BoxDecoration(color: iJudeLightGray, borderRadius: BorderRadius.circular(2)))),
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
            Text(
              "Selecione a categoria",
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: iJudeNavy,
              ),
            ),
            const SizedBox(height: 24),
            
            // Grid de Categorias (Estilo IDÊNTICO à Home)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categories.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1, // Mesma proporção da Home
              ),
              itemBuilder: (context, index) {
                final cat = categories[index];
                
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ServiceOptionsPage(categoryName: cat.label),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white, // Fundo branco igual à Home
                      borderRadius: BorderRadius.circular(20), // Arredondamento igual
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Círculo colorido de fundo do ícone
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: cat.color.withValues(alpha: 0.1), 
                            shape: BoxShape.circle,
                          ),
                          child: Icon(cat.icon, size: 32, color: cat.color),
                        ),
                        const SizedBox(height: 12),
                        // Texto Navy (Escuro)
                        Text(
                          cat.label,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            color: iJudeNavy, 
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
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
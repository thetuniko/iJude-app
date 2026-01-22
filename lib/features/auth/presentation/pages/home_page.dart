import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ServiceSelectionPage extends StatefulWidget {
  const ServiceSelectionPage({super.key});

  @override
  State<ServiceSelectionPage> createState() => _ServiceSelectionPageState();
}

class _ServiceSelectionPageState extends State<ServiceSelectionPage> {
  String? selectedCategory;

  final List<Map<String, dynamic>> categories = [
    {"label": "Elétrica", "icon": Icons.bolt, "color": Colors.orange},
    {"label": "Hidráulica", "icon": Icons.water_drop, "color": Colors.blue},
    {"label": "Pintura", "icon": Icons.format_paint, "color": Colors.purple},
    {"label": "Montagem", "icon": Icons.inventory_2, "color": Colors.deepOrange},
    {"label": "Ar-condicionado", "icon": Icons.air, "color": Colors.cyan},
    {"label": "Jardinagem", "icon": Icons.park, "color": Colors.green},
    {"label": "Limpeza", "icon": Icons.auto_awesome, "color": Colors.pink},
    {"label": "Outros", "icon": Icons.build, "color": Colors.blueGrey},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("iJude", style: TextStyle(color: Color(0xFF0F172A), fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Text(
                    "Olá, como podemos\nte iJudar hoje?",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(fontSize: 26, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
                  ),
                  const SizedBox(height: 32),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: categories.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.1,
                    ),
                    itemBuilder: (context, index) {
                      final cat = categories[index];
                      final isSelected = selectedCategory == cat['label'];
                      return GestureDetector(
                        onTap: () => setState(() => selectedCategory = cat['label']),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected ? const Color(0xFF0F172A) : Colors.transparent,
                              width: 2.5,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(cat['icon'], size: 32, color: cat['color']),
                              const SizedBox(height: 12),
                              Text(cat['label'], style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: selectedCategory != null ? () {} : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F172A),
                  disabledBackgroundColor: const Color(0xFFE2E8F0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  "Continuar",
                  style: TextStyle(
                    color: selectedCategory != null ? Colors.white : const Color(0xFF94A3B8),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
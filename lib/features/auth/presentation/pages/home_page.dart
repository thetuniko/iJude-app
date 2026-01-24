import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ijude_app/features/auth/presentation/pages/features/notifications_page.dart';

// Se tiver a tela de pedido pronta, descomente a linha abaixo:
// import '../../../service_request/presentation/pages/service_request_page.dart';

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
    const Color iJudeBlue = Color(0xFF2563EB);
    const Color iJudeNavy = Color(0xFF0F172A);
    const Color iJudeRed = Color(0xFFEF4444);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      
      // BOTÃO SOS FLUTUANTE
      // Ele desaparece se uma categoria estiver selecionada (para dar espaço ao botão Continuar)
      floatingActionButton: selectedCategory == null ? Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: iJudeRed.withValues(alpha: 0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () => _showSOSModal(context),
          backgroundColor: iJudeRed,
          shape: const CircleBorder(),
          elevation: 0,
          child: const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 32),
        ),
      ) : null,

      body: SafeArea(
        child: Column(
          children: [
            // 1. Barra Superior (Endereço e Notificação)
            _buildCustomAppBar(context),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    // 2. Cabeçalho
                    Text(
                      "Olá, Antonio!",
                      style: GoogleFonts.inter(
                        fontSize: 26, fontWeight: FontWeight.w800, color: iJudeNavy
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "O que precisa de reparo hoje?",
                      style: GoogleFonts.inter(
                        fontSize: 16, color: const Color(0xFF64748B), fontWeight: FontWeight.w500
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // 3. Barra de Pesquisa
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: iJudeBlue.withValues(alpha: 0.1),
                            blurRadius: 10, offset: const Offset(0, 4)
                          )
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "O que precisa de reparo?",
                          hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                          prefixIcon: const Icon(Icons.search, color: iJudeBlue),
                          suffixIcon: Container(
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: iJudeBlue.withValues(alpha: 0.1), shape: BoxShape.circle
                            ),
                            child: const Icon(Icons.mic, color: iJudeBlue, size: 20),
                          ),
                          filled: true, fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(vertical: 16),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: iJudeBlue, width: 1.5)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: iJudeBlue, width: 1.5)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: iJudeBlue, width: 2)),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // 4. Grid de Categorias
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: categories.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 1.1
                      ),
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        final isSelected = selectedCategory == cat['label'];

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              // LÓGICA DE TOGGLE (MARCAR/DESMARCAR)
                              if (selectedCategory == cat['label']) {
                                selectedCategory = null; // Desmarca se já estava selecionado
                              } else {
                                selectedCategory = cat['label']; // Seleciona o novo
                              }
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: Colors.white, borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: isSelected ? iJudeNavy : Colors.transparent, width: 2.5),
                              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(color: cat['color'].withValues(alpha: 0.1), shape: BoxShape.circle),
                                  child: Icon(cat['icon'], size: 32, color: cat['color']),
                                ),
                                const SizedBox(height: 12),
                                Text(cat['label'], style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: iJudeNavy)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // 5. Botão Continuar Animado
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: selectedCategory != null ? 100 : 0, // Cresce ou diminui
              child: selectedCategory != null ? Padding(
                padding: const EdgeInsets.all(24.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      print("Indo para detalhes de: $selectedCategory");
                      // Navigator.push(context, MaterialPageRoute(builder: (_) => ServiceRequestPage(...)));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: iJudeNavy,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 5,
                    ),
                    child: const Text(
                      "Continuar",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ) : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  // Widget da Barra Superior
  Widget _buildCustomAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.location_on, color: Color(0xFF2563EB), size: 24),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Seu endereço", style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF64748B))),
                  Row(
                    children: [
                      Text("Rua das Flores, 123", style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))),
                      const Icon(Icons.keyboard_arrow_down, size: 16, color: Color(0xFF0F172A)),
                    ],
                  ),
                ],
              ),
            ],
          ),
          
          // Lado Direito: Notificação Clicável
          GestureDetector(
            onTap: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => const NotificationsPage())
              );
            },
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.notifications_none, color: Color(0xFF0F172A), size: 24),
                ),
                Positioned(
                  right: 10, top: 10,
                  child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Função para abrir o modal SOS
  void _showSOSModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (context) => const _SOSContent(),
    );
  }
}

// Conteúdo do Modal SOS
class _SOSContent extends StatelessWidget {
  const _SOSContent();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 24), decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
          Row(
            children: [
              Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFFFEF2F2), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444), size: 28)),
              const SizedBox(width: 16),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("SOS Emergência", style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))), Text("Atendimento prioritário", style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF64748B)))]),
              const Spacer(), IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close, color: Color(0xFF94A3B8))),
            ],
          ),
          const SizedBox(height: 32),
          _buildEmergencyOption(Icons.water_drop, "Vazamento / Inundação", Colors.blue),
          const SizedBox(height: 16),
          _buildEmergencyOption(Icons.bolt, "Curto-circuito", Colors.amber[700]!),
          const SizedBox(height: 16),
          _buildEmergencyOption(Icons.local_fire_department, "Vazamento de Gás", const Color(0xFFEF4444)),
          const SizedBox(height: 32),
          const Text("Emergência grave? Ligue imediatamente", style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, height: 56, child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.phone, color: Color(0xFF0F172A)), label: Text("Ligar para Suporte", style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A))), style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFFE2E8F0)), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))))),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildEmergencyOption(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16)),
      child: Row(children: [Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color, shape: BoxShape.circle), child: Icon(icon, color: Colors.white, size: 24)), const SizedBox(width: 16), Text(label, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF0F172A)))]),
    );
  }
}
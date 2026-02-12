import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Core e Providers
import '../../../../core/auth_provider.dart';
import '../../../../core/api_config.dart';

// Componentes e Páginas
import '../../../../shared/widgets/address_selection_sheet.dart';
import '../../../../shared/models/service_category.dart';
import '../../../../shared/data/mock_category_repository.dart';
import '../../../service_request/presentation/pages/service_options_page.dart';

class ServiceSelectionPage extends StatefulWidget {
  const ServiceSelectionPage({super.key});

  @override
  State<ServiceSelectionPage> createState() => _ServiceSelectionPageState();
}

class _ServiceSelectionPageState extends State<ServiceSelectionPage> {
  final MockCategoryRepository categoryRepository = MockCategoryRepository();
  late List<ServiceCategory> categories;
  String? selectedCategory;
  
  List<Map<String, String>> userAddresses = [];
  bool _isLoadingAddresses = false;

  Map<String, String> currentAddress = {
    "label": "Casa",
    "address": "Cadastre um endereço"
  };

  @override
  void initState() {
    super.initState();
    categories = categoryRepository.getCategories();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchUserAddresses();
    });
  }

  Future<void> _fetchUserAddresses() async {
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    if (user == null) return;
    
    if (mounted) setState(() => _isLoadingAddresses = true);

    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/client/addresses/${user.id}'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            userAddresses = data.map((addr) => {
              "label": addr['label'].toString(),
              // ALTERAÇÃO: Agora pegamos apenas Rua e Número para a exibição
              "address": "${addr['street']}, ${addr['number']}",
            }).toList();
            if (userAddresses.isNotEmpty) currentAddress = userAddresses.first;
          });
        }
      }
    } catch (e) {
      debugPrint("Erro ao carregar endereços: $e");
    } finally {
      if (mounted) setState(() => _isLoadingAddresses = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color iJudeNavy = Color(0xFF0F172A);
    const Color iJudeBlue = Color(0xFF2563EB);
    const Color iJudeRed = Color(0xFFEF4444);

    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    final String fullName = user?.name ?? "visitante";
    final String firstName = fullName.split(' ').first;

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: selectedCategory == null ? _buildSOSButton(iJudeRed) : null,
      body: SafeArea(
        child: Column(
          children: [
            _buildCustomAppBar(context, iJudeBlue, iJudeNavy, user != null),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    Text("Olá, $firstName!", 
                      style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w800, color: iJudeNavy)),
                    const SizedBox(height: 8),
                    Text("O que precisa de reparo hoje?", 
                      style: GoogleFonts.inter(fontSize: 16, color: Colors.grey[600], fontWeight: FontWeight.w500)),
                    const SizedBox(height: 24),
                    _buildSearchBar(iJudeBlue),
                    const SizedBox(height: 32),
                    _buildGrid(iJudeNavy),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            _buildContinueButton(iJudeNavy),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomAppBar(BuildContext context, Color primaryColor, Color navy, bool isLoggedIn) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded( // Expanded adicionado para garantir que o endereço ocupe o espaço sem estourar
            child: GestureDetector(
              onTap: () {
                showAddressSelectionSheet(
                  context: context,
                  currentAddress: currentAddress,
                  addresses: userAddresses, 
                  onSelected: (newAddress) => setState(() => currentAddress = newAddress),
                  onRefresh: _fetchUserAddresses,
                );
              },
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _isLoadingAddresses 
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                      : Icon(Icons.location_on, color: primaryColor, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded( // Expanded interno para permitir que o texto se ajuste
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isLoggedIn ? currentAddress['label']! : "Bem-vindo!", 
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Row(
                          children: [
                            Flexible( // Flexible com ellipsis resolve o erro de Right Overflow
                              child: Text(
                                isLoggedIn ? currentAddress['address']! : "Entre para ver seus endereços", 
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold, 
                                  fontSize: 14, 
                                  color: Color(0xFF0F172A),
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            const Icon(Icons.keyboard_arrow_down, size: 18),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10), // Pequeno recuo antes do sino de notificação
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
                child: Icon(Icons.notifications_none, color: navy),
              ),
              Positioned(
                right: 8, top: 8,
                child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Métodos _buildSearchBar, _buildGrid, _buildSOSButton e _buildContinueButton permanecem iguais
  Widget _buildSearchBar(Color blue) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        // ignore: deprecated_member_use
        border: Border.all(color: blue.withOpacity(0.5), width: 1.5),
        boxShadow: [
          // ignore: deprecated_member_use
          BoxShadow(color: blue.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: "O que precisa de reparo?",
          hintStyle: TextStyle(color: Colors.grey[400]),
          icon: Icon(Icons.search, color: blue),
          suffixIcon: Icon(Icons.mic, color: blue),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildGrid(Color navy) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final cat = categories[index];
        final isSelected = selectedCategory == cat.label;
        return GestureDetector(
          onTap: () => setState(() => selectedCategory = isSelected ? null : cat.label),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: isSelected ? navy : Colors.transparent, width: 2),
              boxShadow: [
                // ignore: deprecated_member_use
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: cat.color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(cat.icon, color: cat.color, size: 30),
                ),
                const SizedBox(height: 12),
                Text(cat.label, 
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: navy)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSOSButton(Color red) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // ignore: deprecated_member_use
        boxShadow: [BoxShadow(color: red.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: FloatingActionButton(
        onPressed: () {},
        backgroundColor: red,
        elevation: 0,
        child: const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildContinueButton(Color navy) {
    if (selectedCategory == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        width: double.infinity, height: 56,
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => ServiceOptionsPage(categoryName: selectedCategory!),
            ));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: navy,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text("Continuar", 
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        ),
      ),
    );
  }
}
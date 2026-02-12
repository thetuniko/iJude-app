import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Adicionado para máscaras de entrada
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../../../../core/api_config.dart';
import '../../../../core/auth_provider.dart';

class AddressRegistrationPage extends StatefulWidget {
  const AddressRegistrationPage({super.key});

  @override
  State<AddressRegistrationPage> createState() => _AddressRegistrationPageState();
}

class _AddressRegistrationPageState extends State<AddressRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Controllers
  final _labelController = TextEditingController();
  final _streetController = TextEditingController();
  final _numberController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _neighborhoodController = TextEditingController();
  final _cityController = TextEditingController();

  Future<void> _saveAddress() async {
    // 1. Validação local do formulário
    if (!_formKey.currentState!.validate()) return;

    // 2. Recupera o usuário logado para vincular o endereço no banco Neon
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.user?.id;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Sessão expirada. Faça login novamente.")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 3. Envio para o endpoint configurado no NestJS
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/client/address'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'clientId': userId,
          'label': _labelController.text.trim(),
          'street': _streetController.text.trim(),
          'number': _numberController.text.trim(),
          // Envia apenas números para o PostgreSQL
          'zipCode': _zipCodeController.text.replaceAll(RegExp(r'[^0-9]'), ''),
          'neighborhood': _neighborhoodController.text.trim(),
          'city': _cityController.text.trim(),
        }),
      );

      // Verificação de segurança para BuildContext assíncrono (resolve o aviso de lint)
      if (!mounted) return;

      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Endereço salvo com sucesso!"), 
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        // Retorna 'true' para sinalizar que a Home deve atualizar a lista dinâmica
        Navigator.pop(context, true);
      } else {
        final errorData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorData['message'] ?? "Erro ao salvar endereço")),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Falha na conexão. Verifique sua internet.")),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color iJudeNavy = Color(0xFF0F172A);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Novo Endereço", 
          style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: iJudeNavy)),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: iJudeNavy, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: iJudeNavy))
        : Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              children: [
                _buildField(
                  label: "Apelido", 
                  controller: _labelController, 
                  hint: "Ex: Casa, Trabalho, Mãe",
                  icon: Icons.bookmark_outline,
                  iJudeNavy: iJudeNavy,
                ),
                const SizedBox(height: 16),
                _buildField(
                  label: "CEP", 
                  controller: _zipCodeController, 
                  hint: "00000-000",
                  icon: Icons.map_outlined,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    _ZipCodeFormatter(), // Máscara automática (00000-000)
                  ],
                  iJudeNavy: iJudeNavy,
                ),
                const SizedBox(height: 16),
                _buildField(
                  label: "Rua", 
                  controller: _streetController, 
                  hint: "Nome do logradouro",
                  icon: Icons.route_outlined,
                  iJudeNavy: iJudeNavy,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      flex: 2, 
                      child: _buildField(
                        label: "Número", 
                        controller: _numberController, 
                        hint: "123",
                        keyboardType: TextInputType.number,
                        iJudeNavy: iJudeNavy,
                      )
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 3, 
                      child: _buildField(
                        label: "Bairro", 
                        controller: _neighborhoodController, 
                        hint: "Ex: Centro",
                        iJudeNavy: iJudeNavy,
                      )
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildField(
                  label: "Cidade", 
                  controller: _cityController, 
                  hint: "Sua cidade",
                  icon: Icons.location_city_outlined,
                  iJudeNavy: iJudeNavy,
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveAddress,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: iJudeNavy,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Text("Salvar Endereço", 
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
    );
  }

  Widget _buildField({
    required String label, 
    required TextEditingController controller, 
    required String hint, 
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    required Color iJudeNavy,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, 
          style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14, color: const Color(0xFF0F172A))),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          style: GoogleFonts.inter(fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
            prefixIcon: icon != null ? Icon(icon, color: const Color(0xFF64748B), size: 20) : null,
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12), 
              borderSide: const BorderSide(color: Color(0xFFE2E8F0))
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: iJudeNavy, width: 1),
            ),
          ),
          validator: (value) => value == null || value.isEmpty ? "Campo obrigatório" : null,
        ),
      ],
    );
  }
}

// Classe auxiliar para formatar o CEP enquanto o usuário digita
class _ZipCodeFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    if (text.length > 8) return oldValue;
    
    var selectionIndex = newValue.selection.end;
    var newText = text;

    if (text.length > 5) {
      newText = '${text.substring(0, 5)}-${text.substring(5)}';
      selectionIndex++;
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
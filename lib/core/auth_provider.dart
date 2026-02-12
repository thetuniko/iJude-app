import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../shared/models/user_model.dart';
import 'api_config.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;
  bool get isAuthenticated => _user != null;

  void setUser(UserModel user) {
    _user = user;
    notifyListeners(); 
  }

  void logout() {
    _user = null;
    notifyListeners();
  }

  /// Método atualizado para quebrar o loop definitivamente
  Future<void> acceptTerms() async {
    if (_user == null) return;

    // 1. ATUALIZAÇÃO OTIMISTA: Mudamos o estado local ANTES da rede.
    // Isso garante que a MainScreen veja 'true' no próximo frame e pare o loop.
    final userBackup = _user;
    _user = _user!.copyWith(termsAccepted: true);
    notifyListeners(); 

    final url = Uri.parse('${ApiConfig.baseUrl}/client/${_user!.id}/accept-terms');

    try {
      debugPrint('Solicitando aceite de termos no servidor para ID: ${userBackup!.id}...');
      
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10)); // Evita que o app trave se o Render demorar

      // 2. VERIFICAÇÃO DE SUCESSO NO BANCO NEON
      if (response.statusCode == 200 || response.statusCode == 204) {
        debugPrint('✅ Sucesso no Render/Neon: Termos aceitos permanentemente.');
      } else {
        // Se o servidor falhar feio, revertemos o estado para segurança
        _user = userBackup;
        notifyListeners();
        debugPrint('❌ Erro no Servidor: Status ${response.statusCode}. Revertendo estado local.');
      }
    } catch (e) {
      // Em caso de erro de conexão, mantemos como 'true' localmente para não frustrar o usuário,
      // mas logamos o erro para debug no WSL.
      debugPrint('⚠️ Falha de conexão com o backend: $e. Mantendo aceite local para evitar loop.');
    }
  }
}
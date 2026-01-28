import 'package:flutter/material.dart';
import '../shared/models/user_model.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;
  bool get isAuthenticated => _user != null;

  // Função para salvar o usuário após o login
  void setUser(UserModel user) {
    _user = user;
    notifyListeners(); // Avisa todas as telas para se atualizarem
  }

  // Função para deslogar
  void logout() {
    _user = null;
    notifyListeners();
  }
}
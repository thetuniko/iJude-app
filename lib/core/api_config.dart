import 'package:flutter/foundation.dart';

class ApiConfig {
  static String get baseUrl {
    if (kReleaseMode) {
      // 🚀 PRODUÇÃO (Quando estiver no GitHub Pages)
      return 'https://ijude-client-backend.onrender.com'; 
    } else {
      // 🛠️ DESENVOLVIMENTO (Quando estiver no PC)
      return 'http://localhost:3000';
    }
  }
}
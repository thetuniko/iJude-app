import 'package:flutter/material.dart';

class ServiceCategory {
  final String id;
  final String label;
  final IconData icon; // No futuro, isso pode ser uma String (URL da imagem ou nome do ícone)
  final Color color;   // No futuro, isso virá como Hex String (ex: "#FF5733") do banco

  ServiceCategory({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
  });
}
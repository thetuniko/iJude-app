import 'package:flutter/material.dart';
import '../models/service_category.dart';

class MockCategoryRepository {
  // Simula o Banco de Dados
  final List<ServiceCategory> _categories = [
    ServiceCategory(id: '1', label: "Elétrica", icon: Icons.bolt, color: Colors.orange),
    ServiceCategory(id: '2', label: "Hidráulica", icon: Icons.water_drop, color: Colors.blue),
    ServiceCategory(id: '3', label: "Pintura", icon: Icons.format_paint, color: Colors.purple),
    ServiceCategory(id: '4', label: "Montagem", icon: Icons.inventory_2, color: Colors.deepOrange),
    ServiceCategory(id: '5', label: "Ar-condicionado", icon: Icons.air, color: Colors.cyan),
    ServiceCategory(id: '6', label: "Jardinagem", icon: Icons.park, color: Colors.green),
    ServiceCategory(id: '7', label: "Limpeza", icon: Icons.auto_awesome, color: Colors.pink),
    ServiceCategory(id: '8', label: "Outros", icon: Icons.build, color: Colors.blueGrey),
  ];

  List<ServiceCategory> getCategories() {
    return _categories;
  }
}
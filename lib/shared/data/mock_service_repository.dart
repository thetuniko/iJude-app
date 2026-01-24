import '../models/service_option.dart'; // <--- Esse import não pode estar vermelho

class MockServiceRepository {
  final List<ServiceOption> _allOptions = [
    ServiceOption(id: '1', categoryId: 'Jardinagem', title: 'Corte de grama', minPrice: 80, maxPrice: 200, timeEstimate: '1-3h'),
    ServiceOption(id: '2', categoryId: 'Jardinagem', title: 'Poda de árvore', minPrice: 100, maxPrice: 300, timeEstimate: '2-4h'),
    ServiceOption(id: '4', categoryId: 'Elétrica', title: 'Troca de chuveiro', minPrice: 80, maxPrice: 150, timeEstimate: '1h'),
    // ... adicione mais se quiser
  ];

  List<ServiceOption> getOptionsByCategory(String category) {
    final options = _allOptions.where((op) => op.categoryId == category).toList();
    if (options.isEmpty) {
      return [
        ServiceOption(id: '99', categoryId: category, title: 'Avaliação Técnica', minPrice: 50, maxPrice: 100, timeEstimate: 'Var.'),
      ];
    }
    return options;
  }
}
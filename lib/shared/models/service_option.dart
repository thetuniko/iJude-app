class ServiceOption {
  final String id;
  final String title;
  final String categoryId;
  final double minPrice;
  final double maxPrice;
  final String timeEstimate;

  ServiceOption({
    required this.id,
    required this.title,
    required this.categoryId,
    required this.minPrice,
    required this.maxPrice,
    required this.timeEstimate,
  });

  String get priceFormatted => "R\$ ${minPrice.toStringAsFixed(0)}-${maxPrice.toStringAsFixed(0)}";
}
class AddressModel {
  final String id;
  final String label;
  final String address;

  AddressModel({required this.id, required this.label, required this.address});

  // Converte o JSON do Backend para o objeto Dart
  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'],
      label: json['label'],
      // Monta a string de endereço amigável
      address: "${json['street']}, ${json['number']} - ${json['neighborhood']}",
    );
  }
}
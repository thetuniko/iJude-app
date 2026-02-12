class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final bool termsAccepted;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.termsAccepted,
  });

  // Converte o JSON que vem do Render (NestJS) para o objeto Flutter
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      // Garante que o valor nulo do Neon vire false por padrão
      termsAccepted: json['termsAccepted'] ?? false,
    );
  }

  // Método auxiliar para facilitar a atualização de estado no AuthProvider
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    bool? termsAccepted,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      termsAccepted: termsAccepted ?? this.termsAccepted,
    );
  }
}
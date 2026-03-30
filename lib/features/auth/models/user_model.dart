class UserModel {
  final int id;
  final String username;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? email;
  final List<String> permissions;

  UserModel({
    required this.id,
    required this.username,
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    required this.permissions,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      phone: json['phone'],
      email: json['email'],
      permissions: List<String>.from(json['permissions'] ?? []),
    );
  }
}

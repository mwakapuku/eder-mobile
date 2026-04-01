import 'dart:ffi';

class UserModel {
  final int id;
  final String username;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? email;
  final List<String> permissions;
  final List<int> groups;

  UserModel({
    required this.id,
    required this.username,
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    required this.permissions,
    required this.groups,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    try {
      return UserModel(
        id: json['id'],
        username: json['username'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        phone: json['phone'],
        email: json['email'],
        permissions: List<String>.from(json['permissions'] ?? []),
        groups: (json['groups'] as List?)?.map((e) => e as int).toList() ?? [],
      );
    } catch (e) {
      print('❌ UserModel.fromJson failed: $e');
      print('❌ raw json: $json');
      rethrow;
    }
  }

  String get fullName => '$firstName $lastName'.trim();

  Map<String, dynamic> toJson() => {
    'first_name': firstName,
    'last_name': lastName,
    'username': username,
    'email': email,
    if (phone != null) 'phone': phone,
    'groups': groups,
  };

  UserModel copyWith({
    String? firstName,
    String? lastName,
    String? username,
    String? email,
    String? phone,
    List<String>? permissions,
    List<int>? groups,
  }) => UserModel(
    id: id,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    username: username ?? this.username,
    email: email ?? this.email,
    phone: phone ?? this.phone,
    permissions: permissions ?? this.permissions,
    groups: groups ?? this.groups,
  );
}

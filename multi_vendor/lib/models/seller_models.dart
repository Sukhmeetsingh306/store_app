import 'dart:convert';
import '../utils/widget/random/avatar_random.dart';

class SellerModels {
  final String id;
  final String name;
  final String email;
  final String state;
  final String city;
  final String locality;
  final String password;
  final List<String> roles;
  final String primaryRole; // 🔹 new primary role
  final String image;
  int? age;
  String? phone;

  SellerModels({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.age,
    required this.state,
    required this.city,
    required this.locality,
    required this.password,
    required this.roles,
    String? primaryRole,
    String? image,
  })  : primaryRole = primaryRole ?? _determinePrimaryRole(roles),
        image = image ?? generateRandomAvatar();

  static String _determinePrimaryRole(List<String> roles) {
    if (roles.contains("admin")) return "admin";
    if (roles.contains("seller")) return "seller";
    if (roles.contains("consumer")) return "consumer";
    return "";
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'age': age,
      'state': state,
      'city': city,
      'locality': locality,
      'password': password,
      'roles': roles,
      'primaryRole': primaryRole,
      'image': image,
    };
  }

  factory SellerModels.fromMap(Map<String, dynamic> map) {
    final rolesList = List<String>.from(map['roles'] ?? ['seller']);
    return SellerModels(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'],
      age: map['age'],
      state: map['state'] ?? '',
      city: map['city'] ?? '',
      locality: map['locality'] ?? '',
      password: map['password'] ?? '',
      roles: rolesList,
      primaryRole: map['primaryRole'],
      image: map['image'] ?? generateRandomAvatar(),
    );
  }

  String toJsonString() => json.encode(toJson());

  factory SellerModels.fromJson(String source) {
    return SellerModels.fromMap(json.decode(source));
  }
}

import 'dart:convert';
import 'package:random_avatar/random_avatar.dart';

class LoginUserModel {
  final String id;
  final String name;
  final String email;
  String? phone;
  int? age;
  final String state;
  final String city;
  final String locality;
  final String password;
  final String token;
  final List<String> roles; // all roles
  final String primaryRole; // 🔹 new primary role
  final String image;

  LoginUserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.age,
    required this.state,
    required this.city,
    required this.locality,
    required this.password,
    required this.token,
    required this.roles,
    String? primaryRole,
    String? image,
  })  : primaryRole = primaryRole ?? _determinePrimaryRole(roles),
        image = image ?? generateRandomAvatar();

  // Determine primary role based on priority
  static String _determinePrimaryRole(List<String> roles) {
    if (roles.contains("admin")) return "admin";
    if (roles.contains("seller")) return "seller";
    if (roles.contains("consumer")) return "consumer";
    return "";
  }

  static String generateRandomAvatar() {
    return RandomAvatar(
      DateTime.now().toIso8601String(),
      height: 90,
      width: 90,
    ).toString();
  }

  Map<String, dynamic> toUser() {
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
      'token': token,
      'roles': roles,
      'primaryRole': primaryRole,
      'image': image,
    };
  }

  factory LoginUserModel.fromUser(Map<String, dynamic> map) {
    final rolesList = List<String>.from(map['roles'] ?? ["consumer"]);
    return LoginUserModel(
      id: map['_id'] ?? "",
      name: map['name'] ?? "",
      email: map['email'] ?? "",
      phone: map['phone'],
      age: map['age'] ?? 18,
      state: map['state'] ?? "",
      city: map['city'] ?? "",
      locality: map['locality'] ?? "",
      password: map['password'] ?? "",
      token: map['token'] ?? "",
      roles: rolesList,
      primaryRole: map['primaryRole'], // optional if coming from backend
      image: map['image'],
    );
  }

  String toJson() => json.encode(toUser());

  factory LoginUserModel.fromJson(String source) =>
      LoginUserModel.fromUser(json.decode(source));
}

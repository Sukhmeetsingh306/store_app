import 'dart:convert';

import 'package:random_avatar/random_avatar.dart';

class SellerModels {
  final String id;
  final String name;
  final String email;
  final String state;
  final String city;
  final String locality;
  final String password;
  final String role;
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
    required this.role,
    String? image,
  }) : image = image ?? generateRandomAvatar();

  static String generateRandomAvatar() {
    return RandomAvatar(
      DateTime.now().toIso8601String(), // Unique seed for avatar
      height: 90,
      width: 90,
    ).toString();
  }

  Map<String, dynamic> toSeller() {
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
      'role': role,
      'image': image,
    };
  }

  factory SellerModels.fromSeller(Map<String, dynamic> map) {
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
      role: map['role'] ?? 'seller',
      image: map['image'] ?? generateRandomAvatar(),
    );
  }

  String toJson() => json.encode(toSeller());

  factory SellerModels.fromJson(String source) {
    return SellerModels.fromSeller(json.decode(source));
  }
}

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
  bool? isSeller;
  final String image; // Ensured to always have a value

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
    this.isSeller,
    String? image,
  }) : image = image ?? generateRandomAvatar(); // Use random avatar if null

  // Generates a random avatar using the package
  static String generateRandomAvatar() {
    return RandomAvatar(
      DateTime.now().toIso8601String(), // Unique seed for avatar
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
      'isSeller': isSeller,
      'image': image, // Always has a value
    };
  }

  /// Converts a `Map<String, dynamic>` to a `LoginUserModel` instance.
  factory LoginUserModel.fromUser(Map<String, dynamic> map) {
    return LoginUserModel(
      id: map['_id'] ?? "",
      name: map['name'] ?? "",
      email: map['email'] ?? "",
      phone: map['phone'] ?? "",
      age: map['age'] ?? 18, // Default to 18 if missing
      state: map['state'] ?? "",
      city: map['city'] ?? "",
      locality: map['locality'] ?? "",
      password: map['password'] ?? "",
      token: map['token'] ?? "",
      isSeller: map['isSeller'] ?? false,
      image: map['image'],
    );
  }

  /// Converts a `LoginUserModel` instance to a JSON string.
  String toJson() => json.encode(toUser());

  /// Converts a JSON string to a `LoginUserModel` instance.
  factory LoginUserModel.fromJson(String source) =>
      LoginUserModel.fromUser(json.decode(source));
}

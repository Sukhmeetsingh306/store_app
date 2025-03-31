import 'dart:convert';

class LoginUserModel {
  final String id;
  final String name;
  final String email;
  final String state;
  final String city;
  final String locality;
  final String password;
  final String token;
  final bool isSeller;

  LoginUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.state,
    required this.city,
    required this.locality,
    required this.password,
    required this.token,
    required this.isSeller,
  });

  Map<String, dynamic> toUser() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'state': state,
      'city': city,
      'locality': locality,
      'password': password,
      'token': token,
      'isSeller': isSeller,
    };
  }

  /// Converts a `Map<String, dynamic>` to a `LoginUserModel` instance.
  factory LoginUserModel.fromUser(Map<String, dynamic> map) {
    return LoginUserModel(
      id: map['_id'] ?? "",
      name: map['name'] ?? "",
      email: map['email'] ?? "",
      state: map['state'] ?? "",
      city: map['city'] ?? "",
      locality: map['locality'] ?? "",
      password: map['password'] ?? "",
      token: map['token'] ?? "",
      isSeller: map['isSeller'] ?? false,
    );
  }

  /// Converts a `LoginUserModel` instance to a JSON string.
  String toJson() => json.encode(toUser());

  /// Converts a JSON string to a `LoginUserModel` instance.
  factory LoginUserModel.fromJson(String source) =>
      LoginUserModel.fromUser(json.decode(source));
}

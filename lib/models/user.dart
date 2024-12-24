import 'dart:convert';

class User {
  final String id;
  final String name;
  final String email;
  final String state;
  final String city;
  final String locality;
  final String password;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.state,
    required this.city,
    required this.locality,
    required this.password,
  });

  // serialization or mapping

  /*
  static Map<String, dynamic> fromUser(User user) {
    return {
      'id': user.id,
      'name': user.name,
      'email': user.email,
      'state': user.state,
      'city': user.city,
      'locality': user.locality,
      'password': user.password,
    }
  */

  Map<String, dynamic> fromUser() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'state': state,
      'city': city,
      'locality': locality,
      'password': password,
    };
  }

  // serialization or mapping
  // as converting the map to JSON String

  String toJson() => json.encode(fromUser());
}

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

  //deserialization
  // to do this kind of data data is again needed to be opened

  factory User.fromMap(Map<String, dynamic>map){
    return User(
      id: map['_id'] as String? ?? "",
      name: map['name']  as String? ?? "",
      email: map['email']  as String? ?? "",
      state: map['state']  as String? ?? "",
      city: map['city']  as String? ?? "",
      locality: map['locality']  as String? ?? "",
      password: map['password']  as String? ?? "",
      // (as String? ?? "") as this will replace the data that is not given to the empty string
    );
  }
}

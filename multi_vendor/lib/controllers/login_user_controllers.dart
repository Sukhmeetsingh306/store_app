import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:random_avatar/random_avatar.dart'; // Add this import
import 'package:multi_vendor/globals_variables.dart';
import 'package:multi_vendor/models/login_user_models.dart';
import 'package:multi_vendor/services/http_services.dart';

class LoginUserControllers {
  Future<void> signUpUsers({
    required BuildContext context,
    required String email,
    required String name,
    required String password,
    required String phone,
    required int age,
    String? image, // Optional
    bool? isSeller,
  }) async {
    try {
      // Generate random avatar if image is null
      image = image ?? generateRandomAvatar();

      LoginUserModel user = LoginUserModel(
        id: "",
        name: name,
        email: email,
        phone: phone,
        age: age,
        image: image, // Default avatar or custom image
        state: "",
        city: "",
        locality: "",
        password: password,
        token: "",
        isSeller: isSeller ?? false,
      );

      http.Response response = await http.post(
        Uri.parse('$webUri/signup'),
        body: jsonEncode(user.toJson()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        throw Exception('Request timed out');
      });

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          print("Account successfully created!");
        },
      );
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  // Function to generate a random avatar using RandomAvatar package
  String generateRandomAvatar() {
    // Returns a unique random avatar URL using the current time
    return RandomAvatar(
      DateTime.now().toIso8601String(), // Unique seed for avatar
      height: 90,
      width: 90,
    ).toString();
  }

  Future<bool> signInUsers({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse("$webUri/signin"),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        throw Exception('Request timed out');
      });

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        String token = responseData['token'];
        print("Login successful: Token: $token");
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(responseData['message'] ?? 'Invalid credentials')),
        );
        return false;
      }
    } catch (e) {
      print('Error: ${e.toString()}');
      return false;
    }
  }
}

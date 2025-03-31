import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:multi_vendor/globals_variables.dart';
import 'package:multi_vendor/models/login_user_models.dart';
import 'package:multi_vendor/services/http_services.dart';

class LoginUserControllers {
  Future<void> signUpUsers({
    required context,
    required String email,
    required String name,
    required String password,
    bool? isSeller,
  }) async {
    try {
      LoginUserModel user = LoginUserModel(
        id: "",
        name: name,
        email: email,
        state: "",
        city: "",
        locality: "",
        password: password,
        token: "",
        isSeller: isSeller ?? false,
      );

      http.Response response = await http.post(
        Uri.parse('$webUri/signup/'),
        body: user.toJson(),
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
          //showSnackBar(context, 'Account has been Created');
          print("Account is successfully Created");
        },
      );
    } catch (e) {
      // showSnackBar(context, 'Error: ${e.toString()}');
      print('Error: ${e.toString()}');
    }
  }

  Future<bool> signInUsers({
    required BuildContext context,
    String? email,
    String? password,
  }) async {
    try {
      // Sending the HTTP POST request
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
        var responseData = jsonDecode(response.body);
        String token = responseData['token'];
        // You can store the token or navigate the user to another screen
        print("Login successful: Token: $token");
        print("User is validated!");
        print("Email: $email");
        print("Password: $password");
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(responseData['message'] ?? 'Invalid credentials')),
        );
        return false;
      }
    } catch (e) {
      // Handle any exceptions thrown during the request
      print('Error: ${e.toString()}');
      return false;

      // Show AlertDialog with a general error message
    }
  }
}

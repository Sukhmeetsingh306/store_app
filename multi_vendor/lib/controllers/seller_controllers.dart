import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:multi_vendor/models/seller_models.dart';
import 'package:http/http.dart' as http;

import '../globals_variables.dart';
import '../utils/widget/random/avatar_random.dart';

class SellerControllers {
  Future<void> signUpSeller({
    required String name,
    required String email,
    required String password,
    required String age,
    required String phone,
    required BuildContext context,
    String? image,
  }) async {
    try {
      image = image ?? generateRandomAvatar();

      SellerModels seller = SellerModels(
        id: '',
        name: name,
        email: email,
        state: '',
        city: '',
        locality: '',
        password: password,
        role: '',
        image: image,
        age: int.tryParse(age),
        phone: phone,
      );

      http.Response response = await http.post(
        Uri.parse('$webUri/seller/signup'),
        body: jsonEncode(seller.toJson()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        throw Exception('Request timed out');
      });

      if (context.mounted) {
        if (response.statusCode == 200) {
          // Successfully signed up
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Seller account created successfully!")),
          );
          // Optionally, navigate to another page or perform other actions
        } else {
          // Handle error response
          final errorResponse = jsonDecode(response.body);
          throw Exception(
              errorResponse['message'] ?? 'Failed to sign up seller');
        }
      }
    } catch (e) {
      print("Error signing up seller: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to sign up seller: $e")),
        );
      }
    }
  }

  Future<bool> signInSeller({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$webUri/seller/signin"),
        body: jsonEncode({'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        throw Exception('Request timed out');
      });

      if (response.statusCode == 200) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Seller signed in successfully!")),
          );
        }
        return true;
      } else {
        final errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse['message'] ?? 'Failed to sign in seller');
      }
    } catch (e) {
      print('Error signing in seller: ${e.toString()}');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to sign in seller: $e")),
        );
      }
      return false;
    }
  }
}

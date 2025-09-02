import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_vendor/models/seller_models.dart';
import 'package:http/http.dart' as http;
import 'package:multi_vendor/provider/seller_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../globals_variables.dart';
import '../utils/widget/random/avatar_random.dart';

final riverpodContainer = ProviderContainer();

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
        roles: ["seller", "consumer"],
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
      print("🔹 Attempting seller login with email: $email");

      final response = await http.post(
        Uri.parse("$webUri/seller/signin"),
        body: jsonEncode({'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        throw Exception('Request timed out');
      });

      print("🔹 Response status: ${response.statusCode}");
      print("🔹 Response body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Save token
        final SharedPreferences pref = await SharedPreferences.getInstance();
        final String token = responseData['token'];
        await pref.setString('auth_token', token);

        // Save seller data
        final String sellerJson = jsonEncode(responseData['seller']);
        await pref.setString('sellerData', sellerJson); // ✅ consistent key
        print("🔹 Saved seller JSON: $sellerJson");

        // Update Riverpod state
        riverpodContainer.read(sellerProvider.notifier).setSeller(sellerJson);

        final roles = List<String>.from(responseData['seller']['roles'] ?? []);
        print("🔹 Seller roles: $roles");

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Seller signed in successfully!")),
          );

          if (roles.contains("admin")) {
            context.go('/management');
          } else if (roles.contains("seller")) {
            context.go('/seller/dashboard');
          } else {
            context.go('/');
          }
        }

        return true;
      } else {
        final errorResponse = jsonDecode(response.body);
        throw Exception(errorResponse['message'] ?? 'Failed to sign in seller');
      }
    } catch (e) {
      print('❌ Error signing in seller: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to sign in seller: $e")),
        );
      }
      return false;
    }
  }
}

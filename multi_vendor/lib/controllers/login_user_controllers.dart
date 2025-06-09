import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:random_avatar/random_avatar.dart'; // Add this import
import 'package:multi_vendor/globals_variables.dart';
import 'package:multi_vendor/models/login_user_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/user_provider.dart';
import '../services/http/http_services.dart';

final riverpodContainer = ProviderContainer();

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
      final response = await http.post(
        Uri.parse("$webUri/signin"),
        body: jsonEncode({'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        throw Exception('Request timed out');
      });

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final SharedPreferences pref = await SharedPreferences.getInstance();
        final String token = responseData['token'];
        final String userJson = jsonEncode(responseData['user']);

        await pref.setString('auth_token', token);
        await pref.setString('user', userJson);

        // Update app state via provider
        riverpodContainer.read(userProvider.notifier).setUser(userJson);

        // You should do navigation only *after* checking mounted
        if (context.mounted) {
          context.go('/homePage'); // Direct navigation, no pop
        }

        return true;
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseData['message'] ?? 'Invalid credentials'),
            ),
          );
        }
        return false;
      }
    } catch (e) {
      debugPrint('Sign-in error: ${e.toString()}');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Something went wrong. Please try again.')),
        );
      }
      return false;
    }
  }

  // sign out user
  Future<void> signOutUser(BuildContext context) async {
    try {
      // Clear user data from shared preferences
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.remove('auth_token');
      await pref.remove('user');

      // Clear user state in the provider
      riverpodContainer.read(userProvider.notifier).signOut();

      // Navigate to login page
      if (context.mounted) {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).popUntil((route) => route.isFirst);
          context.pushReplacement('/loginPage');
        } else {
          context.go('/loginPage');
        }
      }
    } catch (e) {
      print('Error signing out: ${e.toString()}');
    }
  }
}

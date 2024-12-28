import 'dart:convert';

import 'package:store_app/globals_variables.dart';
import 'package:store_app/models/user.dart';
import 'package:store_app/services/http_response_service.dart';
import 'package:http/http.dart' as http;

class AuthController {
  Future<void> signUpUsers({
    required context,
    required String email,
    required String name,
    required String password,
  }) async {
    try {
      User user = User(
        id: "",
        name: name,
        email: email,
        state: "",
        city: "",
        locality: "",
        password: password,
        token: "",
      );

      http.Response response = await http.post(
        Uri.parse('$uri/api/signup/'),
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

  Future<void> signInUsers({
    required context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse("$uri/api/signin"),
        body: jsonEncode(
          {
            'email': email,
            'password': password,
          },
        ),
      headers: <String,String>{
        'Content-Type': 'application/json; charset=UTF-8',
      }).timeout(const Duration(seconds: 10), onTimeout: () {
        throw Exception('Request timed out');
      });

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          //showSnackBar(context, 'Account has been Created');
          print("Login successful");
        },
      );
    } catch (e) {
      showSnackBar(context, 'Error: ${e.toString()}');
      print('Error: ${e.toString()}');
    }
  }
}

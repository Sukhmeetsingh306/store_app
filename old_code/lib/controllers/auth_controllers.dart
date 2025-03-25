// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_app/globals_variables.dart';
import 'package:store_app/models/api/user.dart';
import 'package:store_app/models/navigate_models.dart';
import 'package:store_app/provider/user_provider.dart';
import 'package:store_app/services/http_response_service.dart';
import 'package:http/http.dart' as http;
import 'package:store_app/views/screens/main_screen.dart';

final riverpodContainer = ProviderContainer();

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
    required BuildContext context,
    String? email,
    String? password,
  }) async {
    try {
      // Sending the HTTP POST request
      http.Response response = await http.post(
        Uri.parse("$uri/api/signin"),
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

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () async {
          //Access sharedPreference for token and user data
          SharedPreferences pref = await SharedPreferences.getInstance();

          // taking the token and user data
          String token = json.decode(response.body)['token'];

          //store the auth token in pref
          await pref.setString('auth_token', token);

          //encode the user data received from the backend
          final userJson = jsonEncode(jsonDecode(response.body)['user']);

          //update the application state with riverpod
          riverpodContainer.read(userProvider.notifier).setUser(userJson);

          pushAndRemoveUntil(context, MainScreen());
        },
      );
      // // Handling the response
      // if (response.statusCode == 200) {
      //   // Handle success - Parse the JSON response
      //   var responseData = jsonDecode(response.body);
      //   String token = responseData['token'];
      //   // You can store the token or navigate the user to another screen
      //   print("Login successful: Token: $token");
      //   // Navigate to another screen or do something else
      // } else {
      //   // Show error message if response is not 200
      //   var responseData = jsonDecode(response.body);
      //   String errorMessage = responseData['message'];
      //   print('Error: $errorMessage');

      //   // Show AlertDialog with the error message
      //   showDialog(
      //     context: context,
      //     builder: (BuildContext context) {
      //       return AlertDialog(
      //         title: Text('Error'),
      //         content: Text(errorMessage),
      //         actions: [
      //           TextButton(
      //             child: Text('OK'),
      //             onPressed: () {
      //               Navigator.of(context).pop(); // Close the dialog
      //             },
      //           ),
      //         ],
      //       );
      //     },
      //   );
      // }
    } catch (e) {
      // Handle any exceptions thrown during the request
      print('Error: ${e.toString()}');
      // Show AlertDialog with a general error message
    }
  }

  // Future<void> signInUsers({
  //   required context,
  //   String? email,
  //   String? password,
  // }) async {
  //   try {
  //     http.Response response = await http.post(Uri.parse("$uri/api/signin"),
  //         body: jsonEncode(
  //           {
  //             'email': email,
  //             'password': password,
  //           },
  //         ),
  //         headers: <String, String>{
  //           'Content-Type': 'application/json; charset=UTF-8',
  //         }).timeout(const Duration(seconds: 10), onTimeout: () {
  //       throw Exception('Request timed out');
  //     });

  //     manageHttpResponse(
  //       response: response,
  //       context: context,
  //       onSuccess: () {
  //         //showSnackBar(context, 'Account has been Created');
  //         print("Login successful");
  //       },
  //     );
  //   } catch (e) {
  //     //showSnackBar(context, 'Error: ${e.toString()}');
  //     print('Error: ${e.toString()}');
  //   }
  // }
}

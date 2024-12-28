import 'dart:convert';

import 'package:flutter/material.dart';
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

    // Handling the response
    if (response.statusCode == 200) {
      // Handle success - Parse the JSON response
      var responseData = jsonDecode(response.body);
      String token = responseData['token'];
      // You can store the token or navigate the user to another screen
      print("Login successful: Token: $token");
      // Navigate to another screen or do something else
    } else {
      // Show error message if response is not 200
      var responseData = jsonDecode(response.body);
      String errorMessage = responseData['message'];
      print('Error: $errorMessage');

      // Show AlertDialog with the error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    }
  } catch (e) {
    // Handle any exceptions thrown during the request
    print('Error: ${e.toString()}');
    // Show AlertDialog with a general error message
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('An error occurred: ${e.toString()}'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
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

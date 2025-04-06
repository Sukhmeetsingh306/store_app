//import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:multi_vendor/utils/fonts/google_fonts_utils.dart';

void manageHttpResponse({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;
    case 400:
      print("400");
      //showSnackBar(context, json.decode(response.body)['message']);
      break;
    case 500:
      print("500");
      //showSnackBar(context, json.decode(response.body)['message']);
      break;
    case 201:
      onSuccess();
      break;
    case 404:
      print("404");
      //showSnackBar(context, "Not Found");
      break;
  }
}

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: googleInterText(text),
    ),
  );
}

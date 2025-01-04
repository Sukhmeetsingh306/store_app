import 'dart:convert';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:store_app/globals_variables.dart';
import 'package:store_app/models/api/category_api_models.dart';

import 'package:http/http.dart' as http;
class CategoryControllers {
  uploadCategory({
    required dynamic pickedImage,
    required dynamic pickedBanner,
    required String categoryName,
    required context,
  }) async {
    try {
      final categoryCloudinary = CloudinaryPublic(
        cloudinaryName,
        cloudinaryPresentName,
      );

      CloudinaryResponse categoryImageResponse =
          await categoryCloudinary.uploadFile(
        CloudinaryFile.fromBytesData(pickedImage,
            identifier: 'categoryPickedImage', folder: 'categoryPickedImages'),
      );

      CloudinaryResponse categoryBannerResponse =
          await categoryCloudinary.uploadFile(
        CloudinaryFile.fromBytesData(
          pickedBanner,
          identifier: 'categoryPickedBanner',
          folder: 'categoryPickedImages',
        ),
      );

      String categoryImage = categoryImageResponse.secureUrl;

      String categoryBannerImage = categoryBannerResponse.secureUrl;

      Category category = Category(
        categoryId: "",
        categoryName: categoryName,
        categoryImage: categoryImage,
        categoryBanner: categoryBannerImage,
      );

      http.Response response = await http.post(
          Uri.parse("$webUri/api/category"),
          body: category.categoryToJson(),
          headers: <String, String>{
            "content-type": "application/json; charset=UTF-8",
          }).timeout(const Duration(seconds: 10), onTimeout: () {
        throw Exception('Request timed out');
      });

      // Handling the response
      if (response.statusCode == 200) {
        // Handle success - Parse the JSON response
        var responseData = jsonDecode(response.body);
        String token = responseData['token'];
        // You can store the token or navigate the user to another screen
        print("Category Uploaded successful: Token: $token");
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
      print("Error uploading in cloudinary in category_controller : $e");
    }
  }
}

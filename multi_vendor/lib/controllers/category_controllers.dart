import 'dart:convert';

import 'package:cloudinary_public/cloudinary_public.dart';

import 'package:http/http.dart' as http;

import '../globals_variables.dart';
import '../models/api/category_api_models.dart';
import '../services/http_services.dart';

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

      CategoryApiModels category = CategoryApiModels(
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
        },
      );

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, "Categories");
        },
      );
    } catch (e) {
      print("Error uploading in cloudinary in category_controller : $e");
    }
  }

  //fetching of the categories
  Future<List<CategoryApiModels>> fetchCategory() async {
    try {
      http.Response response = await http.get(
        Uri.parse("$webUri/api/category"),
        headers: <String, String>{
          "content-type": "application/json; charset=UTF-8",
        },
      );

      //print(response.body);
      if (response.statusCode == 200) {
        List<dynamic> categoryData = jsonDecode(response.body);

        List<CategoryApiModels> categoryModel = categoryData.map((category) {
          return CategoryApiModels.categoryFromMap(category);
        }).toList();

        return categoryModel;
      } else {
        throw Exception("Failed to fetch categories");
      }
    } catch (e) {
      print("Error fetching categories : $e");
      return [];
    }
  }
}

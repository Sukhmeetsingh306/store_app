import 'dart:convert';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:store_app/models/api/subCategory_api_models.dart';

import 'package:http/http.dart' as http;
import 'package:store_app/services/http_response_service.dart';

import '../globals_variables.dart';

class SubCategoryControllers {
  uploadSubCategory({
    required String categoryId,
    required String categoryName,
    required String subCategoryName,
    required dynamic subCategoryPickedImage,
    required context,
  }) async {
    try {
      final subCategoryCloudinary = CloudinaryPublic(
        cloudinaryName,
        cloudinaryPresentName,
      );

      CloudinaryResponse subcategoryImageResponse =
          await subCategoryCloudinary.uploadFile(
        CloudinaryFile.fromBytesData(subCategoryPickedImage,
            identifier: 'subCategoryPickedImage',
            folder: "subCategoryPickedImage"),
      );

      String subCategoryImage = subcategoryImageResponse.secureUrl;

      SubCategoryApiModels subCategory = SubCategoryApiModels(
        subCategoryId: "",
        categoryId: categoryId,
        categoryName: categoryName,
        subCategoryImage: subCategoryImage,
        subCategoryName: subCategoryName,
      );

      http.Response response = await http.post(
        Uri.parse("$webUri/api/subCategory"),
        body: subCategory.subCategoryToJson(),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8"
        },
      );

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, "SubCategories");
        },
      );
    } catch (e) {
      print("Error uploading in cloudinary in category_controller : $e");
    }
  }

  Future<List<SubCategoryApiModels>> fetchSubCategories() async {
    try {
      http.Response response = await http.get(
        Uri.parse("$webUri/api/subCategory"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> subCategoryData = jsonDecode(response.body);

        List<SubCategoryApiModels> subCategories = subCategoryData
            .map((data) => SubCategoryApiModels.subCategoryFromMap(data))
            .toList();

        return subCategories;
      } else {
        throw Exception("Failed to fetch categories");
      }
    } catch (e) {
      print("Error fetching categories : $e");
      return [];
    }
  }
}

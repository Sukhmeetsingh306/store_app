import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:store_app/globals_variables.dart';
import 'package:store_app/models/api/category_api_models.dart';

import 'package:http/http.dart' as http;

import '../services/http_response_service.dart';

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
}

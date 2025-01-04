import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:store_app/globals_variables.dart';
import 'package:store_app/models/api/category_api_models.dart';

import 'package:http/http.dart' as http;


class CategoryControllers {
  uploadCategory({
    required dynamic pickedImage,
    required dynamic pickedBanner,
    required String categoryName,
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
    } catch (e) {
      print("Error uploading in cloudinary in category_controller : $e");
    }
  }
}

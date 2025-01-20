import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:store_app/models/api/subCategory_api_models.dart';

import '../globals_variables.dart';

class SubCategoryControllers {
  uploadSubCategory({
    required String categoryId,
    required String categoryName,
    required String subCategoryName,
    required dynamic subCategoryPickedImage,
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

      SubCategoryApiModels(
        subCategoryId: "",
        categoryId: categoryId,
        categoryName: categoryName,
        subCategoryImage: subCategoryImage,
        subCategoryName: subCategoryName,
      );
    } catch (e) {
      print("Error uploading in cloudinary in category_controller : $e");
    }
  }
}

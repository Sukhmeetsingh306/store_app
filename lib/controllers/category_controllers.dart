import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:store_app/globals_variables.dart';

class CategoryControllers {
  uploadCategory(
      {required dynamic pickedImage, required dynamic pickedBanner}) async {
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

      print(categoryImageResponse);
      print(categoryBannerResponse);
    } catch (e) {
      print("Error uploading in cloudinary in category_controller : $e");
    }
  }
}

import 'dart:convert';

import 'package:cloudinary_public/cloudinary_public.dart';

import 'package:http/http.dart' as http;

import '../globals_variables.dart';
import '../models/api/upload_banner_api_model.dart';
import '../services/http_services.dart';

class UploadBannerControllers {
  uploadBanner({
    required dynamic pickedBanner,
    required context,
  }) async {
    try {
      final uploadBannerCloudinary = CloudinaryPublic(
        cloudinaryName,
        cloudinaryPresentName,
      );

      CloudinaryResponse uploadBannerResponse =
          await uploadBannerCloudinary.uploadFile(
        CloudinaryFile.fromBytesData(
          pickedBanner,
          identifier: 'uploadPickedBanner',
          folder: 'uploadPickedBannerImages',
        ),
      );

      String uploadBannerImage = uploadBannerResponse.secureUrl;

      UploadBannerApiModels uploadBanner = UploadBannerApiModels(
        bannerId: "",
        bannerImage: uploadBannerImage,
      );

      http.Response response = await http.post(
        Uri.parse("$webUri/api/banner"),
        body: uploadBanner.bannerToJson(),
        headers: <String, String>{
          "content-type": "application/json; charset=UTF-8",
        },
      );

      manageHttpResponse(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, "UploadBanner");
        },
      );
    } catch (e) {
      print("Error uploading in cloudinary in banner_controller : $e");
    }
  }

  // fetching of the banners
  Future<List<UploadBannerApiModels>> fetchBanners() async {
    try {
      http.Response response = await http.get(
        Uri.parse("$webUri/api/banner"),
        headers: <String, String>{
          "content-type": "application/json; charset=UTF-8",
        },
      );

      //print(response.body);
      if (response.statusCode == 200) {
        List<dynamic> bannerData = jsonDecode(response.body);

        List<UploadBannerApiModels> bannerModel = bannerData
            .map((banner) => UploadBannerApiModels.bannerFromJson(banner))
            .toList();

        return bannerModel;
      } else {
        throw Exception("failed to load banner");
      }
    } catch (e) {
      print("Error fetching in cloudinary in banner_controller : $e");
      return [];
    }
  }
}

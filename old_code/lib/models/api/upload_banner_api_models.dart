import 'dart:convert';

class UploadBannerApiModels {
  final String bannerId;
  final String bannerImage;

  UploadBannerApiModels({
    required this.bannerId,
    required this.bannerImage,
  });

  Map<String, dynamic> bannerToMap() {
    return <String, dynamic>{
      'bannerId': bannerId,
      'bannerImage': bannerImage,
    };
  }

  factory UploadBannerApiModels.bannerFromJson(
      Map<String, dynamic> bannerToMap) {
    return UploadBannerApiModels(
      bannerId: bannerToMap['_id'] as String,
      bannerImage: bannerToMap['bannerImage'] as String,
    );
  }

  String bannerToJson() {
    return json.encode(bannerToMap());
  }

  // factory UploadBannerApiModels.bannerFromJson(String source) {
  //   return UploadBannerApiModels.bannerFromMap(
  //     json.decode(source) as Map<String, dynamic>,
  //   );
  // }
}

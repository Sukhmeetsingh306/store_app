import 'package:flutter/material.dart';
import 'package:store_app/components/code/text/googleFonts.dart';
import 'package:store_app/controllers/upload_banner_controllers.dart';

import '../../../../models/api/upload_banner_api_models.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({super.key});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  late Future<List<UploadBannerApiModels>> futureBanner;

  @override
  void initState() {
    futureBanner = UploadBannerControllers().fetchBanners();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureBanner,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Center(
            child: googleText(
              "Error: ${snapshot.error}",
              fontWeight: FontWeight.normal,
              fontSize: 18,
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: googleText(
              "No banners found",
              fontWeight: FontWeight.normal,
              fontSize: 18,
            ),
          );
        } else {
          final bannerCount = snapshot.data!;
          return SizedBox(
            height: 400,
            child: ListView.builder(
              itemCount: bannerCount.length,
              itemBuilder: (context, index) {
                final banner = bannerCount[index];
                return Image.network(
                  width: 40,
                  height: 40,
                  banner.bannerImage,
                );
              },
            ),
          );
        }
      },
    );
  }
}

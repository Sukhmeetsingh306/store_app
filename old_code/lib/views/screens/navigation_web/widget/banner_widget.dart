import 'package:flutter/foundation.dart';
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
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return errormessage("Error: ${snapshot.error}");
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
          if (defaultTargetPlatform == TargetPlatform.iOS) {
            return PageView.builder(
              itemCount: bannerCount.length,
              itemBuilder: (context, index) {
                final banner = bannerCount[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    banner.bannerImage,
                    fit: BoxFit.cover,
                  ),
                );
              },
            );
          } else if (kIsWeb) {
            return GridView.builder(
              itemCount: bannerCount.length,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                crossAxisSpacing: 15,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                final banner = bannerCount[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    banner.bannerImage,
                    width: 100,
                    height: 10,
                  ),
                );
              },
            );
          }
          return Center();
        }
      },
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../controllers/upload_banner_controllers.dart';
import '../../models/api/upload_banner_api_model.dart';
import '../fonts/google_fonts_utils.dart';

class BannerWidgetSupportUser extends StatefulWidget {
  const BannerWidgetSupportUser({super.key});

  @override
  State<BannerWidgetSupportUser> createState() =>
      _BannerWidgetSupportUserState();
}

class _BannerWidgetSupportUserState extends State<BannerWidgetSupportUser> {
  late Future<List<UploadBannerApiModels>> futureBanner;

  @override
  void initState() {
    futureBanner = UploadBannerControllers().fetchBanners();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UploadBannerApiModels>>(
      future: futureBanner,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: googleInterText(
              "Error: ${snapshot.error}",
              fontWeight: FontWeight.normal,
              fontSize: 16,
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: googleInterText(
              "No banners found",
              fontWeight: FontWeight.normal,
              fontSize: 18,
            ),
          );
        } else {
          final banners = snapshot.data!;

          // Mobile / iOS / Android
          if (defaultTargetPlatform == TargetPlatform.iOS ||
              defaultTargetPlatform == TargetPlatform.android) {
            return PageView.builder(
              physics: const NeverScrollableScrollPhysics(), // disable swipe
              itemCount: banners.length,
              itemBuilder: (context, index) {
                final banner = banners[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    banner.bannerImage,
                    fit: BoxFit.cover,
                  ),
                );
              },
            );
          }

          // Web
          if (kIsWeb) {
            double screenWidth = MediaQuery.of(context).size.width;
            bool isSmallWebScreen = screenWidth < 600;

            // Small web screen: PageView but non-scrollable
            if (isSmallWebScreen) {
              return PageView.builder(
                physics: const NeverScrollableScrollPhysics(), // disable swipe
                itemCount: banners.length,
                itemBuilder: (context, index) {
                  final banner = banners[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                      banner.bannerImage,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              );
            }

            // Large web screen: static horizontal row
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(), // stop scroll
              child: Row(
                children: banners.map((banner) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                      banner.bannerImage,
                      width: 300,
                      height: 170,
                      fit: BoxFit.cover,
                    ),
                  );
                }).toList(),
              ),
            );
          }

          return const SizedBox.shrink();
        }
      },
    );
  }
}

/*
/save this code later as this will require in the seller screen

return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          itemCount: bannerCount.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(), // disables GridView scroll
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            crossAxisSpacing: 15,
            mainAxisSpacing: 8,
            childAspectRatio: 16 / 9,
            maxCrossAxisExtent: 350,
          ),
          itemBuilder: (context, index) {
            final banner = bannerCount[index];
            return Image.network(
              banner.bannerImage,
              fit: BoxFit.cover,
            );
          },
        ),
      ),
    );
 */

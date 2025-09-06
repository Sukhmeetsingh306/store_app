import 'dart:ui';

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
    return FutureBuilder(
      future: futureBanner,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return errormessage("Error: ${snapshot.error}");
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: googleInterText(
              "No banners found",
              fontWeight: FontWeight.normal,
              fontSize: 18,
            ),
          );
        } else {
          final bannerCount = snapshot.data!;
          if (defaultTargetPlatform == TargetPlatform.iOS ||
              defaultTargetPlatform == TargetPlatform.android) {
            return PageView.builder(
              itemCount: bannerCount.length,
              itemBuilder: (context, index) {
                final banner = bannerCount[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      banner.bannerImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            );
          } else if (kIsWeb) {
            double screenWidth = MediaQuery.of(context).size.width;
            bool isSmallWebScreen = screenWidth < 600;

            if (isSmallWebScreen) {
              // Small screen web: PageView
              return ScrollConfiguration(
                behavior: CustomScrollBehavior(),
                child: PageView.builder(
                  itemCount: bannerCount.length,
                  itemBuilder: (context, index) {
                    final banner = bannerCount[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          banner.bannerImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              // Large screen web: scrollable GridView
              return ScrollConfiguration(
                behavior: CustomScrollBehavior(),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: bannerCount.map((banner) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            banner.bannerImage,
                            width: 300,
                            height: 170,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
            }
          }

          return const Center();
        }
      },
    );
  }
}

class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}

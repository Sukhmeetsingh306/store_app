import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../controllers/upload_banner_controllers.dart';
import '../../models/api/upload_banner_api_model.dart';
import '../../utils/fonts/google_fonts_utils.dart';
import '../../utils/widget/platform/platform_check_web.dart';
import '../../utils/widget/space_widget_utils.dart';

class BannerWidgetWeb extends StatefulWidget {
  const BannerWidgetWeb({super.key});

  @override
  State<BannerWidgetWeb> createState() => _BannerWidgetWebState();
}

class _BannerWidgetWebState extends State<BannerWidgetWeb> {
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
              defaultTargetPlatform == TargetPlatform.android ||
              isWebMobileWeb()) {
            return SizedBox(
              height: 600,
              child: ListView.builder(
                itemCount: bannerCount.length,
                itemBuilder: (context, index) {
                  final banner = bannerCount[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 200, // fixed image height
                      child: Image.network(
                        banner.bannerImage,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (kIsWeb) {
            final isMobile = isWebMobile(context);

            return SizedBox(
              height: 400,
              child: GridView.builder(
                itemCount: bannerCount.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isMobile ? 3 : 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 8,
                  childAspectRatio: 2,
                ),
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
              ),
            );
          }

          return Center();
        }
      },
    );
  }
}

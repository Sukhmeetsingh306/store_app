import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'support/hover_widget_support_user.dart';
import '../../../utils/fonts/google_fonts_utils.dart';
import '../../../utils/theme/color/color_theme.dart';

class HeaderWidgetUser extends StatelessWidget {
  const HeaderWidgetUser({super.key});

  @override
  Widget build(BuildContext context) {
    return sizedBoxHeaderData(context, arrowPresent: false);
  }
}

Widget verticalDividerIcon() {
  return googleInterText(
    "|",
    color: ColorTheme.color.textWhiteColor,
  );
}

Widget bellIcon() {
  return Material(
    type: MaterialType.transparency,
    child: InkWell(
      onTap: () {},
      child: Ink(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.notifications_active_outlined,
          size: 25, // Adjust the size as needed
          color: ColorTheme.color.whiteColor,
        ),
      ),
    ),
  );
}

Widget messageIcon() {
  return Material(
    type: MaterialType.transparency,
    child: InkWell(
      onTap: () {},
      child: Ink(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          color: Colors.transparent, // Set a background color if needed
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.messenger_outline_outlined,
          size: 25, // Adjust the size as needed
          color: ColorTheme.color.whiteColor,
        ),
      ),
    ),
  );
}

PreferredSizeWidget detailHeaderWidget(
  BuildContext context, {
  VoidCallback? backOnPressed,
}) {
  double mediaQueryHeight = MediaQuery.of(context).size.height;

  return PreferredSize(
    preferredSize: Size.fromHeight(mediaQueryHeight * 0.17),
    child: sizedBoxHeaderData(
      context,
      arrowPresent: true,
      backOnPressed: backOnPressed,
    ),
  );
}

Widget sizedBoxHeaderData(
  BuildContext context, {
  bool arrowPresent = false,
  VoidCallback? backOnPressed,
}) {
  double mediaQueryWidth = MediaQuery.of(context).size.width;
  double mediaQueryHeight = MediaQuery.of(context).size.height;

  bool isWebMobile = kIsWeb && mediaQueryWidth > 1026;

  int getResponsiveFlex(double width) {
    const int minFlex = 5;
    const int maxFlex = 11;
    const double minWidth = 1024;
    const double maxWidth = 1600;

    double clampedWidth = width.clamp(minWidth, maxWidth);

    double normalized = (clampedWidth - minWidth) / (maxWidth - minWidth);
    int calculatedFlex = (minFlex + (normalized * (maxFlex - minFlex))).round();

    return calculatedFlex;
  }

  return SizedBox(
    width: mediaQueryWidth,
    height: mediaQueryHeight * 0.17,
    child: Stack(
      clipBehavior: Clip.none,
      children: [
        // Image.asset(
        //   //'assets/images/arrow.png',
        //   'assets/images/background_image.jpg',
        //   width: mediaQueryWidth,
        //   //height: _mediaQueryHeight * 0.3,
        //   fit: BoxFit.cover,
        // ),
        Container(color: ColorTheme.color.mediumBlue),
        if (isWebMobile)
          Positioned(
            top: mediaQueryHeight * 0.1,
            left: mediaQueryWidth * 0.02,
            right: mediaQueryWidth * 0.02,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Address Section
                Flexible(
                  flex: 4,
                  child: GestureDetector(
                    onTap: () {
                      print('Enter the navigation for address page');
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: ColorTheme.color.textWhiteColor,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              googleInterText(
                                'Delivery To: User Address',
                                fontSize: 15,
                                color: ColorTheme.color.textWhiteColor,
                                fontWeight: FontWeight.w400,
                              ),
                              googleInterTextWeight4Font14(
                                "Update Address",
                                color: ColorTheme.color.textWhiteColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (arrowPresent)
                  Positioned(
                    left: mediaQueryWidth * 0.02,
                    top: mediaQueryHeight * 0.1,
                    child: IconButton(
                      onPressed: backOnPressed,
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                      ),
                    ),
                  ),
                Flexible(
                  flex: getResponsiveFlex(mediaQueryWidth),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: SizedBox(
                      height: 50,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Enter",
                          hintStyle: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF7F7F7F),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 12,
                          ),
                          prefixIcon: const Icon(Icons.search_rounded),
                          suffixIcon: const Icon(Icons.camera_alt_outlined),
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 5,
                  child: Wrap(
                    alignment: WrapAlignment.end,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      verticalDividerIcon(),
                      HoverWidgetSupportUser(),
                      verticalDividerIcon(),
                      GestureDetector(
                        onTap: () {
                          print('Enter the navigation for address page');
                        },
                        child: googleInterTextWeight4Font16(
                          "Become a Seller",
                          color: ColorTheme.color.textWhiteColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      verticalDividerIcon(),
                      bellIcon(),
                      verticalDividerIcon(),
                      messageIcon(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        if (!isWebMobile)
          if (arrowPresent)
            Positioned(
              top: mediaQueryHeight * 0.1,
              child: IconButton(
                onPressed: backOnPressed,
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                ),
              ),
            ),
        if (!isWebMobile)
          Positioned(
            bottom: mediaQueryHeight * 0.013,
            left: mediaQueryWidth *
                (isWebMobile
                    ? (arrowPresent ? 0.25 : 0.20)
                    : (arrowPresent ? 0.12 : 0.08)),
            right: mediaQueryWidth * (isWebMobile ? 0.30 : 0.23),
            child: SizedBox(
              width: 250,
              height: 50,
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Enter",
                  hintStyle: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF7F7F7F),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 12,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                  ),
                  suffixIcon: Icon(
                    Icons.camera_alt_outlined,
                  ),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  focusColor: ColorTheme.color.blackColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
        if (!isWebMobile)
          Positioned(
            bottom: mediaQueryHeight * 0.022,
            right: mediaQueryWidth * 0.12,
            child: bellIcon(),
          ),
        if (!isWebMobile)
          Positioned(
            bottom: mediaQueryHeight * 0.022,
            right: mediaQueryWidth * 0.02,
            child: messageIcon(),
          ),
      ],
    ),
  );
}

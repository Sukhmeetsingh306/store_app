import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:go_router/go_router.dart';

import 'support/hover_widget_support_user.dart';
import '../../../utils/fonts/google_fonts_utils.dart';
import '../../../utils/theme/color/color_theme.dart';

class HeaderWidgetUser extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const HeaderWidgetUser({super.key, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return sizedBoxHeaderData(context, arrowPresent: false);
  }

  Widget sizedBoxHeaderData(
    BuildContext context, {
    bool arrowPresent = false,
    VoidCallback? backOnPressed,
    Widget? drawerMenuButton,
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
      int calculatedFlex =
          (minFlex + (normalized * (maxFlex - minFlex))).round();

      return calculatedFlex;
    }

    return SizedBox(
      width: mediaQueryWidth,
      height: mediaQueryHeight * 0.17,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(color: ColorTheme.color.mediumBlue),
          if (isWebMobile)
            Positioned(
              top: mediaQueryHeight * 0.1,
              left: mediaQueryWidth * 0.02,
              right: mediaQueryWidth * 0.02,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (arrowPresent)
                    IconButton(
                      onPressed: backOnPressed,
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                      ),
                    ),
                  drawerMenuButtonPresent(scaffoldKey),
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
                          onTap: () async {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                            );

                            await Future.delayed(const Duration(seconds: 3));

                            if (!context.mounted) return;

                            Navigator.of(context, rootNavigator: true).pop();

                            context.go('/management');
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
          if (!isWebMobile) ...[
            if (arrowPresent)
              Positioned(
                bottom: mediaQueryHeight * 0.013,
                left: mediaQueryWidth * 0.0001,
                child: IconButton(
                  onPressed: backOnPressed,
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                  ),
                ),
              ),
            Positioned(
              bottom: mediaQueryHeight * 0.013,
              left:
                  arrowPresent ? mediaQueryWidth * 0.1 : mediaQueryWidth * 0.02,
              right: mediaQueryWidth * 0.23,
              child: Row(
                children: [
                  drawerMenuButton ?? drawerMenuButtonPresent(scaffoldKey),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
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
                          prefixIcon: Icon(Icons.search_rounded),
                          suffixIcon: Icon(Icons.camera_alt_outlined),
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
                ],
              ),
            ),
            Positioned(
              bottom: mediaQueryHeight * 0.022,
              right: mediaQueryWidth * 0.12,
              child: bellIcon(),
            ),
            Positioned(
              bottom: mediaQueryHeight * 0.022,
              right: mediaQueryWidth * 0.02,
              child: messageIcon(),
            ),
          ]
        ],
      ),
    );
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
            size: 25,
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
            color: Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.messenger_outline_outlined,
            size: 25,
            color: ColorTheme.color.whiteColor,
          ),
        ),
      ),
    );
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  PreferredSizeWidget detailHeaderWidget(
    BuildContext context, {
    VoidCallback? backOnPressed,
    required GlobalKey<ScaffoldState> scaffoldKey,
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

  Widget drawerMenuButtonPresent(GlobalKey<ScaffoldState> scaffoldKey) {
    return Builder(
      builder: (context) {
        return InkWell(
          onTap: () {
            print("Drawer Button Clicked!");
            ScaffoldState? scaffoldState =
                context.findAncestorStateOfType<ScaffoldState>();
            scaffoldState?.openDrawer();
          },
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: ColorTheme.color.mediumBlue,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Icon(Icons.menu, color: Colors.white),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../provider/user_provider.dart';
import '../../../utils/code/dialog_code.dart';
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

    bool isWebMobile = kIsWeb && mediaQueryWidth > 1100;

    return SizedBox(
      width: mediaQueryWidth,
      height: mediaQueryHeight * 0.17,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(color: ColorTheme.color.mediumBlue),
          Positioned(
            top: mediaQueryHeight * 0.1,
            left: mediaQueryWidth * 0.02,
            right: mediaQueryWidth * 0.02,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (arrowPresent)
                  IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: backOnPressed,
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                    ),
                  ),
                drawerMenuButtonPresent(scaffoldKey),
                if (isWebMobile) ...[
                  const SizedBox(width: 4),
                  Expanded(
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
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                googleInterText(
                                  'Delivery To: User Address',
                                  fontSize: 14,
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
                ],
                Expanded(
                  flex: isWebMobile ? 2 : 1,
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
                if (isWebMobile) const SizedBox(width: 10),
                Wrap(
                  alignment: WrapAlignment.end,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (isWebMobile) ...[
                      verticalDividerIcon(),
                      HoverWidgetSupportUser(),
                      verticalDividerIcon(),
                      Consumer(
                        builder: (context, ref, child) {
                          final user = ref.read(userProvider);

                          String buttonText = "Become a Seller"; // default

                          if (user != null) {
                            switch (user.primaryRole) {
                              case "admin":
                                buttonText = "Seller Side Admin";
                                break;
                              case "seller":
                                buttonText = "Sell Goods";
                                break;
                              case "consumer":
                                buttonText = "Become a Seller";
                                break;
                            }
                          }
                          return GestureDetector(
                            onTap: () async {
                              // Optional: show loading
                              showLoadingDialog(context);

                              await Future.delayed(const Duration(seconds: 2));

                              if (!context.mounted) return;
                              Navigator.of(context, rootNavigator: true).pop();

                              if (user == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Please login first.")),
                                );
                                return;
                              }

                              // Navigation based on role
                              switch (user.primaryRole) {
                                case "admin":
                                  context.go('/management'); // admin dashboard
                                  break;
                                case "seller":
                                  context.go(
                                      '/seller/dashboard'); // seller dashboard
                                  break;
                                case "consumer":
                                  // 🔹 Show confirmation dialog
                                  final result = await showDialog<bool>(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => alertDialog(
                                      context,
                                      onPressed: () {
                                        // Close dialog and return true
                                        Navigator.of(context).pop(true);
                                      },
                                    ),
                                  );

                                  if (result == true && context.mounted) {
                                    context.go(
                                        '/sellerPage'); // navigate only if confirmed
                                  }
                                  break;
                                default:
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Unauthorized role")),
                                  );
                              }
                            },
                            child: googleInterTextWeight4Font16(
                              buttonText,
                              color: ColorTheme.color.textWhiteColor,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                      ),
                      verticalDividerIcon(),
                    ],
                    bellIcon(),
                    if (isWebMobile) verticalDividerIcon(),
                    messageIcon(),
                  ],
                ),
              ],
            ),
          )
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

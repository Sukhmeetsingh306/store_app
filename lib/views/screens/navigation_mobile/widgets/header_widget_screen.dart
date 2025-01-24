import 'package:flutter/material.dart';
import 'package:store_app/components/color/color_theme.dart';

class HeaderWidgetScreen extends StatelessWidget {
  const HeaderWidgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double mediaQueryWidth = MediaQuery.of(context).size.width;
    double mediaQueryHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      width: mediaQueryWidth,
      height: mediaQueryHeight * 0.17,
      child: Stack(
        children: [
          Image.asset(
            //'assets/images/arrow.png',
            'assets/images/arrow.png',
            width: mediaQueryWidth,
            //height: _mediaQueryHeight * 0.3,
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: mediaQueryHeight * 0.013,
            left: mediaQueryWidth * 0.08,
            right: mediaQueryWidth * 0.23,
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
                ),
              ),
            ),
          ),
          Positioned(
            bottom: mediaQueryHeight * 0.022,
            right: mediaQueryWidth * 0.12,
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: () {},
                child: Ink(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color:
                        Colors.transparent, // Set a background color if needed
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.notifications_active_outlined,
                    size: 28, // Adjust the size as needed
                    color: ColorTheme.color.whiteColor,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: mediaQueryHeight * 0.022,
            right: mediaQueryWidth * 0.02,
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: () {},
                child: Ink(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color:
                        Colors.transparent, // Set a background color if needed
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.messenger_outline_outlined,
                    size: 28, // Adjust the size as needed
                    color: ColorTheme.color.whiteColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

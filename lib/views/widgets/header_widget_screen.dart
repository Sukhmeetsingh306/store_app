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
            'assets/images/arrow.png',
            width: mediaQueryWidth,
            //height: _mediaQueryHeight * 0.3,
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: mediaQueryHeight * 0.013,
            left: mediaQueryWidth * 0.08,
            right: mediaQueryWidth * 0.2,
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
        ],
      ),
    );
  }
}

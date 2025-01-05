import 'package:flutter/material.dart';

import '../color/color_theme.dart';
import 'text/googleFonts.dart';

Widget webImageInput(
  dynamic dynamicImage,
  String text,
  BuildContext context,
) {
  double mediaQueryWidth = MediaQuery.of(context).size.width;
  double mediaQueryHeight = MediaQuery.of(context).size.height;

  double squareSize = (mediaQueryWidth < mediaQueryHeight
          ? mediaQueryWidth
          : mediaQueryHeight) *
      0.20;

  return Container(
    width: squareSize,
    height: squareSize,
    decoration: BoxDecoration(
      color: ColorTheme.color.grayColor,
      borderRadius: BorderRadius.circular(
        5,
      ),
    ),
    child: Center(
      child: dynamicImage != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(5), // Match container radius
              child: Image.memory(
                dynamicImage,
                width: squareSize,
                height: squareSize,
                fit: BoxFit
                    .cover, // Adjust to 'contain', 'cover', or 'fill' based on your design
              ),
            )
          : googleText(
              text,
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
    ),
  );
}

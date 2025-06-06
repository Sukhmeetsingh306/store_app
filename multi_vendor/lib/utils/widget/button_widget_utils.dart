import 'package:flutter/material.dart';

import '../fonts/google_fonts_utils.dart';
import '../theme/color/color_theme.dart';

ElevatedButton elevatedButton(
  String buttonText,
  VoidCallback onPressed, {
  Color? backgroundColor,
  Color? textColor,
} // Optional parameter for background color
    ) {
  return ElevatedButton(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all<Color>(
        backgroundColor ?? gradientColors()[3],
      ),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
    ),
    onPressed: onPressed,
    child: googleInterText(
      buttonText,
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: textColor ?? Colors.white,
    ),
  );
}

TextButton textButton(
  String buttonText,
  VoidCallback onPressed, {
  FontWeight? fontWeight,
}) {
  return TextButton(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.all<Color>(
        ColorTheme.color.textWhiteColor,
      ),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
    onPressed: onPressed,
    child: googleInterText(
      buttonText,
      fontSize: 13,
      fontWeight: fontWeight ?? FontWeight.w400,
    ),
  );
}

BottomNavigationBarItem bottomBarItem(
  Widget icon,
  String name,
) {
  return BottomNavigationBarItem(
    icon: icon,
    label: name,
  );
}

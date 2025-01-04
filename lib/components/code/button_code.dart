import 'package:flutter/material.dart';

import '../color/color_theme.dart';
import 'text/googleFonts.dart';

ElevatedButton elevatedButton(void Function() onPressed, String text) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorTheme.color.dodgerBlue,
      ),
      onPressed: onPressed,
      child: webButtonGoogleText(
        text,
        color: ColorTheme.color.whiteColor,
      ),
    );
  }
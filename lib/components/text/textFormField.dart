import 'package:flutter/material.dart';

import '../color/color_theme.dart';
import 'googleFonts.dart';

Padding textFormField(String labelText, String image) {
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: TextFormField(
      decoration: InputDecoration(
        fillColor: ColorTheme.color.whiteColor,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9),
          borderSide: BorderSide(color: ColorTheme.color.lustRedColor),
        ),
        labelText: labelText,
        //focusedBorder: InputBorder.none,
        //enabledBorder: InputBorder.none,
        labelStyle: googleFonts(
          fontFamily: 'Nunito Sans',
          fontSize: 14,
          letterSpacing: 0.1,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Image.asset(
            image,
            width: 20,
            height: 20,
          ),
        ),
      ),
    ),
  );
}

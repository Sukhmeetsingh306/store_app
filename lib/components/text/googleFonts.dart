// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Text googleText(String text, {double? fontSize, FontWeight? fontWeight, Color? color}) {
  return Text(
    text,
    style: GoogleFonts.getFont(
      'Lato',
      color: color ?? Colors.black,
      fontWeight: fontWeight ?? FontWeight.bold,
      letterSpacing: 0.2,
      fontSize: fontSize ?? 23, // Defaults to 23 if fontSize is null
    ),
  );
}

TextStyle googleFonts(
    {double? fontSize,
    FontWeight? fontWeight,
    String? fontFamily,
    double? letterSpacing}) {
  return GoogleFonts.getFont(
    fontFamily ?? 'Lato',
    color: Colors.black,
    fontWeight: fontWeight ?? FontWeight.bold,
    letterSpacing: letterSpacing ?? 0.2,
    fontSize: fontSize ?? 23, // Defaults to 23 if fontSize is null
  );
}

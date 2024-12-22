import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Text googleText(String text, {double? fontSize, FontWeight? fontWeight}) {
  return Text(
    text,
    style: GoogleFonts.getFont(
      'Lato',
      color: Colors.black,
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

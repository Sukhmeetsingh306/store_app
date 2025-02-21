// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Text googleText(String text,
    {double? fontSize, FontWeight? fontWeight, Color? color}) {
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

Text googleTextSands(
  String text, {
  FontWeight? fontWeight,
  double? fontSize,
  double? letterSpacing,
  Color? color,
}) {
  return Text(
    text,
    style: GoogleFonts.quicksand(
      color: color ?? Colors.black,
      fontWeight: fontWeight ?? FontWeight.bold,
      letterSpacing: letterSpacing ?? 0.2,
      fontSize: fontSize ?? 16, //
    ),
  );
}

Text googleTextRob(
  String text, {
  FontWeight? fontWeight,
  double? fontSize,
  double? letterSpacing,
  Color? color,
}) {
  return Text(
    text,
    overflow: TextOverflow.ellipsis,
    style: GoogleFonts.roboto(
      color: color ?? Colors.black,
      fontWeight: fontWeight ?? FontWeight.w600,
      letterSpacing: letterSpacing ?? 0.2,
      fontSize: fontSize ?? 12, //
    ),
  );
}

TextStyle googleFonts({
  double? fontSize,
  FontWeight? fontWeight,
  String? fontFamily,
  double? letterSpacing,
  Color? color,
}) {
  return GoogleFonts.getFont(
    fontFamily ?? 'Lato',
    color: color ?? Colors.black,
    fontWeight: fontWeight ?? FontWeight.bold,
    letterSpacing: letterSpacing ?? 0.2,
    fontSize: fontSize ?? 23, // Defaults to 23 if fontSize is null
  );
}

Text webButtonGoogleText(
  String text, {
  double? fontSize,
  FontWeight? fontWeight,
  Color? color,
}) {
  return googleText(
    text,
    fontSize: fontSize ?? 16,
    fontWeight: fontWeight ?? FontWeight.w600,
    color: color ?? Colors.black,
  );
}

Center errormessage(
  String text,
) {
  return Center(
    child: googleText(
      text,
      fontWeight: FontWeight.normal,
      fontSize: 18,
    ),
  );
}

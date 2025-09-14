import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/color/color_theme.dart';

Text googleInterText(
  String text, {
  double? fontSize,
  FontWeight? fontWeight,
  Color? color,
  TextAlign? textAlign,
  double? letterSpacing,
  int? maxLines,
  TextOverflow? overflow,
}) {
  return Text(
    text,
    textAlign: textAlign,
    style: GoogleFonts.getFont(
      'Inter',
      color: color ?? ColorTheme.color.blackColor,
      fontWeight: fontWeight ?? FontWeight.w600,
      letterSpacing: letterSpacing ?? 0.1,
      fontSize: fontSize ?? 23,
    ),
    maxLines: maxLines,
    overflow: overflow,
  );
}

Text googleInterTextLato(
  String text, {
  double? fontSize,
  FontWeight? fontWeight,
  Color? color,
  TextAlign? textAlign,
  double? letterSpacing,
  int? maxLines,
  TextOverflow? overflow,
}) {
  return Text(
    text,
    textAlign: textAlign,
    style: GoogleFonts.lato(
      color: color ?? ColorTheme.color.blackColor,
      fontWeight: fontWeight ?? FontWeight.w600,
      letterSpacing: letterSpacing ?? 0.1,
      fontSize: fontSize ?? 21,
    ),
    maxLines: maxLines,
    overflow: overflow,
  );
}

Text googleInterTextWeight4Font16(String text,
    {double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    TextAlign? textAlign,
    double? letterSpacing}) {
  return Text(
    text,
    textAlign: textAlign,
    style: GoogleFonts.getFont(
      'Inter',
      color: color ?? ColorTheme.color.blackColor,
      fontWeight: fontWeight ?? FontWeight.w400,
      letterSpacing: letterSpacing ?? 0.1,
      fontSize: fontSize ?? 16,
    ),
  );
}

Text googleInterTextWeight4Font12(String text,
    {double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    TextAlign? textAlign}) {
  return Text(
    text,
    textAlign: textAlign,
    style: GoogleFonts.getFont(
      'Inter',
      color: color ?? ColorTheme.color.blackColor,
      fontWeight: fontWeight ?? FontWeight.w400,
      letterSpacing: 0.1,
      fontSize: fontSize ?? 12,
    ),
  );
}

Text googleInterTextWeight4Font14(String text,
    {double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    TextAlign? textAlign}) {
  return Text(
    text,
    textAlign: textAlign,
    style: GoogleFonts.getFont(
      'Inter',
      color: color ?? ColorTheme.color.blackColor,
      fontWeight: fontWeight ?? FontWeight.w400,
      letterSpacing: 0.1,
      fontSize: fontSize ?? 14,
    ),
  );
}

Text googleInterTextWeight4Font14ColorGrey(String text,
    {double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    TextAlign? textAlign}) {
  return Text(
    text,
    textAlign: textAlign,
    style: GoogleFonts.getFont(
      'Inter',
      color: color ?? Colors.grey,
      fontWeight: fontWeight ?? FontWeight.w400,
      letterSpacing: 0.1,
      fontSize: fontSize ?? 14,
    ),
  );
}

Text googleReadexProText(String text,
    {double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    TextAlign? textAlign}) {
  return Text(
    text,
    textAlign: textAlign,
    style: GoogleFonts.getFont(
      'Readex Pro',
      color: color ?? ColorTheme.color.blackColor,
      fontWeight: fontWeight ?? FontWeight.w600,
      letterSpacing: 0.1,
      fontSize: fontSize ?? 23,
    ),
  );
}

Center errormessage(
  String text,
) {
  return Center(
    child: googleInterText(
      text,
      fontWeight: FontWeight.normal,
      fontSize: 18,
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

Text webButtonGoogleText(
  String text, {
  double? fontSize,
  FontWeight? fontWeight,
  Color? color,
}) {
  return googleInterText(
    text,
    fontSize: fontSize ?? 16,
    fontWeight: fontWeight ?? FontWeight.w600,
    color: color ?? Colors.black,
  );
}

Widget divider() {
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: const Divider(),
  );
}

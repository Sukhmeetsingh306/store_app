import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

// Widget textFormField(
//   TextEditingController controller,
//   String labelText,
//   String hintText,
//   FormFieldValidator<String> validator, {
//   Widget? suffixIcon,
//   TextInputType? keyboardType,
//   Iterable<String>? autofillHints,
//   void Function(String)? onChanged,
//   bool? obscureText,
//   AutovalidateMode? autovalidateMode,
//   List<TextInputFormatter>? inputFormatters,
// }) {
//   return TextFormField(
//     controller: controller,
//     decoration: InputDecoration(
//       labelText: labelText,
//       labelStyle: GoogleFonts.getFont(
//         'Inter',
//         color: ColorTheme.color.textWhiteColor,
//         fontWeight: FontWeight.w400,
//         fontSize: 16,
//       ),
//       hintText: hintText,
//       hintStyle: GoogleFonts.getFont(
//         'Inter',
//         color: ColorTheme.color.textWhiteColor,
//         fontWeight: FontWeight.w400,
//         fontSize: 16,
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderSide: BorderSide(
//           color: Colors.transparent, // Ensure transparent border
//           width: 1.0,
//         ),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderSide: BorderSide(
//           color: Colors.transparent,
//           width: 1.0,
//         ),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       filled: true, // Ensure it's filled
//       fillColor: Colors.black, // Set desired background color
//       contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
//       suffixIcon: suffixIcon,
//     ),
// style: GoogleFonts.getFont(
//   'Inter',
//   color: Colors.white, // Ensure text color is visible
//   fontWeight: FontWeight.w400,
//   fontSize: 16,
// ),
//     keyboardType: keyboardType,
//     autofillHints: autofillHints,
//     validator: validator,
//     onChanged: onChanged,
//     obscureText: obscureText ?? false,
//     autovalidateMode: autovalidateMode,
//     inputFormatters: inputFormatters,
//   );
// }

Widget textFormField(
  TextEditingController controller,
  String labelText,
  FormFieldValidator<String> validator, {
  String? hintText,
  Widget? suffixIcon,
  TextInputType? keyboardType,
  Iterable<String>? autofillHints,
  void Function(String)? onChanged,
  bool? obscureText,
  AutovalidateMode? autovalidateMode,
  List<TextInputFormatter>? inputFormatters,
  int? maxLines,
  int? maxLength,
  int? minLines,
}) {
  final bool isObscured = obscureText ?? false;

  // Rule: Obscured text fields MUST be single-line
  final int safeMaxLines = isObscured ? 1 : (maxLines ?? 1);
  final int? safeMinLines = isObscured ? 1 : minLines;

  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.getFont(
        'Inter',
        color: Colors.grey,
        fontWeight: FontWeight.w400,
        fontSize: 16,
      ),
      labelText: labelText,
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(10.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(10.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(10.0),
      ),
      alignLabelWithHint: true,
    ),
    style: GoogleFonts.getFont(
      'Inter',
      color: Colors.black,
      fontWeight: FontWeight.w400,
      fontSize: 16,
    ),
    keyboardType: keyboardType,
    autofillHints: autofillHints,
    validator: validator,
    onChanged: onChanged,
    obscureText: isObscured,
    autovalidateMode: autovalidateMode,
    inputFormatters: inputFormatters,
    maxLength: maxLength,
    minLines: safeMinLines,
    maxLines: safeMaxLines,
    textAlignVertical: TextAlignVertical.top,
  );
}

Widget phoneNumber(
  TextEditingController controller,
  String labelText,
  String hintText, {
  ValueChanged<PhoneNumber>? onChanged,
  String? errorText,
}) {
  return IntlPhoneField(
    controller: controller,
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: GoogleFonts.getFont(
        'Inter',
        color: Colors.black,
        fontWeight: FontWeight.w400,
        fontSize: 16,
      ),
      hintText: hintText,
      hintStyle: GoogleFonts.getFont(
        'Inter',
        color: Colors.black,
        fontWeight: FontWeight.w400,
        fontSize: 16,
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(10.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(10.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(10.0),
      ),
      filled: true,
      fillColor: Colors.transparent,
      contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      errorText: errorText,
    ),
    keyboardType: TextInputType.phone,
    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    initialCountryCode: 'US',
    dropdownTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 16,
    ),
    dropdownIcon: Icon(
      Icons.arrow_drop_down,
      color: Colors.black,
    ),
    onChanged: onChanged, // This now matches the expected type
    style: GoogleFonts.getFont(
      'Inter',
      color: Colors.black,
      fontWeight: FontWeight.w400,
      fontSize: 16,
    ),
  );
}

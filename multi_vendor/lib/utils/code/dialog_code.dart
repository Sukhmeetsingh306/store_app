import 'package:flutter/material.dart';
import 'package:multi_vendor/utils/fonts/text_fonts_utils.dart';
import 'package:multi_vendor/utils/widget/form/appTextButton_form.dart';
import '../fonts/google_fonts_utils.dart';

Widget alertDialog(
  BuildContext context, {
  final VoidCallback? onPressed,
}) {
  return AlertDialog(
    insetPadding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.25),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.0),
    ),
    title: googleReadexProText("Confirmation", fontSize: 22),
    content: RichText(
      text: TextSpan(
        children: [
          textSpan(
            'Need Seller Account?',
            fontSize: 18,
          ),
        ],
      ),
    ),
    actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    actions: [
      IntrinsicWidth(
        child: Row(
          mainAxisSize: MainAxisSize.min, // only take space needed
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: googleReadexProText(
                "Cancel",
                fontSize: 16,
                color: const Color.fromRGBO(36, 124, 255, 1),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppTextButton(
                buttonWidth: 150,
                buttonText: 'Confirm',
                onPressed: onPressed,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

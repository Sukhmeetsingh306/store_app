import 'package:flutter/material.dart';

import '../../color/color_theme.dart';
import 'googleFonts.dart';

class RowTextSands extends StatelessWidget {
  final String title;
  final String subTitle;
  const RowTextSands({
    super.key,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        googleTextSands(
          title,
          fontWeight: FontWeight.w600,
        ),
        googleTextSands(
          subTitle,
          fontWeight: FontWeight.w600,
          color: ColorTheme.color.dodgerBlue,
        ),
      ],
    );
  }
}

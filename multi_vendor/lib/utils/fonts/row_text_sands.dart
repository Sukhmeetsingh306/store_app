import 'package:flutter/material.dart';

import '../theme/color/color_theme.dart';
import 'google_fonts_utils.dart';

class RowTextSands extends StatelessWidget {
  final String title;
  final String subTitle;
  const RowTextSands({
    super.key,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(
    BuildContext context, {
    double? bottom,
    double? left,
    double? right,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: bottom ?? 3.0,
        left: left ?? 18,
        right: right ?? 18,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          googleTextSands(
            title,
            fontWeight: FontWeight.bold,
          ),
          googleTextSands(
            subTitle,
            fontWeight: FontWeight.bold,
            color: ColorTheme.color.dodgerBlue,
          ),
        ],
      ),
    );
  }
}

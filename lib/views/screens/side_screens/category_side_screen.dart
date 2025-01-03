import 'package:flutter/material.dart';
import 'package:store_app/components/text/googleFonts.dart';

import '../../../components/color/color_theme.dart';

class CategorySideScreen extends StatelessWidget {
  static const String routeName = '/categoryScreen';
  const CategorySideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double mediaQueryWidth = MediaQuery.of(context).size.width;
    double mediaQueryHeight = MediaQuery.of(context).size.height;

    double squareSize = (mediaQueryWidth < mediaQueryHeight
            ? mediaQueryWidth
            : mediaQueryHeight) *
        0.20;

    return Column(
      children: [
        Container(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: googleText(
              'Category',
              fontSize: 36,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Divider(),
        ),
        Row(
          children: [
            Container(
              width: squareSize,
              height: squareSize,
              decoration: BoxDecoration(
                color: ColorTheme.color.grayColor,
                borderRadius: BorderRadius.circular(
                  5,
                ),
              ),
              child: Center(
                child: googleText(
                  'Category Image',
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: mediaQueryWidth * 0.15,
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Enter Category Name',
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

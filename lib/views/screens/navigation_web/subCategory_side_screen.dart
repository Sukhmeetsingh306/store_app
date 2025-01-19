import 'package:flutter/material.dart';

import '../../../components/code/divider_code.dart';
import '../../../components/code/text/googleFonts.dart';

class SubCategorySideScreen extends StatelessWidget {
  static const String routeName = '/subCategoryScreen';

  const SubCategorySideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: googleText(
                'Subcategory',
                fontSize: 36,
              ),
            ),
          ),
          divider(),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../components/code/divider_code.dart';
import '../../../components/code/text/googleFonts.dart';
import '../../../controllers/category_controllers.dart';
import '../../../models/api/category_api_models.dart';

class SubCategorySideScreen extends StatefulWidget {
  static const String routeName = '/subCategoryScreen';

  const SubCategorySideScreen({super.key});

  @override
  State<SubCategorySideScreen> createState() => _SubCategorySideScreenState();
}

class _SubCategorySideScreenState extends State<SubCategorySideScreen> {
  late Future<List<CategoryApiModels>> futureSubCategory;

  @override
  void initState() {
    super.initState();
    futureSubCategory = CategoryControllers().fetchCategory();
  }

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

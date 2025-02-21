import 'package:flutter/material.dart';
import 'package:store_app/components/code/text/googleFonts.dart';
import 'package:store_app/models/api/category_api_models.dart';

class InnerCategoryScreen extends StatelessWidget {
  final CategoryApiModels category;
  const InnerCategoryScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: googleText(category.categoryName),
      ),
    );
  }
}

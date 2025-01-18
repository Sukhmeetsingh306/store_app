import 'package:flutter/material.dart';
import 'package:store_app/models/api/category_api_models.dart';

import '../../../../controllers/category_controllers.dart';

class CategoryWidget extends StatefulWidget {
  const CategoryWidget({super.key});

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {

  late Future<List<CategoryApiModels>> futureCategory;

  @override
  void initState() {
    super.initState();
    futureCategory = CategoryControllers().fetchCategory();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
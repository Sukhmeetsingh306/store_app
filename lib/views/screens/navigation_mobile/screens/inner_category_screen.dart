import 'package:flutter/material.dart';
import 'package:store_app/components/code/text/googleFonts.dart';
import 'package:store_app/controllers/subCategory_controllers.dart';
import 'package:store_app/models/api/category_api_models.dart';
import 'package:store_app/models/api/subCategory_api_models.dart';
import 'package:store_app/models/navigate_models.dart';
import 'package:store_app/views/screens/navigation_web/widget/subCategory_widget.dart';

import '../widgets/header_widget_screen.dart';
import 'widget/banner_mobile_widget.dart';

class InnerCategoryScreen extends StatefulWidget {
  final CategoryApiModels category;
  const InnerCategoryScreen({super.key, required this.category});

  @override
  State<InnerCategoryScreen> createState() => _InnerCategoryScreenState();
}

class _InnerCategoryScreenState extends State<InnerCategoryScreen> {
  late Future<List<SubCategoryApiModels>> subCategoryModel;
  final SubCategoryControllers subCategoryControllers =
      SubCategoryControllers();

  @override
  void initState() {
    super.initState();
    subCategoryModel = subCategoryControllers
        .getSubCategoryByCategoryName(widget.category.categoryName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: detailHeaderWidget(
        context,
        backOnPressed: () => pop(context),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          bannerImageMobileWidget(context, widget.category.categoryBanner),
          Center(
            child: googleTextSands(
              'Shop by SubCategory',
              fontSize: 19,
              letterSpacing: 1.4,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SubCategoryWidget(
              future: subCategoryModel,
            ),
          ),
        ],
      ),
    );
  }
}

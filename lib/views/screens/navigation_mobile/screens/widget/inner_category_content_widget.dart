import 'package:flutter/material.dart';

import '../../../../../components/code/text/googleFonts.dart';
import '../../../../../controllers/subCategory_controllers.dart';
import '../../../../../models/api/category_api_models.dart';
import '../../../../../models/api/subCategory_api_models.dart';
import '../../../navigation_web/widget/subCategory_widget.dart';
import 'banner_mobile_widget.dart';

class InnerCategoryContentWidget extends StatefulWidget {
  final CategoryApiModels category;

  const InnerCategoryContentWidget({super.key, required this.category});

  @override
  State<InnerCategoryContentWidget> createState() =>
      _InnerCategoryContentWidgetState();
}

class _InnerCategoryContentWidgetState
    extends State<InnerCategoryContentWidget> {
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          bannerImageMobileWidget(context, widget.category.categoryBanner),
          Center(
            child: googleTextSands(
              'Shop by Category',
              fontSize: 19,
              letterSpacing: 1.4,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: SubCategoryWidget(
              future: subCategoryModel,
            ),
          ),
        ],
      ),
    );
  }
}

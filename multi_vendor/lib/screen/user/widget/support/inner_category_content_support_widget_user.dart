import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../controllers/subCategory_controllers.dart';
import '../../../../models/api/category_api_models.dart';
import '../../../../models/api/subcategory_api_models.dart';
import '../../../../utils/fonts/google_fonts_utils.dart';
import '../../../../utils/fonts/row_text_sands.dart';
import '../../../../utils/widget/platform/platform_check.dart';
import 'banner_image_support_widget_user.dart';
import 'sub_category_support_user.dart';

class InnerCategoryContentSupportWidgetUser extends StatefulWidget {
  final CategoryApiModels category;
  final bool? listView;

  const InnerCategoryContentSupportWidgetUser(
      {super.key, required this.category, this.listView});

  @override
  State<InnerCategoryContentSupportWidgetUser> createState() =>
      _InnerCategoryContentSupportWidgetUserState();
}

class _InnerCategoryContentSupportWidgetUserState
    extends State<InnerCategoryContentSupportWidgetUser> {
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
          bannerImageResponsiveWidget(context, widget.category.categoryBanner),
          Center(
            child: googleInterText(
              'Shop by Category',
              fontSize: 19,
              letterSpacing: 1.4,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  SubCategorySupportUser(
                    future: subCategoryModel,
                  ),
                  SizedBox(height: kIsWeb ? 10 : 4),
                  kIsWeb
                      ? RowTextSands(
                          title: 'Popular Product:',
                          subTitle: ' View All',
                          mainAxisAlignment:
                              kIsWeb && (isIOSWeb() || isAndroidWeb())
                                  ? MainAxisAlignment.spaceBetween
                                  : MainAxisAlignment.spaceEvenly,
                        )
                      : RowTextSands(
                          title: 'Popular Product:',
                          subTitle: ' View All',
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

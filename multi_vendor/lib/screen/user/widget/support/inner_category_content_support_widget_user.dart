import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:multi_vendor/controllers/product_controllers.dart';
import 'package:multi_vendor/screen/user/widget/support/reuse_widget_support.dart';

import '../../../../controllers/subCategory_controllers.dart';
import '../../../../models/api/category_api_models.dart';
import '../../../../models/api/subcategory_api_models.dart';
import '../../../../models/product_model.dart';
import '../../../../utils/fonts/google_fonts_utils.dart';
import '../../../../utils/fonts/row_text_sands.dart';
import '../../../../utils/widget/platform/platform_check.dart';
import 'banner_image_support_widget_user.dart';

class InnerCategoryContentSupportWidgetUser extends StatefulWidget {
  final CategoryApiModels category;
  final bool listView;

  const InnerCategoryContentSupportWidgetUser({
    super.key,
    required this.category,
    this.listView = false,
  });

  @override
  State<InnerCategoryContentSupportWidgetUser> createState() =>
      _InnerCategoryContentSupportWidgetUserState();
}

class _InnerCategoryContentSupportWidgetUserState
    extends State<InnerCategoryContentSupportWidgetUser> {
  late Future<List<SubCategoryApiModels>> subCategoryModel;
  late Future<List<ProductModel>> productModel;

  final SubCategoryControllers subCategoryControllers =
      SubCategoryControllers();
  final ProductController productController = ProductController();

  final Set<int> favoriteIndexes = {};
  final Set<int> cartIndexes = {};

  @override
  void initState() {
    super.initState();
    subCategoryModel = subCategoryControllers
        .getSubCategoryByCategoryName(widget.category.categoryName);
    productModel =
        productController.fetchProductCategory(widget.category.categoryName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        children: [
          bannerImageResponsiveWidget(context, widget.category.categoryBanner),
          const SizedBox(height: 10),
          Center(
            child: googleInterText(
              'Shop by Category',
              fontSize: 19,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          futureBuilderSubCategory(
            context,
            subCategoryModel,
            "No Sub Category Found",
            horizontalScroll: true,
          ),
          const SizedBox(height: 10),
          kIsWeb
              ? RowTextSands(
                  title: 'Popular Product:',
                  subTitle: ' View All',
                  mainAxisAlignment: kIsWeb && (isIOSWeb() || isAndroidWeb())
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.spaceEvenly,
                )
              : const RowTextSands(
                  title: 'Popular Product:',
                  subTitle: ' View All',
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
          const SizedBox(height: 10),
          futureBuilderProduct(
            context,
            productModel,
            "No Popular Products",
            widget.listView,
            favoriteIndexes,
            cartIndexes,
            (index) {
              setState(() {
                if (favoriteIndexes.contains(index)) {
                  favoriteIndexes.remove(index);
                } else {
                  favoriteIndexes.add(index);
                }
              });
            },
            (index) {
              setState(() {
                if (cartIndexes.contains(index)) {
                  cartIndexes.remove(index);
                } else {
                  cartIndexes.add(index);
                }
              });
            },
          ),
        ],
      ),
    );
  }
}

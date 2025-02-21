import 'package:flutter/material.dart';
import 'package:store_app/models/api/category_api_models.dart';
import 'package:store_app/models/navigate_models.dart';
import 'package:store_app/views/screens/navigation_mobile/screens/widget/banner_mobile_widget.dart';
import 'package:store_app/views/screens/navigation_mobile/widgets/header_widget_screen.dart';

class InnerCategoryScreen extends StatelessWidget {
  final CategoryApiModels category;
  const InnerCategoryScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: detailHeaderWidget(
        context,
        backOnPressed: () => pop(context),
      ),
      body: bannerImageMobileWidget(context, category.categoryBanner),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:store_app/models/api/category_api_models.dart';

import '../../../../components/color/color_theme.dart';
import '../../../../models/image_model.dart';
import '../../../../models/navigate_models.dart';
import '../account__navigation_screen.dart';
import '../cart_navigation_screen.dart';
import '../category_navigation_screen.dart';
import '../fav_navigation_screen.dart';
import '../store_navigation_screen.dart';
import '../widgets/header_widget_screen.dart';
import 'widget/inner_category_content_widget.dart';

class InnerCategoryScreen extends StatefulWidget {
  final CategoryApiModels category;
  const InnerCategoryScreen({super.key, required this.category});

  @override
  State<InnerCategoryScreen> createState() => _InnerCategoryScreenState();
}

class _InnerCategoryScreenState extends State<InnerCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    int mobilePagesIndex = 0;
    final List<Widget> mobilePages = [
      InnerCategoryContentWidget(
        category: widget.category,
      ),
      FavNavigationScreen(),
      CategoryNavigationScreen(),
      StoreNavigationScreen(),
      CartNavigationScreen(),
      AccountNavigationScreen(),
    ];
    return Scaffold(
      appBar: detailHeaderWidget(
        context,
        backOnPressed: () => pop(context),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: mobilePagesIndex,
        selectedItemColor: ColorTheme.color.deepPuceColor,
        selectedFontSize: 14,
        unselectedFontSize: 12,
        unselectedItemColor: ColorTheme.color.grayColor,
        onTap: (value) => setState(
          () {
            mobilePagesIndex = value;
          },
        ),
        items: [
          bottomBarItem(
            Icon(Icons.home_outlined),
            'Home',
          ),
          bottomBarItem(
            Icon(Icons.favorite_border_outlined),
            'Favorite',
          ),
          bottomBarItem(
            Icon(Icons.category_outlined),
            'Categories',
          ),
          bottomBarItem(
            Icon(Icons.shopping_bag_outlined),
            'Stores',
          ),
          bottomBarItem(
            Icon(Icons.shopping_cart_outlined),
            'Cart',
          ),
          bottomBarItem(
            Icon(Icons.account_circle_outlined),
            'Account',
          ),
        ],
        elevation: 5,
      ),
      body: mobilePages[mobilePagesIndex],
    );
  }
}

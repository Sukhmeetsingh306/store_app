import 'package:flutter/material.dart';

import '../../../models/api/category_api_models.dart';
import '../../../utils/theme/color/color_theme.dart';
import '../../../utils/widget/button_widget_utils.dart';
import '../../../utils/widget/mobile/drawer_mobile_widget.dart';
import 'header_widget_user.dart';
import 'navigation/account_navigation_screen.dart';
import 'navigation/cart_navigation_screen.dart';
import 'navigation/category_navigation_screen.dart';
import 'navigation/fav_navigation_screen.dart';
import 'navigation/store_navigation_screen.dart';
import 'support/inner_category_content_support_widget_user.dart';

class InnerCategoryScreen extends StatefulWidget {
  final CategoryApiModels category;
  final bool showBottomNav;

  const InnerCategoryScreen({
    super.key,
    required this.category,
    this.showBottomNav = true,
  });

  @override
  State<InnerCategoryScreen> createState() => _InnerCategoryScreenState();
}

class _InnerCategoryScreenState extends State<InnerCategoryScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  int mobilePagesIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> mobilePages = [
      InnerCategoryContentSupportWidgetUser(
        category: widget.category,
      ),
      FavNavigationScreen(),
      CategoryNavigationScreen(
        hasAppBar: false,
      ),
      StoreNavigationScreen(),
      CartNavigationScreen(),
      AccountNavigationScreen(),
    ];

    final headerWidgetUser = HeaderWidgetUser(
      scaffoldKey: scaffoldKey,
    );

    return Scaffold(
      key: scaffoldKey,
      appBar: headerWidgetUser.detailHeaderWidget(
        context,
        backOnPressed: () => Navigator.pop(context),
        scaffoldKey: scaffoldKey,
      ),
      drawer: DrawerWidget(
        scaffoldKey: scaffoldKey,
        onFavTap: () {
          setState(() {
            mobilePagesIndex = 1;
          });
        },
        onCategoryTap: () {
          print("worked in inner category screen"); // now should print ✅
          setState(() {
            mobilePagesIndex = 2;
          });
        },
      ),
      bottomNavigationBar: widget.showBottomNav
          ? BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: mobilePagesIndex,
              selectedItemColor: ColorTheme.color.deepPuceColor,
              selectedFontSize: 14,
              unselectedFontSize: 12,
              unselectedItemColor: ColorTheme.color.grayColor,
              onTap: (value) {
                setState(() {
                  mobilePagesIndex = value;
                });
              },
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
            )
          : null,
      body: mobilePages[mobilePagesIndex],
    );
  }
}

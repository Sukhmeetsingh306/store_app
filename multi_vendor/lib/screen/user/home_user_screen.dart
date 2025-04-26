import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import '../../utils/theme/color/color_theme.dart';
import '../../utils/widget/mobile/drawer_mobile_widget.dart';
import '../../utils/widget/mobile/user_screen_wrapper_mobile.dart';
import 'widget/banner_widget_user.dart';
import 'widget/navigation/account_navigation_screen.dart';
import 'widget/navigation/cart_navigation_screen.dart';
import 'widget/navigation/category_navigation_screen.dart';
import 'widget/navigation/fav_navigation_screen.dart';
import 'widget/navigation/store_navigation_screen.dart';
import 'widget/support/category_widget_support_user.dart';

class HomeUserScreen extends StatefulWidget {
  static String routeName = '/homePage';
  static String routePath = '/homePage';

  const HomeUserScreen({super.key});

  @override
  State<HomeUserScreen> createState() => _HomeUserScreenState();
}

class _HomeUserScreenState extends State<HomeUserScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int mobilePagesIndex = 0;

  late final List<Widget> mobilePages;

  bool isMobile(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return !kIsWeb && width < 600;
  }

  @override
  void initState() {
    super.initState();
    mobilePages = [
      UserScreenWrapper(
        scaffoldKey: _scaffoldKey,
        child: Column(
          children: const [
            BannerWidgetIOS(),
            CategoryWidgetSupportUser(),
          ],
        ),
      ),
      UserScreenWrapper(
        scaffoldKey: _scaffoldKey,
        child: const FavNavigationScreen(),
      ),
      UserScreenWrapper(
        scaffoldKey: _scaffoldKey,
        child: CategoryNavigationScreen(hasAppBar: false),
      ),
      UserScreenWrapper(
        scaffoldKey: _scaffoldKey,
        child: const StoreNavigationScreen(),
      ),
      UserScreenWrapper(
        scaffoldKey: _scaffoldKey,
        child: const CartNavigationScreen(),
      ),
      UserScreenWrapper(
        scaffoldKey: _scaffoldKey,
        child: const AccountNavigationScreen(),
      ),
    ];
  }

  BottomNavigationBarItem bottomBarItem(Icon icon, String label) {
    return BottomNavigationBarItem(icon: icon, label: label);
  }

  @override
  Widget build(BuildContext context) {
    final bool showBottomBar = isMobile(context);

    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerWidget(
        scaffoldKey: _scaffoldKey,
        onCategoryTap: () {
          setState(() {
            mobilePagesIndex = 2;
          });
          Navigator.pop(context);
        },
      ),
      body: mobilePages[mobilePagesIndex],
      bottomNavigationBar: showBottomBar
          ? BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: mobilePagesIndex,
              selectedItemColor: ColorTheme.color.deepPuceColor,
              selectedFontSize: 14,
              unselectedFontSize: 12,
              unselectedItemColor: ColorTheme.color.grayColor,
              onTap: (index) {
                setState(() {
                  mobilePagesIndex = index;
                });
              },
              items: [
                bottomBarItem(Icon(Icons.home_outlined), 'Home'),
                bottomBarItem(Icon(Icons.favorite_border_outlined), 'Favorite'),
                bottomBarItem(Icon(Icons.category_outlined), 'Categories'),
                bottomBarItem(Icon(Icons.shopping_bag_outlined), 'Stores'),
                bottomBarItem(Icon(Icons.shopping_cart_outlined), 'Cart'),
                bottomBarItem(Icon(Icons.account_circle_outlined), 'Account'),
              ],
              elevation: 5,
            )
          : null,
    );
  }
}

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:multi_vendor/screen/user/widget/header_widget_user.dart';

import '../../utils/fonts/google_fonts_utils.dart';
import '../../utils/theme/color/color_theme.dart';
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
      Column(
        children: [
          HeaderWidgetUser(scaffoldKey: _scaffoldKey),
          const BannerWidgetIOS(),
          const CategoryWidgetSupportUser(),
        ],
      ),
      const FavNavigationScreen(),
      CategoryNavigationScreen(hasAppBar: false),
      const StoreNavigationScreen(),
      const CartNavigationScreen(),
      const AccountNavigationScreen(),
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
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * .55,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .18,
              child: DrawerHeader(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF247CFF),
                      Color(0xFF2680F8),
                      Color(0xFF2B86FF),
                      Color(0xFF3490FE),
                      Color(0xFF3D9CFF),
                    ],
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: googleInterText("Menu",
                      color: Colors.white, fontSize: 28),
                ),
              ),
            ),
            listTile("Home", Icon(Icons.home_outlined)),
            listTile("Profile", Icon(Icons.account_circle_outlined)),
            listTile("Seller", Icon(Icons.store_outlined)),
            listTile("Categories", Icon(Icons.category_outlined),
                onTap: () => Navigator.pushNamed(context, '/categoryPage')),
            listTile("Favorites", Icon(Icons.favorite_border),
                onTap: () => Navigator.pushNamed(context, '/favPage')),
            listTile("Cart", Icon(Icons.shopping_cart_outlined),
                onTap: () => Navigator.pushNamed(context, '/cartPage')),
            listTile("Orders", Icon(Icons.receipt_long_outlined),
                onTap: () => Navigator.pushNamed(context, '/orderPage')),
            listTile("Support", Icon(Icons.support_agent_outlined),
                onTap: () => Navigator.pushNamed(context, '/supportPage')),
            listTile("Settings", Icon(Icons.settings_outlined)),
            listTile("Logout", Icon(Icons.logout_outlined), onTap: () {}),
          ],
        ),
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

Widget listTile(String text, Widget leading, {GestureTapCallback? onTap}) {
  return Column(
    children: [
      ListTile(
        leading: leading,
        title: googleInterText(
          text,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        onTap: onTap ?? () {},
      ),
      Divider(),
    ],
  );
}

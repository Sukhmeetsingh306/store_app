import 'package:flutter/material.dart';
import 'package:multi_vendor/screen/user/widget/header_widget_user.dart';

import '../../utils/fonts/google_fonts_utils.dart';
import 'widget/banner_widget_user.dart';
import 'widget/support/category_widget_support_user.dart';

class HomeUserScreen extends StatelessWidget {
  HomeUserScreen({super.key});

  static String routeName = '/homePage';
  static String routePath = '/homePage';

  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(); // <-- STEP 1

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // <-- STEP 2
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
                      Color(0xFF247CFF), // Same strong base blue
                      Color(0xFF2680F8), // Slightly more balanced
                      Color(0xFF2B86FF), // Richer mid-blue
                      Color(0xFF3490FE), // Bright and lively
                      Color(0xFF3D9CFF), // Soft blue to finish
                    ],
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: googleInterText(
                    "Menu",
                    color: Colors.white,
                    fontSize: 28,
                  ),
                ),
              ),
            ),
            listTile("Home", Icon(Icons.home_outlined)),
            listTile("Profile", Icon(Icons.account_circle_outlined),
                onTap: () {}),
            listTile(
              "Categories",
              Icon(Icons.category_outlined),
              onTap: () {
                Navigator.pushNamed(context, '/categoryPage');
              },
            ),
            listTile(
              "Favorites",
              Icon(Icons.favorite_border),
              onTap: () {
                Navigator.pushNamed(context, '/favPage');
              },
            ),
            listTile(
              "Cart",
              Icon(Icons.shopping_cart_outlined),
              onTap: () {
                Navigator.pushNamed(context, '/cartPage');
              },
            ),
            listTile(
              "Orders",
              Icon(Icons.receipt_long_outlined),
              onTap: () {
                Navigator.pushNamed(context, '/orderPage');
              },
            ),
            listTile(
              "Support",
              Icon(Icons.support_agent_outlined),
              onTap: () {
                Navigator.pushNamed(context, '/supportPage');
              },
            ),
            listTile("Settings", Icon(Icons.settings_outlined)),
            listTile("Logout", Icon(Icons.logout_outlined), onTap: () {}),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderWidgetUser(scaffoldKey: _scaffoldKey), // <-- STEP 3
            const BannerWidgetIOS(),
            const CategoryWidgetSupportUser(),
          ],
        ),
      ),
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

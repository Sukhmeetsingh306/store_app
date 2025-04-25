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
        width: MediaQuery.of(context).size.width * .5,
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
            ListTile(title: Text("Item 1")),
            ListTile(title: Text("Item 2")),
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

ListTile listTile(String text, Widget leading, {GestureTapCallback? onTap}) {
  return ListTile(
    leading: leading,
    title: googleInterText(text, fontSize: 16, fontWeight: FontWeight.normal),
    onTap: onTap ?? () {},
  );
}

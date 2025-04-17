import 'package:flutter/material.dart';
import 'package:multi_vendor/screen/user/widget/header_widget_user.dart';

import 'widget/banner_widget_user.dart';
import 'widget/support/category_widget_support_user.dart';

class HomeUserScreen extends StatelessWidget {
  const HomeUserScreen({super.key});

  static String routeName = '/homePage';
  static String routePath = '/homePage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: const [
            HeaderWidgetUser(),
            BannerWidgetIOS(),
            CategoryWidgetSupportUser(),
          ],
        ),
      ),
    );
  }
}

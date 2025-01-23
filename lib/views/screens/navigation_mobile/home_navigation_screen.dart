import 'package:flutter/material.dart';

import '../navigation_web/widget/category_widget.dart';
import 'widgets/banner_widget_ios.dart';
import 'widgets/header_widget_screen.dart';

class HomeNavigationScreen extends StatelessWidget {
  const HomeNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        HeaderWidgetScreen(),
        BannerWidgetIOS(),
        CategoryWidget(),
      ],
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:store_app/views/screens/navigation_mobile/widgets/banner_widget.dart';

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
      ],
    ));
  }
}

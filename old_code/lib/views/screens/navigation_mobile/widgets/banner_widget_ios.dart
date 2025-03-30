// this code is for the ios devices or for the mobile devices

import 'package:flutter/material.dart';
import 'package:store_app/components/color/color_theme.dart';

import '../../navigation_web/widget/banner_widget.dart';

class BannerWidgetIOS extends StatelessWidget {
  const BannerWidgetIOS({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.17,
        decoration: BoxDecoration(
          color: ColorTheme.color.whiteColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: BannerWidget(),
      ),
    );
  }
}

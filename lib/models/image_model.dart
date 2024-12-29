import 'package:flutter/material.dart';

Image imageAssets(
  String image, {
  double? width,
  double? height,
}) {
  return Image.asset(
    image,
    width: width ?? 25,
    height: height ?? 20,
  );
}

BottomNavigationBarItem bottomBarItem(
  Widget icon,
  String name,
) {
  return BottomNavigationBarItem(
    icon: icon,
    label: name,
  );
}

import 'package:flutter/material.dart';

Widget bannerImageMobileWidget(BuildContext context, String src) {
  return Container(
    padding: const EdgeInsets.all(8),
    height: MediaQuery.of(context).size.height * 0.25,
    width: MediaQuery.of(context).size.width,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        src,
        fit: BoxFit.cover,
      ),
    ),
  );
}

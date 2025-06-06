import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Widget bannerImageResponsiveWidget(BuildContext context, String src) {
  if (kIsWeb) {
    final width = MediaQuery.of(context).size.width;

    return Center(
      child: Container(
        padding: const EdgeInsets.all(8),
        width: width > 1200 ? 600 : width * 0.6, // Reduced width
        height: 250, // Increased height
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            src,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  } else {
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
}

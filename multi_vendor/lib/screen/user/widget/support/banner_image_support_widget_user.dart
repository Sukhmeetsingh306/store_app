import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Widget bannerImageResponsiveWidget(BuildContext context, String? url) {
  if (url == null || url.isEmpty) {
    // Fallback if no banner is provided
    return Container(
      width: double.infinity,
      height: kIsWeb ? 250 : MediaQuery.of(context).size.height * 0.25,
      color: Colors.grey.shade200,
      alignment: Alignment.center,
      child: const Text(
        "No Banner",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  final double width = MediaQuery.of(context).size.width;
  final double height =
      kIsWeb ? 250 : MediaQuery.of(context).size.height * 0.25;
  final double containerWidth =
      kIsWeb ? (width > 1200 ? 600 : width * 0.6) : width;

  return Center(
    child: Container(
      padding: const EdgeInsets.all(8),
      width: containerWidth,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          url,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Fallback if the URL is invalid
            return Container(
              width: double.infinity,
              height: height,
              color: Colors.grey.shade200,
              alignment: Alignment.center,
              child: const Text(
                "Invalid Banner",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            );
          },
        ),
      ),
    ),
  );
}

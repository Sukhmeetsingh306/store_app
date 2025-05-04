import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:html' as html;

Widget sizedBoxH5() {
  return SizedBox(
    height: 5,
  );
}

Widget sizedBoxH8() {
  return SizedBox(
    height: 8,
  );
}

Widget sizedBoxH10() {
  return SizedBox(
    height: 10,
  );
}

Widget sizedBoxH15() {
  return SizedBox(
    height: 15,
  );
}

Widget sizedBoxH20() {
  return SizedBox(
    height: 20,
  );
}

Widget sizedBoxW16() {
  return SizedBox(width: 16);
}

Widget sizedBoxMediaQuery(
  BuildContext context, {
  double? width,
  double? height,
}) {
  return SizedBox(
    width: MediaQuery.of(context).size.width * width!,
    height: MediaQuery.of(context).size.height * height!,
  );
}

bool isWebMobile(BuildContext context) {
  return kIsWeb && MediaQuery.of(context).size.width > 1026;
}

bool isIOSWeb() {
  if (kIsWeb) {
    final userAgent = html.window.navigator.userAgent.toLowerCase();
    return userAgent.contains('iphone') ||
        userAgent.contains('ipad') ||
        userAgent.contains('ipod');
  }
  return false;
}

bool isAndroidWeb() {
  if (kIsWeb) {
    final userAgent = html.window.navigator.userAgent.toLowerCase();
    return userAgent.contains('android');
  }
  return false;
}

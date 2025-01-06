import 'package:flutter/material.dart';

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

import 'package:flutter/material.dart';

import '../../../screen/user/widget/header_widget_user.dart';

class UserScreenWrapper extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Widget child;

  const UserScreenWrapper({
    super.key,
    required this.scaffoldKey,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HeaderWidgetUser(scaffoldKey: scaffoldKey),
        Expanded(child: SingleChildScrollView(child: child)),
      ],
    );
  }
}

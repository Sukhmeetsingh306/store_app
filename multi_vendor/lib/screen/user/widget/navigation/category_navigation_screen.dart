import 'package:flutter/material.dart';

import '../header_widget_user.dart';
import '../support/category_widget_support_user.dart';

class CategoryNavigationScreen extends StatelessWidget {
  final bool hasAppBar;

  const CategoryNavigationScreen({super.key, bool? hasAppBar})
      : hasAppBar = hasAppBar ?? true; // Ensures hasAppBar is never null

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: hasAppBar
          ? PreferredSize(
              preferredSize: Size.fromHeight(
                MediaQuery.of(context).size.height * 0.2,
              ),
              child: HeaderWidgetUser(),
            )
          : null,
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: CategoryWidgetSupportUser(
              listView: true,
            ),
          ),
        ],
      ),
    );
  }
}

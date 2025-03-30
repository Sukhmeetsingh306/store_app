import 'package:flutter/material.dart';
import 'package:store_app/views/screens/navigation_web/widget/category_widget.dart';

import 'widgets/header_widget_screen.dart';

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
              child: HeaderWidgetScreen(),
            )
          : null,
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: CategoryWidget(
              listView: true,
            ),
          ),
        ],
      ),
    );
  }
}

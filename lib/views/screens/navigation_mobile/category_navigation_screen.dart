import 'package:flutter/material.dart';
import 'package:store_app/views/screens/navigation_web/widget/category_widget.dart';

import 'widgets/header_widget_screen.dart';

class CategoryNavigationScreen extends StatelessWidget {
  const CategoryNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          MediaQuery.of(context).size.height * 20,
        ),
        child: HeaderWidgetScreen(),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey.shade300,
              child: CategoryWidget(
                listView: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

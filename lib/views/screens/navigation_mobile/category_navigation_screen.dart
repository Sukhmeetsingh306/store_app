import 'package:flutter/material.dart';

import 'widgets/header_widget_screen.dart';

class CategoryNavigationScreen extends StatefulWidget {
  const CategoryNavigationScreen({super.key});

  @override
  State<CategoryNavigationScreen> createState() => _CategoryNavigationScreenState();
}

class _CategoryNavigationScreenState extends State<CategoryNavigationScreen> {
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
            ),
          ),
        ],
      ),
    );
  }
}

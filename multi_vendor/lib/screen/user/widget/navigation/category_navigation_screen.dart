import 'package:flutter/material.dart';

import '../header_widget_user.dart';
import '../support/category_widget_support_user.dart';

class CategoryNavigationScreen extends StatelessWidget {
  final bool hasAppBar;
  final GlobalKey<ScaffoldState> scaffoldKey;

  static String routeName = '/categoryPage';
  static String routePath = '/categoryPage';

  CategoryNavigationScreen({
    super.key,
    bool? hasAppBar,
    GlobalKey<ScaffoldState>? scaffoldKey,
  })  : hasAppBar = hasAppBar ?? true,
        scaffoldKey = scaffoldKey ?? GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: hasAppBar
          ? PreferredSize(
              preferredSize: Size.fromHeight(
                MediaQuery.of(context).size.height * 0.2,
              ),
              child: HeaderWidgetUser(
                scaffoldKey: scaffoldKey,
              ),
            )
          : null,
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: CategoryWidgetSupportUser(
              listView: true,
              showHeadingRow: false,
            ),
          ),
        ],
      ),
    );
  }
}

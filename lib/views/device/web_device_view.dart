import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

import '../../components/color/color_theme.dart';
import '../../components/text/googleFonts.dart';

class WebDeviceView extends StatefulWidget {
  const WebDeviceView({super.key});

  @override
  State<WebDeviceView> createState() => _WebDeviceViewState();
}

class _WebDeviceViewState extends State<WebDeviceView> {
  @override
  Widget build(BuildContext context)  {
    return AdminScaffold(
      appBar: AppBar(
        backgroundColor: ColorTheme.color.dodgerBlue,
        title: googleText("Management"),
        centerTitle: false,
      ),
      body: googleText('DashBoard'),
      sideBar: SideBar(
        items: const [
          AdminMenuItem(
            title: 'Vendors',
            route: "",
            icon: CupertinoIcons.person_3,
          ),
          AdminMenuItem(
            title: 'Buyers',
            route: "",
            icon: CupertinoIcons.person,
          ),
          AdminMenuItem(
            title: 'Orders',
            route: '',
            icon: Icons.shopping_cart_outlined,
          ),
          AdminMenuItem(
            title: 'Categories',
            route: "",
            icon: Icons.category_outlined,
          ),
          AdminMenuItem(
            title: 'Upload Banners',
            route: "",
            icon: Icons.upload_sharp,
          ),
          AdminMenuItem(
            title: 'Products',
            route: '',
            icon: Icons.shopping_cart_outlined,
          ),
        ],
        selectedRoute: '/',
        textStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
        ),
        iconColor: Colors.black,
      ),
    );
  }
}
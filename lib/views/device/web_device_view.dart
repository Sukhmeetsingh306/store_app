import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:store_app/views/screens/side_screens/buyer_side_screen.dart';
import 'package:store_app/views/screens/side_screens/category_side_screen.dart';
import 'package:store_app/views/screens/side_screens/order_side_screen.dart';
import 'package:store_app/views/screens/side_screens/product_side_screen.dart';
import 'package:store_app/views/screens/side_screens/upload_banner_side_screen.dart';

import '../../components/color/color_theme.dart';
import '../../components/text/googleFonts.dart';
import '../screens/side_screens/vendor_side_screen.dart';

class WebDeviceView extends StatefulWidget {
  const WebDeviceView({super.key});

  @override
  State<WebDeviceView> createState() => _WebDeviceViewState();
}

class _WebDeviceViewState extends State<WebDeviceView> {
  final Widget _selectedScreen = VendorSideScreen();

  Widget web(){
    return AdminScaffold(
      appBar: AppBar(
        backgroundColor: ColorTheme.color.dodgerBlue,
        title: googleText("Management"),
        centerTitle: false,
      ),
      body: _selectedScreen,
      sideBar: SideBar(
        items: const [
          AdminMenuItem(
            title: 'Vendors',
            route: VendorSideScreen.routeName,
            icon: CupertinoIcons.person_3,
          ),
          AdminMenuItem(
            title: 'Buyers',
            route: BuyerSideScreen.routeName,
            icon: CupertinoIcons.person,
          ),
          AdminMenuItem(
            title: 'Orders',
            route: OrderSideScreen.routeName,
            icon: Icons.shopping_cart_outlined,
          ),
          AdminMenuItem(
            title: 'Categories',
            route: CategorySideScreen.routeName,
            icon: Icons.category_outlined,
          ),
          AdminMenuItem(
            title: 'Upload Banners',
            route: UploadBannerSideScreen.routeName,
            icon: Icons.upload_sharp,
          ),
          AdminMenuItem(
            title: 'Products',
            route: ProductSideScreen.routeName,
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

  @override
  Widget build(BuildContext context)  {
    return web();
  }
}
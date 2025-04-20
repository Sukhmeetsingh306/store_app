import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/fonts/google_fonts_utils.dart';
import '../../utils/theme/color/color_theme.dart';
import '../../utils/widget/web/admin_menu_item.dart';
import '../../utils/widget/web/admin_scaffold_web.dart';
import '../../utils/widget/web/side_bar_web.dart';
import 'sideScreen/buyer_side_screen.dart';
import 'sideScreen/category_side_screen.dart';
import 'sideScreen/order_side_screen.dart';
import 'sideScreen/product_side_screen.dart';
import 'sideScreen/sub_category_side_screen.dart';
import 'sideScreen/upload_banner_side_screen.dart';
import 'sideScreen/vendor_side_screen.dart';

class WebDeviceView extends StatefulWidget {
  static String routeName = '/management';
  static String routePath = '/management';

  const WebDeviceView({super.key});

  @override
  State<WebDeviceView> createState() => _WebDeviceViewState();
}

class _WebDeviceViewState extends State<WebDeviceView> {
  // MARK: when the code completed change it back
  //Widget _selectedScreen = VendorSideScreen();
  Widget _selectedScreen = SubCategorySideScreen();

  screenSelector(screen) {
    switch (screen.route) {
      case VendorSideScreen.routeName:
        setState(() {
          _selectedScreen = VendorSideScreen();
        });
        break;

      case BuyerSideScreen.routeName:
        setState(() {
          _selectedScreen = BuyerSideScreen();
        });
        break;

      case OrderSideScreen.routeName:
        setState(() {
          _selectedScreen = OrderSideScreen();
        });
        break;

      case CategorySideScreen.routeName:
        setState(() {
          _selectedScreen = CategorySideScreen();
        });
        break;

      case SubCategorySideScreen.routeName:
        setState(() {
          _selectedScreen = SubCategorySideScreen();
        });
        break;

      case ProductSideScreen.routeName:
        setState(() {
          _selectedScreen = ProductSideScreen();
        });
        break;

      case UploadBannerSideScreen.routeName:
        setState(() {
          _selectedScreen = UploadBannerSideScreen();
        });
        break;
    }
  }

  Widget web() {
    return AdminScaffold(
      backgroundColor: ColorTheme.color.transparentBack,
      appBar: AppBar(
        backgroundColor: ColorTheme.color.dodgerBlue,
        title: googleInterText("Management"),
        centerTitle: false,
      ),
      body: _selectedScreen,
      sideBar: SideBar(
        header: Container(
          height: MediaQuery.of(context).size.height * 0.07,
          width: double.infinity,
          decoration: BoxDecoration(
            color: ColorTheme.color.blackColor,
            borderRadius: BorderRadius.all(Radius.circular(1)),
          ),
          child: Center(
            child: googleInterText(
              'Multi Vendor Admin',
              color: ColorTheme.color.whiteColor,
            ),
          ),
        ),
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
            title: 'SubCategories',
            route: SubCategorySideScreen.routeName,
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
        textStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w400,
        ),
        iconColor: Colors.black,
        selectedRoute: '',
        onSelected: (route) => screenSelector(route),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return web();
  }
}

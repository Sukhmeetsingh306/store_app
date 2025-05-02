import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../utils/fonts/google_fonts_utils.dart';
import '../../utils/theme/color/color_theme.dart';
import '../../utils/widget/space_widget_utils.dart';
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
  bool isLoading = false;

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

      case 'return':
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        );

        Future.delayed(const Duration(seconds: 3)).then((_) {
          if (!mounted) return;

          Navigator.of(context, rootNavigator: true).pop();

          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          } else {
            context.go('/homePage');
          }
        });
        break;
    }
  }

  Widget web() {
    return AdminScaffold(
      backgroundColor: ColorTheme.color.transparentBack,
      appBar: AppBar(
        backgroundColor: ColorTheme.color.mediumBlue,
        title: googleInterText(
          "Management",
          color: Colors.white,
        ),
        centerTitle: false,
      ),
      body: _selectedScreen,
      sideBar: isWebMobile(context)
          ? SideBar(
              header: Container(
                height: MediaQuery.of(context).size.height * 0.07,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(1)),
                  gradient: LinearGradient(
                    colors: gradientColors(),
                  ),
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
                AdminMenuItem(
                  title: 'Return',
                  route: 'return',
                  icon: Icons.arrow_back_sharp,
                ),
              ],
              textStyle: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w400,
              ),
              iconColor: Colors.black,
              selectedRoute: '',
              onSelected: (route) => screenSelector(route),
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        web(),
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.white.withAlpha(4),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
      ],
    );
  }
}

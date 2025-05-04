import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_vendor/utils/widget/space_widget_utils.dart';

import '../../utils/fonts/google_fonts_utils.dart';
import '../../utils/theme/color/color_theme.dart';
import '../../utils/widget/web/admin_menu_item.dart';
import '../../utils/widget/web/admin_scaffold_web.dart';
import '../../utils/widget/web/side_bar_item.dart';
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

// MARK: when the code completed change it back
//Widget _selectedScreen = VendorSideScreen();
class _WebDeviceViewState extends State<WebDeviceView> {
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
    return LayoutBuilder(builder: (context, constraints) {
      return AdminScaffold(
        backgroundColor: ColorTheme.color.transparentBack,
        drawer: Drawer(
          width: (isWebMobile(context)) ||
                  defaultTargetPlatform == TargetPlatform.iOS ||
                  defaultTargetPlatform == TargetPlatform.android
              ? kIsWeb
                  ? MediaQuery.of(context).size.width * 0.2
                  : MediaQuery.of(context).size.width * 0.6
              : MediaQuery.of(context).size.width * 0.34,
          backgroundColor: ColorTheme.color.whiteColor,
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: SafeArea(
              top: false,
              child: buildSideBarContent(isInsideDrawer: true),
            ),
          ),
        ),
        appBar: AppBar(
          backgroundColor: ColorTheme.color.mediumBlue,
          iconTheme: const IconThemeData(color: Colors.white),
          title: googleInterText("Management", color: Colors.white),
          centerTitle: false,
        ),
        body: _selectedScreen,
        //  MARK: removed this as per unable to solve the error unable to get the code to be fixed for alternative side bar and drawer
        // sideBar: isMobile
        //     ? SideBar(
        //         header: const SizedBox
        //             .shrink(), // We're handling header inside the body now
        //         items: const [],
        //         textStyle: const TextStyle(), // Empty dummy setup
        //         onSelected: (_) {}, // Dummy
        //         selectedRoute: '',
        //         child: buildSideBarContent(),
        //       )
        //     : null,
      );
    });
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

  List<AdminMenuItem> get _menuItems => const [
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
      ];

  Widget buildSideBarContent({bool isInsideDrawer = false}) {
    final isMobile = isWebMobile(context);

    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.18,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: gradientColors()),
          ),
          alignment: Alignment.bottomLeft,
          padding: const EdgeInsets.only(left: 16, bottom: 16),
          child: googleInterText(
            'Multi Vendor Admin',
            color: ColorTheme.color.whiteColor,
            fontSize: isMobile ? null : 24,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _menuItems.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: SideBarItem(
                  items: _menuItems,
                  index: index,
                  onSelected: (selectedIndex) {
                    if (isInsideDrawer) Navigator.pop(context);
                    screenSelector(selectedIndex);
                  },
                  selectedRoute: '',
                  textStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                  iconColor: Colors.black,
                  activeTextStyle: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                  ),
                  activeIconColor: Colors.blue,
                  backgroundColor: Colors.transparent,
                  activeBackgroundColor: const Color(0xFFE0E0E0),
                  borderColor: Colors.grey.shade300,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

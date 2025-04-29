import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_vendor/services/http_services.dart';

import '../../fonts/google_fonts_utils.dart';
import '../../routes/navigation_routes.dart';

class DrawerWidget extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final VoidCallback? onHomeTap;
  final VoidCallback? onCategoryTap;
  final VoidCallback? onFavTap;
  final VoidCallback? onCartTap;
  final VoidCallback? onStoreTap;
  final VoidCallback? onAccountTap;

  const DrawerWidget({
    super.key,
    required this.scaffoldKey,
    this.onCategoryTap,
    this.onFavTap,
    this.onHomeTap,
    this.onCartTap,
    this.onStoreTap,
    this.onAccountTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isWebMobile = kIsWeb && MediaQuery.of(context).size.width > 1026;

    return Drawer(
      width: isWebMobile
          ? MediaQuery.of(context).size.width * 0.15
          : MediaQuery.of(context).size.width * 0.5,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * .18,
            child: DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF247CFF),
                    Color(0xFF2680F8),
                    Color(0xFF2B86FF),
                    Color(0xFF3490FE),
                    Color(0xFF3D9CFF),
                  ],
                ),
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child:
                    googleInterText("Menu", color: Colors.white, fontSize: 28),
              ),
            ),
          ),
          listTile(
            "Home",
            Icon(Icons.home_outlined),
            onTap: () {
              Navigator.pop(context);
              if (onHomeTap != null) {
                onHomeTap!();
              } else {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  context.pushReplacement('/homePage');
                } else {
                  context.go('/homePage');
                }
              }
            },
          ),
          listTile(
            "Categories",
            Icon(Icons.category_outlined),
            onTap: () {
              pop(context);
              if (onCategoryTap != null) {
                onCategoryTap!();
              }
            },
          ),
          listTile("Favorites", Icon(Icons.favorite_border), onTap: () {
            pop(context);
            if (onFavTap != null) {
              onFavTap!();
            }
          }),
          listTile("Store", Icon(Icons.shopping_bag_outlined), onTap: () {
            pop(context);
            if (onStoreTap != null) {
              onStoreTap!();
            }
          }),
          listTile("Cart", Icon(Icons.shopping_cart_outlined), onTap: () {
            pop(context);
            if (onCartTap != null) {
              onCartTap!();
            }
          }),
          listTile("Support", Icon(Icons.support_agent_outlined), onTap: () {
            pop(context);

            showSnackBar(context, 'Support is not available yet');
          }),
          listTile("Seller", Icon(Icons.store_outlined), onTap: () {
            pop(context);

            showSnackBar(context, 'Seller is not available yet');
          }),
          listTile(
            "Account",
            Icon(Icons.account_circle_outlined),
            onTap: () {
              pop(context);
              if (onAccountTap != null) {
                onAccountTap!();
              }
            },
          ),
          listTile("Settings", Icon(Icons.settings_outlined), onTap: () {
            pop(context);

            showSnackBar(context, 'Settings is not available yet');
          }),
          listTile("Logout", Icon(Icons.logout_outlined), onTap: () {
            pop(context);
            Navigator.of(context).popUntil((route) => route.isFirst);
            context.pushReplacement('/loginPage');
          }),
        ],
      ),
    );
  }

  Widget listTile(String text, Widget leading, {GestureTapCallback? onTap}) {
    return Column(
      children: [
        ListTile(
          leading: leading,
          title: googleInterText(
            text,
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
          onTap: onTap ?? () {},
        ),
        Divider(),
      ],
    );
  }
}

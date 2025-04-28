import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../fonts/google_fonts_utils.dart';
import '../../routes/navigation_routes.dart';

class DrawerWidget extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final VoidCallback? onHomeTap;
  final VoidCallback? onCategoryTap;

  const DrawerWidget({
    super.key,
    required this.scaffoldKey,
    this.onCategoryTap,
    this.onHomeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * .55,
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
          listTile("Favorites", Icon(Icons.favorite_border),
              onTap: () => Navigator.pushNamed(context, '/favPage')),
          listTile("Cart", Icon(Icons.shopping_cart_outlined),
              onTap: () => Navigator.pushNamed(context, '/cartPage')),
          listTile("Support", Icon(Icons.support_agent_outlined),
              onTap: () => Navigator.pushNamed(context, '/supportPage')),
          listTile("Seller", Icon(Icons.store_outlined)),
          listTile("Settings", Icon(Icons.settings_outlined)),
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

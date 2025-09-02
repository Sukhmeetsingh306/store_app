import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/fonts/google_fonts_utils.dart';
import '../../utils/routes/navigation_routes.dart';
import '../../utils/theme/color/color_theme.dart';
import '../../utils/widget/platform/platform_check.dart';
import 'user_screen/earning_user_seller_screen.dart';
import 'user_screen/upload_user_seller_screen.dart';
import 'user_screen/edit_user_seller_screen.dart';
import 'user_screen/order_user_seller_screen.dart';
import 'user_screen/profile_user_seller_screen.dart';

class UserSellerScreen extends StatefulWidget {
  const UserSellerScreen({super.key});

  static String routeName = '/seller/dashboard';
  static String routePath = '/seller/dashboard';

  @override
  State<UserSellerScreen> createState() => _UserSellerScreenState();
}

class _UserSellerScreenState extends State<UserSellerScreen> {
  int pageIndex = 0;

  late final List<Widget> sellerPages;

  @override
  void initState() {
    super.initState();

    sellerPages = [
      const EarningUserSellerScreen(),
      const UploadUserSellerScreen(),
      const EditUserSellerScreen(),
      const OrderUserSellerScreen(),
      const ProfileUserSellerScreen(),
    ];
  }

  BottomNavigationBarItem bottomBarItem(Icon icon, String label) {
    return BottomNavigationBarItem(icon: icon, label: label);
  }

  void onPageSelected(int index) {
    setState(() {
      pageIndex = index;
    });
    print("🔹 Drawer/BottomNav tapped: Page Index = $pageIndex");
  }

  @override
  Widget build(BuildContext context) {
    bool isWebMobile = kIsWeb && MediaQuery.of(context).size.width > 1026;

    return Scaffold(
      drawer: Drawer(
        width: isWebMobile
            ? MediaQuery.of(context).size.width * 0.2
            : (isWebMobileWeb()
                ? MediaQuery.of(context).size.width * 0.7 // Mobile web
                : MediaQuery.of(context).size.width * 0.5), // Desktop web

        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .18,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradientColors(),
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: googleInterText("Menu",
                      color: Colors.white, fontSize: 28),
                ),
              ),
            ),
            listTile(
              "Earnings",
              const Icon(Icons.monetization_on_outlined),
              onTap: () {
                Navigator.of(context).pop();
                onPageSelected(0);
              },
            ),
            listTile(
              "Upload Products",
              const Icon(Icons.upload_outlined),
              onTap: () {
                Navigator.of(context).pop();
                onPageSelected(1);
              },
            ),
            listTile(
              "Edit Products",
              const Icon(Icons.edit_outlined),
              onTap: () {
                Navigator.of(context).pop();
                onPageSelected(2);
              },
            ),
            listTile(
              "Orders",
              const Icon(Icons.shopping_cart_outlined),
              onTap: () {
                Navigator.of(context).pop();
                onPageSelected(3);
              },
            ),
            listTile(
              "Profile",
              const Icon(Icons.account_circle_outlined),
              onTap: () {
                Navigator.of(context).pop();
                onPageSelected(4);
              },
            ),
            listTile("Logout", Icon(Icons.logout_outlined), onTap: () {
              pop(context);
              Navigator.of(context).popUntil((route) => route.isFirst);
              context.pushReplacement('/loginPage');
            }),
          ],
        ),
      ),
      body: sellerPages[pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: ColorTheme.color.dodgerBlue,
        unselectedItemColor: ColorTheme.color.grayColor,
        onTap: onPageSelected,
        items: [
          bottomBarItem(const Icon(Icons.monetization_on_outlined), 'Earnings'),
          bottomBarItem(const Icon(Icons.upload_outlined), 'Upload'),
          bottomBarItem(const Icon(Icons.edit_outlined), 'Edit'),
          bottomBarItem(const Icon(Icons.shopping_cart_outlined), 'Orders'),
          bottomBarItem(const Icon(Icons.account_circle_outlined), 'Profile'),
        ],
        elevation: 5,
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

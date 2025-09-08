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

  String getPageTitle(int index) {
    switch (index) {
      case 0:
        return "Earnings";
      case 1:
        return "Upload Products";
      case 2:
        return "Edit Products";
      case 3:
        return "Orders";
      case 4:
        return "Profile";
      default:
        return "Management";
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isWeb = kIsWeb; // Running on web
    double width = MediaQuery.of(context).size.width;
    bool isMobilePlatform = defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android;

    bool isLargeScreen = kIsWeb && width <= 1026;

    double calculatedWidth =
        isMobilePlatform || isLargeScreen ? width * 0.5 : width * 0.2;

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        drawer: Drawer(
          backgroundColor: ColorTheme.color.whiteColor,
          width: calculatedWidth,
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
              listTile("Logout", const Icon(Icons.logout_outlined), onTap: () {
                pop(context);
                Navigator.of(context).popUntil((route) => route.isFirst);
                context.pushReplacement('/loginPage');
              }),
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: ColorTheme.color.mediumBlue,
          iconTheme: const IconThemeData(color: Colors.white),
          title: googleInterText(
            getPageTitle(pageIndex),
            color: Colors.white,
            fontSize: 23,
          ),
          centerTitle: false,
          elevation: 5,
          toolbarHeight: 80,
          actions: [
            if (width > 500)
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      color: ColorTheme.color.deepPuceColor,
                      size: 25,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  googleInterText(
                    "Seller",
                    color: Colors.white,
                    fontSize: 20,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
            Padding(
              padding: EdgeInsets.all(isWeb ? 18.0 : 0),
              child: IconButton(
                icon: const Icon(Icons.logout_outlined, color: Colors.white),
                tooltip: "Logout",
                onPressed: () {
                  context.go('/loginPage');
                },
              ),
            ),
          ],
        ),
        body: sellerPages[pageIndex],
        bottomNavigationBar: isWeb
            ? null
            : BottomNavigationBar(
                currentIndex: pageIndex,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: ColorTheme.color.dodgerBlue,
                unselectedItemColor: ColorTheme.color.grayColor,
                onTap: onPageSelected,
                items: [
                  bottomBarItem(
                      const Icon(Icons.monetization_on_outlined), 'Earnings'),
                  bottomBarItem(const Icon(Icons.upload_outlined), 'Upload'),
                  bottomBarItem(const Icon(Icons.edit_outlined), 'Edit'),
                  bottomBarItem(
                      const Icon(Icons.shopping_cart_outlined), 'Orders'),
                  bottomBarItem(
                      const Icon(Icons.account_circle_outlined), 'Profile'),
                ],
                elevation: 5,
              ),
      );
    });
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

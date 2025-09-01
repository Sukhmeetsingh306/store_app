import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_vendor/screen/seller/user_screen/edit_user_seller_screen.dart';
import 'package:multi_vendor/screen/seller/user_screen/order_user_seller_screen.dart';
import 'package:multi_vendor/screen/seller/user_screen/profile_user_seller_screen.dart';
import 'package:multi_vendor/screen/seller/user_screen/upload_user_seller_screen.dart';
import '../../utils/theme/color/color_theme.dart';
import 'user_screen/earning_user_seller_screen.dart';

class UserSellerScreen extends StatefulWidget {
  const UserSellerScreen({super.key});

  static String routeName = '/seller/dashboard';
  static String routePath = '/seller/dashboard';

  @override
  State<UserSellerScreen> createState() => _UserSellerScreenState();
}

class _UserSellerScreenState extends State<UserSellerScreen> {
  int pageIndex = 0;
  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();

    pages = [
      EarningUserSellerScreen(),
      UploadUserSellerScreen(),
      EditUserSellerScreen(),
      OrderUserSellerScreen(),
      ProfileUserSellerScreen(),
    ];
  }

  BottomNavigationBarItem bottomBarItem(Icon icon, String label) {
    return BottomNavigationBarItem(icon: icon, label: label);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageIndex,
        onTap: (val) {
          setState(() {
            pageIndex = val;
          });
        },
        unselectedItemColor: ColorTheme.color.grayColor,
        selectedItemColor: ColorTheme.color.dodgerBlue,
        type: BottomNavigationBarType.fixed,
        items: [
          bottomBarItem(const Icon(CupertinoIcons.money_dollar), 'Earnings'),
          bottomBarItem(const Icon(CupertinoIcons.upload_circle), 'Upload'),
          bottomBarItem(const Icon(Icons.edit), 'Edit'),
          bottomBarItem(const Icon(CupertinoIcons.shopping_cart), 'Orders'),
          bottomBarItem(const Icon(CupertinoIcons.profile_circled), 'Profile'),
        ],
        elevation: 5,
      ),
    );
  }
}

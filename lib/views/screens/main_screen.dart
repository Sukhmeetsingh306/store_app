import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:store_app/components/color/color_theme.dart';
import 'package:store_app/components/text/googleFonts.dart';
import 'package:store_app/models/image_model.dart';
import 'package:flutter/foundation.dart';

import './navigation/account__navigation_screen.dart';
import './navigation/cart_navigation_screen.dart';
import './navigation/fav_navigation_screen.dart';
import './navigation/home_navigation_screen.dart';
import './navigation/store_navigation_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _pageIndex = 0;
  final List<Widget> _pages = [
    HomeNavigationScreen(),
    FavNavigationScreen(),
    StoreNavigationScreen(),
    CartNavigationScreen(),
    AccountNavigationScreen(),
  ];

  // Icon iconBlack(IconData icon) {
  //   return Icon(icon, color: Colors.black);
  // }

  // Widget listTitle(IconData icon, String text) {
  //   return ListTile(
  //     leading: iconBlack(icon),
  //     title: googleText(
  //       text,
  //       fontSize: 15,
  //       fontWeight: FontWeight.w400,
  //     ),
  //     onTap: () {
  //       // Handle item 2 tap
  //     },
  //   );
  // }

  Widget iosDevice() {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _pageIndex,
        selectedItemColor: ColorTheme.color.deepPuceColor,
        selectedFontSize: 14,
        unselectedFontSize: 12,
        unselectedItemColor: ColorTheme.color.grayColor,
        onTap: (value) => setState(
          () {
            _pageIndex = value;
          },
        ),
        items: [
          bottomBarItem(
            Icon(Icons.home_outlined),
            'Home',
          ),
          bottomBarItem(
            Icon(Icons.favorite_border_outlined),
            'Favorite',
          ),
          bottomBarItem(
            Icon(Icons.shopping_bag_outlined),
            'Stores',
          ),
          bottomBarItem(
            Icon(Icons.shopping_cart_outlined),
            'Cart',
          ),
          bottomBarItem(
            Icon(Icons.account_circle_outlined),
            'Account',
          ),
        ],
        elevation: 5,
      ),
      body: _pages[_pageIndex],
    );
  }

  Widget webDevice() {
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

  // return Scaffold(
  //   appBar: AppBar(
  //     backgroundColor: ColorTheme.color.dodgerBlue,
  //     title: googleText("Management"),
  //   ),
  //   drawer: Drawer(
  //     child: ListView(
  //       padding: EdgeInsets.zero,
  //       children: [
  //         SizedBox(
  //           height: MediaQuery.of(context).size.height * 0.082,
  //           child: DrawerHeader(
  //             decoration: BoxDecoration(
  //               color: Colors.blue,
  //             ),
  //             child: Text('Drawer Header'),
  //           ),
  //         ),
  //         listTitle(CupertinoIcons.person_3, 'Vendors'),
  //         listTitle(CupertinoIcons.person, 'Buyers'),
  //         listTitle(Icons.shopping_cart_outlined, 'Orders'),
  //         listTitle(Icons.category_outlined, 'Categories'),
  //         listTitle(Icons.upload, 'Upload Banner'),
  //         listTitle(Icons.shopping_bag_outlined, 'Products'),
  //       ],
  //     ),
  //   ),
  // );
  //}

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return iosDevice();
    } else if (kIsWeb) {
      return webDevice();
    } else {
      // Default case for Android, Windows, etc.
      return Scaffold(
        body: Center(child: Text('Platform not supported')),
      );
    }
  }
}

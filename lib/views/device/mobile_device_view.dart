// mobile_device.dart
import 'package:flutter/material.dart';
import 'package:store_app/components/color/color_theme.dart';

import '../screens/navigation/account__navigation_screen.dart';
import '../screens/navigation/cart_navigation_screen.dart';
import '../screens/navigation/fav_navigation_screen.dart';
import '../screens/navigation/home_navigation_screen.dart';
import '../screens/navigation/store_navigation_screen.dart';

class MobileDevice extends StatefulWidget {
  const MobileDevice({super.key});

  @override
  State<MobileDevice> createState() => _MobileDeviceState();
}

class _MobileDeviceState extends State<MobileDevice> {
  int _mobilePagesIndex = 0;
  final List<Widget> _mobilePages = [
    HomeNavigationScreen(),
    FavNavigationScreen(),
    StoreNavigationScreen(),
    CartNavigationScreen(),
    AccountNavigationScreen(),
  ];

  BottomNavigationBarItem bottomBarItem(Icon icon, String label) {
    return BottomNavigationBarItem(
      icon: icon,
      label: label,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _mobilePagesIndex,
        selectedItemColor: ColorTheme.color.deepPuceColor,
        selectedFontSize: 14,
        unselectedFontSize: 12,
        unselectedItemColor: ColorTheme.color.grayColor,
        onTap: (value) => setState(
          () {
            _mobilePagesIndex = value;
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
      body: _mobilePages[_mobilePagesIndex],
    );
  }
}

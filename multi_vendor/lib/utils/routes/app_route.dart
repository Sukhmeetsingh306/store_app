import 'package:flutter/material.dart';
import 'package:multi_vendor/screen/authentication/register_auth_screen.dart';
import 'package:multi_vendor/screen/user/home_user_screen.dart';

import '../../screen/authentication/login_auth_screen.dart';
import '../../screen/authentication/seller_auth_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/loginPage': (context) => const LoginAuthScreen(),
      '/registerPage': (context) => const RegisterAuthScreen(),
      '/sellerPage': (context) => const SellerAuthScreen(),
      '/homePage': (context) => const HomeUserScreen()
    };
  }
}

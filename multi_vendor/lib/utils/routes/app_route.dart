import 'package:flutter/material.dart';
import 'package:multi_vendor/screen/authentication/register_auth_screen.dart';

import '../../screen/authentication/login_auth_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/loginPage': (context) => const LoginAuthScreen(),
      '/registerPage': (context) => const RegisterAuthScreen(),
    };
  }
}

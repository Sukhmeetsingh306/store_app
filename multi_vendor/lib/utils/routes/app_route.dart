import 'package:flutter/material.dart';

import '../../screen/authentication/login_auth_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/loginPage': (context) => const LoginAuthScreen(),
    };
  }
}

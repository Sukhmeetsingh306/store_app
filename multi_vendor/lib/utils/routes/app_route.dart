import 'package:flow/screen/main/deposit_main_screen.dart';
import 'package:flutter/material.dart';

import '../../screen/authentication/forget_password_auth_screen.dart';
import '../../screen/authentication/login_auth_screen.dart';
import '../../screen/authentication/register_auth_screen.dart';
import '../../screen/main/dashboard_main_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/loginPage': (context) => const LoginAuthScreen(),
      '/registerPage': (context) => const RegisterAuthScreen(),
      '/forgetPage': (context) => const ForgetPasswordAuthScreen(),
      '/dashboardPage': (context) => const DashboardMainScreen(),
      '/depositPage': (context) => const DepositMainScreen(),
      // '/registerDetailPage': (context) => RegisterDetailAuthScreen(),
    };
  }
}

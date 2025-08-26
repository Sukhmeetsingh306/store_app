import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_vendor/provider/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/login_user_models.dart';

class SplashScreenRoute extends ConsumerStatefulWidget {
  const SplashScreenRoute({super.key});

  @override
  ConsumerState<SplashScreenRoute> createState() => _SplashScreenRouteState();
}

class _SplashScreenRouteState extends ConsumerState<SplashScreenRoute> {
  @override
  void initState() {
    super.initState();
    _checkAuthTokenAndNavigate();
  }

  Future<void> _checkAuthTokenAndNavigate() async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('auth_token');
    final userJson = pref.getString('user');

    if (!mounted) return;

    if (token != null && userJson != null) {
      // Parse saved user JSON into model
      final user = LoginUserModel.fromJson(userJson);

      // Save in provider
      ref.read(userProvider.notifier).updateUser(user);

      // Navigate based on role
      if (user.roles.contains("seller")) {
        context.go('/management'); // Seller dashboard
      } else if (user.roles.contains("admin")) {
        context.go('/adminDashboard'); // Future use
      } else {
        context.go('/homePage'); // Default consumer dashboard
      }
    } else {
      // No token/user → logout
      ref.read(userProvider.notifier).signOut();
      if (context.mounted) {
        context.go('/loginPage');
      }
    }

    // MARK: check for the signout way that if the user is had entered check for the cookie if already entered check for the data else navigate to login page else stay in the home page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(5),
          ),
          child: const Center(child: CircularProgressIndicator())),
    );
  }
}

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
      if (user.roles.contains("admin")) {
        context.go('/management'); // Admin dashboard
      } else if (user.roles.contains("seller")) {
        context.go('/seller/dashboard'); // Seller dashboard
      } else if (user.roles.contains("consumer")) {
        context.go('/homePage'); // Consumer homepage
      } else {
        // Fallback for unknown role
        ref.read(userProvider.notifier).signOut();
        context.go('/loginPage');
      }
    } else {
      // No token/user → logout
      ref.read(userProvider.notifier).signOut();
      if (context.mounted) {
        context.go('/loginPage');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black.withAlpha(5),
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

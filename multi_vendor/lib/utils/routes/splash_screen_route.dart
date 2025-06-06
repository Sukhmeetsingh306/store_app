import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_vendor/provider/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? token = pref.getString('auth_token');
    String? userJson = pref.getString('user');

    if (!mounted) return;
    if (token != null && userJson != null) {
      ref.read(userProvider.notifier).setUser(userJson);
      context.go('/homePage');
    } else {
      context.go('/loginPage');
    }
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

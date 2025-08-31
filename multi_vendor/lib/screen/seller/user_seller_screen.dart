import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UserSellerScreen extends StatelessWidget {
  const UserSellerScreen({super.key});

  static String routeName = '/seller/dashboard';
  static String routePath = '/seller/dashboard';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          children: [
            ElevatedButton(
                onPressed: () => context.go('/loginPage'),
                child: const Text('logout ')),
            const Text('seller mobile interface'),
          ],
        ),
      ),
    );
  }
}

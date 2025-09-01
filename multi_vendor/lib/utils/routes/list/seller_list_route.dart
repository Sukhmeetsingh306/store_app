import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../provider/user_provider.dart';
import '../../fonts/google_fonts_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/login_user_models.dart';

class SellerListTile extends ConsumerWidget {
  const SellerListTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.store_outlined),
      title: googleInterText(
        'Seller',
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      onTap: () async {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          // Show loading spinner
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          );

          // Simulate API call / delay
          await Future.delayed(const Duration(seconds: 3));

          if (!context.mounted) return;

          // Remove loading
          Navigator.of(context, rootNavigator: true).pop();

          // 🔹 Load user from SharedPreferences
          final pref = await SharedPreferences.getInstance();
          final userJson = pref.getString('user');

          if (!context.mounted) return;
          if (userJson == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("User not logged in")),
            );
            return;
          }

          final user = LoginUserModel.fromJson(userJson);

          // 🔹 Role-based navigation using primaryRole
          switch (user.primaryRole) {
            case "admin":
              context.go('/management');
              break;
            case "seller":
              context.go('/seller/dashboard');
              break;
            case "consumer":
              context.go('/homePage');
              break;
            default:
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Unauthorized role")),
              );
          }

          // Optional: update Riverpod state if needed
          ref.read(userProvider.notifier).updateUser(user);
        });
      },
    );
  }
}

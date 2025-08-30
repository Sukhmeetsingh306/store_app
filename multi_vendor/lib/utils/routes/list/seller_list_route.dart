import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../provider/user_provider.dart';
import '../../fonts/google_fonts_utils.dart';

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
      onTap: () {
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

          // Role-based navigation using userProvider
          final userNotifier = ref.read(userProvider.notifier);

          if (userNotifier.isAdmin) {
            context.go('/management');
          } else if (userNotifier.isSeller) {
            context.go('/seller/dashboard');
          } else if (userNotifier.isConsumer) {
            context.go('/homePage');
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Unauthorized role")),
            );
          }
        });
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../controllers/seller_controllers.dart';
import '../../../../provider/seller_provider.dart';
import '../../../../utils/widget/form/appTextButton_form.dart';

class SellerLoginButton extends ConsumerStatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final SellerControllers sellerControllers;
  final void Function(bool)? onError;

  const SellerLoginButton({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.sellerControllers,
    this.onError,
  });

  @override
  ConsumerState<SellerLoginButton> createState() => _SellerLoginButtonState();
}

class _SellerLoginButtonState extends ConsumerState<SellerLoginButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AppTextButton(
      buttonText: _isLoading ? 'Logging in...' : 'Login as Seller',
      onPressed: _isLoading
          ? null
          : () async {
              if (!widget.formKey.currentState!.validate()) {
                print("⚠️ Form validation failed");
                return;
              }

              setState(() => _isLoading = true);

              try {
                print("🔹 Attempting seller login from button...");

                bool success = await widget.sellerControllers.signInSeller(
                  email: widget.emailController.text.trim(),
                  password: widget.passwordController.text.trim(),
                  context: context,
                );

                if (!success) {
                  print("❌ Seller login failed");
                  if (widget.onError != null) widget.onError!(true);
                  return;
                }

                // Read seller data from SharedPreferences
                final pref = await SharedPreferences.getInstance();
                final sellerData = pref.getString('sellerData'); // ✅ match key
                print("🔹 SharedPreferences sellerData: $sellerData");

                if (sellerData != null) {
                  ref.read(sellerProvider.notifier).setSeller(sellerData);
                  print("✅ Seller provider updated successfully");
                } else {
                  print("❌ SharedPreferences has no sellerData");
                }
              } catch (e) {
                print("❌ Error in SellerLoginButton: $e");
                if (widget.onError != null) widget.onError!(true);
              } finally {
                if (mounted) setState(() => _isLoading = false);
              }
            },
    );
  }
}

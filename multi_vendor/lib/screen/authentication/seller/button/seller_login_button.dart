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
              if (widget.formKey.currentState!.validate()) {
                setState(() {
                  _isLoading = true;
                });

                try {
                  await widget.sellerControllers.signInSeller(
                    email: widget.emailController.text.trim(),
                    password: widget.passwordController.text.trim(),
                    context: context,
                  );

                  // Update seller state in Riverpod
                  final sellerNotifier = ref.read(sellerProvider.notifier);
                  final pref = await SharedPreferences.getInstance();
                  final sellerData = pref.getString('sellerData');
                  if (sellerData != null) {
                    sellerNotifier.setSeller(sellerData);
                  }

                  final sellerState = ref.read(sellerProvider);
                  final roles = sellerState.roles;
                  if (!context.mounted) return;
                  if (roles.contains('admin')) {
                    context.go('/management');
                  } else if (roles.contains('seller')) {
                    context.go('/seller/dashboard');
                  } else if (roles.contains('consumer')) {
                    context.go('/homePage');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Unauthorized role")),
                    );
                  }
                } catch (e) {
                  if (widget.onError != null) {
                    widget.onError!(true);
                  }
                } finally {
                  if (mounted) {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                }
              }
            },
    );
  }
}

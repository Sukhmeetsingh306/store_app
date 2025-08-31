// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../controllers/login_user_controllers.dart';
import '../../../../provider/user_provider.dart';
import '../../../../utils/widget/form/appTextButton_form.dart';
import '../../../../models/login_user_models.dart';

class UserLoginButton extends ConsumerStatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final LoginUserControllers loginUserControllers;
  final void Function(bool)? onError;

  const UserLoginButton(
      {super.key,
      required this.formKey,
      required this.emailController,
      required this.passwordController,
      required this.loginUserControllers,
      this.onError});

  @override
  ConsumerState<UserLoginButton> createState() => _UserLoginButtonState();
}

class _UserLoginButtonState extends ConsumerState<UserLoginButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AppTextButton(
      buttonText: _isLoading ? 'Logging in...' : 'Login',
      onPressed: _isLoading
          ? null
          : () async {
              if (!widget.formKey.currentState!.validate()) {
                print("⚠️ Form validation failed");
                return;
              }

              setState(() => _isLoading = true);

              try {
                bool isAuthenticated =
                    await widget.loginUserControllers.signInUsers(
                  context: context,
                  email: widget.emailController.text.trim(),
                  password: widget.passwordController.text.trim(),
                );

                if (!isAuthenticated) {
                  print("❌ Invalid credentials or roles");
                  return;
                }

                // Load user from SharedPreferences
                final pref = await SharedPreferences.getInstance();
                final userJson = pref.getString('user');
                if (userJson == null) return;

                final user = LoginUserModel.fromJson(userJson);

                // Update Riverpod state
                ref.read(userProvider.notifier).updateUser(user);

                // Print statements exactly as before
                print("✅ User Details:");
                print("ID: ${user.id}");
                print("Name: ${user.name}");
                print("Email: ${user.email}");
                print("Roles: ${user.roles}");
                print("Primary Role: ${user.primaryRole}");

                // Navigation based on primaryRole
                if (!context.mounted) return;
                switch (user.primaryRole) {
                  case "admin":
                    print("➡️ Redirect to /management");
                    break;
                  case "seller":
                    print("➡️ Redirect to /seller/dashboard");
                    break;
                  case "consumer":
                    print("➡️ Consumer only");
                    break;
                  default:
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Unauthorized role")),
                    );
                }
              } catch (e) {
                print("❌ Error during login: $e");
              } finally {
                if (mounted) setState(() => _isLoading = false);
              }
            },
    );
  }
}

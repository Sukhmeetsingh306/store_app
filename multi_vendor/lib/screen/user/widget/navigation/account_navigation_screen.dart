import 'package:flutter/material.dart';
import 'package:multi_vendor/controllers/login_user_controllers.dart';
import 'package:multi_vendor/utils/widget/button_widget_utils.dart';

class AccountNavigationScreen extends StatelessWidget {
  AccountNavigationScreen({super.key});

  final LoginUserControllers _loginUserController = LoginUserControllers();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: elevatedButton(
          'Sign Out',
          () async {
            await _loginUserController.signOutUser(context);
          },
        ),
      ),
    );
  }
}

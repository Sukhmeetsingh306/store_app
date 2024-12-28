import 'package:flutter/material.dart';
import 'package:store_app/components/color/color_theme.dart';
import 'package:store_app/components/text/textFormField.dart';
import 'package:store_app/models/navigate_models.dart';
import 'package:store_app/views/screens/auth/register_page.dart';

import '../../../components/text/googleFonts.dart';
import '../../../controllers/auth_controllers.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthController _authController = AuthController();
  String email = '';
  String password = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/pencil.jpg'),
            fit: BoxFit.cover,
            opacity: 0.5,
          ),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              googleText('Login Your Account'),
              googleText(
                'To Explore the World Model',
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              Image.asset(
                'assets/images/mail-p.png',
                width: 300,
                height: 300,
              ),
              textFormField(
                onChanged: (value) => setState(() {
                  email = value;
                }),
                "Email",
                'assets/icons/email.png',
                validator: (value) {
                  final regex = RegExp(
                      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
                  if (!regex.hasMatch(value!)) {
                    return 'Invalid email address';
                  }
                  return null;
                },
              ),
              textFormField(
                onChanged: (value) => setState(() {
                  password = value;
                }),
                "Password",
                'assets/icons/password.png',
                obscureText: _obscureText,
                passObscureText: IconButton(
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText; // Toggle visibility
                    });
                  },
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters long';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                height: MediaQuery.of(context).size.height * 0.045,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromRGBO(144, 213, 255, 7),
                ),
                child: InkWell(
                  onTap: () async {
                    // _formKey.currentState?.validate() ?? false
                    //     ? pushAndRemoveUntil(
                    //         context,
                    //         RegisterPage(), // change this when the login is successful
                    //       )
                    //     : null;
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        isLoading = true;
                      });
                      await _authController
                          .signInUsers(
                        context: context,
                        email: email,
                        password: password,
                      )
                          .whenComplete(() {
                        setState(() {
                          isLoading = false;
                        });
                      });
                    }
                  },
                  child: isLoading
                      ? SizedBox(
                          height: 2,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: ColorTheme.color.blackColor,
                          ),
                        )
                      : googleText(
                          'Log In',
                          fontWeight: FontWeight.w400,
                          fontSize: 21,
                        ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  googleText(
                    'Create a New Account?',
                    fontWeight: FontWeight.w300,
                    fontSize: 15,
                  ),
                  TextButton(
                    onPressed: () {
                      materialRouteNavigator(
                        context,
                        RegisterPage(),
                      );
                    },
                    child: googleText(
                      'Sign Up',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

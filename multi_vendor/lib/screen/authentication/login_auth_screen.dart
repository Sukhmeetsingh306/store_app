import 'package:flutter/material.dart';

import '../../utils/fonts/google_fonts_utils.dart';
import '../../utils/fonts/text_fonts_utils.dart';
import '../../utils/validation/password_validations.dart';
import '../../utils/widget/form/appTextButton_form.dart' show AppTextButton;
import '../../utils/widget/form/textForm_form.dart';
import '../../utils/widget/space_widget_utils.dart';

class LoginAuthScreen extends StatefulWidget {
  const LoginAuthScreen({super.key});

  static String routeName = 'loginPage';
  static String routePath = '/loginPage';

  @override
  State<LoginAuthScreen> createState() => _LoginAuthScreenState();
}

class _LoginAuthScreenState extends State<LoginAuthScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscureText = true;
  bool hasMinLength = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  final List<String> emailDomains = [
    'gmail.com',
    'yahoo.com',
    'icloud.com',
    'outlook.com',
  ];
  String selectedDomain = 'gmail.com';

  void _updateEmail() {
    String email = _emailController.text.split('@')[0];
    _emailController.text = '$email@$selectedDomain';
    _emailController.selection = TextSelection.fromPosition(
      TextPosition(offset: email.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 30,
            right: 30,
            bottom: 10,
            top: 5,
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                googleInterText(
                  'Login',
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                ),
                sizedBoxH8(),
                googleInterText(
                  'Login To Continue Using The App',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Center content
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/icons/mobile.png',
                              height: 220,
                            ),
                            sizedBoxH15(),
                            textFormField(
                              _emailController,
                              'Email',
                              (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                } else if (!RegExp(
                                        r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$")
                                    .hasMatch(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                              suffixIcon: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedDomain,
                                  alignment: Alignment.centerRight,
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      setState(() {
                                        selectedDomain = newValue;
                                        _updateEmail();
                                      });
                                    }
                                  },
                                  items: emailDomains
                                      .map<DropdownMenuItem<String>>(
                                          (String domain) {
                                    return DropdownMenuItem<String>(
                                      value: domain,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "@$domain",
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ), // Smaller dropdown icon
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              autofillHints: [AutofillHints.email],
                              onChanged: (value) {
                                _updateEmail();
                              },
                            ),
                            sizedBoxH15(),
                            textFormField(
                              _passwordController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              'Password',
                              (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a password';
                                }
                                if (value.length < 8) {
                                  return 'Password must be at least 8 characters long';
                                }
                                RegExp regex = RegExp(
                                    r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&]).{8,}$');
                                if (!regex.hasMatch(value)) {
                                  return 'Password must contain at least one uppercase letter, one number, and one special character';
                                }
                                return null;
                              },
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureText
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                              obscureText: _obscureText,
                            ),
                          ],
                        ),
                      ),
                      sizedBoxH8(),
                      Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () {
                            // materialRouteNavigator(
                            //   context,
                            //   ForgetPasswordScreen(),
                            // );
                          },
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                textSpan(
                                  'Forget Password?',
                                  fontSize: 14,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      sizedBoxH8(),
                      PasswordValidations(hasMinLength: hasMinLength),
                      sizedBoxH15(),
                      AppTextButton(
                        buttonText: "Login",
                        onPressed: () async {
                          // if (_formKey.currentState!.validate()) {
                          //   bool isAuthenticated =
                          //       await _loginController.loginUser(
                          //     context: context,
                          //     email: _emailController.text,
                          //     password: _passwordController.text,
                          //   );

                          //   if (isAuthenticated) {
                          //     pushAndRemoveUntil(
                          //       context,
                          //       DashboardAccount(),
                          //     );
                          //   }
                          // }
                        },
                      ),
                    ],
                  ),
                ),
                // Bottom Section
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          // materialRouteNavigator(
                          //   context,
                          //   SignUpScreen(),
                          // );
                        },
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              textSpan(
                                'Don\'t Have An Account?',
                                fontSize: 14,
                              ),
                              textSpan(
                                ' Create Account',
                                fontSize: 14,
                                color: const Color.fromRGBO(36, 124, 255, 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Divider(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

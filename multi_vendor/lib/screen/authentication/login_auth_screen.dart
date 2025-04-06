import 'package:flutter/material.dart';
import 'package:multi_vendor/utils/routes/navigation_routes.dart';

import '../../controllers/login_user_controllers.dart';
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

  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LoginUserControllers _loginUserControllers = LoginUserControllers();

  String mail = '';
  String password = "";

  bool isLoading = false;
  bool _obscureText = true;
  bool hasMinLength = false;
  bool hasError = false;

  @override
  void dispose() {
    super.dispose();
    _mailController.dispose();
    _passwordController.dispose();
  }

  final List<String> mailDomains = [
    'gmail.com',
    'yahoo.com',
    'icloud.com',
    'outlook.com',
  ];
  String selectedDomain = 'gmail.com';

  void _updatemail() {
    String mail = _mailController.text.split('@')[0];
    _mailController.text = '$mail@$selectedDomain';
    _mailController.selection = TextSelection.fromPosition(
      TextPosition(offset: mail.length),
    );
  }

  Widget pageCode(bool isLargeScreen) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: isLargeScreen ? 500 : double.infinity,
      ),
      child: Container(
        height: isLargeScreen ? MediaQuery.of(context).size.height * 0.8 : null,
        padding: EdgeInsets.symmetric(
          horizontal: isLargeScreen ? 50 : 0,
          vertical: isLargeScreen ? 50 : 0,
        ),
        decoration: isLargeScreen
            ? BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey, width: 2),
                borderRadius: BorderRadius.circular(20), // Rounded edges
              )
            : null,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
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
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/icons/mobile.png',
                          height: 220,
                        ),
                        sizedBoxH15(),
                        textFormField(
                          _mailController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          'mail',
                          (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your mail';
                            } else if (!RegExp(
                                    r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$")
                                .hasMatch(value)) {
                              return 'Please enter a valid mail';
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
                                    _updatemail();
                                  });
                                }
                              },
                              items: mailDomains.map<DropdownMenuItem<String>>(
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
                            _updatemail();
                          },
                        ),
                        sizedBoxH15(),
                        textFormField(
                          _passwordController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                  SizedBox(
                    height: hasError
                        ? MediaQuery.of(context).size.height * .022
                        : MediaQuery.of(context).size.height * .06,
                  ),
                  AppTextButton(
                    buttonText: "Login",
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        bool isAuthenticated =
                            await _loginUserControllers.signInUsers(
                          context: context,
                          email: _mailController.text,
                          password: _passwordController.text,
                        );

                        if (isAuthenticated) {
                          setState(() {
                            hasError = false; // No error, normal spacing
                          });
                          print('User is validated');
                        } else {
                          setState(() {
                            hasError = true; // Error, increase spacing
                          });
                          print("There is an error");
                        }
                      } else {
                        setState(() {
                          hasError = true; // Error from form validation
                        });
                      }
                    },
                  ),
                ],
              ),
              sizedBoxH8(),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        materialNamedRouteNavigator(context, '/registerPage');
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        bool isLargeScreen = constraints.maxWidth > 900;
        return isLargeScreen
            ? Stack(
                children: [
                  Image.asset(
                    'assets/images/img.png',
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(color: Colors.grey); // fallback color
                    },
                  ),
                  Container(
                    color: Colors.grey[200],
                    child: Center(child: pageCode(isLargeScreen)),
                  ),
                ],
              )
            : SafeArea(
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    child: pageCode(isLargeScreen)));
      }),
    );
  }
}

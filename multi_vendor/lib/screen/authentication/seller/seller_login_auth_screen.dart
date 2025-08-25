import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
//import 'package:multi_vendor/controllers/seller_controllers.dart';

import '../../../controllers/seller_controllers.dart';
import '../../../utils/fonts/google_fonts_utils.dart';
import '../../../utils/fonts/text_fonts_utils.dart';
import '../../../utils/validation/password_validations.dart';
import '../../../utils/widget/animation/seller_widget_utils_animation.dart';
import '../../../utils/widget/form/appTextButton_form.dart' show AppTextButton;
import '../../../utils/widget/form/textForm_form.dart';
import '../../../utils/widget/space_widget_utils.dart';

class SellerLoginAuthScreen extends StatefulWidget {
  const SellerLoginAuthScreen({super.key});

  static String routeName = 'sellerLoginPage';
  static String routePath = '/sellerLoginPage';

  @override
  State<SellerLoginAuthScreen> createState() => _SellerLoginAuthScreenState();
}

class _SellerLoginAuthScreenState extends State<SellerLoginAuthScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final SellerControllers _sellerControllers = SellerControllers();

  String mail = '';
  String password = "";

  bool isLoading = false;
  bool _obscureText = true;
  bool hasMinLength = false;
  bool hasError = false;

  late SellerWidgetUtilsAnimation _animationUtils;

  @override
  void initState() {
    _animationUtils = SellerWidgetUtilsAnimation(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _animationUtils.dispose();
    super.dispose();
  }

  final List<String> mailDomains = [
    'gmail.com',
    'yahoo.com',
    'icloud.com',
    'outlook.com',
  ];
  String selectedDomain = 'gmail.com';

  void _updateMail() {
    String mail = _mailController.text.split('@')[0];
    _mailController.text = '$mail@$selectedDomain';
    _mailController.selection = TextSelection.fromPosition(
      TextPosition(offset: mail.length),
    );
  }

  Widget pageCode(bool isLargeScreen, bool isLargeScreenWeb) {
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
              _animationUtils.buildAnimated(
                type: SellerAnimationType.fadeSlide1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    googleInterText(
                      'Login Vendor',
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                    ),
                    sizedBoxH8(),
                    googleInterText(
                      'Login To Continue Selling Products',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.042,
              ),
              _animationUtils.buildAnimated(
                type: SellerAnimationType.fadeSlide3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _animationUtils.buildAnimated(
                            type: SellerAnimationType.fadeSlideScale2,
                            child: Image.asset(
                              'assets/icons/vendor.jpg',
                              height: 235,
                            ),
                          ),
                          sizedBoxH15(),
                          textFormField(
                            _mailController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            'Vendor Mail',
                            (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your vendor mail';
                              } else if (!RegExp(
                                      r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$")
                                  .hasMatch(value)) {
                                return 'Please enter a valid vendor mail';
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
                                      _updateMail();
                                    });
                                  }
                                },
                                items: mailDomains
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
                              _updateMail();
                            },
                          ),
                          sizedBoxH15(),
                          textFormField(
                            _passwordController,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            'Vendor Password',
                            (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a vendor password';
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
                          : MediaQuery.of(context).size.height * .09,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: AppTextButton(
                            buttonText: "Login as User",
                            onPressed: () async {
                              context.go('/loginPage');
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: AppTextButton(
                            buttonText: "Login",
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                bool isAuthenticated =
                                    await _sellerControllers.signInSeller(
                                  context: context,
                                  email: _mailController.text.trim(),
                                  password: _passwordController.text.trim(),
                                );

                                if (isAuthenticated) {
                                  setState(() {
                                    hasError = false;
                                  });
                                  print('User is validated');
                                  context.go('/management');
                                } else {
                                  setState(() {
                                    hasError = true;
                                  });
                                  print("There is an error");
                                  // Optionally show a snackbar or error message here
                                }
                              } else {
                                setState(() {
                                  hasError = true;
                                });
                                print("Form validation failed");
                                // Optionally show a snackbar or form error message here
                              }
                              // context.go('/management');
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              sizedBoxH8(),
              _animationUtils.buildAnimated(
                type: SellerAnimationType.fadeSlideScale2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          isLargeScreenWeb
                              ? context.go('/sellerPage')
                              : context.push('/sellerPage');
                        },
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              textSpan(
                                'Don\'t Have An Vendor Account?',
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
        bool isLargeScreenWeb = constraints.maxWidth > 450;
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
                    child: Center(
                        child: pageCode(isLargeScreen, isLargeScreenWeb)),
                  ),
                ],
              )
            : SafeArea(
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    child: pageCode(isLargeScreen, isLargeScreenWeb)));
      }),
    );
  }
}

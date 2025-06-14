import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_vendor/screen/authentication/register_detail_auth_screen.dart';
import 'package:multi_vendor/utils/routes/navigation_routes.dart';

import '../../utils/fonts/google_fonts_utils.dart';
import '../../utils/fonts/text_fonts_utils.dart';
import '../../utils/validation/password_validations.dart';
import '../../utils/validation/termsAndConditions_core.dart';
import '../../utils/widget/form/appTextButton_form.dart';
import '../../utils/widget/form/textForm_form.dart';
import '../../utils/widget/space_widget_utils.dart';

class RegisterAuthScreen extends StatefulWidget {
  const RegisterAuthScreen({super.key});

  static String routeName = 'registerPage';
  static String routePath = '/registerPage';

  @override
  State<RegisterAuthScreen> createState() => _RegisterAuthScreenState();
}

class _RegisterAuthScreenState extends State<RegisterAuthScreen>
    with TickerProviderStateMixin {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _otpMailController = TextEditingController();

  late AnimationController _textAnimationController1;
  late Animation<Offset> _slideAnimation1;
  late Animation<double> _fadeAnimation1;

  late AnimationController _controller2;
  late Animation<double> _fadeAnimation2;
  late Animation<Offset> _slideAnimation2;
  late Animation<double> _scaleAnimation2;

  late AnimationController _controller3;
  late Animation<double> _fadeAnimation3;
  late Animation<Offset> _moveAnimation3;

  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  bool _obscureText = true;
  bool _confirmObscureText = true;
  bool hasMinLength = false;
  bool otpSent = false;
  bool otpMailSent = false;
  bool hasError = false;

  final passwordFocusNode = FocusNode();
  final passwordConfirmationFocusNode = FocusNode();

  String? fullPhoneNumber;

  @override
  void initState() {
    super.initState();

    _textAnimationController1 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _slideAnimation1 = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _textAnimationController1,
        curve: Curves.easeOut,
      ),
    );

    _fadeAnimation1 = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _textAnimationController1,
        curve: Curves.easeIn,
      ),
    );

    _textAnimationController1.forward();

    _controller2 = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation2 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller2, curve: Curves.easeInOut),
    );

    _slideAnimation2 = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller2, curve: Curves.easeInOut),
    );

    _scaleAnimation2 = Tween<double>(begin: 1.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller2, curve: Curves.easeInOut),
    );

    Future.delayed(const Duration(milliseconds: 50), () {
      _controller2.forward();
    });

    _controller3 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _fadeAnimation3 = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _textAnimationController1, curve: Curves.easeInOut),
    );

    _moveAnimation3 =
        Tween<Offset>(begin: Offset(0, 0.1), end: Offset(0, 0)).animate(
      CurvedAnimation(
          parent: _textAnimationController1, curve: Curves.easeInOut),
    );

    Future.delayed(const Duration(milliseconds: 50), () {
      _controller3.forward();

      _controller3.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller2.forward();
        }
      });
    });

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0), // starts from bottom
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();
  }

  final List<String> mailDomains = [
    'gmail.com',
    'yahoo.com',
    'icloud.com',
    'outlook.com',
  ];
  String selectedDomain = 'gmail.com'; // Default domain

  void _updateMail() {
    String mail =
        _mailController.text.split('@')[0]; // Keep only the username part
    _mailController.text = '$mail@$selectedDomain';
    _mailController.selection = TextSelection.fromPosition(
      TextPosition(offset: mail.length), // Keep cursor before the '@'
    );
  }

  @override
  void dispose() {
    _mailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _otpMailController.dispose();
    _textAnimationController1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _sendmailOTP() {
    if (_mailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid mail')),
      );
      return;
    }

    setState(() {
      otpMailSent = true;
    });
  }

  void reloadWidget() {
    setState(() {
      _formKey = GlobalKey<FormState>();
    });
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
                  child: pageCode(isLargeScreen),
                ),
              );
      }),
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
        child: isLargeScreen
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    pageInnerCode(isLargeScreen),
                    SizedBox(height: 25),
                    buttonBottomCode(_formKey, context),
                  ],
                ),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: pageInnerCode(isLargeScreen),
                    ),
                  ),
                  buttonBottomCode(_formKey, context),
                ],
              ),
      ),
    );
  }

  Column pageInnerCode(bool isLargeScreen) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center, // Center the form
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SlideTransition(
          position: _slideAnimation1,
          child: FadeTransition(
            opacity: _fadeAnimation1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                googleInterText(
                  'Create Account',
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                ),
                sizedBoxH8(),
                googleInterText(
                  'Sign up now and start exploring all that our\napp has to offer. We\'re excited to welcome\nyou to our community!',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ],
            ),
          ),
        ),
        sizedBoxH8(),
        FadeTransition(
          opacity: _fadeAnimation3,
          child: SlideTransition(
            position: _moveAnimation3,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  sizedBoxH10(),
                  textFormField(
                    _mailController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    'mail',
                    (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your mail';
                      } else if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$")
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
                              _updateMail();
                            });
                          }
                        },
                        items: mailDomains
                            .map<DropdownMenuItem<String>>((String domain) {
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start, // important!
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            textFormField(
                              _otpMailController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              'mail OTP',
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a valid OTP';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        children: [
                          isLargeScreen
                              ? SizedBox(height: hasError ? 8 : 2)
                              : SizedBox(height: hasError ? 14 : 8),
                          AppTextButton(
                            onPressed: _sendmailOTP,
                            buttonText: 'OTP',
                            buttonWidth: 75,
                            buttonHeight: 45,
                            horizontalPadding: 0,
                            verticalPadding: 0,
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (otpMailSent)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: googleInterText(
                        'OTP has been sent to your mail',
                        fontSize: 10,
                      ),
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
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                    obscureText: _obscureText,
                  ),
                  sizedBoxH15(),
                  textFormField(
                    _confirmPasswordController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    'Confirm Password',
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
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    suffixIcon: IconButton(
                      icon: Icon(
                        _confirmObscureText
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _confirmObscureText = !_confirmObscureText;
                        });
                      },
                    ),
                    obscureText: _confirmObscureText,
                  ),
                  sizedBoxH15(),
                  PasswordValidations(hasMinLength: hasMinLength),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buttonBottomCode(GlobalKey<FormState> formKey, BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 20,
          // hasError ? 20 : MediaQuery.of(context).size.height * .11,
        ),
        SlideTransition(
          position: _offsetAnimation,
          child: Column(
            children: [
              Center(child: TermsAndConditionsText()),
              sizedBoxH15(),
              AppTextButton(
                buttonText: "Create Account",
                onPressed: () {
                  materialRouteNavigator(
                    context,
                    RegisterDetailAuthScreen(),
                  );
                },
              ),
            ],
          ),
        ),
        sizedBoxH8(),
        FadeTransition(
          opacity: _fadeAnimation2,
          child: SlideTransition(
            position: _slideAnimation2,
            child: ScaleTransition(
              scale: _scaleAnimation2,
              child: Column(
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        context.go('/loginPage');
                      },
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            textSpan(
                              'Already have an account?',
                              fontSize: 14,
                            ),
                            textSpan(
                              ' Login',
                              fontSize: 14,
                              color: const Color.fromRGBO(36, 124, 255, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  sizedBoxH5(),
                  Divider(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

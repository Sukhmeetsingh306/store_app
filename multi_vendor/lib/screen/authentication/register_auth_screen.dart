import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class _RegisterAuthScreenState extends State<RegisterAuthScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _otpEmailController = TextEditingController();

  bool _obscureText = true;
  bool _confirmObscureText = true;
  bool hasMinLength = false;
  bool otpSent = false;
  bool otpEmailSent = false;
  bool hasError = false;

  final passwordFocusNode = FocusNode();
  final passwordConfirmationFocusNode = FocusNode();

  String? fullPhoneNumber;

  final List<String> emailDomains = [
    'gmail.com',
    'yahoo.com',
    'icloud.com',
    'outlook.com',
  ];
  String selectedDomain = 'gmail.com'; // Default domain

  void _updateEmail() {
    String email =
        _emailController.text.split('@')[0]; // Keep only the username part
    _emailController.text = '$email@$selectedDomain';
    _emailController.selection = TextSelection.fromPosition(
      TextPosition(offset: email.length), // Keep cursor before the '@'
    );
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _otpEmailController.dispose();
  }

  void _sendEmailOTP() {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid Email')),
      );
      return;
    }

    setState(() {
      otpEmailSent = true;
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
                    Divider(),
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
                  Divider(),
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
        sizedBoxH8(),
        Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              sizedBoxH10(),
              textFormField(
                _emailController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                'Email',
                (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  } else if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$")
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
                  _updateEmail();
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start, // important!
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        textFormField(
                          _otpEmailController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          'Email OTP',
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
                        onPressed: _sendEmailOTP,
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
              if (otpEmailSent)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: googleInterText(
                    'OTP has been sent to your Email',
                    fontSize: 10,
                  ),
                ),
              sizedBoxH15(),
              PasswordValidations(hasMinLength: hasMinLength),
            ],
          ),
        ),
      ],
    );
  }
}

Widget buttonBottomCode(GlobalKey<FormState> formKey, BuildContext context) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      SizedBox(
        height: 20,
        // hasError ? 20 : MediaQuery.of(context).size.height * .11,
      ),
      Center(child: TermsAndConditionsText()),
      sizedBoxH15(),
      AppTextButton(
        buttonText: "Create Account",
        onPressed: () async {
          // if (formKey.currentState!.validate()) {
          //   print("Account Created Successfully!");

          materialRouteNavigator(
            context,
            RegisterDetailAuthScreen(),
          );
          //}
        },
      ),
      sizedBoxH8(),
      Center(
        child: GestureDetector(
          onTap: () {
            pushNamedAndRemoveUntil(context, '/loginPage');
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
    ],
  );
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// import '../../controllers/login_user_controllers.dart';
import '../../utils/fonts/google_fonts_utils.dart';
import '../../utils/fonts/text_fonts_utils.dart';
import '../../utils/validation/password_validations.dart';
import '../../utils/widget/form/appTextButton_form.dart' show AppTextButton;
import '../../utils/widget/form/textForm_form.dart';
import '../../utils/widget/space_widget_utils.dart';

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
  //final LoginUserControllers _loginUserControllers = LoginUserControllers();

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

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

  String mail = '';
  String password = "";

  bool isLoading = false;
  bool _obscureText = true;
  bool hasMinLength = false;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();

    _textAnimationController1 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
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
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _moveAnimation3 =
        Tween<Offset>(begin: Offset(0, 0.1), end: Offset(0, 0)).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    Future.delayed(const Duration(milliseconds: 50), () {
      _controller3.forward();

      _controller3.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller2.forward();
        }
      });
    });
  }

  @override
  void dispose() {
    _mailController.dispose();
    _passwordController.dispose();
    _controller.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _textAnimationController1.dispose();
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
              SlideTransition(
                position: _slideAnimation1,
                child: FadeTransition(
                  opacity: _fadeAnimation1,
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
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.042,
              ),
              FadeTransition(
                opacity: _fadeAnimation3,
                child: SlideTransition(
                  position: _moveAnimation3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FadeTransition(
                              opacity: _fadeAnimation,
                              child: SlideTransition(
                                position: _slideAnimation,
                                child: ScaleTransition(
                                  scale: _scaleAnimation,
                                  child: Image.asset(
                                    'assets/icons/vendor.jpg',
                                    height: 235,
                                  ),
                                ),
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
                            : MediaQuery.of(context).size.height * .06,
                      ),
                      AppTextButton(
                        buttonText: "Login as Vendor",
                        onPressed: () async {
                          // if (_formKey.currentState!.validate()) {
                          //   bool isAuthenticated =
                          //       await _loginUserControllers.signInUsers(
                          //     context: context,
                          //     email: _mailController.text,
                          //     password: _passwordController.text,
                          //   );

                          //   if (isAuthenticated) {
                          //     setState(() {
                          //       hasError = false; // No error, normal spacing
                          //     });
                          //     print('User is validated');
                          //   } else {
                          //     setState(() {
                          //       hasError = true; // Error, increase spacing
                          //     });
                          //     print("There is an error");
                          //   }
                          // } else {
                          //   setState(() {
                          //     hasError = true; // Error from form validation
                          //   });
                          // }
                          // pushNamedAndRemoveUntil(context, '/homePage');
                          context.go('/management');
                        },
                      ),
                    ],
                  ),
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
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              context.push('/sellerPage');
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
                                    color:
                                        const Color.fromRGBO(36, 124, 255, 1),
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

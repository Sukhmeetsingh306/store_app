import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../utils/fonts/google_fonts_utils.dart';
import '../../utils/fonts/text_fonts_utils.dart';
import '../../utils/routes/navigation_routes.dart';
import '../../utils/theme/color/color_theme.dart';
import '../../utils/validation/termsAndConditions_core.dart';
import '../../utils/widget/form/appTextButton_form.dart';
import '../../utils/widget/form/textForm_form.dart';
import '../../utils/widget/space_widget_utils.dart';

class SellerAuthScreen extends StatefulWidget {
  const SellerAuthScreen({super.key});

  static const String routeName = '/sellerPage';
  static const String routePath = '/sellerPage';

  @override
  State<SellerAuthScreen> createState() => _SellerAuthScreenState();
}

class _SellerAuthScreenState extends State<SellerAuthScreen>
    with TickerProviderStateMixin {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _otpMailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpPhoneController = TextEditingController();
  final TextEditingController _gstController = TextEditingController();

  int descriptionCharCount = 0;

  String mail = '';

  bool isLargeScreen = false;
  bool hasError = false;
  bool otpMailSent = false;
  bool isLoading = false;
  bool otpPhoneSent = false;

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

  File? _imageFile;
  Uint8List? _webImage;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();

    if (!kIsWeb) {
      if (Platform.isAndroid || Platform.isIOS) {
        var status = await Permission.photos.request(); // Request permission

        if (status.isDenied || status.isPermanentlyDenied) {
          print('Permission denied');
          openAppSettings(); // Open app settings if denied
          return;
        }
      }
    }

    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        // Convert to Uint8List for web
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImage = bytes;
        });
      } else {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    }
  }

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
  String selectedDomain = 'gmail.com';

  void _updateEmail() {
    String mail = _mailController.text.split('@')[0];
    _mailController.text = '$mail@$selectedDomain';
    _mailController.selection = TextSelection.fromPosition(
      TextPosition(offset: mail.length),
    );
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

  void _sendPhoneOTP() {
    if (_phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid Number')),
      );
      return;
    }

    setState(() {
      otpPhoneSent = true;
    });
  }

  @override
  void dispose() {
    _textAnimationController1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _controller.dispose();
    super.dispose();
  }

  void reloadWidget() {
    setState(() {
      _formKey = GlobalKey<FormState>();
    });
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
                  SingleChildScrollView(
                    child: pageInnerCode(isLargeScreen),
                  ),
                  buttonBottomCode(_formKey, context),
                ],
              ),
      ),
    );
  }

  Widget pageInnerCode(bool isLargeScreen) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
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
                  'Seller Account',
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                ),
                sizedBoxH8(),
                googleInterText(
                  'Sign up now and start selling all the product\nyou have to offer. We\'re excited to welcome\nyou to our community!',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ],
            ),
          ),
        ),
        sizedBoxH10(),
        FadeTransition(
          opacity: _fadeAnimation3,
          child: SlideTransition(
            position: _moveAnimation3,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Center(
                    child: CircleAvatar(
                      backgroundColor: ColorTheme.color.whiteColor,
                      radius: 45,
                      backgroundImage: kIsWeb
                          ? (_webImage != null ? MemoryImage(_webImage!) : null)
                          : (_imageFile != null
                              ? FileImage(_imageFile!)
                              : null),
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white24,
                                blurRadius: 10,
                                spreadRadius: 2,
                                offset: Offset(4, 4),
                              ),
                            ],
                          ),
                          child: (_imageFile == null && _webImage == null)
                              ? Image.asset(
                                  "assets/images/logo.png",
                                  height: 60,
                                  width: 60,
                                )
                              : null,
                        ),
                      ),
                    ),
                  ),
                  sizedBoxH8(),
                  googleInterText(
                    'Upload a logo for your business.',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  sizedBoxH15(),
                  textFormField(
                    _companyController,
                    'Company Name',
                    hintText: 'Eg: ABC Pvt Ltd',
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  sizedBoxH15(),
                  textFormField(
                    _descriptionController,
                    'Description',
                    (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Description is required';
                      } else if (value.length < 50) {
                        return 'Minimum 50 characters required';
                      } else if (value.length > 200) {
                        return 'Maximum 200 characters allowed';
                      }
                      return null;
                    },
                    minLines: 2,
                    maxLines: 10,
                    maxLength: 200,
                    keyboardType: TextInputType.multiline,
                    onChanged: (value) {
                      setState(() {
                        descriptionCharCount = value.length;
                      });
                    },
                  ),
                  sizedBoxH10(),
                  textFormField(
                    _mailController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    'Company mail',
                    hintText: 'Eg: abc@gmail.com',
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
                              _updateEmail();
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
                      _updateEmail();
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
                              hintText: 'Eg: 12345',
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              'Company mail OTP',
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
                  FormField<PhoneNumber>(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (phone) {
                      if (_phoneController.text.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                    builder: (state) {
                      return phoneNumber(
                        _phoneController,
                        'Business Number',
                        '1234567890',
                        errorText: state.errorText,
                        onChanged: (phone) {
                          state.didChange(phone);
                        },
                      );
                    },
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start, // important!
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            textFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              _otpPhoneController,
                              'Business Number OTP',
                              hintText: 'Eg: 12345',
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
                            onPressed: _sendPhoneOTP,
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
                  if (otpPhoneSent)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: googleInterText(
                        'OTP has been sent to your Business Number',
                        fontSize: 10,
                      ),
                    ),
                  sizedBoxH15(),
                  textFormField(
                    _gstController,
                    'GST Number (Optional)',
                    hintText: 'Eg: 22AAAAA0000A1Z5',
                    (value) {
                      if (value != null && value.isNotEmpty) {
                        final gstRegex = RegExp(
                            r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$');
                        if (!gstRegex.hasMatch(value)) {
                          return 'Please enter a valid GST number';
                        }
                      }
                      return null;
                    },
                    keyboardType: TextInputType.text,
                    maxLength: 15,
                  ),
                ],
              ),
            ),
          ),
        ),
        sizedBoxH20(),
      ],
    );
  }

  Widget buttonBottomCode(GlobalKey<FormState> formKey, BuildContext context) {
    return Column(
      children: [
        SlideTransition(
          position: _offsetAnimation,
          child: Column(
            children: [
              Center(child: TermsAndConditionsText()),
              sizedBoxH15(),
              AppTextButton(
                buttonText: 'Create Account',
                onPressed: () async {
                  //if (_formKey.currentState!.validate()) {
                  // if (isSeller) {
                  //   Navigator.pushNamed(context, '/sellerPage');
                  // } else {
                  //   Navigator.pushReplacementNamed(context, '/loginPage');
                  // }
                  //}
                },
              ),
            ],
          ),
        ),
        sizedBoxH10(),
        FadeTransition(
          opacity: _fadeAnimation2,
          child: SlideTransition(
            position: _slideAnimation2,
            child: ScaleTransition(
              scale: _scaleAnimation2,
              child: Column(
                children: [
                  InkWell(
                    onTap: () async {
                      if (Navigator.of(context).canPop()) {
                        pop(context);
                      } else {
                        context.go('/registerPage');
                      }
                    },
                    child: Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            textSpan(
                              'Preview Details?',
                              fontSize: 14,
                            ),
                            textSpan(
                              ' Preview',
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
                  padding: EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  child: SingleChildScrollView(
                    child: pageCode(isLargeScreen),
                  ),
                ),
              );
      }),
    );
  }
}


/*
Store Name

Store Description

Business mail

Business Phone

Business Address

GST / Tax ID (Optional)

Upload Logo (Optional)

create a new screen for address for the company

MARK: Add Pan Number as compulsory field
*/
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:multi_vendor/utils/widget/animation/seller_widget_utils_animation.dart';
import 'package:multi_vendor/utils/widget/form/image_picker_form.dart';
import 'package:multi_vendor/utils/widget/form/mail_form.dart';

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

  final ImagePickerForm _imagePickerForm = ImagePickerForm();

  int descriptionCharCount = 0;

  String mail = '';

  bool isLargeScreen = false;
  bool hasError = false;
  bool otpMailSent = false;
  bool isLoading = false;
  bool otpPhoneSent = false;

  late SellerWidgetUtilsAnimation _animationUtils;

  File? _imageFile;
  Uint8List? _webImage;

  void _onImagePicked(File? file, Uint8List? webImage) {
    setState(() {
      _imageFile = file;
      _webImage = webImage;
    });
  }

  @override
  void initState() {
    _animationUtils = SellerWidgetUtilsAnimation(vsync: this);
    super.initState();
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
    _animationUtils.dispose();
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
        _animationUtils.buildAnimated(
          type: SellerAnimationType.fadeSlide1,
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
        sizedBoxH10(),
        _animationUtils.buildAnimated(
          type: SellerAnimationType.fadeSlide3,
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
                        : (_imageFile != null ? FileImage(_imageFile!) : null),
                    child: GestureDetector(
                      onTap: () => _imagePickerForm.pickImage(_onImagePicked),
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
                MailForm(
                  mailController: _mailController,
                  isLargeScreen: isLargeScreen,
                  hasError: hasError,
                  otpMailController: _otpMailController,
                  name: 'Company',
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
              ],
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
        _animationUtils.buildAnimated(
          type: SellerAnimationType.slide,
          child: Column(
            children: [
              Center(child: TermsAndConditionsText()),
              sizedBoxH15(),
              AppTextButton(
                buttonText: 'Create Account',
                onPressed: () async {
                  context.push('/sellerTaxDetailPage');
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
        _animationUtils.buildAnimated(
          type: SellerAnimationType.fadeSlideScale2,
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
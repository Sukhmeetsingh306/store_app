import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
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

class RegisterDetailAuthScreen extends StatefulWidget {
  const RegisterDetailAuthScreen({super.key});

  @override
  State<RegisterDetailAuthScreen> createState() =>
      _RegisterDetailAuthScreenState();
}

class _RegisterDetailAuthScreenState extends State<RegisterDetailAuthScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _otpPhoneController = TextEditingController();

  File? _imageFile;
  Uint8List? _webImage;

  bool isSeller = false;
  bool hasError = false;
  bool otpPhoneSent = false;

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

  Map<String, String>? data;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (data == null) {
      // Extract arguments from ModalRoute safely here
      data = ModalRoute.of(context)?.settings.arguments as Map<String, String>?;
      print(
          "Email: ${data?['email']}"); // Debug to confirm data is passed correctly
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _otpPhoneController.dispose();
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
                    child: Center(child: pageCode(context, isLargeScreen)),
                  ),
                ],
              )
            : SafeArea(
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    child: pageCode(context, isLargeScreen)),
              );
      }),
    );
  }

  Widget pageInnerCode(BuildContext context, bool isLargeScreen) {
    return Column(
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
        sizedBoxH10(),
        Form(
          key: _formKey,
          child: Column(
            children: [
              // Profile Image Upload Section
              Center(
                child: CircleAvatar(
                  backgroundColor: ColorTheme.color.whiteColor,
                  radius: 45,
                  backgroundImage: kIsWeb
                      ? (_webImage != null ? MemoryImage(_webImage!) : null)
                      : (_imageFile != null ? FileImage(_imageFile!) : null),
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
                          ? const Icon(
                              Icons.person_add_alt_1_outlined,
                              size: 50,
                              color: Colors.grey,
                            )
                          : null,
                    ),
                  ),
                ),
              ),
              sizedBoxH8(),
              googleInterText(
                'Upload a photo for us to easily identify you.',
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              sizedBoxH15(),
              textFormField(
                _nameController,
                'Your Name',
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
                _ageController,
                'Your Age',
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your age';
                  }
                  return null;
                },
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
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IntlPhoneField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          labelStyle: GoogleFonts.getFont(
                            'Inter',
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                          hintText: 'Your Number',
                          hintStyle: GoogleFonts.getFont(
                            'Inter',
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 16),
                          errorText: state.errorText,
                        ),
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        initialCountryCode: 'US',
                        dropdownTextStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        dropdownIcon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black,
                        ),
                        onChanged: (phone) {
                          state.didChange(phone);
                        },
                        style: GoogleFonts.getFont(
                          'Inter',
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                    ],
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
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          _otpPhoneController,
                          'Number OTP',
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
                    'OTP has been sent to your Email',
                    fontSize: 10,
                  ),
                ),
              sizedBoxH5(),
              sellerToggle(),
            ],
          ),
        ),
      ],
    );
  }

  Widget sellerToggle() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSeller = !isSeller;
        });
      },
      child: AnimatedScale(
        scale: isSeller ? 1.03 : 1.0,
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 450),
          curve: Curves.easeInOutBack,
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          margin: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSeller ? Colors.blue.withAlpha(8) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSeller ? Colors.blue : Colors.grey,
              width: 1.4,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale: animation,
                  child: child,
                ),
                child: Icon(
                  Icons.storefront,
                  key: ValueKey<bool>(isSeller),
                  color: isSeller ? Colors.blue : Colors.grey,
                  size: isSeller ? 26 : 24,
                ),
              ),
              SizedBox(width: 12),
              AnimatedDefaultTextStyle(
                duration: Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                style: TextStyle(
                  color: isSeller ? Colors.blue : Colors.black,
                  fontSize: 16,
                  fontWeight: isSeller ? FontWeight.w600 : FontWeight.w500,
                ),
                child: googleInterText(
                  'Seller Account',
                  color: isSeller ? Colors.blue : Colors.black,
                  fontSize: 16,
                  fontWeight: isSeller ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget pageCode(BuildContext context, bool isLargeScreen) {
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
                    pageInnerCode(context, isLargeScreen),
                    SizedBox(height: 25),
                    buttonBottomCodeDetail(_formKey, context),
                    Divider(),
                  ],
                ),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: pageInnerCode(context, isLargeScreen),
                    ),
                  ),
                  buttonBottomCodeDetail(_formKey, context),
                  Divider(),
                ],
              ),
      ),
    );
  }

  Widget buttonBottomCodeDetail(
      GlobalKey<FormState> formKey, BuildContext context) {
    return Column(
      children: [
        Center(child: TermsAndConditionsText()),
        sizedBoxH15(),
        AppTextButton(
          buttonText: 'Create Account',
          onPressed: () async {
            //if (_formKey.currentState!.validate()) {
            if (isSeller) {
              Navigator.pushNamed(context, '/sellerPage');
            } else {
              Navigator.pushReplacementNamed(context, '/loginPage');
            }
            //}
          },
        ),
        sizedBoxH10(),
        InkWell(
          onTap: () async {
            if (Navigator.of(context).canPop()) {
              pop(context);
            } else {
              pushNamedAndRemoveUntil(context, '/registerPage');
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
      ],
    );
  }
}

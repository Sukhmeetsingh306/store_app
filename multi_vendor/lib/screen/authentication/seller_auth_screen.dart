import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../utils/fonts/google_fonts_utils.dart';
import '../../utils/theme/color/color_theme.dart';
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

class _SellerAuthScreenState extends State<SellerAuthScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _otpmailController = TextEditingController();

  int descriptionCharCount = 0;

  String mail = '';

  bool isLargeScreen = false;
  bool hasError = false;
  bool otpmailSent = false;
  bool isLoading = false;

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

  void _sendmailOTP() {
    if (_mailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid mail')),
      );
      return;
    }

    setState(() {
      otpmailSent = true;
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
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 15,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
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
                    sizedBoxH10(),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Center(
                            child: CircleAvatar(
                              backgroundColor: ColorTheme.color.whiteColor,
                              radius: 45,
                              backgroundImage: kIsWeb
                                  ? (_webImage != null
                                      ? MemoryImage(_webImage!)
                                      : null)
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
                                  child:
                                      (_imageFile == null && _webImage == null)
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            'Company mail',
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
                              _updatemail();
                            },
                          ),
                          sizedBoxH15(),
                          Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.start, // important!
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    textFormField(
                                      _otpmailController,
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
                          if (otpmailSent)
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: googleInterText(
                                'OTP has been sent to your mail',
                                fontSize: 10,
                              ),
                            ),
                        ],
                      ),
                    ),
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


/*
Store Name

Store Description

Business mail

Business Phone

Business Address

GST / Tax ID (Optional)

Upload Logo (Optional)
*/
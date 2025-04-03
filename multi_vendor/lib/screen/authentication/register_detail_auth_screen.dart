import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
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
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
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
                                      child: (_imageFile == null &&
                                              _webImage == null)
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
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your age';
                                  }
                                  return null;
                                },
                              ),
                              sizedBoxH15(),
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
                                onChanged: (phone) {},
                                validator: (phone) {
                                  if (phone == null || phone.number.isEmpty) {
                                    return 'Please enter your phone number';
                                  }
                                  return null;
                                },
                                style: GoogleFonts.getFont(
                                  'Inter',
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                              ),
                              sizedBoxH15(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Place the button at the bottom
                Column(
                  children: [
                    Center(child: TermsAndConditionsText()),
                    sizedBoxH15(),
                    AppTextButton(
                      buttonText: 'Create Account',
                      onPressed: () async {
                        // Handle create account logic
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
                    Divider(),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}

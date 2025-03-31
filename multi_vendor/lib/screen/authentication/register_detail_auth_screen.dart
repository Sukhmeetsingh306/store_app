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
import '../../utils/routes/navigation_routes.dart';
import '../../utils/theme/color/color_theme.dart';
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
  final TextEditingController _referenceController = TextEditingController();

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
    _referenceController.dispose();
  }

  void reloadWidget() {
    setState(() {
      _formKey = GlobalKey<FormState>();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(15, 25, 0, 0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
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
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 18, 20, 0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Center(
                              child: CircleAvatar(
                                backgroundColor:
                                    ColorTheme.color.backgroundBlack,
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
                                          color: Colors.black26,
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
                                  color: ColorTheme.color.textWhiteColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                                hintText: 'Your Number',
                                hintStyle: GoogleFonts.getFont(
                                  'Inter',
                                  color: ColorTheme.color.textWhiteColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                filled: true,
                                fillColor: Colors
                                    .black, // Background color of the input field
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 16),
                              ),
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              initialCountryCode: 'US',

                              dropdownDecoration: BoxDecoration(
                                color:
                                    Colors.black, // Dropdown background color
                                borderRadius: BorderRadius.circular(8),
                              ),

                              dropdownTextStyle: TextStyle(
                                color: Colors.white, // Dropdown text color
                                fontSize: 16,
                              ),

                              dropdownIcon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white, // Dropdown icon color
                              ),

                              onChanged: (phone) {
                                // print(phone.completeNumber);
                              },

                              validator: (phone) {
                                if (phone == null || phone.number.isEmpty) {
                                  return 'Please enter your phone number';
                                }
                                return null;
                              },

                              // Customize the popup menu using theme
                              style: TextStyle(color: Colors.white),
                            ),
                            sizedBoxH15(),
                          ],
                        ),
                      ),
                    ),
                    sizedBoxH15(),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 5, 20, 0),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 40),
                            child: AppTextButton(
                              buttonText: 'Create Account',
                              onPressed: () async {
                                // if (_formKey.currentState!.validate()) {
                                //   await _registerController.registerUser(
                                //     context: context,
                                //     name: _nameController.text,
                                //     password: widget.password,
                                //     email: widget.email,
                                //   );
                                //   setState(() {
                                //     _formKey.currentState!.reset();
                                //   });

                                //   reloadWidget();
                                //   materialNamedRouteNavigator(
                                //     context,
                                //     '/loginPage',
                                //   );
                                // }
                              },
                            ),
                          ),
                          sizedBoxH10(),
                          Opacity(
                            opacity: 0.9,
                            child: InkWell(
                              onTap: () async {},
                              child: Container(
                                width: MediaQuery.sizeOf(context).width * 0.7,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.7),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.arrow_back_rounded,
                                      color: ColorTheme
                                          .color.buttonBackgroundColor,
                                      size: 24,
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          4, 0, 24, 0),
                                      child: InkWell(
                                        onTap: () async {
                                          if (Navigator.of(context).canPop()) {
                                            pop(context);
                                          } else {
                                            pushNamedAndRemoveUntil(
                                              context,
                                              '/registerPage',
                                            );
                                          }
                                        },
                                        child: googleInterText(
                                          'Preview',
                                          color: ColorTheme
                                              .color.buttonBackgroundColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    googleInterText(
                                      'Preview email detail!',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

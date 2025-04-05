import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../utils/fonts/google_fonts_utils.dart';
import '../../utils/theme/color/color_theme.dart';
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

  int descriptionCharCount = 0;

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
                            minLines: 3,
                            maxLines: 10,
                            maxLength: 200,
                            keyboardType: TextInputType.multiline,
                            onChanged: (value) {
                              setState(() {
                                descriptionCharCount = value.length;
                              });
                            },
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

Business Email

Business Phone

Business Address

GST / Tax ID (Optional)

Upload Logo (Optional)
*/
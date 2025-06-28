import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../utils/fonts/google_fonts_utils.dart';
import '../../../utils/fonts/text_fonts_utils.dart';
import '../../../utils/routes/navigation_routes.dart';
import '../../../utils/validation/termsAndConditions_core.dart';
import '../../../utils/widget/animation/seller_widget_utils_animation.dart';
import '../../../utils/widget/form/appTextButton_form.dart';
import '../../../utils/widget/form/textForm_form.dart';
import '../../../utils/widget/space_widget_utils.dart';

class SellerTaxDetailScreen extends StatefulWidget {
  const SellerTaxDetailScreen({super.key});

  static const String routeName = '/sellerTaxDetailPage';
  static const String routePath = '/sellerTaxDetailPage';

  @override
  State<SellerTaxDetailScreen> createState() => _SellerTaxDetailScreenState();
}

class _SellerTaxDetailScreenState extends State<SellerTaxDetailScreen>
    with TickerProviderStateMixin {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Uint8List? _panCardImage;
  bool _isUploading = false;

  final TextEditingController _panController = TextEditingController();
  final TextEditingController _gstController = TextEditingController();

  late SellerWidgetUtilsAnimation _animationUtils;

  @override
  void initState() {
    _animationUtils = SellerWidgetUtilsAnimation(vsync: this);
    super.initState();
  }

  Future<void> _pickPanImage() async {
    setState(() => _isUploading = true);

    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );

    if (result != null && result.files.first.bytes != null) {
      setState(() {
        _panCardImage = result.files.first.bytes;
      });
    }

    setState(() => _isUploading = false);
  }

  @override
  void dispose() {
    _panController.dispose();
    _gstController.dispose();
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
                    _pageInnerCode(isLargeScreen),
                    SizedBox(height: 25),
                    buttonBottomCode(_formKey, context),
                  ],
                ),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SingleChildScrollView(
                    child: _pageInnerCode(isLargeScreen),
                  ),
                  SizedBox(height: 115),
                  buttonBottomCode(_formKey, context),
                ],
              ),
      ),
    );
  }

  Widget _pageInnerCode(bool isLargeScreen) {
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
                'Seller Tax Details',
                fontWeight: FontWeight.w700,
                fontSize: 24,
              ),
              sizedBoxH8(),
              googleInterText(
                'Please upload your PAN card and GST \ndetails to proceed.',
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ],
          ),
        ),
        SizedBox(height: 30),
        Form(
          key: _formKey,
          //     padding: const EdgeInsets.all(16),
          //     padding: const EdgeInsets.all(16),
          child: _animationUtils.buildAnimated(
            type: SellerAnimationType.fadeSlide3,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: _pickPanImage,
                    child: Container(
                      height: 170,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        border: Border.all(color: Colors.grey, width: 2),
                        borderRadius: BorderRadius.circular(
                            12), // Rectangular with rounded corners
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: _panCardImage != null
                                ? Image.memory(
                                    _panCardImage!,
                                    fit: BoxFit
                                        .cover, // Adjusts image to fit nicely
                                  )
                                : Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.upload_file,
                                            size: 32, color: Colors.grey),
                                        SizedBox(height: 8),
                                        Text(
                                          'Upload PAN',
                                          style: TextStyle(
                                              fontSize: 14, color: Colors.grey),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                          if (_isUploading)
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withAlpha(3),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                  child: CircularProgressIndicator()),
                            ),
                        ],
                      ),
                    ),
                  ),
                  sizedBoxH8(),
                  googleInterText(
                    'Upload PAN for your business.',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  sizedBoxH20(),
                  textFormField(
                    _panController,
                    'PAN Number',
                    hintText: 'Eg: ABCDE1234F',
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your PAN number';
                      } else if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$')
                          .hasMatch(value)) {
                        return 'Enter a valid PAN (e.g. ABCDE1234F)';
                      }
                      return null;
                    },
                    onChanged: (val) {
                      _panController.value = _panController.value.copyWith(
                        text: val.toUpperCase(),
                        selection: TextSelection.collapsed(offset: val.length),
                      );
                    },
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
                  sizedBoxH20(),
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
      children: [
        _animationUtils.buildAnimated(
          type: SellerAnimationType.fadeSlide3,
          child: Column(
            children: [
              Center(child: TermsAndConditionsText()),
              sizedBoxH15(),
              AppTextButton(
                buttonText: 'Create Account',
                onPressed: () async {
                  //context.push('/sellerTaxDetailPage');
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
                    context.go('/sellerPage');
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

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../controllers/category_controllers.dart';
import '../../../utils/fonts/google_fonts_utils.dart';
import '../../../utils/widget/button_widget_utils.dart';
import '../../../utils/widget/space_widget_utils.dart';
import '../../../utils/widget/web/web_input_image.dart';
import '../../user/widget/support/category_widget_support_user.dart';

class CategorySideScreen extends StatefulWidget {
  static const String routeName = '/categoryScreen';
  const CategorySideScreen({super.key});

  @override
  State<CategorySideScreen> createState() => _CategorySideScreenState();
}

class _CategorySideScreenState extends State<CategorySideScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final CategoryControllers _categoryController = CategoryControllers();

  late String categoryName;

  dynamic _categoryImage;
  dynamic _bannerImage;

  bool _isLoading = false;
  bool _isSnackBarVisible = false;

  Future<dynamic> simulateImageUpload() async {
    await Future.delayed(Duration(seconds: 2));
  }

  Future<void> uploadImage(ValueSetter<dynamic> updateImage) async {
    FilePickerResult? fileImage = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (fileImage != null) {
      setState(() {
        updateImage(fileImage
            .files.first.bytes); // Use the callback to update the image
        print('Image uploaded');
      });
    }
  }

  Widget uploadButton(ValueSetter<dynamic> image) {
    return elevatedButton(
      'Upload Image',
      () {
        uploadImage(image);
      },
    );
  }

  void reloadWidget() {
    setState(() {
      _formKey = GlobalKey<FormState>();
    });
  }

  @override
  Widget build(BuildContext context) {
    double mediaQueryWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 4,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: googleInterText(
                        'Category',
                        fontSize: 36,
                      ),
                    ),
                  ),
                  divider(),
                  Row(
                    children: [
                      webImageInput(
                        _categoryImage,
                        'Category Image',
                        context,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: !isWebMobile(context)
                              ? mediaQueryWidth * 0.6
                              : mediaQueryWidth * 0.15,
                          child: TextFormField(
                            onChanged: (value) {
                              categoryName = value;
                            },
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.length <= 3) {
                                return 'Please Enter Valid Category Name';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Enter Category Name',
                            ),
                          ),
                        ),
                      ),
                      if (isWebMobile(context)) ...[
                        sizedBoxMediaQuery(context, width: 0.023, height: 0),
                        cancelButton(),
                        const SizedBox(width: 8),
                        submitButton(),
                      ],
                    ],
                  ),
                  // Responsive section for mobile or small screens
                  if (!isWebMobile(context))
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          uploadButton(
                            (image) {
                              _categoryImage = image;
                            },
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(child: cancelButton()),
                              const SizedBox(width: 8),
                              Expanded(child: submitButton()),
                            ],
                          ),
                        ],
                      ),
                    ),
                  sizedBoxMediaQuery(
                    context,
                    width: 0,
                    height: 0.02,
                  ),
                  if (isWebMobile(context))
                    uploadButton(
                      (image) {
                        _categoryImage = image;
                      },
                    ),
                  divider(),
                  webImageInput(
                    _bannerImage,
                    'Banner Image',
                    context,
                  ),
                  sizedBoxMediaQuery(
                    context,
                    width: 0,
                    height: 0.02,
                  ),
                  if (!isWebMobile(context))
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          uploadButton(
                            (image) {
                              _bannerImage = image;
                            },
                          ),
                        ],
                      ),
                    ),
                  if (isWebMobile(context))
                    uploadButton(
                      (image) {
                        _bannerImage = image;
                      },
                    ),
                  divider(),
                  CategoryWidgetSupportUser(),
                ],
              ),
            ),
          ),
        ),
        if (_isLoading)
          Positioned.fill(
            child: Stack(
              children: [
                ModalBarrier(
                  dismissible: false,
                  color: Colors.black.withValues(alpha: .5),
                ),
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget cancelButton() {
    return TextButton(
      onPressed: () {},
      child: webButtonGoogleText(
        'Cancel',
      ),
    );
  }

  Widget submitButton() {
    return elevatedButton(
      "Submit",
      () async {
        setState(() {
          _isLoading = true;
        });
        if (_bannerImage == null || _categoryImage == null) {
          if (!_isSnackBarVisible) {
            _isSnackBarVisible = true;
            ScaffoldMessenger.of(context)
                .showSnackBar(
                  SnackBar(
                    content: Text('Please add an image'),
                    duration: Duration(seconds: 2),
                  ),
                )
                .closed
                .then((_) {
              _isSnackBarVisible = false;
            });
          }
          setState(() {
            _isLoading = false;
          });
          return;
        }
        if (_formKey.currentState!.validate()) {
          print(categoryName);
          _categoryController.uploadCategory(
            pickedImage: _categoryImage,
            pickedBanner: _bannerImage,
            categoryName: categoryName,
            context: context,
          );

          dynamic newImage = await simulateImageUpload();
          setState(() {
            _categoryImage = newImage;
            _bannerImage = newImage;
            _isLoading = false;
          });

          reloadWidget(); // Only called when validation passes
        } else {
          setState(() {
            _isLoading = false; // Reset loading if validation fails
          });
        }
      },
    );
  }
}

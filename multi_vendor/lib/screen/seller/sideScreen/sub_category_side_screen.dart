// ignore_for_file: file_names

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../controllers/subCategory_controllers.dart';
import '../../../models/api/category_api_models.dart';
import '../../web/sub_category_drop_down.dart';
import '../../../utils/fonts/google_fonts_utils.dart';
import '../../../utils/widget/button_widget_utils.dart';
import '../../../utils/widget/space_widget_utils.dart';
import '../../../utils/widget/web/web_input_image.dart';
import '../../user/widget/support/sub_category_support_user.dart';

class SubCategorySideScreen extends StatefulWidget {
  static const String routeName = '/subCategoryScreen';

  const SubCategorySideScreen({super.key});

  @override
  State<SubCategorySideScreen> createState() => _SubCategorySideScreenState();
}

class _SubCategorySideScreenState extends State<SubCategorySideScreen> {
  final SubCategoryControllers subCategoryController = SubCategoryControllers();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String subCategoryName;

  CategoryApiModels? selectedCategory;

  dynamic _categoryImage;

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
        updateImage(fileImage.files.first.bytes);
        print('Image uploaded');
      });
    }
  }

  void reloadWidget() {
    setState(() {
      _formKey = GlobalKey<FormState>();
    });
  }

  @override
  Widget build(BuildContext context) {
    double mediaQueryWidth = MediaQuery.of(context).size.width;
    bool isWebMobile = kIsWeb && mediaQueryWidth > 1026;

    return Stack(
      children: [
        Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: googleInterText('Category', fontSize: 36),
                    ),
                  ),
                  divider(),
                  SubCategoryDropDownWidget(
                    onCategorySelected: (category) {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                  ),
                  sizedBoxMediaQuery(context, width: 0, height: 0.01),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                              width: !isWebMobile
                                  ? mediaQueryWidth * 0.6
                                  : mediaQueryWidth * 0.15,
                              child: TextFormField(
                                onChanged: (value) {
                                  subCategoryName = value;
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
                          if (isWebMobile) ...[
                            sizedBoxMediaQuery(context,
                                width: 0.023, height: 0),
                            cancelButton(),
                            const SizedBox(width: 8),
                            submitButton(),
                          ],
                        ],
                      ),

                      // Responsive section for mobile or small screens
                      if (!isWebMobile)
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              elevatedButton(
                                "Upload Image",
                                () {
                                  uploadImage((img) {
                                    setState(() {
                                      _categoryImage = img;
                                    });
                                  });
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
                    ],
                  ),
                  sizedBoxMediaQuery(context, width: 0, height: 0.02),
                  if (isWebMobile)
                    elevatedButton(
                      "Upload Image",
                      () {
                        uploadImage((img) {
                          setState(() {
                            _categoryImage = img;
                          });
                        });
                      },
                    ),
                  divider(),
                  SubCategorySupportUser(),
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
                  color: Colors.black.withOpacity(0.5),
                ),
                const Center(
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
      child: webButtonGoogleText('Cancel'),
    );
  }

  Widget submitButton() {
    return elevatedButton(
      "Submit",
      () async {
        setState(() {
          _isLoading = true;
        });

        if (_categoryImage == null) {
          if (!_isSnackBarVisible) {
            _isSnackBarVisible = true;
            ScaffoldMessenger.of(context)
                .showSnackBar(
                  const SnackBar(
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

        if (selectedCategory == null) {
          if (!_isSnackBarVisible) {
            _isSnackBarVisible = true;
            ScaffoldMessenger.of(context)
                .showSnackBar(
                  const SnackBar(
                    content: Text('Please select a category'),
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
          await subCategoryController.uploadSubCategory(
            categoryId: selectedCategory!.categoryId,
            categoryName: selectedCategory!.categoryName,
            subCategoryName: subCategoryName,
            subCategoryPickedImage: _categoryImage,
            context: context,
          );

          dynamic newImage = await simulateImageUpload();
          setState(() {
            _formKey.currentState!.reset();
            _categoryImage = newImage;
            _isLoading = false;
          });

          reloadWidget();
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      },
    );
  }
}

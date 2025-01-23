// ignore_for_file: file_names

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:store_app/controllers/subCategory_controllers.dart';
import 'package:store_app/views/screens/navigation_web/widget/dropDown_widget.dart/subCategory_dropDown_widget.dart';
import 'package:store_app/views/screens/navigation_web/widget/subCategory_widget.dart';

import '../../../components/code/button_code.dart';
import '../../../components/code/divider_code.dart';
import '../../../components/code/sized_space_code.dart';
import '../../../components/code/text/googleFonts.dart';
import '../../../components/code/webImageInput_code.dart';
import '../../../models/api/category_api_models.dart';

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
        updateImage(fileImage
            .files.first.bytes); // Use the callback to update the image
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
                      child: googleText(
                        'Category',
                        fontSize: 36,
                      ),
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
                  sizedBoxMediaQuery(
                    context,
                    width: 0,
                    height: 0.01,
                  ),
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
                          width: mediaQueryWidth * 0.15,
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
                            decoration: InputDecoration(
                              labelText: 'Enter Category Name',
                            ),
                          ),
                        ),
                      ),
                      sizedBoxMediaQuery(
                        context,
                        width: 0.023,
                        height: 0,
                      ),
                      TextButton(
                        onPressed: () {},
                        child: webButtonGoogleText(
                          'Cancel',
                        ),
                      ),
                      elevatedButton(
                        () async {
                          setState(() {
                            _isLoading = true;
                          });

                          if (_categoryImage == null) {
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

                          if (selectedCategory == null) {
                            if (!_isSnackBarVisible) {
                              _isSnackBarVisible = true;
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                    SnackBar(
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

                            reloadWidget(); // Only called when validation passes
                          } else {
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        },
                        "Submit",
                      ),
                    ],
                  ),
                  sizedBoxMediaQuery(
                    context,
                    width: 0,
                    height: 0.02,
                  ),
                  elevatedButton(
                    () {
                      uploadImage(
                        (img) {
                          setState(() {
                            _categoryImage = img;
                          });
                        },
                      );
                    },
                    "Upload Image",
                  ),
                  divider(),
                  SubCategoryWidget(),
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
}

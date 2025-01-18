import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:store_app/components/code/text/googleFonts.dart';
import 'package:store_app/components/code/webImageInput_code.dart';
import 'package:store_app/views/screens/navigation_web/widget/category_widget.dart';

import '../../../components/code/button_code.dart';
import '../../../components/code/divider_code.dart';
import '../../../components/code/sized_space_code.dart';
import '../../../controllers/category_controllers.dart';

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

  Widget elevatedButtonCategory(ValueSetter<dynamic> image) {
    return elevatedButton(
      () {
        uploadImage(image);
      },
      'Upload Image',
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
                      child: googleText(
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
                          width: mediaQueryWidth * 0.15,
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
                                _isSnackBarVisible =
                                    false;
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
                              _isLoading =
                                  false; // Reset loading if validation fails
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
                  elevatedButtonCategory(
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
                  elevatedButtonCategory(
                    (image) {
                      _bannerImage = image;
                    },
                  ),
                  divider(),
                  CategoryWidget(),
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

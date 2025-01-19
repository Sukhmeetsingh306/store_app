import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../components/code/button_code.dart';
import '../../../components/code/divider_code.dart';
import '../../../components/code/sized_space_code.dart';
import '../../../components/code/text/googleFonts.dart';
import '../../../components/code/webImageInput_code.dart';
import '../../../controllers/category_controllers.dart';
import '../../../models/api/category_api_models.dart';

class SubCategorySideScreen extends StatefulWidget {
  static const String routeName = '/subCategoryScreen';

  const SubCategorySideScreen({super.key});

  @override
  State<SubCategorySideScreen> createState() => _SubCategorySideScreenState();
}

class _SubCategorySideScreenState extends State<SubCategorySideScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late Future<List<CategoryApiModels>> futureSubCategory;

  CategoryApiModels? selectedCategory;

  late String categoryName;

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

  @override
  void initState() {
    super.initState();
    futureSubCategory = CategoryControllers().fetchCategory();
  }

  void reloadWidget() {
    setState(() {
      _formKey = GlobalKey<FormState>();
    });
  }

  @override
  Widget build(BuildContext context) {
    double mediaQueryWidth = MediaQuery.of(context).size.width;

    return Form(
      key: _formKey,
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
                  'Subcategory',
                  fontSize: 36,
                ),
              ),
            ),
            divider(),
            FutureBuilder(
              future: futureSubCategory,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return errormessage("Error: ${snapshot.error}");
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: googleText(
                      "No Category found",
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                    ),
                  );
                } else {
                  return DropdownButton<CategoryApiModels>(
                      hint: googleText(
                        "Select Category",
                        fontWeight: FontWeight.normal,
                        fontSize: 18,
                      ),
                      items: snapshot.data!.map((CategoryApiModels category) {
                        return DropdownMenuItem<CategoryApiModels>(
                          value: category,
                          child: googleText(
                            category.categoryName,
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                        });
                        print(selectedCategory);
                      });
                }
              },
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
                    if (_formKey.currentState!.validate()) {

                      // dynamic newImage = await simulateImageUpload();
                      // setState(() {
                      //   _categoryImage = newImage;
                      //   _bannerImage = newImage;
                      //   _isLoading = false;
                      // });

                      reloadWidget(); // Only called when validation passes
                    } else {
                      setState(() {
                        _isLoading = false; // Reset loading if validation fails
                      });
                    }
                  },
                  "Submit",
                ),
              ],
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
        ),
      ),
    );
  }
}

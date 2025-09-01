import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_vendor/utils/widget/button_widget_utils.dart';
import 'package:multi_vendor/utils/widget/form/textForm_form.dart';
import 'package:multi_vendor/utils/widget/space_widget_utils.dart';

import '../../../controllers/category_controllers.dart';
import '../../../controllers/subCategory_controllers.dart';
import '../../../models/api/category_api_models.dart';
import '../../../models/api/subcategory_api_models.dart';
import '../../../utils/fonts/google_fonts_utils.dart';

class UploadUserSellerScreen extends StatefulWidget {
  const UploadUserSellerScreen({super.key});

  @override
  State<UploadUserSellerScreen> createState() => _UploadUserSellerScreenState();
}

class _UploadUserSellerScreenState extends State<UploadUserSellerScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _productController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  List<XFile>? imageFileList = [];

  late Future<List<CategoryApiModels>> futureCategory;
  late Future<List<SubCategoryApiModels>> futureSubCategory;

  CategoryApiModels? _selectedCategory;
  SubCategoryApiModels? _selectedSubCategory;

  @override
  void initState() {
    super.initState();
    futureCategory = CategoryControllers().fetchCategory();
    futureSubCategory =
        SubCategoryControllers().fetchSubCategories(); // default load
  }

  getSubcategoryByCategory(val) {
    setState(() {
      futureSubCategory =
          SubCategoryControllers().getSubCategoryByCategoryName(val.name);
      _selectedSubCategory = null;
    });
  }

  // chooseImage() async {
  //   final pickedImage = await _picker.pickImage(source: ImageSource.gallery);

  //   if (pickedImage == null) {
  //     print('No image selected');
  //   } else {
  //     setState(() {
  //       imageFileList!.add(pickedImage);
  //     });
  //   }
  // }

  Future<void> chooseImage() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedImage =
                      await _picker.pickImage(source: ImageSource.camera);
                  if (pickedImage != null) {
                    setState(() {
                      imageFileList!.add(pickedImage);
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedImage =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (pickedImage != null) {
                    setState(() {
                      imageFileList!.add(pickedImage);
                    });
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.attach_file),
                title: const Text('Files'),
                onTap: () async {
                  Navigator.pop(context);
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    allowMultiple: false,
                    type: FileType
                        .any, // you can restrict to FileType.image, pdf, etc.
                  );
                  if (result != null && result.files.single.path != null) {
                    File file = File(result.files.single.path!);
                    // Not an XFile, but you can handle separately
                    setState(() {
                      imageFileList!.add(XFile(file.path));
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            GridView.builder(
              shrinkWrap: true,
              itemCount: imageFileList!.length + 1,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
                childAspectRatio: 1.0,
              ),
              itemBuilder: (context, index) {
                return index == 0
                    ? Center(
                        child: IconButton(
                          icon: const Icon(Icons.add_a_photo),
                          onPressed: chooseImage,
                        ),
                      )
                    : SizedBox(
                        width: 50,
                        height: 50,
                        child: Image.file(
                          File(imageFileList![index - 1].path),
                          fit: BoxFit.cover,
                        ),
                      );
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textFormField(
                    _productController,
                    'Product Name',
                    (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter product name';
                      }
                      return null;
                    },
                  ),
                  sizedBoxH15(),
                  Row(
                    children: [
                      // Category Dropdown
                      Expanded(
                        child: FutureBuilder(
                          future: futureCategory,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return errormessage("Error: ${snapshot.error}");
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return Center(
                                child: googleInterText(
                                  "No Category found",
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18,
                                ),
                              );
                            } else {
                              return DropdownButtonFormField<CategoryApiModels>(
                                initialValue: _selectedCategory,
                                decoration: InputDecoration(
                                  labelText: 'Category',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                items: snapshot.data!
                                    .map((CategoryApiModels category) {
                                  return DropdownMenuItem<CategoryApiModels>(
                                    value: category,
                                    child: Text(category.categoryName),
                                  );
                                }).toList(),
                                onChanged: (CategoryApiModels? newValue) {
                                  setState(() {
                                    _selectedCategory = newValue;
                                    _selectedSubCategory = null;
                                    futureSubCategory = SubCategoryControllers()
                                        .getSubCategoryByCategoryName(
                                            newValue!.categoryName);
                                  });
                                },
                                validator: (value) => value == null
                                    ? 'Please select a category'
                                    : null,
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _selectedCategory == null
                            ? InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Sub-Category',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 16),
                                ),
                                child: googleInterText(
                                  "No Sub-Category",
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                ),
                              )
                            : FutureBuilder(
                                future: futureSubCategory,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return errormessage(
                                        "Error: ${snapshot.error}");
                                  } else if (!snapshot.hasData ||
                                      snapshot.data!.isEmpty) {
                                    return InputDecorator(
                                      decoration: InputDecoration(
                                        labelText: 'Sub-Category',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 16),
                                      ),
                                      child: googleInterText(
                                        "No Sub-Category",
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16,
                                      ),
                                    );
                                  } else {
                                    return DropdownButtonFormField<
                                        SubCategoryApiModels>(
                                      initialValue: _selectedSubCategory,
                                      decoration: InputDecoration(
                                        labelText: 'Sub-Category',
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                      ),
                                      items: snapshot.data!.map(
                                          (SubCategoryApiModels subcategory) {
                                        return DropdownMenuItem<
                                            SubCategoryApiModels>(
                                          value: subcategory,
                                          child:
                                              Text(subcategory.subCategoryName),
                                        );
                                      }).toList(),
                                      onChanged:
                                          (SubCategoryApiModels? newValue) {
                                        setState(() {
                                          _selectedSubCategory = newValue;
                                        });
                                      },
                                      validator: (value) => value == null
                                          ? 'Please select a sub-category'
                                          : null,
                                    );
                                  }
                                },
                              ),
                      ),
                    ],
                  ),
                  sizedBoxH15(),
                  Row(
                    children: [
                      Expanded(
                        child: textFormField(
                          _quantityController,
                          'Product Quantity',
                          (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter product quantity';
                            }
                            if (int.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: textFormField(
                          _priceController,
                          'Price Per Unit',
                          (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter price per unit';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
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
                        //descriptionCharCount = value.length;
                      });
                    },
                  ),
                ],
              ),
            ),
            elevatedButton('Upload Product', () {
              if (_formKey.currentState!.validate()) {
                print("Form is valid, proceed with upload");
              } else {
                print("Form is invalid, please correct the errors");
              }
            })
          ],
        ),
      ),
    );
  }
}

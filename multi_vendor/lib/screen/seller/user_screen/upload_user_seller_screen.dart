import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_vendor/controllers/product_controllers.dart';
import 'package:multi_vendor/provider/seller_provider.dart';
import 'package:multi_vendor/utils/widget/button_widget_utils.dart';
import 'package:multi_vendor/utils/widget/form/textForm_form.dart';
import 'package:multi_vendor/utils/widget/space_widget_utils.dart';

import '../../../controllers/category_controllers.dart';
import '../../../controllers/subCategory_controllers.dart';
import '../../../models/api/category_api_models.dart';
import '../../../models/api/subcategory_api_models.dart';
import '../../../utils/fonts/google_fonts_utils.dart';

class UploadUserSellerScreen extends ConsumerStatefulWidget {
  const UploadUserSellerScreen({super.key});

  @override
  ConsumerState<UploadUserSellerScreen> createState() =>
      _UploadUserSellerScreenState();
}

class _UploadUserSellerScreenState
    extends ConsumerState<UploadUserSellerScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  final ProductController _productControllerInstance = ProductController();
  final TextEditingController _productController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  List<XFile>? imageFileList = [];

  late Future<List<CategoryApiModels>> futureCategory;
  late Future<List<SubCategoryApiModels>> futureSubCategory;

  CategoryApiModels? _selectedCategory;
  SubCategoryApiModels? _selectedSubCategory;

  late String productName;
  late double productQuantity;
  late double productPrice;
  late String productDescription;

  bool _isUploading = false;

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
  void dispose() {
    _productController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _uploadProduct(final seller) async {
    if (_isUploading) return; // safeguard

    if (_formKey.currentState!.validate()) {
      if (seller.id.isEmpty || seller.name.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Seller info missing! Please login again.")),
        );
        return;
      }

      setState(() => _isUploading = true);

      try {
        await _productControllerInstance.uploadProduct(
          productName: _productController.text.trim(),
          productCategory: _selectedCategory?.categoryName ?? "Uncategorized",
          productSubCategory:
              _selectedSubCategory?.subCategoryName ?? "General",
          productDescription: _descriptionController.text.trim(),
          productPrice: productPrice,
          productQuantity: productQuantity.toInt(),
          sellerId: seller.id,
          sellerName: seller.name,
          productImage: imageFileList?.map((file) => file.path).toList() ?? [],
          context: context,
          subCategories: [],
        );

        print("✅ Product uploaded");

        // clear all fields
        _productController.clear();
        _quantityController.clear();
        _priceController.clear();
        _descriptionController.clear();
        setState(() {
          productPrice = 0.0;
          productQuantity = 0;
          imageFileList = [];
        });

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar() // removes any active snackbar first
          ..showSnackBar(
            const SnackBar(
              content: Text("Product uploaded successfully!"),
              duration: Duration(seconds: 2),
            ),
          );
      } catch (e) {
        print("❌ Upload failed: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Upload failed: $e")),
        );
      } finally {
        setState(() => _isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final seller = ref.watch(sellerProvider);

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 360, // max width for grid
                ),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: (imageFileList?.length ?? 0) + 1,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 3 items per row
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                    childAspectRatio: 1.0,
                  ),
                  itemBuilder: (context, index) {
                    // First item: add image icon
                    if (index == 0) {
                      return GestureDetector(
                        onTap: chooseImage,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.add_a_photo,
                              size: 36,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      );
                    }

                    // Remaining items: user images
                    final imageIndex = index - 1;
                    return Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: FileImage(
                                  File(imageFileList![imageIndex].path)),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        // Number badge
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${imageIndex + 1}', // Show number
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        // Remove icon
                        Positioned(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                imageFileList!.removeAt(imageIndex);
                              });
                            },
                            child: const CircleAvatar(
                              radius: 9,
                              backgroundColor: Colors.red,
                              child: Icon(
                                Icons.close,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textFormField(
                      _productController,
                      'Product Name',
                      (value) => value == null || value.isEmpty
                          ? 'Please enter product name'
                          : null,
                      hintText: 'e.g. Shirt, T-Shirt, Pant...',
                      onChanged: (val) {
                    setState(() {
                      productName = val;
                    });
                  }),
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
                          hintText: 'e.g. 20',
                          onChanged: (val) {
                            setState(() {
                              productQuantity = double.tryParse(val) ?? 0.0;
                            });
                          },
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
                          hintText: 'e.g. ₹200',
                          onChanged: (val) {
                            setState(() {
                              productPrice = double.tryParse(val) ?? 0.0;
                            });
                          },
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
                      } else if (value.length < 5) {
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
                    hintText: 'Write about your product...',
                    onChanged: (value) {
                      setState(() {
                        productDescription = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            elevatedButton(
              _isUploading ? "Uploading..." : "Upload Product",
              _isUploading ? null : () => _uploadProduct(seller),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io' as io;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_vendor/controllers/product_controllers.dart';
import 'package:multi_vendor/models/seller_models.dart';
import 'package:multi_vendor/provider/seller_provider.dart';
import 'package:multi_vendor/utils/widget/button_widget_utils.dart';
import 'package:multi_vendor/utils/widget/form/textForm_form.dart';
import 'package:multi_vendor/utils/widget/space_widget_utils.dart';

import '../../../controllers/category_controllers.dart';
import '../../../controllers/subCategory_controllers.dart';
import '../../../models/api/category_api_models.dart';
import '../../../models/api/subcategory_api_models.dart';
import '../../../utils/fonts/google_fonts_utils.dart';
import '../../../utils/theme/color/color_theme.dart';

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

  double get mediaQueryWidth => MediaQuery.of(context).size.width;
  bool get isWebMobile => kIsWeb && mediaQueryWidth > 626;

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

  Widget buildImageContainer(List<XFile> imageFileList) {
    if (imageFileList.isEmpty) {
      return Container(
        width: !isWebMobile ? 140 : width,
        height: !isWebMobile ? 140 : height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade200,
        ),
        child: const Center(
          child: Icon(
            Icons.add_a_photo,
            size: 36,
            color: Colors.grey,
          ),
        ),
      );
    }

    final displayIndex = selectedImageIndex ?? imageFileList.length - 1;
    final displayImage = imageFileList[displayIndex];

    return Container(
      width: !isWebMobile ? 140 : width,
      height: !isWebMobile ? 140 : height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade200,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: kIsWeb
            ? FutureBuilder<Uint8List>(
                future: displayImage.readAsBytes(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(
                        child: Icon(Icons.error, color: Colors.red));
                  } else {
                    return Image.memory(snapshot.data!,
                        fit: BoxFit.cover, width: 140, height: 140);
                  }
                },
              )
            : Image.file(
                io.File(displayImage.path),
                fit: BoxFit.cover,
                width: 140,
                height: 140,
              ),
      ),
    );
  }

  Future<void> chooseImage() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              if (!kIsWeb) ...[
                ListTile(
                  leading: Icon(CupertinoIcons.photo_camera),
                  title: googleInterText('Camera', fontSize: 15),
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
                Divider(),
                ListTile(
                  leading: Icon(CupertinoIcons.photo),
                  title: googleInterText('Gallery', fontSize: 15),
                  onTap: () async {
                    Navigator.pop(context);
                    final pickedImages = await _picker.pickMultiImage();
                    if (pickedImages.isNotEmpty) {
                      setState(() {
                        imageFileList!.addAll(pickedImages);
                      });
                    }
                  },
                ),
                Divider(),
              ],
              ListTile(
                leading: const Icon(Icons.attach_file),
                title: googleInterText('Files', fontSize: 15),
                onTap: () async {
                  Navigator.pop(context);
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    allowMultiple: true,
                    type: FileType.custom,
                    allowedExtensions: [
                      'jpg',
                      'jpeg',
                      'png',
                    ],
                  );

                  if (result != null) {
                    setState(() {
                      for (var file in result.files) {
                        if (kIsWeb) {
                          if (file.bytes != null) {
                            final webFile = XFile.fromData(
                              file.bytes!,
                              name: file.name,
                              mimeType: file.extension != null
                                  ? 'image/${file.extension}'
                                  : null,
                            );
                            imageFileList!.add(webFile);
                          }
                        } else {
                          if (file.path != null) {
                            imageFileList!.add(XFile(file.path!));
                          }
                        }
                      }
                    });
                  }
                },
              ),
              Divider(),
              if (kIsWeb) ...[
                SizedBox(
                  height: 70,
                ),
              ],
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

  bool get isWebMobileIn => kIsWeb && mediaQueryWidth > 1026;
  int? selectedImageIndex;

  @override
  Widget build(BuildContext context) {
    final seller = ref.watch(sellerProvider);

    var gestureDetector = GestureDetector(
      onTap: () {
        if (imageFileList!.isNotEmpty) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            isDismissible: true,
            enableDrag: true,
            builder: (_) {
              return StatefulBuilder(
                builder: (context, setModalState) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            "Uploaded Images",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                            ),
                            itemCount: imageFileList!.length,
                            itemBuilder: (context, index) {
                              final file = imageFileList![index];
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedImageIndex = index;
                                  });
                                  Navigator.pop(context); // close modal
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: selectedImageIndex == index
                                              ? Colors.blue
                                              : Colors.transparent,
                                          width: 3,
                                        ),
                                        image: DecorationImage(
                                          image: kIsWeb
                                              ? NetworkImage(file.path)
                                              : FileImage(io.File(file.path))
                                                  as ImageProvider,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 4,
                                      left: 4,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          '${index + 1}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            imageFileList!.removeAt(index);
                                            // reset selection if needed
                                            if (selectedImageIndex == index) {
                                              selectedImageIndex =
                                                  imageFileList!.isNotEmpty
                                                      ? imageFileList!.length -
                                                          1
                                                      : null;
                                            }
                                          });
                                          setModalState(() {});
                                        },
                                        child: const CircleAvatar(
                                          radius: 12,
                                          backgroundColor: Colors.red,
                                          child: Icon(
                                            Icons.close,
                                            size: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        }
      },
      child: Stack(
        children: [
          buildImageContainer(imageFileList!),
          if (imageFileList!.isNotEmpty)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${imageFileList!.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: 8,
            right: 8,
            child: GestureDetector(
              onTap: chooseImage,
              child: const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.blue,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return Form(
      key: _formKey,
      child: !isWebMobileIn
          ? _mobileCode(gestureDetector, context, seller)
          : _webCode(gestureDetector, context, seller),
    );
  }

  late double width = MediaQuery.of(context).size.width * .3;
  late double height = MediaQuery.of(context).size.height * 1;

  Widget _webCode(
    GestureDetector gestureDetector,
    BuildContext context,
    SellerModels seller,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 30),
      child: Row(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: SizedBox(
                  width: width,
                  height: height,
                  child: gestureDetector,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: const VerticalDivider(
                  width: 32,
                  thickness: 1,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: googleInterText('Upload New Product',
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: ColorTheme.color.dodgerBlue),
                ),
                SizedBox(height: 20),
                _productName(),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _selectCategory()),
                    const SizedBox(width: 16),
                    Expanded(child: _selectSubCategory()),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _productQuantity()),
                    const SizedBox(width: 16),
                    Expanded(child: _pricePerUnit()),
                  ],
                ),
                const SizedBox(height: 10),
                _productDescription(),
                const SizedBox(height: 30),
                Center(child: _uploadingButton(seller)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _mobileCode(
    GestureDetector gestureDetector,
    BuildContext context,
    SellerModels seller,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          sizedBoxH20(),
          gestureDetector,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _productName(),
                sizedBoxH15(),
                Row(
                  children: [
                    // Category Dropdown
                    Expanded(
                      child: _selectCategory(),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _selectSubCategory(),
                    ),
                  ],
                ),
                sizedBoxH15(),
                Row(
                  children: [
                    Expanded(
                      child: _productQuantity(),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _pricePerUnit(),
                    ),
                  ],
                ),
                sizedBoxH15(),
                _productDescription(),
              ],
            ),
          ),
          SizedBox(
              height:
                  MediaQuery.of(context).size.width * (kIsWeb ? 0.12 : 0.25)),
          _uploadingButton(seller),
        ],
      ),
    );
  }

  Widget _uploadingButton(SellerModels seller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        elevatedButton(
          'Clear',
          () {
            _productController.clear();
            _quantityController.clear();
            _priceController.clear();
            _descriptionController.clear();

            setState(() {
              productPrice = 0.0;
              productQuantity = 0;
              imageFileList = [];
              _selectedCategory = null;
              _selectedSubCategory = null;
            });
          },
        ),
        SizedBox(width: 20),
        elevatedButton(
          _isUploading ? "Uploading..." : "Upload Product",
          _isUploading ? null : () => _uploadProduct(seller),
        ),
      ],
    );
  }

  Widget _productName() {
    return textFormField(
        _productController,
        'Product Name',
        (value) =>
            value == null || value.isEmpty ? 'Please enter product name' : null,
        hintText: 'e.g. Shirt, T-Shirt, Pant...', onChanged: (val) {
      setState(() {
        productName = val;
      });
    });
  }

  Widget _productDescription() {
    return textFormField(
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
    );
  }

  Widget _pricePerUnit() {
    return textFormField(
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
    );
  }

  Widget _productQuantity() {
    return textFormField(
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
    );
  }

  FutureBuilder<List<CategoryApiModels>> _selectCategory() {
    return FutureBuilder(
      future: futureCategory,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return errormessage("Error: ${snapshot.error}");
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
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
            items: snapshot.data!.map((CategoryApiModels category) {
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
                    .getSubCategoryByCategoryName(newValue!.categoryName);
              });
            },
            validator: (value) =>
                value == null ? 'Please select a category' : null,
          );
        }
      },
    );
  }

  Widget _selectSubCategory() {
    return _selectedCategory == null
        ? InputDecorator(
            decoration: InputDecoration(
              labelText: 'Sub-Category',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
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
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return errormessage("Error: ${snapshot.error}");
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return InputDecorator(
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
                );
              } else {
                return DropdownButtonFormField<SubCategoryApiModels>(
                  initialValue: _selectedSubCategory,
                  decoration: InputDecoration(
                    labelText: 'Sub-Category',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  isExpanded: true,
                  items: snapshot.data!.map((SubCategoryApiModels subcategory) {
                    return DropdownMenuItem<SubCategoryApiModels>(
                      value: subcategory,
                      child: Text(
                        subcategory.subCategoryName,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    );
                  }).toList(),
                  onChanged: (SubCategoryApiModels? newValue) {
                    setState(() {
                      _selectedSubCategory = newValue;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Please select a sub-category' : null,
                );
              }
            },
          );
  }
}

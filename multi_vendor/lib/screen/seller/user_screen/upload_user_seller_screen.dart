import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_vendor/utils/widget/form/textForm_form.dart';
import 'package:multi_vendor/utils/widget/space_widget_utils.dart';

class UploadUserSellerScreen extends StatefulWidget {
  const UploadUserSellerScreen({super.key});

  @override
  State<UploadUserSellerScreen> createState() => _UploadUserSellerScreenState();
}

class _UploadUserSellerScreenState extends State<UploadUserSellerScreen> {
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _productController = TextEditingController();

  List<XFile>? imageFileList = [];

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
    return Column(
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
                (val) {},
              ),
              sizedBoxH15(),
              Row(
                children: [
                  Expanded(
                    child: textFormField(
                      _productController,
                      'Product Quantity',
                      (val) {},
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16), // spacing between fields
                  Expanded(
                    child: textFormField(
                      _productController, // use a separate controller
                      'Product Price Per Unit',
                      (val) {},
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              sizedBoxH15(),
              textFormField(
                _productController,
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
        )
      ],
    );
  }
}

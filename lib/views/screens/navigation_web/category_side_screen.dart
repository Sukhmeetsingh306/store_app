import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:store_app/components/code/text/googleFonts.dart';
import 'package:store_app/components/code/webImageInput_code.dart';

import '../../../components/code/divider_code.dart';
import '../../../components/code/sized_space_code.dart';
import '../../../components/color/color_theme.dart';
import '../../../controllers/category_controllers.dart';

class CategorySideScreen extends StatefulWidget {
  static const String routeName = '/categoryScreen';
  const CategorySideScreen({super.key});

  @override
  State<CategorySideScreen> createState() => _CategorySideScreenState();
}

class _CategorySideScreenState extends State<CategorySideScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final CategoryControllers _categoryController = CategoryControllers();

  late String categoryName;

  dynamic _categoryImage;
  dynamic _bannerImage;

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

  Widget elevatedButton(ValueSetter<dynamic> image) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorTheme.color.dodgerBlue,
      ),
      onPressed: () {
        uploadImage(image);
      },
      child: webButtonGoogleText(
        'Upload Image',
        color: ColorTheme.color.whiteColor,
      ),
    );
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
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorTheme.color.dodgerBlue,
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      print(categoryName);
                      _categoryController.uploadCategory(
                        pickedImage: _categoryImage,
                        pickedBanner: _bannerImage,
                        categoryName: categoryName,
                        context: context,
                      );
                    } // will change it when the api creation will begin
                  },
                  child: webButtonGoogleText(
                    'Submit',
                    color: ColorTheme.color.whiteColor,
                  ),
                ),
              ],
            ),
            sizedBoxMediaQuery(
              context,
              width: 0,
              height: 0.02,
            ),
            elevatedButton(
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
            elevatedButton(
              (image) {
                _bannerImage = image;
              },
            ),
            divider(),
          ],
        ),
      ),
    );
  }
}

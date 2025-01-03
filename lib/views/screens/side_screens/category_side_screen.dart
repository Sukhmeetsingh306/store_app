import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:store_app/components/text/googleFonts.dart';

import '../../../components/color/color_theme.dart';

class CategorySideScreen extends StatefulWidget {
  static const String routeName = '/categoryScreen';
  const CategorySideScreen({super.key});

  @override
  State<CategorySideScreen> createState() => _CategorySideScreenState();
}

class _CategorySideScreenState extends State<CategorySideScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String categoryName;

  dynamic _image;

  uploadImage() async {
    FilePickerResult? fileImage = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (fileImage != null) {
      setState(() {
        _image = fileImage.files.first.bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double mediaQueryWidth = MediaQuery.of(context).size.width;
    double mediaQueryHeight = MediaQuery.of(context).size.height;

    double squareSize = (mediaQueryWidth < mediaQueryHeight
            ? mediaQueryWidth
            : mediaQueryHeight) *
        0.20;

    Widget sizedBoxMediaQuery(double? width, double? height) {
      return SizedBox(
        width: mediaQueryWidth * width!,
        height: mediaQueryHeight * height!,
      );
    }

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
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Divider(),
            ),
            Row(
              children: [
                Container(
                  width: squareSize,
                  height: squareSize,
                  decoration: BoxDecoration(
                    color: ColorTheme.color.grayColor,
                    borderRadius: BorderRadius.circular(
                      5,
                    ),
                  ),
                  child: Center(
                    child: _image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(
                                5), // Match container radius
                            child: Image.memory(
                              _image,
                              width: squareSize,
                              height: squareSize,
                              fit: BoxFit
                                  .cover, // Adjust to 'contain', 'cover', or 'fill' based on your design
                            ),
                          )
                        : googleText(
                            'Category Image',
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          ),
                  ),
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
                        if (value == null || value.isEmpty || value.length <= 3) {
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
                  0.023,
                  0,
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
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      print(categoryName);
                    } // will change it when the api creation will begin
                    ;
                  },
                  child: webButtonGoogleText(
                    'Submit',
                    color: ColorTheme.color.whiteColor,
                  ),
                ),
              ],
            ),
            sizedBoxMediaQuery(
              0,
              0.02,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorTheme.color.dodgerBlue,
              ),
              onPressed: () {
                uploadImage();
              },
              child: webButtonGoogleText(
                'Upload Image',
                color: ColorTheme.color.whiteColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: const Divider(),
            ),
          ],
        ),
      ),
    );
  }
}

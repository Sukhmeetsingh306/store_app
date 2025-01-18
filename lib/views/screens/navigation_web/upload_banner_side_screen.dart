import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart'; 
import 'package:store_app/views/screens/navigation_web/widget/banner_widget.dart';

import '../../../components/code/button_code.dart';
import '../../../components/code/divider_code.dart';
import '../../../components/code/sized_space_code.dart';
import '../../../components/code/text/googleFonts.dart';
import '../../../components/code/webImageInput_code.dart';
import '../../../controllers/upload_banner_controllers.dart';

class UploadBannerSideScreen extends StatefulWidget {
  static const String routeName = '/uploadBannerScreen';

  const UploadBannerSideScreen({super.key});

  @override
  State<UploadBannerSideScreen> createState() => _UploadBannerSideScreenState();
}

class _UploadBannerSideScreenState extends State<UploadBannerSideScreen> {
  final UploadBannerControllers _uploadBannerControllers =
      UploadBannerControllers();
  dynamic _uploadBannerImage;
  bool _isLoading = false; 
  Key _widgetKey = UniqueKey(); 

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
      _widgetKey = UniqueKey(); 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          key: _widgetKey, // Use the key here
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
                    'Banner',
                    fontSize: 36,
                  ),
                ),
              ),
              divider(),
              Row(
                children: [
                  webImageInput(
                    _uploadBannerImage,
                    "Banner Image",
                    context,
                  ),
                  sizedBoxMediaQuery(
                    context,
                    width: 0.023,
                    height: 0,
                  ),
                  elevatedButton(
                    () async {
                      setState(() {
                        _isLoading = true; 
                      });
                      await _uploadBannerControllers.uploadBanner(
                        pickedBanner: _uploadBannerImage,
                        context: context,
                      );
                      dynamic newImage = await simulateImageUpload();
                      setState(() {
                        _uploadBannerImage = newImage;
                        _isLoading = false; 
                      });
                      reloadWidget();
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
                        _uploadBannerImage = img;
                      });
                    },
                  );
                },
                "Upload Image",
              ),
              divider(),
              BannerWidget(),
            ],
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
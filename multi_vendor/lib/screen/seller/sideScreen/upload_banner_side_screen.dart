import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../controllers/upload_banner_controllers.dart';
import '../../../utils/fonts/google_fonts_utils.dart';
import '../../../utils/widget/button_widget_utils.dart';
import '../../../utils/widget/space_widget_utils.dart';
import '../../../utils/widget/web/web_input_image.dart';
import '../../web/banner_widget_web.dart';

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
  bool _isSnackBarVisible = false;

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
                  child: googleInterText(
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
                    "Submit",
                    () async {
                      setState(() {
                        _isLoading = true;
                      });
                      if (_uploadBannerImage == null) {
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
                  ),
                ],
              ),
              sizedBoxMediaQuery(
                context,
                width: 0,
                height: 0.02,
              ),
              elevatedButton(
                "Upload Image",
                () {
                  uploadImage(
                    (img) {
                      setState(() {
                        _uploadBannerImage = img;
                      });
                    },
                  );
                },
              ),
              divider(),
              BannerWidgetWeb(),
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

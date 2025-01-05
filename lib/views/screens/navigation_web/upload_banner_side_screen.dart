import 'package:flutter/cupertino.dart';

import '../../../components/code/button_code.dart';
import '../../../components/code/divider_code.dart';
import '../../../components/code/sized_space_code.dart';
import '../../../components/code/text/googleFonts.dart';
import '../../../components/code/webImageInput_code.dart';

class UploadBannerSideScreen extends StatefulWidget {
  static const String routeName = '/uploadBannerScreen';
  const UploadBannerSideScreen({super.key});

  @override
  State<UploadBannerSideScreen> createState() => _UploadBannerSideScreenState();
}

class _UploadBannerSideScreenState extends State<UploadBannerSideScreen> {
  dynamic _uploadBannerImage;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                () {},
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
            () {},
            "Upload Image",
          ),
          divider(),
        ],
      ),
    );
  }
}

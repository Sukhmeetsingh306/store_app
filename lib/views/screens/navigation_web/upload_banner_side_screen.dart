import 'package:flutter/cupertino.dart';

import '../../../components/code/divider_code.dart';
import '../../../components/code/text/googleFonts.dart';

class UploadBannerSideScreen extends StatelessWidget {
  static const String routeName = '/uploadBannerScreen';
  const UploadBannerSideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Container(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: googleText(
                  'Banner',
                  fontSize: 36,
                ),
              ),
            ),
            divider(),],
    );
  }
}

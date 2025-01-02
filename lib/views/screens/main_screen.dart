import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:store_app/views/device/mobile_device_view.dart';

import '../device/web_device_view.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return MobileDevice();
    } else if (kIsWeb) {
      return WebDeviceView();
    } else {
      // Default case for Android, Windows, etc.
      return Scaffold(
        body: Center(child: Text('Platform not supported')),
      );
    }
  }
}

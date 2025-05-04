import 'package:flutter/foundation.dart';

import 'platform_check_stub.dart';

bool isWebMobileWeb() => kIsWeb && (isIOSWeb() || isAndroidWeb());

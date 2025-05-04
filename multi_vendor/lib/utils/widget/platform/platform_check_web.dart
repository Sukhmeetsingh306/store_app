import 'dart:html' as html;
import 'package:flutter/foundation.dart';

bool isIOSWeb() {
  final userAgent = html.window.navigator.userAgent.toLowerCase();
  return userAgent.contains('iphone') ||
      userAgent.contains('ipad') ||
      userAgent.contains('ipod');
}

bool isAndroidWeb() {
  final userAgent = html.window.navigator.userAgent.toLowerCase();
  return userAgent.contains('android');
}

bool isWebMobileWeb() => kIsWeb && (isIOSWeb() || isAndroidWeb());

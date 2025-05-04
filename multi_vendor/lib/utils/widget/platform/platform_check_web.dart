import 'dart:html' as html;

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

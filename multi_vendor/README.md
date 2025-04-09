# multi_vendor

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

<!-- MARK: Removing the # from the url  -->
# Removing the # url
Getting the # in the url in the web as per removing have we have to change some of the code settings

In index.html add 

     <base href="$FLUTTER_BASE_HREF"> ..remove this 
     <base href="/">     .. add this

In dart file in main.dart

     flutter pub add flutter_web_plugins
add in the void main

    usePathUrlStrategy();

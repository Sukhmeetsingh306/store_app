import 'package:flutter/material.dart';
import 'package:multi_vendor/screen/authentication/login_auth_screen.dart';
import 'package:multi_vendor/utils/routes/app_route.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void main() {
  usePathUrlStrategy(); // this is to remove the # from the url as removed the code in the html for this
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Multi Vendor',
      initialRoute: '/loginPage',
      routes: AppRoutes.getRoutes(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white30),
        useMaterial3: true,
      ),
      home: const LoginAuthScreen(),
    );
  }
}

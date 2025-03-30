import 'package:flutter/material.dart';
import 'package:multi_vendor/screen/authentication/login_auth_screen.dart';
import 'package:multi_vendor/utils/routes/app_route.dart';

void main() {
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginAuthScreen(),
    );
  }
}

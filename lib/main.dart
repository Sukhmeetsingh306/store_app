import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
//
import 'provider/user_provider.dart';
import 'views/auth/login_page.dart';
import 'views/screens/main_screen.dart';

void main() {
  // Run the riverpod  for state management

  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // checking the token and the user data
  Future<void> _checkTokenAndSetUser(WidgetRef ref) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    String? token = pref.getString('auth_token');
    String? userJson = pref.getString('user');

    // get db for user
    if (token != null && userJson != null) {
      ref.read(userProvider.notifier).setUser(userJson);
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //home: LoginPage(),
      home: FutureBuilder(
        future: _checkTokenAndSetUser(ref),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = ref.watch(userProvider);
          return user != null ? MainScreen() : LoginPage();
        },
      ),
    );
  }
}

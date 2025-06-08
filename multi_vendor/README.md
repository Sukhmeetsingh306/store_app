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

This app uses Flutter Riverpod for managing client-side authentication and state. The authentication flow is designed to store user data locally using SharedPreferences so that when the user reopens the app, they are redirected to the appropriate screen (home or login) based on their saved token.

     flutter pub add flutter_riverpod

Details stored in Consumer Widget 

     class MyApp extends ConsumerWidget {
          const MyApp({super.key});

          @override
          Widget build(BuildContext context, WidgetRef ref) {
               // App routing or theme setup can go here
          }
     }

A method _checkAuthTokenAndNavigate() is used during app startup to check if a valid auth token and user information are stored. Based on this check, the app navigates to the home page or login page:

     Future<void> _checkAuthTokenAndNavigate() async {
          SharedPreferences pref = await SharedPreferences.getInstance();
          String? token = pref.getString('auth_token');
          String? userJson = pref.getString('user');

          if (!mounted) return;

          if (token != null && userJson != null) {
               ref.read(userProvider.notifier).setUser(userJson);
               context.go('/homePage');
          } else {
               ref.read(userProvider.notifier).signOut();
               if (context.mounted) {
                    context.go('/loginPage');
               }
          }
     }

If both the token and user data are found, the user is considered authenticated and navigated to /homePage.

If not, they are signed out and redirected to /loginPage.

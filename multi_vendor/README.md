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

# Error while committing in the main 
As when the branch is not migrating in the main branch.
Use 

     git add multi_vendor/pubspec.lock
     git commit -m "chore: Update pubspec.lock before pull"
     git pull --tags origin main


# Riverpod

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

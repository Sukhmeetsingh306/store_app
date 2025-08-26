import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/login_user_models.dart';

class UserProvider extends StateNotifier<LoginUserModel?> {
  // Constructor: start with null (no user logged in)
  UserProvider() : super(null);

  /// Get current user
  LoginUserModel? get user => state;

  /// Set user from JSON string (from API or SharedPreferences)
  void setUser(String userJson) {
    state = LoginUserModel.fromJson(userJson);
  }

  /// Update user directly
  void updateUser(LoginUserModel newUser) {
    state = newUser;
  }

  /// Clear user state (logout)
  void signOut() {
    state = null;
  }

  /// Check if user has a specific role
  bool hasRole(String role) => state?.roles.contains(role) ?? false;

  bool get isConsumer => hasRole("consumer") || hasRole("seller");
  bool get isSeller => hasRole("seller");
  bool get isAdmin => hasRole("admin");
}

// Make the provider accessible app-wide
final userProvider = StateNotifierProvider<UserProvider, LoginUserModel?>(
    (ref) => UserProvider());

// import 'package:riverpod/riverpod.dart';

// import '../models/login_user_models.dart';

// class UserProvider extends StateNotifier<LoginUserModel?> {
//   // Constructor initializes with a default user object
//   UserProvider()
//       : super(
//           LoginUserModel(
//             id: '',
//             name: '',
//             email: '',
//             state: '',
//             city: '',
//             locality: '',
//             password: '',
//             token: '',
//           ),
//         );
//   // password and token will be assigned

//   //getter method for extracting the value

//   LoginUserModel? get user => state;

//   // method to get the state form the json
//   // updating user state as per the json string representation of user object

//   void setUser(String userJson) {
//     state = LoginUserModel.fromJson(userJson);
//   }

//   // method to clear the user state
//   void signOut() {
//     state = null;
//   }
// }

// // making the data accessible within the app
// final userProvider = StateNotifierProvider<UserProvider, LoginUserModel?>(
//   (ref) => UserProvider(),
// );

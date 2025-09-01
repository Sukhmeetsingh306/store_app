import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/login_user_models.dart';

class UserProvider extends StateNotifier<LoginUserModel?> {
  // Constructor: start with null (no user logged in)
  UserProvider() : super(null);

  /// Get current user
  LoginUserModel? get user => state;

  /// Set user from JSON string (from API or SharedPreferences)
  void setUser(String userJson) {
    final userModel = LoginUserModel.fromJson(userJson);

    // 🔹 Ensure primaryRole is set based on priority
    final updatedUser = LoginUserModel(
      id: userModel.id,
      name: userModel.name,
      email: userModel.email,
      phone: userModel.phone,
      age: userModel.age,
      state: userModel.state,
      city: userModel.city,
      locality: userModel.locality,
      password: userModel.password,
      token: userModel.token,
      roles: userModel.roles,
      primaryRole: _determinePrimaryRole(userModel.roles),
      image: userModel.image,
    );

    state = updatedUser;
  }

  /// Update user directly
  void updateUser(LoginUserModel newUser) {
    final updatedUser = LoginUserModel(
      id: newUser.id,
      name: newUser.name,
      email: newUser.email,
      phone: newUser.phone,
      age: newUser.age,
      state: newUser.state,
      city: newUser.city,
      locality: newUser.locality,
      password: newUser.password,
      token: newUser.token,
      roles: newUser.roles,
      primaryRole: _determinePrimaryRole(newUser.roles),
      image: newUser.image,
    );
    state = updatedUser;
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

  /// 🔹 Determine primary role based on priority
  String _determinePrimaryRole(List<String> roles) {
    if (roles.contains("admin")) return "admin";
    if (roles.contains("seller")) return "seller";
    if (roles.contains("consumer")) return "consumer";
    return "";
  }
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

import 'package:riverpod/riverpod.dart';
import 'package:store_app/models/api/user.dart';

class UserProvider extends StateNotifier<User> {
  // we will have the constructor and the initializer with the   user
  UserProvider()
      : super(
          User(
            id: '',
            name: '',
            email: '',
            state: '',
            city: '',
            locality: '',
            password: '',
            token: '',
          ),
        );

  // manage the state of the user object allowing update

  // getter method to get the user value form the object
  User? get user => state;

  // method to get the state form the json
  // updating user state as per the json string representation

  void setUser(String userJson) {
    state = User.fromJson(userJson);
  }
}

// make the data assailable within the app
final userProvider =
    StateNotifierProvider<UserProvider, User?>((ref) => UserProvider());

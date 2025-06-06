import 'package:riverpod/riverpod.dart';

import '../models/login_user_models.dart';

class UserProvider extends StateNotifier<LoginUserModel?> {
  // Constructor initializes with a default user object
  UserProvider()
      : super(
          LoginUserModel(
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
  // password and token will be assigned

  //getter method for extracting the value

  LoginUserModel? get user => state;

  // method to get the state form the json
  // updating user state as per the json string representation of user object

  void setUser(String userJson) {
    state = LoginUserModel.fromJson(userJson);
  }
}

// making the data accessible within the app
final userProvider = StateNotifierProvider<UserProvider, LoginUserModel?>(
  (ref) => UserProvider(),
);

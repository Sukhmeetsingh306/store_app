import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_vendor/models/seller_models.dart';

// notifier is used to manage the state of the application as it also designed to notify listeners about the changes taking place in the state
// StateNotifier is a class that helps to manage and notify the state changes
class SellerProvider extends StateNotifier<SellerModels> {
  // Constructor initializes with a default seller object
  SellerProvider()
      : super(
          SellerModels(
            id: '',
            name: '',
            email: '',
            state: '',
            city: '',
            locality: '',
            password: '',
            roles: ['seller', 'consumer'],
          ),
        );
  // password and roles will be assigned

  //getter method for extracting the value

  SellerModels? get seller => state;

  // method to get the state form the json
  // updating seller state as per the json string representation of seller object
  // creating the function setSeller so we can use the provider class and update the state of the seller in the app

  void setSeller(String sellerJson) {
    state = SellerModels.fromJson(sellerJson);
  }

  // method to clear the seller state

  void signOut() {
    state = SellerModels(
      id: '',
      name: '',
      email: '',
      state: '',
      city: '',
      locality: '',
      password: '',
      roles: ['seller', 'consumer'],
    );
  }
}

final sellerProvider = StateNotifierProvider<SellerProvider, SellerModels>(
  (ref) => SellerProvider(),
);

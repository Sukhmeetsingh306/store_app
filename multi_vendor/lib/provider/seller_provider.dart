import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/seller_models.dart';

class SellerProvider extends StateNotifier<SellerModels> {
  SellerProvider()
      : super(
          SellerModels(
            id: '',
            name: '',
            email: '',
            phone: null,
            age: null,
            state: '',
            city: '',
            locality: '',
            password: '',
            roles: [], // start empty, must be set from backend
          ),
        );

  /// Update seller from backend Map or JSON string
  void setSeller(dynamic sellerData) {
    if (sellerData is String) {
      state = SellerModels.fromJson(sellerData);
    } else if (sellerData is Map<String, dynamic>) {
      state = SellerModels.fromMap(sellerData);
    }
  }

  /// Clear seller state
  void signOut() {
    state = SellerModels(
      id: '',
      name: '',
      email: '',
      phone: null,
      age: null,
      state: '',
      city: '',
      locality: '',
      password: '',
      roles: [],
    );
  }

  /// Role helpers
  bool get isAdmin => state.roles.contains('admin');
  bool get isSeller => state.roles.contains('seller');
  bool get isConsumer => state.roles.contains('consumer');
}

/// Provider to access seller state app-wide
final sellerProvider = StateNotifierProvider<SellerProvider, SellerModels>(
    (ref) => SellerProvider());

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
    SellerModels seller;
    if (sellerData is String) {
      seller = SellerModels.fromJson(sellerData);
    } else if (sellerData is Map<String, dynamic>) {
      seller = SellerModels.fromMap(sellerData);
    } else {
      return;
    }

    // 🔹 Set primaryRole based on priority
    state = SellerModels(
      id: seller.id,
      name: seller.name,
      email: seller.email,
      phone: seller.phone,
      age: seller.age,
      state: seller.state,
      city: seller.city,
      locality: seller.locality,
      password: seller.password,
      roles: seller.roles,
      primaryRole: _determinePrimaryRole(seller.roles),
      image: seller.image,
    );
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

  /// 🔹 Determine primary role based on priority
  String _determinePrimaryRole(List<String> roles) {
    if (roles.contains("admin")) return "admin";
    if (roles.contains("seller")) return "seller";
    if (roles.contains("consumer")) return "consumer";
    return "";
  }
}

/// Provider to access seller state app-wide
final sellerProvider = StateNotifierProvider<SellerProvider, SellerModels>(
    (ref) => SellerProvider());

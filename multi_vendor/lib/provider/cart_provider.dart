// manage the state of the cart
// the state of the initial cart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_vendor/models/chart_model.dart';

class CartProvider extends StateNotifier<Map<String, ChartModel>> {
  CartProvider() : super({});

  // method to add the product in the cart
  void addProductToCart({
    required String productName,
    required int productPrice,
    required String productCategory,
    required List<String> productImage,
    required String sellerId,
    required int productQuantity,
    required int totalQuantity,
    required String productId,
    required String productDescription,
    required String fullName,
  }) {
    // check if the cart != null
    if (state.containsKey(productId)) {
      state = {
        ...state,
        productId: ChartModel(
          productName: state[productId]!.productName,
          productPrice: state[productId]!.productPrice,
          productCategory: state[productId]!.productCategory,
          productImage: state[productId]!.productImage,
          sellerId: state[productId]!.sellerId,
          productQuantity: state[productId]!.productQuantity,
          totalQuantity: state[productId]!.totalQuantity + 1,
          productId: state[productId]!.productId,
          productDescription: state[productId]!.productDescription,
          fullName: state[productId]!.fullName,
        ),
      };
    } else {
      // if the cart == null
      // add the product using the provider
      state = {
        productId: ChartModel(
          productName: productName,
          productPrice: productPrice,
          productCategory: productCategory,
          productImage: productImage,
          sellerId: sellerId,
          productQuantity: productQuantity,
          totalQuantity: totalQuantity,
          productId: productId,
          productDescription: productDescription,
          fullName: fullName,
        )
      };
    }
  }

  // method to increase product quantity in cart
  void incrementCartItem(String productId) {
    if (state.containsKey(productId)) {
      state[productId]!.totalQuantity++;

      // notify that the state is changed
      state = {...state};
    }
  }

  //method to decrement the quantity in cart
  void decrementCartItem(String productId) {
    if (state.containsKey(productId)) {
      state[productId]!.totalQuantity--;

      // notify that the state is changed
      state = {...state};
    }
  }

  // method to remove item from the cart
  void removeCartItem(String productId) {
    state.remove(productId);
    // notify about the state
  }

  //method for total items in cart
  double calculateTotalAmount() {
    double totalAmount = 0.0;
    state.forEach((productId, cartItem) {
      totalAmount += cartItem.totalQuantity * cartItem.productPrice;
    });

    return totalAmount;
  }
}

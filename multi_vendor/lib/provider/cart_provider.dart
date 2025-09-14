// manage the state of the cart
// the state of the initial cart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_vendor/models/cart_model.dart';

class CartProvider extends StateNotifier<Map<String, CartModel>> {
  CartProvider() : super({});

  // method to add the product in the cart
  void addProductToCart({
    required String productName,
    required double productPrice,
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
        productId: CartModel(
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
        productId: CartModel(
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

  void removeProductFromCart(String productId) {
    if (state.containsKey(productId)) {
      final currentItem = state[productId]!;

      if (currentItem.totalQuantity > 1) {
        // decrease quantity instead of removing
        state = {
          ...state,
          productId: CartModel(
            productName: currentItem.productName,
            productPrice: currentItem.productPrice,
            productCategory: currentItem.productCategory,
            productImage: currentItem.productImage,
            sellerId: currentItem.sellerId,
            productQuantity: currentItem.productQuantity,
            totalQuantity: currentItem.totalQuantity - 1,
            productId: currentItem.productId,
            productDescription: currentItem.productDescription,
            fullName: currentItem.fullName,
          ),
        };
      } else {
        // if quantity == 1, remove the product from cart
        final updatedState = {...state};
        updatedState.remove(productId);
        state = updatedState;
      }
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

final cartProvider =
    StateNotifierProvider<CartProvider, Map<String, CartModel>>(
  (ref) => CartProvider(),
);

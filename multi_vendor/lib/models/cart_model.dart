class CartModel {
  final String productName;
  final double productPrice;
  final String productCategory;
  final List<String> productImage;
  final String sellerId;
  final int productQuantity;
  int totalQuantity;
  final String productId;
  final String productDescription;
  final String fullName;

  CartModel({
    required this.productName,
    required this.productPrice,
    required this.productCategory,
    required this.productImage,
    required this.sellerId,
    required this.productQuantity,
    required this.totalQuantity,
    required this.productId,
    required this.productDescription,
    required this.fullName,
  });
}

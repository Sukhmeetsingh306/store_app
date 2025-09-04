import 'dart:convert';

class ProductModel {
  final String id;
  final String productName;
  final double productPrice;
  final int productQuantity;
  final String productDescription;
  final String sellerId;
  final String sellerName;
  final String productCategory;
  final String? productSubCategory;
  final List<String> productImage;
  final bool productPopularity;
  final bool productRecommended;
  final bool productFavorite;

  ProductModel({
    required this.id,
    required this.productName,
    required this.productPrice,
    required this.productQuantity,
    required this.productDescription,
    required this.sellerId,
    required this.sellerName,
    required this.productCategory,
    this.productSubCategory,
    required this.productImage,
    this.productPopularity = false,
    this.productRecommended = false,
    required this.productFavorite,
  });

  /// Convert Dart object → Map
  Map<String, dynamic> toProduct() {
    return {
      '_id': id,
      'productName': productName,
      'productPrice': productPrice,
      'productQuantity': productQuantity,
      'productDescription': productDescription,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'productCategory': productCategory,
      'productSubCategory': productSubCategory,
      'productImage': productImage,
      'productPopularity': productPopularity,
      'productRecommended': productRecommended,
      'productFavorite': productFavorite,
    };
  }

  /// Create Product object from Map
  factory ProductModel.fromProduct(Map<String, dynamic> map) {
    return ProductModel(
      id: map['_id'] ?? "",
      productName: map['productName'] ?? "",
      productPrice: (map['productPrice'] as num?)?.toDouble() ?? 0.0,
      productQuantity: (map['productQuantity'] as num?)?.toInt() ?? 0,
      productDescription: map['productDescription'] ?? "",
      sellerId: map['sellerId'] ?? "",
      sellerName: map['sellerName'] ?? "",
      productCategory: map['productCategory'] ?? "",
      productSubCategory: map['productSubCategory'] ?? "",
      productImage: List<String>.from(map['productImage'] as List<dynamic>),
      productPopularity: map['productPopularity'] ?? false,
      productRecommended: map['productRecommended'] ?? false,
      productFavorite: map['productFavorite'] ?? false,
    );
  }

  /// Encode Dart object → JSON string
  String toJson() => json.encode(toProduct());

  /// Decode JSON string → Product object
  factory ProductModel.fromJson(String source) =>
      ProductModel.fromProduct(json.decode(source));

  set isFavorite(bool isFavorite) {}
}

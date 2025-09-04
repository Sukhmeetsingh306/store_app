import 'dart:convert';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../globals_variables.dart';
import '../models/product_model.dart';

class ProductController {
  Future<void> uploadProduct({
    required String productName,
    required String productCategory,
    String? productSubCategory,
    required String productDescription,
    required double productPrice,
    required int productQuantity,
    required String sellerId,
    required String sellerName,
    required List<String> productImage,
    required BuildContext context,
    required List<String> subCategories,
    bool? productFav,
  }) async {
    final cloudinary = CloudinaryPublic(cloudinaryName, cloudinaryPresentName);

    if (productImage.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Select at least 1 image")));
      return;
    }

    try {
      // Upload images to Cloudinary
      List<String> uploadedUrls = [];
      for (String path in productImage) {
        CloudinaryResponse res = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(path, folder: "productImages"),
        );
        uploadedUrls.add(res.secureUrl);
      }

      // Subcategory validation
      if (subCategories.isNotEmpty &&
          (productSubCategory == null || productSubCategory.isEmpty)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Please select a subcategory for this category")),
        );
        return;
      }

      final product = ProductModel(
        id: '',
        productName: productName,
        productPrice: productPrice,
        productQuantity: productQuantity,
        productDescription: productDescription,
        sellerId: sellerId,
        sellerName: sellerName,
        productCategory: productCategory,
        productSubCategory: productSubCategory ?? '',
        productImage: uploadedUrls,
        productFavorite: productFav ?? false,
      );

      print("Uploading Product: ${product.toProduct()}");

      final pref = await SharedPreferences.getInstance();
      final token = pref.getString('auth_token') ?? "";

      final response = await http.post(
        Uri.parse("$webUri/seller/add-product"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // 🔹 pass token
        },
        body: jsonEncode(product.toProduct()),
      );

      if (!context.mounted) return;

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Product added successfully!")));
      } else {
        final error = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error['error'] ?? "Failed to add product")));
      }
    } catch (e) {
      print("Error uploading product: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  Future<List<ProductModel>> fetchPopularProduct() async {
    try {
      http.Response response = await http.get(
        Uri.parse("$webUri/product/popular-product"),
        headers: <String, String>{
          "content-type": "application/json; charset=UTF-8",
        },
      );

      //print(response.body);
      if (response.statusCode == 200) {
        List<dynamic> productData = jsonDecode(response.body);

        List<ProductModel> productModel = productData.map((product) {
          return ProductModel.fromProduct(product);
        }).toList();

        return productModel;
      } else {
        throw Exception("Failed to fetch product");
      }
    } catch (e) {
      print("Error fetching product : $e");
      return [];
    }
  }
}

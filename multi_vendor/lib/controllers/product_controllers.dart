import 'dart:convert';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:multi_vendor/models/product_model.dart';
import 'package:http/http.dart' as http;

import '../globals_variables.dart';

class ProductController {
  void uploadProduct({
    required String productName,
    required String productCategory,
    required String? productSubCategory,
    required String productDescription,
    required double productPrice,
    required double productQuantity,
    required String sellerId,
    required String sellerName,
    required List<String> productImage,
    required context,
    required List<String> subCategories, // pass the category's subcategories
  }) async {
    final productCloudinary = CloudinaryPublic(
      cloudinaryName,
      cloudinaryPresentName,
    );

    if (productImage.isEmpty) {
      print("No images selected for upload.");
      return;
    }

    try {
      List<String> uploadedImageUrls = [];
      for (var i = 0; i < productImage.length; i++) {
        CloudinaryResponse productImageResponse =
            await productCloudinary.uploadFile(
          CloudinaryFile.fromFile(
            productImage[i],
            folder: 'productImages',
          ),
        );
        uploadedImageUrls.add(productImageResponse.secureUrl);
      }

      print("Uploaded Image URLs: $uploadedImageUrls");

      if (subCategories.isNotEmpty) {
        if (productSubCategory == null || productSubCategory.isEmpty) {
          print("Error: Subcategory must be selected for this category.");
          return;
        }
        final ProductModel product = ProductModel(
          id: '',
          productName: productName,
          productPrice: productPrice,
          productQuantity: productQuantity.toInt(),
          productDescription: productDescription,
          sellerId: sellerId,
          sellerName: sellerName,
          productCategory: productCategory,
          productSubCategory: productSubCategory,
          productImage: uploadedImageUrls,
        );
        print("Product ready to be uploaded: $product");

        http.Response response = await http.post(
          Uri.parse("$webUri/seller/add-product"),
          body: jsonEncode(product.toProduct()),
          headers: <String, String>{
            "content-type": "application/json; charset=UTF-8",
          },
        );
        if (context.mounted) {
          if (response.statusCode == 200) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Product added successfully!")),
            );
          } else {
            final errorResponse = jsonDecode(response.body);
            throw Exception(
                errorResponse['message'] ?? 'Failed to add product');
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("select subcategory for this category")),
        );
      }
    } catch (e) {
      print("Error uploading images to Cloudinary: $e");
    }
  }
}

import 'package:flutter/material.dart';

import '../../../../../models/product_model.dart';

class ProductDetailSupportWidget extends StatefulWidget {
  static const String routeName = '/product/productDetail/:productName';
  static const String routePath = '/product/productDetail/:productName';

  final ProductModel product;

  const ProductDetailSupportWidget({super.key, required this.product});

  @override
  State<ProductDetailSupportWidget> createState() =>
      _ProductDetailSupportWidgetState();
}

class _ProductDetailSupportWidgetState
    extends State<ProductDetailSupportWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.product.productName)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.product.productName,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("Price: ₹${widget.product.productPrice.toStringAsFixed(2)}"),
            const SizedBox(height: 10),
            Text("Quantity: ${widget.product.productQuantity}"),
            const SizedBox(height: 10),
            Text("Description: ${widget.product.productDescription}"),
          ],
        ),
      ),
    );
  }
}

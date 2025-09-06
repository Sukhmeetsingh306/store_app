import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../models/product_model.dart';
import '../../../../../utils/fonts/google_fonts_utils.dart';
import '../../../../../utils/theme/color/color_theme.dart';

class ProductDetailSupportWidget extends StatelessWidget {
  final ProductModel product;
  final String? from;

  const ProductDetailSupportWidget({
    super.key,
    required this.product,
    this.from,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorTheme.color.mediumBlue,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: kIsWeb
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () {
                  if (from != null) {
                    context.go(from!);
                  } else {
                    context.go('/homePage');
                  }
                },
              )
            : null, // keep default back button on mobile
        title: googleInterText(
          product.productName,
          color: Colors.white,
          fontSize: 23,
        ),
      ),
      body: Center(
        child: Text("Product: ${product.productName}"),
      ),
    );
  }
}


      // appBar: AppBar(title: Text(widget.product.productName)),
      // body: Padding(
      //   padding: const EdgeInsets.all(16.0),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Text(widget.product.productName,
      //           style:
      //               const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      //       const SizedBox(height: 10),
      //       Text("Price: ₹${widget.product.productPrice.toStringAsFixed(2)}"),
      //       const SizedBox(height: 10),
      //       Text("Quantity: ${widget.product.productQuantity}"),
      //       const SizedBox(height: 10),
      //       Text("Description: ${widget.product.productDescription}"),
      //     ],
      //   ),
      // ),
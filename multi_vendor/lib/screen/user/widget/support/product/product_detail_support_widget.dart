import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../models/product_model.dart';
import '../../../../../utils/fonts/google_fonts_utils.dart';
import '../../../../../utils/theme/color/color_theme.dart';
import '../../../../../utils/widget/banner_widget_support_user.dart';

class ProductDetailSupportWidget extends StatefulWidget {
  final ProductModel product;
  final String? from;

  const ProductDetailSupportWidget({
    super.key,
    required this.product,
    this.from,
  });

  @override
  State<ProductDetailSupportWidget> createState() =>
      _ProductDetailSupportWidgetState();
}

class _ProductDetailSupportWidgetState
    extends State<ProductDetailSupportWidget> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(() {
      final next = _pageController.page?.round() ?? 0;
      if (_currentPage != next) {
        setState(() {
          _currentPage = next;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isWebLarge = kIsWeb && MediaQuery.of(context).size.width > 1024;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorTheme.color.mediumBlue,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: kIsWeb
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () {
                  if (widget.from != null) {
                    context.go(widget.from!);
                  } else {
                    context.go('/homePage');
                  }
                },
              )
            : null,
        title: googleInterText(
          widget.product.productName,
          color: Colors.white,
          fontSize: 23,
        ),
        centerTitle: true,
      ),
      body: isWebLarge
          ? _buildWebLayout(context) // 💻 Web Layout
          : _buildMobileLayout(context), // 📱 Mobile Layout
    );
  }

  Widget _pageImage() {
    final imageCount = widget.product.productImage.length;

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: ScrollConfiguration(
            behavior: CustomScrollBehavior(),
            child: PageView.builder(
              controller: _pageController,
              itemCount: imageCount,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) => Image.network(
                widget.product.productImage[index],
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, stack) =>
                    const Icon(Icons.broken_image, size: 100),
              ),
            ),
          ),
        ),
        if (imageCount > 1)
          Positioned(
            bottom: 12, // distance from bottom
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.product.productImage.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: _currentPage == index ? 20 : 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? Colors.blue : Colors.white70,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  /// 📱 Mobile layout (Column)
  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          AspectRatio(
            aspectRatio: 1,
            child: _pageImage(),
          ),
          const SizedBox(height: 16),

          // Name & Price
          googleInterText(
            widget.product.productName,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          const SizedBox(height: 8),
          googleInterText(
            "\$${widget.product.productPrice}",
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.green,
          ),
          const SizedBox(height: 16),

          // Description
          googleInterText(
            widget.product.productDescription,
            fontWeight: FontWeight.normal,
            fontSize: 16,
          ),
          const SizedBox(height: 24),

          // Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorTheme.color.deepPuceColor,
                ),
                onPressed: () {
                  // TODO: add to favorites
                },
                icon: const Icon(Icons.favorite_border),
                label: const Text("Favorite"),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorTheme.color.mediumBlue,
                ),
                onPressed: () {
                  // TODO: add to cart
                },
                icon: const Icon(Icons.shopping_cart_outlined),
                label: const Text("Add to Cart"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 💻 Web layout (Row with image left, details right)
  Widget _buildWebLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Side - Product Image
          Expanded(
            flex: 5,
            child: AspectRatio(
              aspectRatio: 1,
              child: _pageImage(),
            ),
          ),
          const SizedBox(width: 32),

          // Right Side - Product Details
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                googleInterText(
                  widget.product.productName,
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
                const SizedBox(height: 12),
                googleInterText(
                  "\$${widget.product.productPrice}",
                  fontWeight: FontWeight.w600,
                  fontSize: 24,
                  color: Colors.green,
                ),
                const SizedBox(height: 24),
                googleInterText(
                  widget.product.productDescription,
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                ),
                const SizedBox(height: 32),

                // Action Buttons
                Row(
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorTheme.color.deepPuceColor,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                      ),
                      onPressed: () {
                        // TODO: add to favorites
                      },
                      icon: const Icon(Icons.favorite_border),
                      label: const Text("Favorite"),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorTheme.color.mediumBlue,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                      ),
                      onPressed: () {
                        // TODO: add to cart
                      },
                      icon: const Icon(Icons.shopping_cart_outlined),
                      label: const Text("Add to Cart"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
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
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_vendor/utils/widget/space_widget_utils.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../controllers/product_controllers.dart';
import '../../../../../models/product_model.dart';
import '../../../../../utils/code/quantity_code_utils.dart';
import '../../../../../utils/fonts/google_fonts_utils.dart';
import '../../../../../utils/theme/color/color_theme.dart';
import '../../../../../utils/widget/banner_widget_support_user.dart';
import '../reuse_widget_support.dart';

class ProductDetailSupportWidget extends StatefulWidget {
  final ProductModel product;
  final String? from;
  final bool listView;

  const ProductDetailSupportWidget({
    super.key,
    required this.product,
    this.from,
    this.listView = false,
  });

  @override
  State<ProductDetailSupportWidget> createState() =>
      _ProductDetailSupportWidgetState();
}

class _ProductDetailSupportWidgetState
    extends State<ProductDetailSupportWidget> {
  final ProductController productController = ProductController();

  late PageController _pageController;

  int _currentPage = 0;
  int selectedQty = 1;

  bool _isFavorite = false;

  List<Color>? gradientColors;
  late Future<List<ProductModel>> _categoryProducts;

  final Set<int> favoriteIndexes = {};
  final Set<int> cartIndexes = {};

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

    _categoryProducts =
        productController.fetchProductCategory(widget.product.productCategory);
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

  bool isWebLarge() {
    return kIsWeb && MediaQuery.of(context).size.width > 1024;
  }

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
      body: isWebLarge()
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

  Widget _offer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        googleInterText(
          "Limited Time Deal",
          fontWeight: FontWeight.bold,
          color: ColorTheme.color.lustRedColor,
          fontSize: isWebLarge() ? 29 : 25,
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(
                size: 26,
                _isFavorite ? Icons.favorite : Icons.favorite_border,
                color:
                    _isFavorite ? ColorTheme.color.lustRedColor : Colors.black,
              ),
              onPressed: () {
                setState(() {
                  _isFavorite = !_isFavorite;
                });
              },
            ),
            // 📤 Share button
            IconButton(
              icon: const Icon(Icons.share, color: Colors.black),
              onPressed: () async {
                final productLink =
                    "https://yourapp.com/product/${widget.product.id}";

                final params = ShareParams(
                  text:
                      "Check out this ${widget.product.productName}.\n$productLink",
                );

                await SharePlus.instance.share(params);
              },
            ),

            if (kIsWeb)
              SizedBox(
                width: 5,
              ),
          ],
        ),
      ],
    );
  }

  Widget _about() {
    return googleInterText(
      "Description",
      fontWeight: isWebLarge() ? FontWeight.w500 : FontWeight.w400,
      color: ColorTheme.color.grayColor,
      fontSize: isWebLarge() ? 18 : 17,
    );
  }

  Widget _nameCode() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        googleInterText(
          widget.product.productName,
          fontWeight: FontWeight.w600,
          fontSize: isWebLarge() ? 26 : 22,
        ),
        Row(
          children: [
            googleInterText(
              widget.product.productCategory,
              fontWeight: FontWeight.w400,
              color: ColorTheme.color.buttonBackgroundColor,
              fontSize: 15,
            ),
            if (kIsWeb)
              SizedBox(
                width: 20,
              )
          ],
        ),
      ],
    );
  }

  Widget _productPrice() {
    return googleInterText(
      "₹${widget.product.productPrice}",
      fontWeight: FontWeight.w600,
      fontSize: isWebLarge() ? 20 : 16,
      color: Colors.green,
    );
  }

  Widget containerButton(
    String text,
    IconData icon,
    final VoidCallback? onPressed,
  ) {
    return Container(
      width: double.maxFinite,
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: gradientColors != null
            ? LinearGradient(
                colors: gradientColors!,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: gradientColors == null
            ? const Color.fromRGBO(36, 124, 255, 1)
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: ColorTheme.color.whiteColor,
          ),
          TextButton(
            onPressed: onPressed,
            style: ButtonStyle(
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              padding: WidgetStateProperty.all<EdgeInsets>(
                EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
              ),
            ),
            child: googleInterText(
              text,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget similarCategoryProduct() {
    return FutureBuilder<List<ProductModel>>(
      future: _categoryProducts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("No similar products found"));
        }

        final categoryProducts =
            snapshot.data!.where((p) => p.id != widget.product.id).toList();

        return futureBuilderProduct(
          context,
          Future.value(categoryProducts),
          "No Similar Products",
          widget.listView,
          favoriteIndexes,
          cartIndexes,
          (index) {
            setState(() {
              if (favoriteIndexes.contains(index)) {
                favoriteIndexes.remove(index);
              } else {
                favoriteIndexes.add(index);
              }
            });
          },
          (index) {
            setState(() {
              if (cartIndexes.contains(index)) {
                cartIndexes.remove(index);
              } else {
                cartIndexes.add(index);
              }
            });
          },
        );
      },
    );
  }

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
          _offer(),
          const SizedBox(height: 8),
          _nameCode(),
          const SizedBox(height: 4),
          _productPrice(),
          const SizedBox(height: 18),
          _about(),
          const SizedBox(height: 4),
          googleInterText(
            widget.product.productDescription,
            fontWeight: FontWeight.normal,
            fontSize: 16,
          ),
          const SizedBox(height: 10),
          const Divider(),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: QuantitySelectorFullWidth(
              width: 220,
              initialQuantity: selectedQty,
              onChanged: (value) {
                setState(() {
                  selectedQty = value;
                });
              },
            ),
          ),
          sizedBoxH10(),
          Row(
            children: [
              Expanded(
                  child: containerButton(
                      'Buy', Icons.shopping_bag_outlined, () {})),
              SizedBox(
                width: 16,
              ),
              Expanded(
                child: containerButton('Add to Carts',
                    Icons.shopping_cart_checkout_outlined, () {}),
              ),
            ],
          ),
          sizedBoxH10(),
          const Divider(),
          sizedBoxH10(),
          similarCategoryProduct(),
        ],
      ),
    );
  }

  /// 💻 Web layout (Row with image left, details right)
  Widget _buildWebLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: AspectRatio(
                aspectRatio: 1,
                child: _pageImage(),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            VerticalDivider(
              thickness: 1,
              color: Colors.grey,
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _offer(),
                  const SizedBox(height: 8),
                  _nameCode(),
                  const SizedBox(height: 4),
                  _productPrice(),
                  const SizedBox(height: 18),
                  _about(),
                  const SizedBox(height: 4),
                  googleInterText(
                    widget.product.productDescription,
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                  ),
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: QuantitySelectorFullWidth(
                      width: 220,
                      initialQuantity: selectedQty,
                      onChanged: (value) {
                        setState(() {
                          selectedQty = value;
                        });
                      },
                    ),
                  ),
                  sizedBoxH10(),
                  Row(
                    children: [
                      Expanded(
                          child: containerButton(
                              'Buy', Icons.shopping_bag_outlined, () {})),
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: containerButton('Add to Carts',
                            Icons.shopping_cart_checkout_outlined, () {}),
                      ),
                    ],
                  ),
                  sizedBoxH10(),
                  const Divider(),
                  sizedBoxH10(),
                  similarCategoryProduct(),
                ],
              ),
            ),
          ],
        ),
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
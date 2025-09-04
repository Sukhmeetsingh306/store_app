import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:multi_vendor/controllers/product_controllers.dart';

import '../../../../models/product_model.dart';
import '../../../../utils/fonts/google_fonts_utils.dart';
import '../../../../utils/fonts/row_text_sands.dart';
import '../../../../utils/theme/color/color_theme.dart';
import '../../../../utils/widget/platform/platform_check.dart';

class PopularProductSupportWidget extends StatefulWidget {
  final bool listView;
  final bool? showHeadingRow;
  final bool? productFavorite;

  const PopularProductSupportWidget(
      {super.key,
      this.showHeadingRow = true,
      this.listView = false,
      this.productFavorite});

  @override
  State<PopularProductSupportWidget> createState() =>
      _PopularProductSupportWidgetState();
}

class _PopularProductSupportWidgetState
    extends State<PopularProductSupportWidget> {
  late Future<List<ProductModel>> popularProductsFuture;
  final Set<int> favoriteIndexes = {};
  bool cart = false;
  Set<int> cartIndexes = {};

  @override
  void initState() {
    super.initState();
    popularProductsFuture = ProductController().fetchPopularProduct();
  }

  @override
  Widget build(BuildContext context) {
    bool isWebMobile = kIsWeb && MediaQuery.of(context).size.width > 1026;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showHeadingRow!) ...[
            if ((defaultTargetPlatform == TargetPlatform.iOS ||
                    defaultTargetPlatform == TargetPlatform.android) &&
                widget.listView == false)
              RowTextSands(
                title: 'Popular Product:',
                subTitle: ' View All',
              ),
            if (kIsWeb)
              RowTextSands(
                title: 'Popular Product:',
                subTitle: ' View All',
                mainAxisAlignment: kIsWeb && (isIOSWeb() || isAndroidWeb())
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.spaceEvenly,
              ),
          ],
          FutureBuilder(
            future: popularProductsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return errormessage("Error: ${snapshot.error}");
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: googleInterText(
                    "No Popular Products",
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                  ),
                );
              } else {
                final popularProducts = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: widget.listView
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: popularProducts.length,
                          itemBuilder: (context, index) {
                            final product = popularProducts[index];
                            return ListTile(
                              leading: Image.network(
                                product.productImage[0],
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                              title: googleInterText(
                                product.productName,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              subtitle: googleInterText(
                                "₹${product.productPrice.toStringAsFixed(2)}",
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                              ),
                            );
                          },
                        )
                      : SizedBox(
                          height: isWebMobile ? 300 : 250,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: popularProducts.length,
                            itemBuilder: (context, index) {
                              final product = popularProducts[index];
                              return Container(
                                decoration: BoxDecoration(
                                  color: ColorTheme.color.whiteColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                width: isWebMobile ? 200 : 160,
                                margin: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AspectRatio(
                                      aspectRatio: 1,
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                            ),
                                            child: Image.network(
                                              product.productImage[0],
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: double.infinity,
                                            ),
                                          ),
                                          Positioned(
                                            top: 8,
                                            right: 9,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  if (favoriteIndexes
                                                      .contains(index)) {
                                                    favoriteIndexes
                                                        .remove(index);
                                                  } else {
                                                    favoriteIndexes.add(index);
                                                  }
                                                });
                                              },
                                              child: AnimatedSwitcher(
                                                duration: const Duration(
                                                    milliseconds: 300),
                                                transitionBuilder:
                                                    (child, animation) {
                                                  return ScaleTransition(
                                                    scale: CurvedAnimation(
                                                      parent: animation,
                                                      curve: Curves.easeInOut,
                                                    ),
                                                    child: child,
                                                  );
                                                },
                                                child: Icon(
                                                  favoriteIndexes
                                                          .contains(index)
                                                      ? Icons.favorite
                                                      : Icons.favorite_border,
                                                  key: ValueKey<bool>(
                                                      favoriteIndexes.contains(
                                                          index)), // ensures animation triggers
                                                  color: favoriteIndexes
                                                          .contains(index)
                                                      ? Colors.red
                                                      : Colors.grey,
                                                  size: 24,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          googleInterText(
                                            product.productName,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              googleInterText(
                                                "₹${product.productPrice.toStringAsFixed(2)}",
                                                fontWeight: FontWeight.normal,
                                                fontSize: 14,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    if (cartIndexes
                                                        .contains(index)) {
                                                      cartIndexes.remove(
                                                          index); // remove from cart
                                                    } else {
                                                      cartIndexes.add(
                                                          index); // add to cart
                                                    }
                                                  });
                                                },
                                                child: AnimatedSwitcher(
                                                  duration: const Duration(
                                                      milliseconds: 300),
                                                  transitionBuilder:
                                                      (child, animation) {
                                                    return ScaleTransition(
                                                      scale: CurvedAnimation(
                                                        parent: animation,
                                                        curve: Curves.easeInOut,
                                                      ),
                                                      child: child,
                                                    );
                                                  },
                                                  child: Icon(
                                                    cartIndexes.contains(index)
                                                        ? Icons.shopping_cart
                                                        : Icons
                                                            .shopping_cart_outlined,
                                                    key: ValueKey<bool>(
                                                        cartIndexes.contains(
                                                            index)), // triggers animation
                                                    color: cartIndexes
                                                            .contains(index)
                                                        ? ColorTheme
                                                            .color.dodgerBlue
                                                        : Colors.grey,
                                                    size: 26,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

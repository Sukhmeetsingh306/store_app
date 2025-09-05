import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../utils/fonts/google_fonts_utils.dart';
import '../../../../utils/theme/color/color_theme.dart';

Widget futureBuilderProduct(
  BuildContext context,
  Future future,
  String errorText,
  bool listView,
  Set<int> favoriteIndexes,
  Set<int> cartIndexes,
  void Function(int index)? onFavoritePressed,
  void Function(int index)? onCartPressed,
) {
  bool isWebMobile = kIsWeb && MediaQuery.of(context).size.width > 1026;

  return FutureBuilder(
    future: future,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text("Error: ${snapshot.error}"));
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return Center(
          child: googleInterText(
            errorText,
            fontWeight: FontWeight.normal,
            fontSize: 18,
          ),
        );
      } else {
        final popularProducts = snapshot.data!;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: listView
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
                  height: isWebMobile ? 320 : 270,
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
                                    borderRadius: const BorderRadius.only(
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
                                      onTap: () =>
                                          onFavoritePressed?.call(index),
                                      child: AnimatedSwitcher(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        transitionBuilder: (child, animation) {
                                          return ScaleTransition(
                                            scale: CurvedAnimation(
                                              parent: animation,
                                              curve: Curves.easeInOut,
                                            ),
                                            child: child,
                                          );
                                        },
                                        child: Icon(
                                          favoriteIndexes.contains(index)
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          key: ValueKey<bool>(
                                              favoriteIndexes.contains(index)),
                                          color: favoriteIndexes.contains(index)
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  googleInterText(
                                    product.productName,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    maxLines: 2, // ✅ allow wrapping
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
                                        onTap: () => onCartPressed?.call(index),
                                        child: AnimatedSwitcher(
                                          duration:
                                              const Duration(milliseconds: 300),
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
                                                : Icons.shopping_cart_outlined,
                                            key: ValueKey<bool>(
                                                cartIndexes.contains(index)),
                                            color: cartIndexes.contains(index)
                                                ? ColorTheme.color.dodgerBlue
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
  );
}

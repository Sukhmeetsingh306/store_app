import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../models/api/subcategory_api_models.dart';
import '../../../../provider/cart_provider.dart';
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
  WidgetRef ref,
) {
  bool isWebMobile = kIsWeb && MediaQuery.of(context).size.width > 1026;
  final cartProviderRef = ref.read(cartProvider.notifier);

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
                                  InkWell(
                                    onTap: () {
                                      final jsonString =
                                          jsonEncode(product.toJson());
                                      String path =
                                          '/product/productDetail/${product.productName}';

                                      if (kIsWeb) {
                                        final currentLocation =
                                            GoRouterState.of(context)
                                                .uri
                                                .toString();
                                        context.go(
                                          path,
                                          extra: {
                                            "product": jsonString,
                                            "from": currentLocation,
                                          },
                                        );
                                      } else {
                                        context.push(
                                          path,
                                          extra: {
                                            "product": jsonString,
                                          },
                                        );
                                      }
                                    },
                                    child: ClipRRect(
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
                                    maxLines: 2,
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
                                          final product =
                                              popularProducts[index];

                                          if (cartIndexes.contains(index)) {
                                            cartIndexes.remove(index);
                                            cartProviderRef
                                                .removeProductFromCart(
                                                    product.id);

                                            Flushbar(
                                              messageText: googleInterText(
                                                '${product.productName} removed from cart',
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                              ),
                                              backgroundColor: Colors.redAccent,
                                              margin: const EdgeInsets.all(16),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              duration:
                                                  const Duration(seconds: 2),
                                              animationDuration: const Duration(
                                                  milliseconds: 500),
                                              forwardAnimationCurve:
                                                  Curves.easeOutBack,
                                              reverseAnimationCurve:
                                                  Curves.easeInBack,
                                            ).show(context);
                                          } else {
                                            // 👉 Add to cart
                                            cartIndexes.add(index);

                                            cartProviderRef.addProductToCart(
                                              productName: product.productName,
                                              productPrice:
                                                  product.productPrice,
                                              productCategory:
                                                  product.productCategory,
                                              productImage:
                                                  product.productImage,
                                              sellerId: product.sellerId,
                                              productQuantity: 1,
                                              totalQuantity:
                                                  product.productQuantity,
                                              productId: product
                                                  .id, // use correct field from ProductModel
                                              productDescription:
                                                  product.productDescription,
                                              fullName: product
                                                  .sellerName, // or another field if different
                                            );

                                            Flushbar(
                                              messageText: googleInterText(
                                                '${product.productName} added to cart',
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                              ),
                                              backgroundColor: Colors.black87,
                                              margin: const EdgeInsets.all(16),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              duration:
                                                  const Duration(seconds: 2),
                                              animationDuration: const Duration(
                                                  milliseconds: 500),
                                              forwardAnimationCurve:
                                                  Curves.easeOutBack,
                                              reverseAnimationCurve:
                                                  Curves.easeInBack,
                                            ).show(context);
                                          }

                                          // 🔄 Refresh UI
                                          (context as Element).markNeedsBuild();
                                        },
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

Widget futureBuilderSubCategory(
  BuildContext context,
  Future<List<SubCategoryApiModels>> future,
  String errorText, {
  bool horizontalScroll = false,
}) {
  final isWebMobile = kIsWeb && MediaQuery.of(context).size.width > 1024;

  return FutureBuilder<List<SubCategoryApiModels>>(
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
        final subCategories = snapshot.data!;

        if (horizontalScroll) {
          return SizedBox(
            height: isWebMobile ? 255 : 205,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: subCategories.length,
              itemBuilder: (context, index) {
                final subCategory = subCategories[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: subCategoryCard(context, subCategory),
                );
              },
            ),
          );
        } else {
          final crossAxis = isWebMobile ? 5 : 4;
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: subCategories.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxis,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemBuilder: (context, index) {
              final subCategory = subCategories[index];
              return subCategoryCard(context, subCategory);
            },
          );
        }
      }
    },
  );
}

Widget subCategoryCard(
  BuildContext context,
  SubCategoryApiModels subCategory,
) {
  return Container(
    decoration: BoxDecoration(
      color: ColorTheme.color.whiteColor,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withAlpha(2),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    width: kIsWeb && MediaQuery.of(context).size.width > 1024 ? 180 : 140,
    margin: const EdgeInsets.all(4),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            child: Image.network(
              subCategory.subCategoryImage,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: googleInterText(
            subCategory.subCategoryName,
            fontWeight: FontWeight.w500,
            fontSize: 14,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:multi_vendor/controllers/product_controllers.dart';

import '../../../../../models/product_model.dart';
import '../../../../../utils/fonts/row_text_sands.dart';
import '../../../../../utils/widget/platform/platform_check.dart';
import '../reuse_widget_support.dart';

class PopularProductSupportWidget extends StatefulWidget {
  final bool listView;
  final bool? showHeadingRow;

  const PopularProductSupportWidget({
    super.key,
    this.showHeadingRow = true,
    this.listView = false,
  });

  @override
  State<PopularProductSupportWidget> createState() =>
      _PopularProductSupportWidgetState();
}

class _PopularProductSupportWidgetState
    extends State<PopularProductSupportWidget> {
  late Future<List<ProductModel>> popularProductsFuture;
  final Set<int> favoriteIndexes = {};
  final Set<int> cartIndexes = {};

  @override
  void initState() {
    super.initState();
    popularProductsFuture = ProductController().fetchPopularProduct();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showHeadingRow!) ...[
            if ((defaultTargetPlatform == TargetPlatform.iOS ||
                    defaultTargetPlatform == TargetPlatform.android) &&
                widget.listView == false)
              const RowTextSands(
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
          futureBuilderProduct(
            context,
            popularProductsFuture,
            "No Popular Products",
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
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:store_app/models/api/category_api_models.dart';

import '../../../../components/code/text/googleFonts.dart';
import '../../../../controllers/category_controllers.dart';

class CategoryWidget extends StatefulWidget {
  const CategoryWidget({super.key});

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  late Future<List<CategoryApiModels>> futureCategory;

  @override
  void initState() {
    super.initState();
    futureCategory = CategoryControllers().fetchCategory();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureCategory,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return errormessage("Error: ${snapshot.error}");
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: googleText(
              "No Category found",
              fontWeight: FontWeight.normal,
              fontSize: 18,
            ),
          );
        } else {
          final categoryCount = snapshot.data!;
          return GridView.builder(
            itemCount: categoryCount.length,
            shrinkWrap: true,
            physics: defaultTargetPlatform == TargetPlatform.iOS
                ? NeverScrollableScrollPhysics()
                : null,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: defaultTargetPlatform == TargetPlatform.iOS
                  ? 4 // ios
                  : 6, // web
              crossAxisSpacing: 15,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              final category = categoryCount[index];
              return Column(
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 3.0),
                      child: Image.network(
                        width: defaultTargetPlatform == TargetPlatform.iOS
                            ? MediaQuery.of(context).size.width * 1
                            : MediaQuery.of(context).size.width * 0.2,
                        height: defaultTargetPlatform == TargetPlatform.iOS
                            ? MediaQuery.of(context).size.height * 1
                            : MediaQuery.of(context).size.height * 0.18,
                        category.categoryImage,
                      ),
                    ),
                  ),
                  Flexible(
                    child: googleTextSands(
                      category.categoryName,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }
}

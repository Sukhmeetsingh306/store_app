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
              "No banners found",
              fontWeight: FontWeight.normal,
              fontSize: 18,
            ),
          );
        } else {
          final categoryCount = snapshot.data!;
          return GridView.builder(
            itemCount: categoryCount.length,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              crossAxisSpacing: 15,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              final category = categoryCount[index];
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                      width: 100,
                      height: 10,
                      category.categoryImage,
                    ),
                  ),
                  googleText(category.categoryName),
                ],
              );
            },
          );
        }
      },
    );
  }
}

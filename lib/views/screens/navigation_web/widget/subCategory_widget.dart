// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:store_app/controllers/subCategory_controllers.dart';

import '../../../../components/code/text/googleFonts.dart';
import '../../../../models/api/subCategory_api_models.dart';

class SubCategoryWidget extends StatefulWidget {
  const SubCategoryWidget({super.key});

  @override
  State<SubCategoryWidget> createState() => _SubCategoryWidgetState();
}

class _SubCategoryWidgetState extends State<SubCategoryWidget> {
  late Future<List<SubCategoryApiModels>> futureSubCategory;

  @override
  void initState() {
    super.initState();
    futureSubCategory = SubCategoryControllers().fetchSubCategories();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureSubCategory,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return errormessage("Error: ${snapshot.error}");
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: googleText(
              "No Sub Category found",
              fontWeight: FontWeight.normal,
              fontSize: 18,
            ),
          );
        } else {
          final subCategoryCount = snapshot.data!;
          return GridView.builder(
            itemCount: subCategoryCount.length,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              crossAxisSpacing: 15,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              final subCategory = subCategoryCount[index];
              return Column(
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 3.0),
                      child: Image.network(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.height * 0.15,
                        subCategory.subCategoryImage,
                      ),
                    ),
                  ),
                  Flexible(
                    child: googleText(
                      subCategory.subCategoryName,
                      fontWeight: FontWeight.w500,
                      fontSize: 19,
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

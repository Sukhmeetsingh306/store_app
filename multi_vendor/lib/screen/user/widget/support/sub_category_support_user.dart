// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../controllers/subCategory_controllers.dart';
import '../../../../models/api/subcategory_api_models.dart';
import '../../../../utils/fonts/google_fonts_utils.dart';

class SubCategorySupportUser extends StatefulWidget {
  final Future<List<SubCategoryApiModels>>? future;
  const SubCategorySupportUser({
    super.key,
    this.future,
  });

  @override
  State<SubCategorySupportUser> createState() => _SubCategorySupportUserState();
}

class _SubCategorySupportUserState extends State<SubCategorySupportUser> {
  late Future<List<SubCategoryApiModels>> futureSubCategory;

  @override
  void initState() {
    super.initState();
    futureSubCategory = SubCategoryControllers().fetchSubCategories();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return FutureBuilder(
      future: widget.future ?? futureSubCategory,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return errormessage("Error: ${snapshot.error}");
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Center(
              child: googleTextRob(
                "No Sub Category ",
                fontWeight: FontWeight.normal,
                fontSize: 16,
                letterSpacing: 1.4,
              ),
            ),
          );
        } else {
          final subCategoryCount = snapshot.data!;
          if (defaultTargetPlatform == TargetPlatform.iOS) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: List.generate(
                  // change the element count in the row
                  (subCategoryCount.length / 7).ceil(),
                  (setIndex) {
                    final start = setIndex * 7;
                    final end = (setIndex + 1) * 7;
                    final subCategorySubset = subCategoryCount.sublist(
                      start,
                      end > subCategoryCount.length
                          ? subCategoryCount.length
                          : end,
                    );

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        spacing: 8,
                        children: subCategorySubset
                            .map((subCategory) => subCategoryMobileStyleDisplay(
                                context,
                                subCategory.subCategoryImage,
                                subCategory.subCategoryName))
                            .toList(),
                      ),
                    );
                  },
                ),
              ),
            );
          } else if (kIsWeb) {
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
                        child: googleInterText(
                          subCategory.subCategoryName,
                          fontWeight: FontWeight.w500,
                          fontSize: 19,
                        ),
                      ),
                    ],
                  );
                });
          } else {
            // Default return for other platforms
            return Center(
              child: googleInterText(
                "Unsupported platform",
                fontWeight: FontWeight.normal,
                fontSize: 18,
              ),
            );
          }
        }
      },
    );
  }
}

Widget subCategoryMobileStyleDisplay(
  BuildContext context,
  String image,
  String title,
) {
  return Column(
    children: [
      Container(
        width: MediaQuery.of(context).size.width * 0.2,
        height: MediaQuery.of(context).size.height * 0.15,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image.network(
            width: MediaQuery.of(context).size.width * 0.2,
            height: MediaQuery.of(context).size.height * 0.15,
            image,
          ),
        ),
      ),
      const SizedBox(height: 8),
      SizedBox(
        width: MediaQuery.of(context).size.width * .11,
        child: googleTextRob(title),
      )
    ],
  );
}

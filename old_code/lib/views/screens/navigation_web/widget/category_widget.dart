import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:store_app/controllers/subCategory_controllers.dart';
import 'package:store_app/models/api/category_api_models.dart';
import 'package:store_app/models/api/subCategory_api_models.dart';
import 'package:store_app/models/navigate_models.dart';
import 'package:store_app/views/screens/navigation_mobile/screens/inner_category_screen.dart';

import '../../../../components/code/text/googleFonts.dart';
import '../../../../components/code/text/row_text.dart';
import '../../../../components/color/color_theme.dart';
import '../../../../controllers/category_controllers.dart';

class CategoryWidget extends StatefulWidget {
  final bool listView;

  const CategoryWidget({super.key, this.listView = false});

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  late Future<List<CategoryApiModels>> futureCategory;
  CategoryApiModels? _selectedCategory;

  List<SubCategoryApiModels> _subCategory = [];
  final SubCategoryControllers _subCategoryControllers =
      SubCategoryControllers();

  @override
  void initState() {
    super.initState();
    futureCategory = CategoryControllers().fetchCategory();

    futureCategory.then((categories) {
      for (var category in categories) {
        if (category.categoryName == "Fashion") {
          // make the code that it pick the every first category
          setState(() {
            _selectedCategory = category;
          });
          _loadSubCategory(category.categoryName);
        }
      }
    });
  }

  Future<void> _loadSubCategory(String categoryName) async {
    final subCategory = await _subCategoryControllers
        .getSubCategoryByCategoryName(categoryName);
    setState(() {
      _subCategory = subCategory;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (defaultTargetPlatform == TargetPlatform.iOS &&
            widget.listView == false)
          RowTextSands(
            title: 'Categories:',
            subTitle: ' View All',
          ),
        FutureBuilder(
          future: futureCategory,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
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
//MARK: Code for mobile category screen
              if (widget.listView == true) {
                return SingleChildScrollView(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          color: Colors.grey.shade300,
                          height: MediaQuery.of(context).size.height * 0.7,
                          width: MediaQuery.of(context).size.width * 0.02,
                          child: ListView.builder(
                            itemCount: categoryCount.length,
                            itemBuilder: (context, index) {
                              final category = categoryCount[index];
                              return ListTile(
                                onTap: () {
                                  setState(() {
                                    _selectedCategory = category;
                                  });
                                  _loadSubCategory(category.categoryName);
                                },
                                title: googleTextSands(
                                  category.categoryName,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: _selectedCategory == category
                                      ? ColorTheme.color.dodgerBlue
                                      : ColorTheme.color.blackColor,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: _selectedCategory != null
                            ? SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: googleTextSands(
                                        _selectedCategory!.categoryName,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        letterSpacing: 1.7,
                                      ),
                                    ),
                                    Container(
                                      height: 150,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            _selectedCategory!.categoryBanner,
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    _subCategory.isNotEmpty
                                        ? GridView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            padding: const EdgeInsets.all(4),
                                            shrinkWrap: true,
                                            itemCount: _subCategory.length,
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3,
                                              mainAxisSpacing: 4,
                                              crossAxisSpacing: 8,
                                              childAspectRatio: 2 / 3,
                                            ),
                                            itemBuilder: (context, index) {
                                              final subCategory =
                                                  _subCategory[index];

                                              return Column(
                                                children: [
                                                  Container(
                                                    width: 50,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[200],
                                                    ),
                                                    child: Center(
                                                      child: Image.network(
                                                        subCategory
                                                            .subCategoryImage,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  Center(
                                                    child: googleTextSands(
                                                      subCategory
                                                          .subCategoryName,
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                              child: googleTextSands(
                                                'No Sub-Category',
                                                fontSize: 18,
                                                letterSpacing: 1.5,
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                              )
                            : Container(
                                color: Colors.grey.shade300,
                                height:
                                    MediaQuery.of(context).size.height * 0.7,
                                width: MediaQuery.of(context).size.width * 0.02,
                              ),
                      ),
                    ],
                  ),
                );
              }
//MARK: Code for Web View
              return GridView.builder(
                padding: const EdgeInsets.only(top: 10),
                itemCount: categoryCount.length,
                shrinkWrap: true,
                physics: defaultTargetPlatform == TargetPlatform.iOS ||
                        defaultTargetPlatform == TargetPlatform.android
                    ? NeverScrollableScrollPhysics()
                    : null,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: defaultTargetPlatform == TargetPlatform.iOS ||
                          defaultTargetPlatform == TargetPlatform.android
                      ? 4 // ios
                      : 6, // web
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  final category = categoryCount[index];
                  return InkWell(
                    onTap: () => materialRouteNavigator(
                      context,
                      InnerCategoryScreen(
                        category: category,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Image.network(
                            width:
                                defaultTargetPlatform == TargetPlatform.iOS ||
                                        defaultTargetPlatform ==
                                            TargetPlatform.android
                                    ? MediaQuery.of(context).size.width * 0.15
                                    : MediaQuery.of(context).size.width * 0.2,
                            height:
                                defaultTargetPlatform == TargetPlatform.iOS ||
                                        defaultTargetPlatform ==
                                            TargetPlatform.android
                                    ? MediaQuery.of(context).size.height * 0.15
                                    : MediaQuery.of(context).size.height * 0.10,
                            category.categoryImage,
                            fit: BoxFit.cover,
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
                    ),
                  );
                },
              );
            }
          },
        ),
      ],
    );
  }
}

/*

 */

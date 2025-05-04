import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:multi_vendor/utils/widget/platform/platform_check_web.dart';
import '../../../../controllers/category_controllers.dart';
import '../../../../controllers/subCategory_controllers.dart';
import '../../../../models/api/category_api_models.dart';
import '../../../../models/api/subcategory_api_models.dart';
import '../../../../utils/fonts/google_fonts_utils.dart';
import '../../../../utils/fonts/row_text_sands.dart';
import '../../../../utils/routes/navigation_routes.dart';
import '../../../../utils/theme/color/color_theme.dart';
import '../inner_category_widget_user.dart';

class CategoryWidgetSupportUser extends StatefulWidget {
  final bool listView;
  final bool? showHeadingRow;

  const CategoryWidgetSupportUser(
      {super.key, this.listView = false, this.showHeadingRow = true});

  @override
  State<CategoryWidgetSupportUser> createState() =>
      _CategoryWidgetSupportUserState();
}

class _CategoryWidgetSupportUserState extends State<CategoryWidgetSupportUser> {
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
    bool isWebMobile = kIsWeb && MediaQuery.of(context).size.width > 1026;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showHeadingRow!) ...[
          if ((defaultTargetPlatform == TargetPlatform.iOS ||
                  defaultTargetPlatform == TargetPlatform.android) &&
              widget.listView == false)
            RowTextSands(
              title: 'Categories:',
              subTitle: ' View All',
            ),
          if (kIsWeb)
            RowTextSands(
              title: 'Categories:',
              subTitle: ' View All',
              mainAxisAlignment: isWebMobileWeb()
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.spaceEvenly,
            ),
        ],
        FutureBuilder(
          future: futureCategory,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return errormessage("Error: ${snapshot.error}");
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: googleInterText(
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
                      Flexible(
                        flex: 1,
                        child: Container(
                          color: Colors.grey.shade300,
                          height: MediaQuery.of(context).size.height *
                              (kIsWeb ? 0.82 : 0.7),
                          width: MediaQuery.of(context).size.width *
                              (isWebMobile ? 0.2 : (kIsWeb ? 0.3 : 0.34)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: googleInterText(
                                  "Category",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: ColorTheme.color.dodgerBlue,
                                ),
                              ),
                              Flexible(
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: categoryCount.length,
                                  itemBuilder: (context, index) {
                                    final category = categoryCount[index];
                                    final bool isSelected =
                                        _selectedCategory == category;
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 8),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? ColorTheme.color.dodgerBlue
                                                .withAlpha(2)
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: ListTile(
                                        onTap: () {
                                          setState(() {
                                            _selectedCategory = category;
                                          });
                                          _loadSubCategory(
                                              category.categoryName);
                                        },
                                        title: googleInterText(
                                          category.categoryName,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          color: isSelected
                                              ? ColorTheme.color.dodgerBlue
                                              : ColorTheme.color.blackColor,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      _selectedCategory != null
                          ? isWebMobile
                              ? Flexible(
                                  flex: 1, child: singleChildCategoryInner())
                              : singleChildCategoryInner()
                          : Container(
                              color: Colors.grey.shade300,
                              height: MediaQuery.of(context).size.height * 0.7,
                              width: MediaQuery.of(context).size.width * 0.02,
                            ),
                    ],
                  ),
                );
              }
              //MARK: Code for Web View
              if (defaultTargetPlatform == TargetPlatform.iOS ||
                  defaultTargetPlatform == TargetPlatform.android ||
                  isWebMobileWeb()) {
                return GridView.builder(
                  padding: const EdgeInsets.only(top: 10),
                  itemCount: categoryCount.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 8,
                  ),
                  itemBuilder: (context, index) {
                    final category = categoryCount[index];
                    return InkWell(
                      onTap: () => materialRouteNavigator(
                        context,
                        InnerCategoryScreen(category: category),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Image.network(
                              category.categoryImage,
                              width: MediaQuery.of(context).size.width * 0.15,
                              height: MediaQuery.of(context).size.height * 0.15,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Flexible(
                            child: googleInterText(
                              category.categoryName,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else if (kIsWeb) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: categoryCount.map((category) {
                        return InkWell(
                          onTap: () => materialRouteNavigator(
                            context,
                            InnerCategoryScreen(
                              category: category,
                              showBottomNav: false,
                            ),
                          ),
                          child: Container(
                            width: 100,
                            margin: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 60,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      category.categoryImage,
                                      fit: BoxFit.contain, // avoids cropping
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                googleInterText(
                                  category.categoryName,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              }
              return Center(
                child: googleInterTextWeight4Font16('No Category Found'),
              );
            }
          },
        ),
      ],
    );
  }

  Widget singleChildCategoryInner() {
    bool isWebMobile = kIsWeb && MediaQuery.of(context).size.width > 1026;

    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width *
                (isWebMobile ? 0.9 : (kIsWeb ? 0.7 : 0.66)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: googleInterText(
                    _selectedCategory!.categoryName,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 1.7,
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
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
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(4),
                      itemCount: _subCategory.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 8,
                        childAspectRatio: 2 / 3,
                      ),
                      itemBuilder: (context, index) {
                        final subCategory = _subCategory[index];
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Center(
                                child: AspectRatio(
                              aspectRatio: isWebMobile ? 7 / 4 : 1,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    subCategory.subCategoryImage,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            )),
                            const SizedBox(height: 8),
                            Center(
                              child: googleInterText(
                                subCategory.subCategoryName,
                                fontWeight: FontWeight.w400,
                                fontSize: isWebMobile ? 18 : 12,
                              ),
                            ),
                          ],
                        );
                      },
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: googleInterText(
                          'No Sub-Category',
                          fontSize: 18,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

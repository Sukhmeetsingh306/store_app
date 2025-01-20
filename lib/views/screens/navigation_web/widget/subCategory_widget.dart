import 'package:flutter/material.dart';
import 'package:store_app/components/color/color_theme.dart';

import '../../../../components/code/text/googleFonts.dart';
import '../../../../controllers/category_controllers.dart';
import '../../../../models/api/category_api_models.dart';

class SubCategoryWidget extends StatefulWidget {
  final ValueSetter<CategoryApiModels?> onCategorySelected;

  const SubCategoryWidget({super.key, required this.onCategorySelected});

  @override
  State<SubCategoryWidget> createState() => _SubCategoryWidgetState();
}

class _SubCategoryWidgetState extends State<SubCategoryWidget> {
  late Future<List<CategoryApiModels>> futureSubCategory;
  CategoryApiModels? selectedCategory;

  @override
  void initState() {
    super.initState();
    futureSubCategory = CategoryControllers().fetchCategory();
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
              "No Category found",
              fontWeight: FontWeight.normal,
              fontSize: 18,
            ),
          );
        } else {
          return DropdownButton<CategoryApiModels>(
            value: selectedCategory,
            focusColor: ColorTheme.color.transparentBack,
              dropdownColor: ColorTheme.color.whiteColor,
              menuWidth: MediaQuery.of(context).size.width * 0.1,
              menuMaxHeight: MediaQuery.of(context).size.height * 0.3,
              elevation: 4,
            hint: googleText(
              "Select Category",
              fontWeight: FontWeight.normal,
              fontSize: 18,
            ),
            items: snapshot.data!.map((CategoryApiModels category) {
              return DropdownMenuItem<CategoryApiModels>(
                value: category,
                child: googleText(
                  category.categoryName,
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedCategory = value;
              });
              widget.onCategorySelected(value);
            },
          );
        }
      },
    );
  }
}

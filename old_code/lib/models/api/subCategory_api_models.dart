// ignore_for_file: file_names

import 'dart:convert';

class SubCategoryApiModels {
  final String subCategoryId;
  final String categoryId;
  final String categoryName;
  final String subCategoryImage;
  final String subCategoryName;

  SubCategoryApiModels({
    required this.subCategoryId,
    required this.categoryId,
    required this.categoryName,
    required this.subCategoryImage,
    required this.subCategoryName,
  });

  Map<String, dynamic> subCategoryToMap() {
    return <String, dynamic>{
      'subcategoryId': subCategoryId,
      'categoryId': subCategoryId,
      'categoryName': categoryName,
      'subCategoryImage': subCategoryImage,
      'subCategoryName': subCategoryName,
    };
  }

  factory SubCategoryApiModels.subCategoryFromMap(Map<String, dynamic> map){
    return SubCategoryApiModels(
      subCategoryId: map['_id'] as String,
      categoryId: map['categoryId'] as String,
      categoryName: map['categoryName'] as String,
      subCategoryImage: map['subCategoryImage'] as String,
      subCategoryName: map['subCategoryName'] as String,
    );
  }

  String subCategoryToJson() => json.encode(subCategoryToMap());
  //102145496211
}

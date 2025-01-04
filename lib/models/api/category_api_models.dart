import 'dart:convert';

class Category {
  final String categoryId;
  final String categoryName;
  final String categoryImage;
  final String categoryBanner;

  Category({
    required this.categoryId,
    required this.categoryName,
    required this.categoryImage,
    required this.categoryBanner,
  });

  Map<String, dynamic> categoryToMap() {
    // creating a map
    return <String, dynamic>{
      'categoryId': categoryId,
      'categoryName': categoryName,
      'categoryImage': categoryImage,
      'categoryBanner': categoryBanner,
    };
  }

  factory Category.categoryFromMap(Map<String, dynamic> map) {
    //getting from the map
    return Category(
      categoryId: map['categoryId'] as String,
      categoryName: map['categoryName'] as String,
      categoryImage: map['categoryImage'] as String,
      categoryBanner: map['categoryBanner'] as String,
    );
  }

  String categoryToJson() =>
      json.encode(categoryToMap()); // coding the map to the json

  factory Category.categoryFromJson(String source) => Category.categoryFromMap(
        json.decode(source) as Map<String, dynamic>,
      );
}

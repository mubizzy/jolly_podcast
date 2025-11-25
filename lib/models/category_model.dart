class Category {
  final String name;
  final String imageUrl;

  Category({
    required this.name,
    required this.imageUrl,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'] as String,
      imageUrl: json['image_url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image_url': imageUrl,
    };
  }
}

class CategoryGroup {
  final String name;
  final List<Category> categories;
  final List<String> images;

  CategoryGroup({
    required this.name,
    required this.categories,
    required this.images,
  });

  factory CategoryGroup.fromJson(Map<String, dynamic> json) {
    final categoriesData = json['categories'] as List<dynamic>? ?? [];
    final imagesData = json['images'] as List<dynamic>? ?? [];

    return CategoryGroup(
      name: json['name'] as String,
      categories: categoriesData
          .map((cat) => Category.fromJson(cat as Map<String, dynamic>))
          .toList(),
      images: imagesData.map((img) => img as String).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'categories': categories.map((cat) => cat.toJson()).toList(),
      'images': images,
    };
  }
}

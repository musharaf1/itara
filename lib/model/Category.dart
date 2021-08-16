import '../api/Resource.dart';

class Category {
  String? categorySlug;
  String? imageUrl;
  String? name;
  String? description;
  Category? parentCategory;
  List<Category>? subCategories = [];

  Category({
    this.categorySlug,
    this.imageUrl,
    this.name,
    this.description,
    this.subCategories,
    this.parentCategory,
  });

  factory Category.fromJson(Map json) {
    final Iterable _subCategories =
        json['subCategories'] == null ? [] : json['subCategories'];
    final _parentCategory = json['parentCategory'];

    return Category(
      categorySlug: json['categorySlug'],
      imageUrl: json['imageUrl'],
      name: json['name'],
      description: json['description'],
      subCategories: _subCategories != null
          ? _subCategories.map((data) {
              return Category.fromJson(data);
            }).toList()
          : [],
      parentCategory:
          _parentCategory != null ? Category.fromJson(_parentCategory) : null,
    );
  }

  Map toMap() {
    var data = Map<String, dynamic>();

    data['categorySlug'] = categorySlug;
    data['imageUrl'] = imageUrl;
    data['name'] = name;
    data['description'] = description;
    data['subCategories'] = subCategories != null
        ? subCategories!.map((data) {
            return data.toMap();
          }).toList()
        : [];
    data['parentCategory'] =
        parentCategory != null ? parentCategory!.toMap() : null;

    return data;
  }

  static Resource getCategories() {
    return Resource(
      url: 'categories',
      parse: (response) {
        return response;
      },
    );
  }
}

import 'Product.dart';

class FrontPageSection {
  String? frontPageSectionSlug;
  String? name;
  String? description;
  List<Product>? products;

  FrontPageSection({
    this.frontPageSectionSlug,
    this.name,
    this.description,
    this.products,
  });

  factory FrontPageSection.fromJson(Map json) {
    Iterable _products = json['products'];

    return FrontPageSection(
      frontPageSectionSlug: json['frontPageSectionSlug'],
      name: json['name'],
      description: json['description'],
      products: _products.map((model) {
        return Product.fromJson(model);
      }).toList(),
    );
  }

  Map toMap() {
    var data = Map<String, dynamic>();

    data['frontPageSectionSlug'] = frontPageSectionSlug;
    data['name'] = name;
    data['description'] = description;
    data['products'] = products!.map((data) {
      return data.toMap();
    }).toList();

    return data;
  }
}

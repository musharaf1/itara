import 'Category.dart';

class DiscoverSlide {
  String? productNumber;
  String? name;
  String? availableUntil;
  String? defaultImageUrl;
  String? price;
  String? timeCreated;
  Category? category;

  DiscoverSlide({
    this.productNumber,
    this.name,
    this.availableUntil,
    this.defaultImageUrl,
    this.price,
    this.timeCreated,
    this.category,
  });

  factory DiscoverSlide.fromJson(Map json) {
    // print(_category.name);
    // print(json['category']);

    return DiscoverSlide(
      productNumber: json['productNumber'],
      name: json['name'],
      availableUntil: json['availableUntil'],
      defaultImageUrl: json['defaultImageUrl'],
      price: json['price'],
      timeCreated: json['timeCreated'],
      category:
          json['category'] == null ? null : Category.fromJson(json['category']),
    );
  }

  Map toMap() {
    var data = Map<String, dynamic>();

    data['productNumber'] = productNumber;
    data['name'] = name;
    data['availableUntil'] = availableUntil;
    data['defaultImageUrl'] = defaultImageUrl;
    data['price'] = price;
    data['timeCreated'] = timeCreated;
    data['category'] = category == null ? null : category!.toMap();

    return data;
  }
}

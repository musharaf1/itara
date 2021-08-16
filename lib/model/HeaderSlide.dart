class HeaderSlide {
  String? categorySlug;
  String? imageUrl;
  String? name;

  HeaderSlide({
    this.categorySlug,
    this.name,
    this.imageUrl,
  });

  factory HeaderSlide.fromJson(Map json) {
    return HeaderSlide(
      categorySlug: json['categorySlug'],
      name: json['name'],
      imageUrl: json['imageUrl'],
    );
  }

  Map toMap() {
    var data = Map<String, dynamic>();

    data['name'] = name;
    data['imageUrl'] = imageUrl;
    data['categorySlug'] = categorySlug;

    return data;
  }
}

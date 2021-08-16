import 'dart:convert';

class Color {
  String? colorName;
  String? colorCode;

  Color({
    this.colorName,
    this.colorCode,
  });

  factory Color.fromJson(Map json) {
    return Color(
      colorName: json['colorName'],
      colorCode: json['colorCode'],
    );
  }

  Map toMap() {
    final data = Map<String, dynamic>();

    data['colorName'] = colorName;
    data['colorCode'] = colorCode;

    return data;
  }
}

class SizeColor {
  String? sizeColorId;
  String? sizeColorPrice;
  int? sizeColorQuantity = 0;
  Color? color;

  SizeColor({
    this.sizeColorId,
    this.sizeColorPrice,
    this.sizeColorQuantity,
    this.color,
  });

  factory SizeColor.fromJson(Map json) {
    return SizeColor(
      sizeColorId: json['sizeColorId'],
      sizeColorPrice: json['sizeColorPrice'],
      sizeColorQuantity: json['sizeColorQuantity'],
      color: Color.fromJson(json['color']),
    );
  }

  Map toMap() {
    final data = Map<String, dynamic>();

    data['sizeColorId'] = sizeColorId;
    data['sizeColorPrice'] = sizeColorPrice;
    data['sizeColorQuantity'] = sizeColorQuantity;
    data['color'] = color!.toMap();

    return data;
  }
}

class Size {
  String? sizeId;
  String? sizeName;
  SizeType? sizeType;

  Size({
    this.sizeId,
    this.sizeName,
    this.sizeType,
  });

  factory Size.fromJson(Map json) {
    return Size(
      sizeId: json['sizeId'],
      sizeName: json['sizeName'],
      sizeType: SizeType.fromJson(json['sizeType']),
    );
  }

  Map toMap() {
    final data = Map<String, dynamic>();

    data['sizeId'] = sizeId;
    data['sizeName'] = sizeName;
    data['sizeType'] = sizeType!.toMap();

    return data;
  }
}

class SizeType {
  String? name;
  String? slug;
  String? description;
  String? imageUrl;
  String? gender;

  SizeType({
    this.name,
    this.slug,
    this.description,
    this.imageUrl,
    this.gender,
  });

  factory SizeType.fromJson(Map json) {
    return SizeType(
      name: json['name'],
      slug: json['slug'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      gender: json['gender'],
    );
  }

  Map toMap() {
    final data = Map<String, dynamic>();

    data['name'] = name;
    data['slug'] = slug;
    data['description'] = description;
    data['imageUrl'] = imageUrl;
    data['gender'] = gender;

    return data;
  }
}

class ProductSize {
  String? productSizeId;
  String? productSizePrice;
  int? productSizeQuantity = 0;
  List<SizeColor>? sizeColors;
  Size? size;

  ProductSize({
    this.productSizeId,
    this.productSizePrice,
    this.productSizeQuantity,
    this.sizeColors,
    this.size,
  });

  factory ProductSize.fromJson(Map json) {
    Iterable _sizeColors = json['productColors'];

    return ProductSize(
      productSizeId: json['productSizeId'],
      productSizePrice: json['productSizePrice'],
      productSizeQuantity: json['productSizeQuantity'],
      sizeColors: _sizeColors != null
          ? _sizeColors.map((json) {
              return SizeColor.fromJson(json);
            }).toList()
          : [],
      size: Size.fromJson(json['size']),
    );
  }

  Map toMap() {
    final data = Map<String, dynamic>();

    data['productSizeId'] = productSizeId;
    data['productSizePrice'] = productSizePrice;
    data['productSizeQuantity'] = productSizeQuantity;
    data['sizeColors'] = sizeColors!.isNotEmpty
        ? sizeColors!.map((model) {
            return model.toMap();
          }).toList()
        : [];
    data['size'] = size!.toMap();

    return data;
  }
}

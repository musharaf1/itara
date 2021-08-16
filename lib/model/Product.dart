import '../api/Resource.dart';

import 'Category.dart';
import 'UserReview.dart';
import 'Meta.dart';
import 'Store.dart';
import 'Inventory.dart';
import 'ProductSize.dart';

class Sort {
  String? name;
  String? sortParameterSlug;

  Sort({this.name, this.sortParameterSlug});
}

class ProductColor {
  String? colorName;
  String? colorCode;

  ProductColor({this.colorName, this.colorCode});

  factory ProductColor.fromJson(Map json) {
    return ProductColor(
      colorName: json['colorName'],
      colorCode: json['colorCode'],
    );
  }

  Map toMap() {
    final data = Map<String, dynamic>();

    data['colorName'] = this.colorName;
    data['colorCode'] = this.colorCode;

    return data;
  }
}

class Product {
  String? productNumber;
  String? name;
  String? availableUntil;
  String? defaultImageUrl;
  String? price;
  String? timeCreated;
  int? remainingStock;
  double? rating;
  int? totalReviews;
  String? description;
  String? productCareInstruction;
  String? specification;
  String? returnPolicy;
  String? productStory;
  bool? isOnSale = true;
  Store? store;
  Inventory? inventory;
  List? productImageUrls;
  List<UserReview>? userReviews;
  List<ProductSize>? productSizes;
  List? productTags;
  List<Category>? categories;
  Category? category;

  Product({
    this.productNumber= '',
    this.name = '',
    this.availableUntil = '',
    this.defaultImageUrl = '',
    this.price = '',
    this.timeCreated = '',
    this.remainingStock = 0,
    this.rating = 0,
    this.totalReviews = 0,
    this.description = '',
    this.productCareInstruction = '',
    this.specification = '',
    this.returnPolicy = '',
    this.productStory = '',
    this.isOnSale = true,
    this.store,
    this.inventory,
    this.productImageUrls = const [],
    this.productTags = const [],
    this.userReviews = const<UserReview>[],
    this.productSizes = const<ProductSize>[],
    this.categories = const<Category>[],
    this.category,
  });

  static List<Sort> sortables = [
    Sort(name: 'Price: High to Low', sortParameterSlug: 'price-high-to-low'),
    Sort(name: 'Price: Low to High', sortParameterSlug: 'price-low-to-high'),
    Sort(name: 'Newest Products', sortParameterSlug: 'newest-products'),
    // Sort(name: 'Best Reviews', sortParameterSlug: 'best-reviews'),
    Sort(name: 'Oldest Products', sortParameterSlug: 'oldest-products'),
    // Sort(name: 'Popularity', sortParameterSlug: 'popularity'),
  ];

  static List<String> inventories = [
    'Single Piece',
    'Limited Quantity',
    'Mass Produced',
  ];

  static List<String> returnPolicyList = [
    'Eligible for return (T & C apply)',
    'Not eligible for return'
  ];

  static Map<String, dynamic> filterables = {
    'highestRating': 5,
    'leastPrice': 0,
    'highestPrice': null,
    'onOfferFilter': false,
  };

  factory Product.fromJson(Map json) {
    Iterable _categories = json["categories"];
    final _category = json['category'];
    Iterable _userReviews = json['userReviews'];
    Iterable _productSizes = json['productSizes'];

    // check if single product is being requested

    if (json['store'] != null) {
      return Product(
        productNumber: json['productNumber'],
        name: json['name'],
        availableUntil: json['availableUntil'],
        defaultImageUrl: json['defaultImageUrl'],
        price: json['price'],
        timeCreated: json['timeCreated'],
        remainingStock: json['remainingStock'],
        rating: json['rating'],
        totalReviews: json['totalReviews'],
        description: json['description'],
        productCareInstruction: json['productCareInstruction'],
        returnPolicy: json['returnPolicy'],
        specification: json['specification'],
        productStory: json['productStory'],
        isOnSale: json['isOnSale'],
        store: json['store'] != null ? Store.fromJson(json['store']) : null,
        inventory: json['inventory'] != null
            ? Inventory.fromJson(json['inventory'])
            : null,
        productImageUrls: json['productImageUrls'],
        productTags: json['productTags'],
        userReviews: _userReviews != null
            ? _userReviews.map((json) {
                return UserReview.fromJson(json);
              }).toList()
            : [],
        productSizes: _productSizes != null
            ? _productSizes.map((json) {
                return ProductSize.fromJson(json);
              }).toList()
            : [],
        categories: _categories != null
            ? _categories.map((model) {
                return Category.fromJson(model);
              }).toList()
            : [],
        category: _category != null ? Category.fromJson(_category) : null,
      );
    }

    return Product(
      productNumber: json['productNumber'],
      name: json['name'],
      availableUntil: json['availableUntil'],
      defaultImageUrl: json['defaultImageUrl'],
      price: json['price'],
      timeCreated: json['timeCreated'],
      remainingStock: json['remainingStock'],
      rating: json['rating'],
      totalReviews: json['totalReviews'],
      description: json['description'],
      categories: _categories != null
          ? _categories.map((model) {
              return Category.fromJson(model);
            }).toList()
          : [],
      category: _category != null ? Category.fromJson(_category) : null,
    );
  }

  Map toMap() {
    final data = Map<String, dynamic>();

    // check if single product is being requested
    if (store != null) {
      data['productNumber'] = productNumber;
      data['name'] = name;
      data['availableUntil'] = availableUntil;
      data['defaultImageUrl'] = defaultImageUrl;
      data['price'] = price;
      data['timeCreated'] = timeCreated;
      data['remainingStock'] = remainingStock;
      data['rating'] = rating;
      data['totalReviews'] = totalReviews;
      data['description'] = description;
      data['productCareInstruction'] = productCareInstruction;
      data['specification'] = specification;
      data['returnPolicy'] = returnPolicy;
      data['productStory'] = productStory;
      data['isOnSale'] = isOnSale;
      data['store'] = store!.toMap();
      data['inventory'] = inventory!.toMap();
      data['productImageUrls'] = productImageUrls;
      data['userReviews'] = userReviews!.isNotEmpty
          ? userReviews!.map((model) {
              return model.toMap();
            }).toList()
          : [];
      data['productSizes'] = productSizes!.isNotEmpty
          ? productSizes!.map((model) {
              return model.toMap();
            }).toList()
          : [];
      data['productTags'] = productTags;
      data['categories'] = categories!.isNotEmpty
          ? categories!.map((model) {
              return model.toMap();
            }).toList()
          : [];
      data['category'] = category != null ? category!.toMap() : null;

      return data;
    }

    data['productNumber'] = productNumber;
    data['name'] = name;
    data['availableUntil'] = availableUntil;
    data['defaultImageUrl'] = defaultImageUrl;
    data['price'] = price;
    data['timeCreated'] = timeCreated;
    data['remainingStock'] = remainingStock;
    data['rating'] = rating;
    data['totalReviews'] = totalReviews;
    data['description'] = description;
    data['categories'] = categories!.isNotEmpty
        ? categories!.map((model) {
            return model.toMap();
          }).toList()
        : [];
    data['category'] = category != null ? category!.toMap() : null;

    return data;
  }

  static Resource search(String query, Map<String, dynamic> filter) {
    final Map<String, dynamic> params = {
      'searchString': query,
    };

    params.addAll(filter);

    // print(params);

    return Resource(
      url: 'products',
      queryParameters: params,
      parse: (response) {
        Iterable _products = response["data"];

        Map result = {
          'products': _products.map((model) {
            return Product.fromJson(model);
          }).toList(),
          'meta': Meta.fromJson({
            'page': response["page"],
            'size': response["size"],
            'count': response["count"],
          }),
        };

        return result;
      },
    );
  }

  static Resource frontpageProducts(String slug, {int pageNumber = 0}) {
    String url = "frontpage-sections/$slug/products";

    if (slug.contains("discover")) {
      url =
          "categories/${slug.replaceAll('discover-', '')}/products?numberOfProducts=20";
    }

    return Resource(
      url: url,
      queryParameters: {
        "pageNumber": pageNumber
      },
      parse: (response) {
        Iterable _products = response['data'];

        Map result = {
          'products': _products.map((json) {
            return Product.fromJson(json);
          }).toList(),
          'meta': Meta.fromJson({
            'page': response["page"],
            'size': response["size"],
            'count': response["count"],
          }),
        };

        return result;
      },
    );
  }

  static Resource getSimilarProducts(String productNumber,{int? pageNumber}) {
    String url = "products/$productNumber/similar-products";

    return Resource(
      url: url,
      queryParameters: {
        "pageNumber" : pageNumber
      },
      parse: (response) {
        Iterable _products = response['data'];

        Map result = {
          'products': _products.map((json) {
            return Product.fromJson(json);
          }).toList(),
          'meta': Meta.fromJson({
            'page': response["page"],
            'size': response["size"],
            'count': response["count"],
          }),
        };

        return result;
      },
    );
  }

  static Resource getProduct(String productNumber) {
    return Resource(
      url: 'products/${productNumber}',
      parse: (response) {
        return Product.fromJson(
          response['data'],
        );
      },
    );
  }

  static Resource colors() {
    return Resource(
      url: 'colors',
      parse: (response) {
        Iterable _colors = response['data'];

        return _colors.map((color) {
          return ProductColor.fromJson(color);
        }).toList();
      },
    );
  }

  static Resource discover({int pageNumber = 0, int itemsPerPage = 20, String query =''}) {
    return Resource(
      url: 'products/discover?tag=$query',
      queryParameters: {
        'pageNumber': pageNumber,
        'itemsPerPage': itemsPerPage,
      },
      parse: (response) {
        return response;
      },
    );
  }

  static Resource productsInCategory({
    String? categorySlug,
    int pageNumber = 0,
    int itemsPerPage = 20,
    String? sortParameterSlug,
    Map? filter,
  }) {
    return Resource(
      url: 'categories/${categorySlug}/products',
      queryParameters: {
        'pageNumber': pageNumber,
        'itemsPerPage': itemsPerPage,
        'sortParameterSlug': sortParameterSlug, // TODO: add in API
        // ...filter
      },
      parse: (response) {
        return response;
      },
    );
  }

  

  static Resource productsByTag({
    String? tag,
    int pageNumber = 0,
    int itemsPerPage = 20,
    String? sortParameterSlug,
    Map? filter,
  }) {
    return Resource(
      url: 'products',
      queryParameters: {
        'pageNumber': pageNumber,
        'itemsPerPage': itemsPerPage,
        'tagNames': tag,
        'sortParameterSlug': sortParameterSlug, // TODO: add in API
        // ...filter
      },
      parse: (response) {
        return response;
      },
    );
  }
}

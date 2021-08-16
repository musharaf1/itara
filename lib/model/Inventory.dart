import 'package:itarashop/api/Resource.dart';

class Inventory {
  String? name;
  String? inventorySlug;
  String? description;

  Inventory({
    this.name,
    this.inventorySlug,
    this.description,
  });

  factory Inventory.fromJson(Map json) {
    return Inventory(
      name: json['name'],
      inventorySlug: json['inventorySlug'],
      description: json['description'],
    );
  }

  Map toMap() {
    final data = Map<String, dynamic>();

    data['name'] = name;
    data['inventorySlug'] = inventorySlug;
    data['description'] = description;

    return data;
  }

  static Resource getInventory() {
    return Resource(
      url: 'inventories',
      parse: (response) {
        return response;
      },
    );
  }

  static Resource getInventoryProducts({
    String? inventory,
    int pageNumber = 0,
    int itemsPerPage = 20,
    String? sortParameterSlug,
    Map? filter,
  }) {
    return Resource(
      url: 'inventories/$inventory/products',
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
}

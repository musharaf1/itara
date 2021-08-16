import 'package:itarashop/api/Resource.dart';
import 'package:itarashop/model/Delivery.dart';
import 'package:itarashop/model/Inventory.dart';
import 'package:itarashop/model/tags.dart';
import 'package:itarashop/transformers/ProductTransformer.dart';
import '../model/Cart.dart';
import '../model/Category.dart';
import '../model/Product.dart';
import '../model/User.dart';
import 'Client.dart';

class ApiResource {
  final Client _client = Client();

  Future<User> register(Map payload) async {
    User user = await _client.post(User.register(payload));

    // save userId and tokens
    await user.saveId();

    return user;
  }

  Future<User> signIn(Map payload) async {
    User user = await _client.post(User.signIn(payload));

    // save userId and tokens
    await user.saveId();

    return user;
  }

  Future<User> updateUser(Map attributes, String userId) async {
    User user = await _client.put(User.updateUser(attributes, userId));

    return user;

    // await user.saveId();
  }

  Future forgotPassword(Map payload) async {
    var result = await _client.post(User.forgotPassword(payload));
    return result;
  }

  Future<Map> searchProducts(String query, Map<String, dynamic> filter) async {
    Map results = await _client.load(Product.search(query, filter));

    return results;
  }

  Future<Map> frontpageProducts(String slug, {int pageNumber = 0}) async {
    Map results = await _client
        .load(Product.frontpageProducts(slug, pageNumber: pageNumber));

    return results;
  }

  Future<Product> getProduct(String productNumber) async {
    Product result = await _client.load(Product.getProduct(productNumber));

    return result;
  }

  Future<List<ProductColor>> colors() async {
    final List results = await _client.load(Product.colors());

    return results as List<ProductColor>;
  }

  Future<Map<String, dynamic>> changePassword(
      String oldPass, String newPass) async {
    Map results = await _client.post(
      Resource(
        url: 'accounts/password/change',
        data: {
          "currentPassword": oldPass,
          "newPassword": newPass,
        },
        parse: (response) {
          return response;
        },
      ),
    );

    return results as Map<String, dynamic>;
  }

  Future getSimilarProducts(String productNumber, {int pageNumber = 0}) async {
    Map results = await _client.load(
        Product.getSimilarProducts(productNumber, pageNumber: pageNumber));

    return results;
  }

  Future<List<Category>> getCategories() async {
    Map results = await _client.load(Category.getCategories());

    return (results['data'] as Iterable).map((json) {
      return Category.fromJson(json);
    }).toList();
  }

  Future<List<Inventory>> getInventories() async {
    Map results = await _client.load(Inventory.getInventory());

    return (results['data'] as Iterable).map((json) {
      return Inventory.fromJson(json);
    }).toList();
  }

  Future<List<Tags>> getTags() async {
    Map results = await _client.load(Tags.getTags());

    return (results['data'] as Iterable).map((json) {
      return Tags.fromMap(json);
    }).toList();
  }

  Future<Map> discover(
      {int pageNumber = 0, itemsPerPage = 20, String query = ''}) async {
    // print("Discover");

    final Map<String, dynamic> results = await _client.load(Product.discover(
        pageNumber: pageNumber, itemsPerPage: itemsPerPage, query: query));

    return results;
    // return ProductTransformer.collection(results);
  }

  Future<Map> listProductsByTag(
    String tag, {
    int pageNumber = 0,
    int itemsPerPage = 20,
    String sortParameterSlug = '',
  }) async {
    Map results = await _client.load(
      Product.productsByTag(
        tag: tag,
        pageNumber: pageNumber,
        itemsPerPage: itemsPerPage,
        sortParameterSlug: sortParameterSlug,
      ),
    );

    // print(results);

    return ProductTransformer.collection(results);
  }

  Future<Map> listProductsByInventory(
    String inventory, {
    int pageNumber = 0,
    int itemsPerPage = 20,
    String sortParameterSlug = '',
  }) async {
    Map results = await _client.load(
      Inventory.getInventoryProducts(
        inventory: inventory,
        pageNumber: pageNumber,
        itemsPerPage: itemsPerPage,
        sortParameterSlug: sortParameterSlug,
      ),
    );

    // print(results);

    return ProductTransformer.collection(results);
  }

  Future<Map> listProductsInCategory(
    String categorySlug, {
    int pageNumber = 0,
    int itemsPerPage = 20,
    String? sortParameterSlug,
  }) async {
    print('I got here with $categorySlug');
    Map results = await _client.load(
      Product.productsInCategory(
        categorySlug: categorySlug,
        pageNumber: pageNumber,
        itemsPerPage: itemsPerPage,
        sortParameterSlug: sortParameterSlug,
      ),
    );

    // print(results);

    return ProductTransformer.collection(results);
  }

  Future<List> getCountries() async {
    return await _client.load(
      Resource(
        url: 'countries',
        parse: (response) {
          return response['data'];
        },
      ),
    );
  }

  /// Checkout
  /// [userId] String
  /// [cartItems] List
  /// Returns [Map]
  Future<Map> checkout(String userId, List<CartItem> cartItems) async {
    Map results = await _client.post(CartItem.checkout(cartItems, userId));

    return results;
  }

  /// Get Delivery Addresses
  /// [userId] String
  /// Returns [List<Delivery>]
  Future<List<Delivery>> delivery(String userId) async {
    final List<Delivery> res = await _client.load(Delivery.list(userId));

    return res;
  }

  /// Create Address
  /// Map [payload] Address objeect
  Future createAddress({String? userId, Map? address}) async {
    return await _client.post(Resource(
      url: 'delivery-addresses',
      data: {
        ...?address,
        'contactName': "${address!['firstName']} ${address['lastName']}",
        'userId': userId,
      },
      parse: (response) {
        return response['data'];
      },
    ));
  }

  /// Update Address
  /// Map [payload] Address objeect
  Future updateAddress({String? userId, Map? address}) async {
    return await _client.put(Resource(
      url: "delivery-addresses/${address!['deliveryAddressId']}",
      data: {
        ...address,
        'contactName': "${address['firstName']} ${address['lastName']}",
        'userId': userId,
      },
      parse: (response) {
        return response['data'];
      },
    ));
  }

  /// Update Address
  /// Map [payload] Address objeect
  Future updateAddressDefault(
      {bool? isDefaultDeliveryAddress, Map? address}) async {
    return await _client.put(Resource(
      url: "delivery-addresses/${address!['deliveryAddressId']}/default",
      data: {
        'isDefaultDeliveryAddress': isDefaultDeliveryAddress,
      },
      parse: (response) {
        return response['data'];
      },
    ));
  }

  /// Get delivery options
  Future<List> deliveryOptions() async {
    return await _client.load(
      Resource(
        url: '/utilities/delivery-options',
        parse: (response) {
          return response['data'];
        },
      ),
    );
  }

  /// Get Payment Methods
  Future<List> paymentMethods() async {
    return await _client.load(
      Resource(
        url: 'payment-methods',
        parse: (response) {
          return response['data'];
        },
      ),
    );
  }

  /// Get coupon code
  Future<Map> getCoupon({String? couponCode}) async {
    return await _client.load(
      Resource(
        url: 'coupons/$couponCode',
        parse: (response) {
          return response['data'];
        },
      ),
    );
  }

  /// Post order
  Future<Map> createOrder({Map? order}) async {
    return await _client.post(
      Resource(
        url: 'orders',
        data: order,
        parse: (response) async {
          // print("done");

          // print(response['data']);

          return response['data'];
        },
      ),
    );
  }

  /// Get Wishlist
  Future<Map> getWishlist({String? userId}) async {
    return await _client.load(
      Resource(
        url: 'wish-lists',
        data: {'userId': userId},
        parse: (response) {
          // print(response);
          return response;
        },
      ),
    );
  }

  /// Add Wishlist
  Future<Map> getWishlistItems({
    String? wishListSlug,
    String? userId,
  }) async {
    return await _client.load(
      Resource(
        url: 'wish-lists/$wishListSlug/items',
        data: {
          'userId': userId,
        },
        parse: (response) async {
          print(response);
          return response;
        },
      ),
    );
  }

  /// Add Wishlist
  Future<Map> addWishlist({
    String? wishListSlug,
    String? productNumber,
    String? userId,
  }) async {
    return await _client.post(
      Resource(
        url: 'wish-lists/$wishListSlug/items',
        data: {
          'productNumber': productNumber,
          'userId': userId,
        },
        parse: (response) async {
          // print(response);
        },
      ),
    );
  }

  /// Create Wishlist
  Future<Map> createWishlist(
      {String? userId, String? name, bool isPublic = true}) async {
    return await _client.post(
      Resource(
        url: 'wish-lists',
        data: {
          'userId': userId,
          'name': name,
          'isPublic': isPublic,
        },
        parse: (response) async {
          //
          // print(response);
        },
      ),
    );
  }

  /// Delete Wishlist item
  Future<Map> deleteWishlist({
    String? wishListSlug,
    String? productNumber,
    String? userId,
  }) async {
    return await _client.delete(
      Resource(
        url: 'wish-lists/$wishListSlug/items/$productNumber',
        data: {
          'userId': userId,
        },
        parse: (response) async {
          print(response);
        },
      ),
    );
  }

  /// Delete Wishlist
  Future<Map> deleteWishlists({
    String? wishListSlug,
    String? productNumber,
    String? userId,
  }) async {
    return await _client.delete(
      Resource(
        url: 'wish-lists/$wishListSlug',
        data: {
          'userId': userId,
        },
        parse: (response) async {
          // print(response);
        },
      ),
    );
  }

  /// Get Orders
  Future<Map> orders({String? userId}) async {
    return await _client.load(
      Resource(
        url: 'orders',
        data: {
          'userId': userId,
        },
        parse: (response) async {
          return response;
        },
      ),
    );
  }

  /// Get Complaints and types
  Future<List> getComplaintStypes() async {
    return await _client.load(
      Resource(
        url: 'complaints/types',
        parse: (response) {
          return response['data'];
        },
      ),
    );
  }

  /// Post complaint/Report
  Future<Map> submitComplaint({
    String? title,
    String? body,
    String? pictureEvidence,
    String? fullname,
    String? email,
    String? phoneNumber,
  }) async {
    return await _client.post(
      Resource(
        url: 'complaints',
        data: {
          'title': title,
          'body': body,
          // 'pictureEvidence': pictureEvidence,
          'fullname': fullname,
          'email': email,
          // 'phoneNumber': phoneNumber,
        },
        parse: (response) {
          return response;
        },
      ),
    );
  }

  /// Post review
  Future<Map> submitReview({
    String? body,
    int rating = 0,
    String? orderItemId,
    String? productNumber,
    String? userId,
  }) async {
    return await _client.post(
      Resource(
        url: 'product-reviews',
        data: {
          "body": body,
          "rating": rating,
          "orderItemId": orderItemId,
          "productNumber": productNumber,
          "userId": userId,
        },
        parse: (response) {
          return response;
        },
      ),
    );
  }

  Future<void> logout({String? refreshToken}) async {
    //
    return await _client.post(
      Resource(
        url: 'accounts/logout',
        data: {
          'refreshToken': refreshToken,
        },
        parse: (response) {
          print(response);
        },
      ),
    );
  }
}

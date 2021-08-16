import '../api/Resource.dart';
import 'Product.dart';

class Cart {
  int? totalQuantity = 0;
  String? totalPrice;
  List<CartItem>? cartItems = [];

  Cart({
    this.totalQuantity,
    this.totalPrice,
    this.cartItems,
  });

  factory Cart.fromJson(Map json) {
    final Iterable _cartItems = json['cartItems'];

    return Cart(
      totalQuantity: json['totalQuantity'],
      totalPrice: json['totalPrice'],
      cartItems: _cartItems.map((item) {
        return CartItem.fromJson(item);
      }).toList(),
    );
  }

  Map toMap() {
    final Map<String, dynamic> data = {};

    data['totalQuantity'] = totalQuantity;
    data['totalPrice'] = totalPrice;
    data['cartItems'] = cartItems!.map((CartItem item) {
      return item.toMap();
    }).toList();

    return data;
  }
}

class CartItem {
  String? productNumber;
  String? productSizeId;
  String? productSizeLabel;
  String? sizeColorId;
  String? sizeColorLabel;
  int? quantity = 0;
  int? maxQty = 0; // local
  bool? isOutOfStock = true;
  Product? product;
  String? price;
  // ProductSize productSize;
  // SizeColor sizeColor;

  CartItem({
    this.productNumber,
    this.quantity,
    this.maxQty,
    this.isOutOfStock,
    this.product,
    this.productSizeId,
    this.productSizeLabel,
    this.sizeColorId,
    this.sizeColorLabel,
    this.price,
  });

  factory CartItem.fromJson(Map json) {
    return CartItem(
      productNumber: json['productNumber'],
      quantity: json['quantity'],
      maxQty: json['maxQty'],
      isOutOfStock: json['isOutOfStock'],
      product: Product.fromJson(json['product']),
      productSizeId: json['productSizeId'],
      productSizeLabel: json['productSizeLabel'],
      sizeColorId: json['productColorId'],
      sizeColorLabel: json['sizeColorLabel'],
      price: json['price'],
    );
  }

  Map toMap() {
    final Map<String, dynamic> data = {};

    data['productNumber'] = productNumber;
    data['quantity'] = quantity;
    data['isOutOfStock'] = isOutOfStock;
    data['product'] = product!.toMap();
    data['productSizeId'] = productSizeId;
    data['productSizeLabel'] = productSizeLabel;
    data['sizeColorId'] = sizeColorId;
    data['sizeColorLabel'] = sizeColorLabel;
    data['price'] = price;

    return data;
  }

  /// Resource for cart items
  /// [userId] argument must not be null
  static Resource getCartItems(String userId) {
    assert(userId != null);
    return Resource(
      url: 'cart-items',
      queryParameters: {
        'userId': userId,
      },
      parse: (response) {
        return Cart.fromJson(
          response['data'],
        );
      },
    );
  }

  // /// Resource for adding cart
  // static Resource addToCart(Map item) {
  //   return Resource(
  //     url: 'cart-items',
  //     data: item,
  //     parse: (response) {
  //       return response;
  //     },
  //   );
  // }

  /// Resource for checkout
  /// [items] argument must not be empty
  /// Returns [Map]
  static Resource checkout(List<CartItem> cartItems, String userId) {
    assert(cartItems.isNotEmpty);

    var cart = <String, dynamic>{
      "cartItems": cartItems.map((e) {
        return e.toMap();
      }).toList(),
      "userId": userId
    };

    // print("Cart Items: " + cart['cartItems'].length.toString());

    return Resource(
      url: 'cart-items',
      data: cart,
      parse: (response) {
        // print("Gotten response");
        // print(response);
        return response['data'];
      },
    );
  }
}

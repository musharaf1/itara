import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:itarashop/api/ApiResource.dart';
import 'package:itarashop/model/Delivery.dart';
import 'api/Client.dart';
import 'api/Resource.dart';
import 'model/Cart.dart';
import 'model/User.dart';
import 'model/Frontpage.dart';

final FlutterSecureStorage _store = FlutterSecureStorage();

class AppState extends ChangeNotifier {
  bool initialising = true;
  bool error = false;
  bool onBoarded = true;
  bool isAuthenticated = false;
  FrontPage? frontpage_sections;
  User? authenticatedUser;
  List<CartItem> cartItems = [];
  List wishlists = [];
  bool enablePushNotification = true;
  List? addressBook;
  Delivery? _address = Delivery(deliveryAddressId: '');
  Delivery? get address => _address;
  bool newUser = false;
  ApiResource apiResource = ApiResource();
  // Client client = Client();

  String _query = '';
  String get query => _query;

  void setAddress(Delivery deliveryAddress) {
    _address = deliveryAddress;
    notifyListeners();
  }

  set setQuery(String value) {
    _query = value;
    notifyListeners();
  }

  final Client _client = Client();

  /// State initialization
  /// emits [notifiable]
  ///
  /// [token], [onboarded] are optional arguments
  Future init() async {
    this.error = false;
    this.onBoarded = await _store.read(key: 'boarded') != null;

    try {
      // await _client.getToken();
      // load frontpage sections
      // this.frontpage_sections = await _client.load(FrontPage.all);

      // // print(this.frontpage_sections);
      // await _store.write(
      //   key: 'frontpage_sections',
      //   value: json.encode(frontpage_sections.toMap()),
      // );

      // load currentUser
      User? _user = await currentUser;
      print(_user);

      if (_user != null) {
        print('user');
        this.error = false;

        // final User refetchUser = await _client.load(User.getCurrentUser(_user));
        // var mergeUserData = <String, dynamic>{};
        // mergeUserData = {
        //   ..._user.toMap(),
        //   ...refetchUser.toMap(),
        // };

        // await _store.write(key: 'user', value: json.encode(mergeUserData));

        // load user address book
        // await this.listAddresses(notify: false);
      } else {
        print('no user');
        newUser = false;
      }
      // stop init
      this.initialising = false;
    } catch (e) {
      print(e);

      this.error = true;
    }

    notifyListeners();
  }

  /// Set user
  ///
  /// [user] must not be empty
  void setCurrentUser(User user) async {
    assert(user != null);
    // print("userTOAdd $user");

    await _store.write(key: 'user', value: json.encode(user.toMap()));

    this.authenticatedUser = user;
    this.isAuthenticated = true;

    // load user address book
    // await this.listAddresses(notify: false);

    notifyListeners();
  }

  /// de-authenticate & signout
  void signout() async {
    await _store.delete(key: 'user');
    await _store.delete(key: 'userId');
    await _store.delete(key: 'token');
    await _store.delete(key: 'refreshToken');

    this.authenticatedUser = null;
    this.isAuthenticated = false;
    this.cartItems = [];
    this.addressBook = [];
    this.wishlists = [];

    notifyListeners();
  }

  /// Get user
  get currentUser async {
    var _user = await _store.read(key: 'user');
    final String? token = await _store.read(key: 'token');

    if (_user != null && token != null) {
      this.authenticatedUser = User.fromJson(json.decode(_user));
      this.isAuthenticated = true;
    } else {
      this.authenticatedUser = null;
      this.isAuthenticated = false;
    }

    return this.authenticatedUser;
  }

  /// Add to Cart
  /// emits [notifiable]
  void addToCart(CartItem payload) {
    if (payload != null) {
      this.cartItems.add(payload);

      notifyListeners();
    }
  }

  /// Update Cart
  void removeCartItem(CartItem cartItem) {
    this.cartItems = cartItems
      ..removeWhere((e) => e.productNumber == cartItem.productNumber);

    notifyListeners();
  }

  /// Update Cart Qty
  void updateCartItemQty(CartItem cartItem) {
    final int index =
        cartItems.indexWhere((e) => e.productNumber == cartItem.productNumber);
    this.cartItems[index] = cartItem;

    notifyListeners();
  }

  /// Update Cart
  void updateCart(List<CartItem> cartItems) {
    this.cartItems = cartItems;
    notifyListeners();
  }

  /// Get cart total
  get cartTotal {
    double total = cartItems.fold(
        0,
        (acc, o) =>
            acc + o.quantity! * double.parse(o.price!.replaceAll(',', '')));

    // print(total);
    return NumberFormat.currency(
      symbol: '₦',
      decimalDigits: 2,
    ).format(total);
  }

  /// Enable push notification
  void updatePushNotification() async {
    this.enablePushNotification = !enablePushNotification;

    // TODO: remote push update

    notifyListeners();
  }

  Future<void> listAddresses({bool notify = true}) async {
    await _client.load(Resource(
      url: 'delivery-addresses',
      queryParameters: {
        'userId': this.authenticatedUser!.id,
      },
      parse: (response) {
        this.addressBook = response['data'];
        print(addressBook);
        if (notify) notifyListeners();
      },
    ));
  }

  Future<void> deleteAddress({String? addressId}) async {
    await _client.delete(
      Resource(
        url: 'delivery-addresses/$addressId',
        parse: (response) {
          this.addressBook = addressBook!
              .where(
                (element) => element['deliveryAddressId'] != addressId,
              )
              .toList();

          notifyListeners();
        },
      ),
    );
  }

  Future<void> updateProfilePictureUrl(String base64Image) async {
    await _client.put(
      Resource(
        url: 'users/${this.authenticatedUser!.id}/profile-picture',
        data: <String, dynamic>{
          'base64': base64Image,
        },
        parse: (response) {
          //
          print(response['data']);

          this.authenticatedUser!.profilePictureUrl = response['data'];
          notifyListeners();
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:itarashop/api/ApiResource.dart';
import 'package:itarashop/common/product_cart.dart';
import 'package:itarashop/common/shimmers/product_cart_shimmer.dart';
import 'package:shimmer/shimmer.dart';

class WishlistItems extends StatefulWidget {
  final String? userId;
  final Map? wishlist;

  const WishlistItems({@required this.userId, @required this.wishlist});

  @override
  _WishlistItemsState createState() => _WishlistItemsState();
}

class _WishlistItemsState extends State<WishlistItems> {
  ApiResource? _apiResource;

  List items = [];
  bool loading = false;
  bool error = false;
  bool load = false;

  @override
  void initState() {
    super.initState();
    _apiResource = ApiResource();
    fetch();
  }

  @override
  void dispose() {
    //
    super.dispose();
  }

  Future<void> fetch() async {
    try {
      this.setState(() {
        loading = true;
        error = false;
      });
      final docs = await _apiResource!.getWishlistItems(
        userId: widget.userId!,
        wishListSlug: widget.wishlist!['wishListSlug'],
      );

      this.setState(() {
        items = List.from(docs['data']);
        loading = false;
      });

      // print(docs);
    } catch (e) {
      this.setState(() {
        error = true;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.wishlist);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Wishlist - ${widget.wishlist!['name']}',
          style: Theme.of(context).textTheme.headline6!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: Column(
        children: [
          Divider(height: 1.0),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.all(20),
              itemCount: items.isNotEmpty ? items.length : 1,
              separatorBuilder: (context, int index) {
                return Divider();
              },
              itemBuilder: (context, int index) {
                print('Here with the value');
                print(items);
                if (items.isEmpty) {
                  print('Here with the value');
                  return Center(
                    child: Text(
                      'No item has been added to this wishlist.',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  );
                }
                // if (index == items.last) {
                //   return Divider();
                // }

                else {
                  final item = items[index];
                  // print(item);

                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/product', arguments: {
                        'productNumber': item['product']['productNumber'],
                      });
                    },
                    child: ProductCart(
                      cartType: CartType.Wishlist,
                      cartItem: item,
                      wishListName: widget.wishlist!['name'],

                      showActions: false,
                      // loading: load,
                      remove: () {
                        print('Hello');
                        items.removeAt(index);
                        setState(() {});
                        // build(context);
                      },
                    ),
                  );
                }

                // return Container(
                //   height: 80,
                //   child: Text('Item placeholder'),
                // );
              },
            ),
          ),
          // Text('HEllo', style: Theme.of(context).textTheme.headline3,),
          // Divider(height: 1.0),
        ],
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:itarashop/common/wishlist_dialog.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../common/buy_label.dart';
import '../common/rating.dart';
import '../model/Product.dart';

class ProductInline extends StatefulWidget {
  final Product? product;

  ProductInline({this.product});

  @override
  _ProductInlineState createState() => _ProductInlineState();
}

class _ProductInlineState extends State<ProductInline>
    with TickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _productAnim;
  bool isInWishlist = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _productAnim = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller!, curve: Interval(0, 0.1)),
    );

    _controller!.addListener(() {
      setState(() {});
    });

    _controller!.forward();

    checkWishlist();
  }

  @override
  void dispose() {
    _controller!.dispose();

    super.dispose();
  }

  Future<void> checkWishlist() async {
    try {
      final _flutterSecureStorage = FlutterSecureStorage();

      String? _storeWishlists =
          await _flutterSecureStorage.read(key: 'wishlists');
      if (_storeWishlists != null) {
        final wishlist = List.from(json.decode(_storeWishlists)).firstWhere(
            (e) => e.split("##").last == widget.product!.productNumber);

        isInWishlist = wishlist.isNotEmpty && wishlist.contains("##");

        this.setState(() {});
      }
    } catch (e) {
      print('nothing found');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool inStock = widget.product!.remainingStock != 0;

    return Transform.translate(
      offset: Offset(0.0, 30 * (1 - _productAnim!.value)),
      child: Opacity(
        opacity: _productAnim!.value,
        child: ListTile(
          contentPadding: EdgeInsets.only(bottom: 15.0),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  // Positioned.fill(
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(5),
                  //       boxShadow: [
                  //         BoxShadow(
                  //           offset: Offset(0, 2),
                  //           color: Colors.black26,
                  //           blurRadius: 6,
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed(
                      '/product',
                      arguments: {
                        'productNumber': widget.product!.productNumber
                      },
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        color: Colors.black.withOpacity(0.1),
                        child: Image(
                          image: NetworkImage(widget.product!.defaultImageUrl!),
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: 200,
                          fit: BoxFit.cover,
                          colorBlendMode: BlendMode.darken,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 10,
                    top: 10,
                    child: GestureDetector(
                      onTap: () async {
                        final appstate = await Provider.of<AppState>(
                          context,
                          listen: false,
                        );

                        if (appstate.isAuthenticated) {
                          return showDialog(
                            context: context,
                            builder: (context) => WishlistAlert(
                              userId: appstate.authenticatedUser!.id,
                              productNumber: widget.product!.productNumber,
                              onTap: (bool status) {
                                this.setState(() {
                                  isInWishlist = status;
                                });
                              },
                            ),
                          );
                        } else {
                          //TODO: Add sign in popup
                          print("Pop up to sign in");
                        }
                      },
                      child: SvgPicture.asset(
                        isInWishlist
                            ? 'assets/images/heart_active.svg'
                            : 'assets/images/heart.svg',
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 20),
              Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // GestureDetector(
                      //   onTap: () => Navigator.of(context).pushNamed(
                      //     '/product',
                      //     arguments: {
                      //       'productNumber': widget.product.productNumber
                      //     },
                      //   ),
                      //   child: SvgPicture.asset('assets/images/link.svg'),
                      // ),
                      // SizedBox(height: 10),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pushNamed(
                          '/product',
                          arguments: {
                            'productNumber': widget.product!.productNumber
                          },
                        ),
                        child: Text(
                          widget.product!.name!,
                          maxLines: 2,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pushNamed(
                          '/product',
                          arguments: {
                            'productNumber': widget.product!.productNumber
                          },
                        ),
                        child: BuyLabel(price: widget.product!.price!),
                      ),
                      SizedBox(height: 10),
                      Text(
                        inStock ? 'In stock' : 'Out of stock',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              color: inStock ? Colors.black54 : Colors.red,
                            ),
                      ),
                      SizedBox(height: 10.0),
                      Rating(rating: widget.product!.rating),
                      Text(
                        "${widget.product!.totalReviews} reviews",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: Colors.black26),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

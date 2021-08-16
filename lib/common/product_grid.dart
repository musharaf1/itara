import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:itarashop/api/ApiResource.dart';
import 'package:itarashop/common/wishlist_dialog.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../common/buy_label.dart';
// import 'package:marketplace/common/small_button.dart';
import '../model/Product.dart';
import 'custom_alert.dart';
// import 'button_widget.dart';

class ProductGrid extends StatefulWidget {
  final Product? product;

  ProductGrid({this.product});

  @override
  _ProductGridState createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid>
    with TickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _productAnim;

  bool isInWishlist = false;
  String slug = '';
  bool busy = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _productAnim = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller!, curve: Curves.decelerate),
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

  //  @override
  // void didUpdateWidget(ProductGrid oldWidget) {
  //   if (oldWidget. != widget.word) {
  //     word = widget.word;
  //   }
  //   super.didUpdateWidget(oldWidget);
  // }

  Future<void> checkWishlist() async {
    try {
      final _flutterSecureStorage = FlutterSecureStorage();
      String? _storeWishlists =
          await _flutterSecureStorage.read(key: 'wishlists');
      // print(_storeWishlists);
      if (_storeWishlists != null) {
        // print(_storeWishlists);
        final wishlist = List.from(json.decode(_storeWishlists)).firstWhere(
            (e) => e.split("##").last == widget.product!.productNumber);

        isInWishlist = wishlist.isNotEmpty && wishlist.contains("##");
        //getting the slug
        var newSlug =
            json.decode(_storeWishlists).first.toString().split("##").first;
        slug = newSlug;
        print('THis is the slug' + newSlug);
        this.setState(() {});
      }
    } catch (e) {
      print('nothing found');
    }
  }

  Future<void> deleteWishlists(item) async {
    try {
      final _flutterSecureStorage = FlutterSecureStorage();
      String? _storeWishlists =
          await _flutterSecureStorage.read(key: 'wishlists');
      List data = json.decode(_storeWishlists!);
      for (int i = 0; i < data.length; i++) {
        if (data[i].toString().contains(item)) {
          data.removeAt(i);
        }
      }
      await _flutterSecureStorage.delete(key: 'wishlists');
      await _flutterSecureStorage.write(
          key: 'wishlists', value: json.encode(data));
      await checkWishlist();
      print('This is the value of isWishList $isInWishlist');
    } catch (e) {
      print('nothing found');
    }
  }

  @override
  Widget build(BuildContext context) {
    // final bool inStock = widget.product.remainingStock != "0";
    final ThemeData t = Theme.of(context);
    print('This is the value of isWishList $isInWishlist');
    return Transform.translate(
      offset: Offset(0.0, 30 * (1 - _productAnim!.value)),
      child: Opacity(
          opacity: _productAnim!.value,
          child: Container(
            width: 180,
            height: 280,
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 60,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pushNamed(
                      '/product',
                      arguments: {
                        'productNumber': widget.product!.productNumber
                      },
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Container(
                        color: Colors.black.withOpacity(0.1),
                        child: widget.product!.defaultImageUrl == null
                            ? SizedBox.shrink()
                            : Image(
                                image: NetworkImage(
                                    widget.product!.defaultImageUrl!),
                                fit: BoxFit.cover,
                                colorBlendMode: BlendMode.darken,
                              ),
                      ),
                    ),
                  ),
                ),
                // Positioned(
                //   top: 10,
                //   right: 10,
                //   child: GestureDetector(
                //     onTap: () {
                //       print(widget.product.productNumber);
                //       return Navigator.of(context).pushNamed(
                //         '/product',
                //         arguments: {
                //           'productNumber': widget.product.productNumber,
                //         },
                //       );
                //     },
                //     child: SvgPicture.asset(
                //       'assets/images/link.svg',
                //       width: 24,
                //       height: 24,
                //     ),
                //   ),
                // ),
                Positioned(
                  right: 10,
                  bottom: 70,
                  child: GestureDetector(
                    onTap: () async {
                      print(isInWishlist);
                      if (isInWishlist == false) {
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
                      } else {
                        print('this is the $slug');
                        await checkWishlist();
                        final appstate = Provider.of<AppState>(
                          context,
                          listen: false,
                        );
                        return showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (context, setStates) {
                                return CustomAlert(
                                  title: 'Remove from Wishlist',
                                  desc:
                                      'Do you want to remove this item from your wish list? ',
                                  loading: busy,
                                  onCancel: () {
                                    // Navigator.pop(context);
                                  },
                                  onAction: () async {
                                    setState(() {
                                      busy = true;
                                    });
                                    ApiResource apiResource = ApiResource();
                                    await apiResource
                                        .deleteWishlist(
                                      wishListSlug: slug,
                                      productNumber:
                                          widget.product!.productNumber!,
                                      userId: appstate.authenticatedUser!.id!,
                                    )
                                        .then((value) async {
                                      setState(() {
                                        busy = false;
                                        isInWishlist = false;
                                      });
                                      await deleteWishlists(
                                          widget.product!.productNumber);
                                      await checkWishlist();

                                      Navigator.pop(context);
                                    });
                                  },
                                );
                              },
                            );
                          },
                        );
                      }
                    },
                    child: Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Center(
                          child: Icon(
                            isInWishlist == true
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 15,
                            color: Theme.of(context).colorScheme.primaryVariant,
                          ),
                          // child: isInWishlist == true
                          //     ? SvgPicture.asset(
                          //         'assets/images/heart_active.svg',
                          //         width: 25,
                          //         height: 25,
                          //       )
                          //     : Icon(
                          //         Icons.favorite_border,
                          //         size: 15,
                          //         color: Theme.of(context)
                          //             .colorScheme
                          //             .primaryVariant
                          //             .withOpacity(0.6),
                          //       ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.product!.name!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: t.textTheme.bodyText1!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4.0),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pushNamed(
                          '/product',
                          arguments: {
                            'productNumber': widget.product!.productNumber
                          },
                        ),
                        child: BuyLabel(price: widget.product!.price!),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

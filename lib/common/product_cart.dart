import 'package:flutter/material.dart';
import 'package:itarashop/api/ApiResource.dart';
import 'package:itarashop/common/progressbar_circular.dart';
import 'package:itarashop/model/Cart.dart';
import 'package:itarashop/model/Product.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import 'cart_actions.dart';

enum CartType { Order, Wishlist }

class ProductCart extends StatefulWidget {
  final GestureTapCallback? remove;
  final Map? cartItem;
  final bool showActions;
  final CartType cartType;
  final String? wishListName;

  ProductCart(
      {@required this.cartItem,
      this.showActions = true,
      this.remove,
      this.wishListName,
      this.cartType = CartType.Order});

  @override
  _ProductCartState createState() => _ProductCartState();
}

class _ProductCartState extends State<ProductCart> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    print(widget.cartItem);
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: widget.showActions ? EdgeInsets.all(20.0) : EdgeInsets.zero,
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () => {
              Navigator.of(context).pushNamed(
                '/product',
                arguments: {
                  'productNumber': widget.cartItem!['productNumber'],
                },
              ),
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: widget.cartItem!['product']['defaultImageUrl'] != null
                  ? Image(
                      image: NetworkImage(
                          widget.cartItem!['product']['defaultImageUrl']),
                      width: 120,
                      height: 140,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 120,
                      height: 140,
                      color: Colors.grey.shade300,
                    ),
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      '/product',
                      arguments: {
                        'productNumber': widget.cartItem!['productNumber'],
                      },
                    );
                  },
                  child: Text(
                    widget.cartItem!['product']['name'],
                    style: textTheme.headline6,
                  ),
                ),

                SizedBox(height: 2),

                Text(
                  widget.cartItem!['product']['productNumber'],
                  style: TextStyle(
                    color: Colors.black38,
                  ),
                ),

                SizedBox(height: 5),

                // in orderItem display
                if (widget.cartItem!['product']['productSize'] != null)

                  /// [color] and [sizes]
                  Row(
                    children: <Widget>[
                      if (widget.cartItem!['product']['productSize']
                              ['sizeColor'] !=
                          null)
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(
                              int.parse(
                                widget.cartItem!['product']['productSize']
                                        ['sizeColor']['colorCode']
                                    .replaceAll('#', "0xFF"),
                              ),
                            ),
                          ),
                        ),
                      SizedBox(width: 8.0),
                      Text(widget.cartItem!['product']['productSize']
                          ['sizeName']),
                    ],
                  ),

                // in cart item display
                if (widget.cartItem!['productSizeId'] != null)

                  /// [color] and [sizes]
                  Row(
                    children: <Widget>[
                      if (widget.cartItem!['sizeColorId'] != null)
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(
                              int.parse(widget.cartItem!['sizeColorLabel']
                                  .replaceAll('#', "0xFF")),
                            ),
                          ),
                        ),
                      SizedBox(width: 8.0),
                      Text(widget.cartItem!['productSizeLabel']),
                    ],
                  ),

                SizedBox(height: 5),

                /// [price]
                Text(
                    "₦${widget.cartItem!['price'] ?? widget.cartItem!['product']['price']}",
                    style: textTheme.bodyText1),

                /// [Call to Actions] and [Quantity]
                ///

                if (widget.showActions)
                  CartActions(
                    cartItem: CartItem.fromJson(widget.cartItem!),
                  ),

                widget.cartType == CartType.Wishlist
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          loading == true
                              ? ProgressbarCircular()
                              : GestureDetector(
                                  onTap: () async {
                                    setState(() {
                                      loading = true;
                                    });
                                    ApiResource apiResource = ApiResource();
                                    await apiResource.deleteWishlist(
                                      userId: Provider.of<AppState>(context,
                                              listen: false)
                                          .authenticatedUser!
                                          .id!,
                                      wishListSlug: widget.wishListName!,
                                      productNumber: widget.cartItem!['product']
                                          ['productNumber'],
                                      // userId: cartItem['product']['']
                                    );
                                    setState(() {
                                      loading = false;
                                    });
                                    widget.remove!();
                                  },
                                  child: Container(
                                    child: Text.rich(
                                      TextSpan(
                                        children: [
                                          WidgetSpan(
                                            child: Icon(
                                              Icons.delete_forever,
                                              color: Colors.grey.shade500,
                                              size: 24,
                                            ),
                                            alignment:
                                                PlaceholderAlignment.middle,
                                          ),
                                          TextSpan(text: 'REMOVE'),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                          Spacer(),
                          widget.cartItem!['product']['remainingStock'] == 0
                              ? SizedBox()
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Theme.of(context)
                                        .colorScheme
                                        .primaryVariant,
                                  ),
                                  onPressed: () {
                                    if (widget.cartItem!['product']
                                            ['remainingStock'] ==
                                        0) {
                                    } else {
                                      print(widget.cartItem!['quantity']);

                                      // if out of stock, don't add to cart.
                                      if (widget.cartItem!['quantity'] == 0)
                                        return;

                                      // add to cart
                                      final CartItem newcartItem = CartItem(
                                        productNumber:
                                            widget.cartItem!['product']
                                                ['productNumber'],
                                        quantity: 1,
                                        maxQty: widget.cartItem!['quantity'],
                                        isOutOfStock: widget.cartItem!['product']
                                            ['isOnSale'],
                                        product: Product.fromJson(
                                            widget.cartItem!['product']),
                                        // productSizeId: selectedSize?.productSizeId,
                                        // productSizeLabel: selectedSize?.size?.sizeName,
                                        // sizeColorId: selectedColor?.sizeColorId,
                                        // sizeColorLabel: selectedColor?.color?.colorCode,
                                        price: widget.cartItem!['product']
                                            ['price'],
                                        // productSize: selectedSize != null ? selectedSize : null,
                                        // sizeColor: selectedColor != null ? selectedColor : null,
                                      );

                                      Provider.of<AppState>(context,
                                              listen: false)
                                          .addToCart(newcartItem);

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text('Item added to cart!'),
                                          behavior: SnackBarBehavior.floating,
                                          duration:
                                              Duration(milliseconds: 1500),
                                          elevation: 2,
                                        ),
                                      );
                                    }
                                  },
                                  child: Text('Add to Cart'),
                                ),
                        ],
                      )
                    : SizedBox()
              ],
            ),
          )
        ],
      ),
    );
  }
}

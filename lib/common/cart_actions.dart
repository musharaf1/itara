import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';
import '../model/Cart.dart';

import 'custom_alert.dart';
import 'quantity_selector.dart';

class CartActions extends StatelessWidget {
  final CartItem? cartItem;
  // bool isLoading = false;

  CartActions({this.cartItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 4.0, right: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Row(
          //   children: <Widget>[
          //     // WishlistCTA(),

          //   ],
          // ),
          GestureDetector(
            onTap: () async {
              await showDialog(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(builder: (context, setState) {
                      return CustomAlert(
                        title: "Remove Item",
                        desc:
                            'Are you sure you want to remove this item from the Cart?',
                        // loading: fa,
                        onCancel: () {
                          Navigator.pop(context);
                        },
                        onAction: () async {
                          Provider.of<AppState>(context, listen: false)
                              .removeCartItem(cartItem!);
                          Navigator.pop(context);
                        },
                      );
                    });
                  });
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
                      alignment: PlaceholderAlignment.middle,
                    ),
                    TextSpan(text: 'REMOVE'),
                  ],
                ),
              ),
            ),
          ),
          QuantitySelector(
            value: cartItem!.quantity ?? 0,
            max: cartItem!.maxQty ?? 0,
            onChange: (int value) {
              cartItem!.quantity = value;
              Provider.of<AppState>(context, listen: false)
                  .updateCartItemQty(cartItem!);

              // TODO: update cart
            },
          ),
        ],
      ),
    );
  }
}

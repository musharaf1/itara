import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:itarashop/common/product_cart.dart';
import '../../common/quantity_selector.dart';
import '../../common/small_button.dart';
import '../../common/wishlist_cta.dart';
import '../../model/Cart.dart';
import '../../ui/cart/cart_summary.dart';
import '../../app_state.dart';

class CartBasket extends StatelessWidget {
  final bool? centerTitle;
  final AppState? appState;

  CartBasket({this.centerTitle, this.appState});

  @override
  Widget build(BuildContext context) {
    final ThemeData t = Theme.of(context);

    return ListView.separated(
      separatorBuilder: (context, index) {
        if (index == 0 || index == appState!.cartItems.length) {
          return SizedBox.shrink();
        }
        return Divider(
          indent: 20.0,
          endIndent: 20.0,
          height: 1.0,
          color: Colors.black12,
        );
      },
      itemCount: appState!.cartItems.length + 2,
      itemBuilder: (BuildContext context, int index) {
        if (index == 0) {
          return Divider(height: 1.0);
        }

        if (index < appState!.cartItems.length + 1) {
          final CartItem cartItem = appState!.cartItems[index - 1];

          // convert to json cuz ProductCart is model indepodent
          return ProductCart(
            cartItem: cartItem.toMap(),
          );
        }

        return CartSummary(
          appState: appState!,
        );
      },
    );
  }
}

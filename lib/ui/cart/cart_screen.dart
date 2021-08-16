import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../ui/cart/cart_basket.dart';
import '../../ui/cart/cart_empty.dart';
import '../../app_state.dart';

class CartScreen extends StatelessWidget {
  final bool? centerTitle;

  CartScreen({this.centerTitle = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        elevation: 0,
        titleSpacing: 0,
        centerTitle: centerTitle,
        backgroundColor: Colors.transparent,
        title: Text(
          'Cart',
         style: Theme.of(context).textTheme.headline6!.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
      ),
      body: Consumer<AppState>(
        builder: (BuildContext context, AppState appState, Widget? child) {
          if (appState.cartItems.isEmpty) {
            return CartEmpty(centerTitle: centerTitle).build(context);
          }
          return CartBasket(centerTitle: centerTitle, appState: appState);
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../model/Product.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import 'button_widget.dart';

class AddCart extends StatefulWidget {
  final Product? product;
  final Function? onTap;
  final int? maxQty;

  AddCart({@required this.product, @required this.onTap, this.maxQty});

  @override
  _AddCartState createState() => _AddCartState();
}

class _AddCartState extends State<AddCart> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (BuildContext context, AppState appState, Widget? child) {
        bool isInCart = appState.cartItems.any((element) =>
            element.product!.productNumber == widget.product!.productNumber);

        return Container(
          height: 75,
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              buildCartStatus(appState),
              SizedBox(width: 12.0),
              buildCartBtn(isInCart, widget.maxQty!),
            ],
          ),
        );
      },
    );
  }

  Expanded buildCartBtn(bool isInCart, int qty) {
    if (isInCart) {
      return Expanded(
        flex: 6,
        child: Button(
          
          label: 'ALREADY IN CART',
        ),
      );
    }
    return Expanded(
      flex: 6,
      child: GestureDetector(
        onTap: () => widget.onTap!(),
        child: Button(
          label: 'ADD TO CART',
          disabled: qty == 0,
          gradient: 'colored',
        ),
      ),
    );
  }

  Expanded buildCartStatus(AppState appState) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed('/cart');
        },
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black12.withAlpha(10),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: SvgPicture.asset(
                'assets/images/cart_active.svg',
                fit: BoxFit.contain,
              ),
            ),
            if (appState.cartItems.isNotEmpty)
              Positioned(
                right: 0,
                top: 10,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      appState.cartItems.length.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}

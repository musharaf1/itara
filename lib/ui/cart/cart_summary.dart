import 'package:flutter/material.dart';
import 'package:itarashop/common/product_grid.dart';
import 'package:itarashop/common/progressbar_circular.dart';
import 'package:itarashop/model/Product.dart';
import '../../api/ApiResource.dart';
import 'package:provider/provider.dart';
import '../../app_state.dart';
import '../../common/button_widget.dart';
import '../../common/headline_link.dart';
import 'cart_empty.dart';

class CartSummary extends StatefulWidget {
  final AppState? appState;
  CartSummary({this.appState});

  @override
  _CartSummaryState createState() => _CartSummaryState();
}

class _CartSummaryState extends State<CartSummary> {
  final ApiResource _apiResoure = ApiResource();
  bool? loading;

  @override
  void initState() {
    loading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Divider(height: 45.0),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'Add coupon on the payment page',
          ),
        ),
        Divider(height: 45.0),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Subtotal',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${widget.appState!.cartTotal}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primaryVariant,
                    ),
                  ),
                ],
              ),
              // Divider(height: 20.0),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: <Widget>[
              //     Text(
              //       'Total',
              //       style: TextStyle(
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //     Text(
              //       '$total',
              //       style: TextStyle(
              //         color: Theme.of(context).colorScheme.primaryVariant,
              //       ),
              //     ),
              //   ],
              // ),
              SizedBox(height: 20.0),
              Consumer<AppState>(
                builder:
                    (BuildContext context, AppState appState, Widget? child) {
                  if (!appState.isAuthenticated) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/signin');
                      },
                      child: Button(
                        label: 'SIGN IN TO CONTINUE',
                      ),
                    );
                  }
                  //
                  else {
                    return InkWell(
                      child: Button(
                        label: 'PROCEED TO CHECKOUT',
                        gradient: 'colored',
                        loading: loading!,
                      ),
                      onTap: () async {
                        // return Navigator.pushNamed(context, '/checkout');
                        if (loading == false) {
                          setState(() {
                            loading = true;
                          });

                          try {
                            final Map res = await _apiResoure.checkout(
                              appState.authenticatedUser!.id!,
                              appState.cartItems,
                            );

                            //TODO: if res['changedItems'], show changed cart items
                            // print("Total price");
                            // print(res['totalPrice']);
                            // print(res);

                            await Navigator.of(context).pushNamed(
                              '/checkout-step-1',
                              arguments: <String, String>{
                                'subtotal': res['totalPrice'],
                              },
                            );
                          } catch (e) {
                            print(e);
                            final SnackBar snackbar = SnackBar(
                              duration: Duration(milliseconds: 3000),
                              elevation: 1,
                              behavior: SnackBarBehavior.floating,
                              content: Text('Network timeout. Try again'),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackbar);
                          }

                          setState(() {
                            loading = false;
                          });
                        }
                      },
                    );
                  }
                },
              ),
              Grid(),
              // SizedBox(height: 12),
              // GestureDetector(
              //   onTap: () async {
              //     final String tel = 'tel://08170135412';

              //     if (await canLaunch(tel)) {
              //       await launch(tel);
              //     } else {
              //       print("Could not launch url");
              //     }
              //   },
              //   child: Button(
              //     label: 'CALL TO ORDER',
              //   ),
              // ),
            ],
          ),
        ),
        SizedBox(height: 20.0),
      ],
    );
  }
}

class Grid extends StatelessWidget {
  Grid({Key? key}) : super(key: key);
  ApiResource _apiResource = ApiResource();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      child: FutureBuilder(
        future: _apiResource.getSimilarProducts(
            Provider.of<AppState>(context).cartItems[0].product!.productNumber!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: ProgressbarCircular(
                useLogo: true,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('No products available'),
            );
          } else {
            final Map data = snapshot.data as Map;
            final List<Product> products = data['products'];

            return TheProducts(
              products: products,
              meta: data['meta'],
              headlineText: 'You might also like..',
            );
          }
        },
      ),
    );
  }
}

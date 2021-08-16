import 'package:flutter/material.dart';
import 'package:itarashop/common/button_widget.dart';
import 'package:itarashop/common/delivery_address.dart';
import 'package:itarashop/common/delivery_option.dart';
import 'package:itarashop/common/payment_option.dart';
import 'package:itarashop/common/product_cart.dart';
import 'package:itarashop/common/total.dart';
import 'package:itarashop/model/Delivery.dart';
import '../../common/checkout_appbar.dart';

class SummaryScreen extends StatefulWidget {
  final Map? orderSummary;

  SummaryScreen({@required this.orderSummary});

  @override
  _SummaryScreenState createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    print(widget.orderSummary);
    print(widget.orderSummary!['orderItems']);

    return Scaffold(
      appBar: CheckoutAppBar(step: 2).build(
        context,
      ),
      // appBar: AppBar(),
      body: ListView(
        children: [
          Divider(height: 1),
          Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Your Order', style: textTheme.bodyText1),
                SizedBox(height: 16),

                // order items
                for (var orderItem in widget.orderSummary!['orderItems'])
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: ProductCart(
                      cartItem: orderItem,
                      showActions: false,
                    ),
                  ),

                SizedBox(height: 16),

                // order total
                Total(
                  subtotal: widget.orderSummary!['orderPrice'],
                  shipping: widget.orderSummary!['shippingPrice'],
                  // vat: widget.orderSummary!['vat'],
                  vat: '',
                  total: widget.orderSummary!['totalPrice'],
                  couponCode: '0',
                  isSummary: true,

                ),

                Divider(height: 1),

                SizedBox(height: 24),

                // Address
                DeliveryAddress(
                  userId: widget.orderSummary!['user']['id'],
                  isSummary: true,
                  address:
                      Delivery.fromJson(widget.orderSummary!['deliveryAddress']),
                ),

                Divider(height: 1),

                // Delivery Method
                SizedBox(height: 24),
                Text(
                  'Delivery Method',
                  style: Theme.of(context).textTheme.bodyText1,
                ),

                DeliveryOption(
                  address: Delivery(),
                  option: widget.orderSummary!['deliveryOption'],
                  isSelected: true,
                  isSummary: true,
                ),

                // Payment Method
                SizedBox(height: 24),
                Text(
                  'Payment Method',
                  style: Theme.of(context).textTheme.bodyText1,
                ),

                PaymentOption(
                  option: widget.orderSummary!['paymentMethod'],
                  isSelected: true,
                  isSummary: true,
                ),

                // Submit order
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: InkWell(
                    child: Button(
                      label: 'CONFIRM',
                      gradient: 'colored',
                      textColor: Colors.white,
                      disabled: false,
                      loading: false,
                    ),
                    onTap: () async {
                      // print(widget.orderSummary['payment']['authorizationUrl']);
                      final String authorizationUrl =
                          widget.orderSummary!['payment']['authorizationUrl'];

                      await Navigator.pushNamed(
                        context,
                        '/webview',
                        arguments: <String, String>{
                          'url': authorizationUrl,
                          'title': 'Confirm Payment',
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

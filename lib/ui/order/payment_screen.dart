import 'package:flutter/material.dart';
import '../../common/coupon_manager.dart';
import '../../common/payment_option.dart';
import '../../common/total.dart';
import '../../api/ApiResource.dart';
import '../../ui/shims/delivery_option.dart';
import '../../common/checkout_appbar.dart';

class PaymentScreen extends StatefulWidget {
  final String? deliveryAddressId;
  final String? deliveryOptionSlug;
  final String? userId;
  final String? subtotal;
  final String? shippingFee;

  PaymentScreen({
    @required this.deliveryAddressId,
    @required this.deliveryOptionSlug,
    @required this.userId,
    @required this.subtotal,
    this.shippingFee,
  });

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  List paymentMethods = [];
  String? couponCode;
  String couponPrice = '0';
  String? paymentMethodSlug;
  bool isLoading = false;

  final ApiResource apiResource = ApiResource();

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: CheckoutAppBar(step: 1).build(
        context,
      ),
      body: FutureBuilder<List>(
          future: apiResource.paymentMethods(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              paymentMethods = snapshot.data!;
            }

            return StatefulBuilder(builder: (context, setState) {
              return ListView(
                children: [
                  Divider(height: 1),

                  /// Payment Method
                  Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Payment Method',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        if (paymentMethods.isEmpty)
                          Column(
                            children: [
                              DeliveryOptionShimmer(),
                              Divider(height: 1),
                            ],
                          ),
                        if (paymentMethods.isNotEmpty)
                          Column(
                            children: [
                              for (MapEntry option
                                  in paymentMethods.asMap().entries)
                                Column(
                                  children: [
                                    InkWell(
                                      child: PaymentOption(
                                        option: option.value,
                                        isSelected:
                                            option.value['paymentMethodSlug'] ==
                                                paymentMethodSlug,
                                      ),
                                      onTap: () {
                                        paymentMethodSlug =
                                            option.value['paymentMethodSlug'];
                                        setState(() {});
                                      },
                                    ),
                                    if (option.key < paymentMethods.length - 1)
                                      Divider(height: 1)
                                  ],
                                ),
                            ],
                          )
                      ],
                    ),
                  ),

                  Divider(height: 1),

                  /// Coupon Code
                  Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Use a Coupon code',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        SizedBox(height: 16),
                        CouponManager(
                          onSave: (String coupon, String price) {
                            setState(() {
                              couponCode = coupon;
                              couponPrice = price;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  Divider(height: 1),

                  Total(
                    buttonLabel: 'Continue to Summary',
                    subtotal: widget.subtotal,
                    isDisabled: paymentMethodSlug == null,
                    isLoading: isLoading,
                    couponCode: couponPrice,
                    vat: '',
                    // vat: (0.075 *
                    //         double.parse(widget.subtotal!.replaceAll(',', '')))
                    //     .toString(),
                    shipping: widget.shippingFee!,
                    // shipping: '',
                    // total: (double.parse(widget.subtotal.replaceAll(',', '')) +
                    //         ((double.parse(couponPrice) / 100) *
                    //             double.parse(
                    //                 widget.subtotal.replaceAll(',', ''))))
                    //     .toString(),
                    total: (double.parse(
                                widget.shippingFee!.replaceAll(',', '')) +
                            double.parse(widget.subtotal!.replaceAll(',', '')) -
                            ((double.parse(couponPrice) / 100) *
                                double.parse(
                                    widget.subtotal!.replaceAll(',', ''))))
                        .toString(),
                    // total: (double.parse(
                    //             widget.shippingFee!.replaceAll(',', '')) +
                    //         double.parse(widget.subtotal!.replaceAll(',', '')) +
                    //         (0.075 *
                    //             double.parse(
                    //                 widget.subtotal!.replaceAll(',', ''))) -
                    //         ((double.parse(couponPrice) / 100) *
                    //             double.parse(
                    //                 widget.subtotal!.replaceAll(',', ''))))
                    //     .toString(),
                    onTap: () async {
                      // print("saved");
                      // print(paymentMethodSlug);
                      // print(couponCode);

                      isLoading = true;
                      setState(() {});

                      var order = <String, dynamic>{
                        'deliveryAddressId': widget.deliveryAddressId,
                        'deliveryOptionSlug': widget.deliveryOptionSlug,
                        'userId': widget.userId,
                        'couponCode': couponCode,
                        'paymentMethodSlug': paymentMethodSlug,
                      };
                      print(order.toString());

                      try {
                        // post order
                        var response = await apiResource.createOrder(
                          order: order,
                        );

                        setState(() {
                          isLoading = false;
                        });

                        // return to summary
                        await Navigator.of(context).pushNamed(
                          '/checkout-step-3',
                          arguments: <String, dynamic>{
                            'orderSummary': response,
                          },
                        );
                      } catch (e) {
                        setState(() {
                          isLoading = false;
                        });

                        // Helpers.

                        // TODO: handle error
                      }
                    },
                  ),
                ],
              );
            });
          }),
    );
  }
}

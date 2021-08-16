import 'package:flutter/material.dart';
import 'package:itarashop/api/err.dart';
import 'package:itarashop/common/total.dart';
import 'package:itarashop/model/Delivery.dart';
import 'package:provider/provider.dart';
import '../../api/ApiResource.dart';
import '../../app_state.dart';
import '../../common/button_widget.dart';
import '../../common/checkout_appbar.dart';
import '../../common/delivery_address.dart';
import '../../common/delivery_option.dart';
import '../../ui/shims/delivery_option.dart';
import '../../utils/utils.dart';

class CheckoutScreen extends StatefulWidget {
  final String? subtotal;

  CheckoutScreen({@required this.subtotal});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final ApiResource apiResource = ApiResource();
  String? deliveryOptionSlug;
  String shippingFee = '0';
  List deliveryOptions = [];

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: CheckoutAppBar(
        step: 0,
      ).build(
        context,
      ),
      body: Consumer<AppState>(builder: (context, appstate, _) {
        Delivery? address;
        final String userId = appstate.authenticatedUser!.id!;
        Delivery? providerAddress = appstate.address;

        if (appstate.addressBook != null && appstate.addressBook!.isNotEmpty) {
          if (providerAddress == null ||
              providerAddress.deliveryAddressId!.length < 1) {
            final defaultAddress = appstate.addressBook!.firstWhere(
              (element) => element['isDefaultDeliveryAddress'] == true,
              orElse: () => appstate.addressBook!.first,
            );

            address = Delivery.fromJson(defaultAddress);
          } else {
            address = providerAddress;
          }
        }

        // print(address == null);

        return FutureBuilder<List>(
            future: apiResource.deliveryOptions(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                deliveryOptions = snapshot.data!;
              }

              return ListView(
                children: <Widget>[
                  Divider(height: 1.0),

                  /// Address Details
                  DeliveryAddress(
                    userId: userId,
                    address: address,
                    isSummary: false,
                  ),

                  Divider(height: 1.0),

                  /// Delivery Method
                  Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Delivery Preference',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        if (deliveryOptions.isEmpty)
                          Column(
                            children: [
                              DeliveryOptionShimmer(),
                              Divider(height: 1),
                            ],
                          ),
                        if (deliveryOptions.isNotEmpty)
                          Column(
                            children: [
                              for (MapEntry option
                                  in deliveryOptions.asMap().entries)
                                Column(
                                  children: [
                                    InkWell(
                                      child: DeliveryOption(
                                        address: address,
                                        option: option.value,
                                        isSelected: deliveryOptionSlug ==
                                            option.value['deliveryOptionSlug'],
                                      ),
                                      onTap: () {
                                        if (address == null) {
                                          ShowErrors.showErrors(
                                              'You need to add/select a delivery address first');
                                        } else {
                                          setState(() {
                                            deliveryOptionSlug = option
                                                .value['deliveryOptionSlug'];
                                            shippingFee = getPrice(
                                                option.value['basePrice'],
                                                context,
                                                address!,
                                                option.value)!;
                                          });
                                        }
                                      },
                                    ),
                                    if (option.key == 0) Divider(height: 1),
                                  ],
                                ),
                            ],
                          ),

                        // TODO: handle error
                        Container(),
                      ],
                    ),
                  ),

                  Divider(height: 1),

                  /// Total
                  Total(
                    buttonLabel: 'Continue to Payment',
                    shipping: shippingFee,
                    // shipping: '',
                    subtotal: widget.subtotal,
                    vat: '',
                    // vat: (0.075 *
                    //         double.parse(widget.subtotal!.replaceAll(',', '')))
                    //     .toString(),
                    // total: '',
                    total: (double.parse(shippingFee.replaceAll(',', '')) +
                            double.parse(widget.subtotal!.replaceAll(',', '')))
                        .toString(),
                    // total: (double.parse(shippingFee.replaceAll(',', '')) +
                    //         double.parse(widget.subtotal!.replaceAll(',', '')) +
                    //         (0.075 *
                    //             double.parse(
                    //                 widget.subtotal!.replaceAll(',', ''))))
                    //     .toString(),
                    isDisabled: deliveryOptionSlug == null || address == null,
                    onTap: () async {
                      await Navigator.of(context).pushNamed(
                        '/checkout-step-2',
                        arguments: <String, String>{
                          'deliveryAddressId': address!.deliveryAddressId!,
                          'deliveryOptionSlug': deliveryOptionSlug!,
                          'userId': userId,
                          'subtotal': widget.subtotal!,
                          'shippingFee': shippingFee,
                        },
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    child: Center(
                      child: Text(
                        'You will be able to add Coupon code in the next step',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            });
      }),
    );
  }
}

String? getPrice(String base, BuildContext context, Delivery? address,
    Map<String, dynamic> option) {
  if (address != null) {
    bool island = address.isOnIsland ?? true;

    if (island == true) {
      if (option['name'].toString().contains('Fast')) {
        final appState = Provider.of<AppState>(context, listen: false);
        var cartItems = appState.cartItems;
        String islandAddition = option['additionalCostPerProductIsland']
            .toString()
            .replaceAll(".00", "")
            .replaceAll(',', '');

        String base = option['basePriceIsland']
            .toString()
            .replaceAll(".00", "")
            .replaceAll(',', '');
        String isLandCap = option['priceCapIsland']
            .toString()
            .replaceAll(".00", "")
            .replaceAll(',', '');
        print('This is the option ${option}');
        print('This is the land addition  $islandAddition');

        double addedPrice =
            double.parse(islandAddition) * (cartItems.length - 1).toDouble();
        double price =
            (double.parse(base) + addedPrice) > double.parse(isLandCap)
                ? double.parse(isLandCap)
                : (double.parse(base) + addedPrice);
        return price.toStringAsFixed(2);
      } else {
        final appState = Provider.of<AppState>(context, listen: false);
        var cartItems = appState.cartItems;
        String islandAddition = option['additionalCostPerProductIsland']
            .toString()
            .replaceAll(".00", "")
            .replaceAll(',', '');

        String base = option['basePriceIsland']
            .toString()
            .replaceAll(".00", "")
            .replaceAll(',', '');

        String isLandCap = option['priceCapIsland']
            .toString()
            .replaceAll(".00", "")
            .replaceAll(',', '');

        double addedPrice =
            double.parse(islandAddition) * (cartItems.length - 1).toDouble();
        double price =
            (double.parse(base) + addedPrice) > double.parse(isLandCap)
                ? double.parse(isLandCap)
                : (double.parse(base) + addedPrice);
        return price.toStringAsFixed(2);
      }
    } else {
      if (option['name'].toString().contains('Standard')) {
        final appState = Provider.of<AppState>(context, listen: false);
        var cartItems = appState.cartItems;
        String islandAddition = option['additionalCostPerProductMainland']
            .toString()
            .replaceAll(".00", "")
            .replaceAll(',', '');

        String base = option['basePriceMainland']
            .toString()
            .replaceAll(".00", "")
            .replaceAll(',', '');

        String isLandCap = option['priceCapMainland']
            .toString()
            .replaceAll(".00", "")
            .replaceAll(',', '');

        double addedPrice =
            double.parse(islandAddition) * (cartItems.length - 1).toDouble();
        double price =
            (double.parse(base) + addedPrice) > double.parse(isLandCap)
                ? double.parse(isLandCap)
                : (double.parse(base) + addedPrice);
        return price.toStringAsFixed(2);
      } else {
        final appState = Provider.of<AppState>(context, listen: false);
        var cartItems = appState.cartItems;
        String islandAddition = option['additionalCostPerProductMainland']
            .toString()
            .replaceAll(".00", "");
        String base = option['basePriceMainland']
            .toString()
            .replaceAll(".00", "")
            .replaceAll(',', '');

        String isLandCap = option['priceCapMainland']
            .toString()
            .replaceAll(".00", "")
            .replaceAll(',', '');

        double addedPrice =
            double.parse(islandAddition) * (cartItems.length - 1).toDouble();
        double price =
            (double.parse(base) + addedPrice) > double.parse(isLandCap)
                ? double.parse(isLandCap)
                : (double.parse(base) + addedPrice);
        return price.toStringAsFixed(2);
      }
    }
  } else {
    return '';
  }
}

// String getPrice(String base, BuildContext context, Delivery address,
//     Map<String, dynamic> option) {
//   bool island = address.isOnIsland!;

//   if (island == true) {
//     if (option['name'].toString().contains('Fast')) {
//       final appState = Provider.of<AppState>(context, listen: false);
//       var cartItems = appState.cartItems;
//       double addedPrice = 150 * cartItems.length.toDouble();
//       String value = base.replaceAll(".00", "");
//       double added = addedPrice;
//       double price = (double.parse(value) + added) > 3000
//           ? 3000
//           : (double.parse(value) + added);
//       print(price);
//       return price.toStringAsFixed(2);
//     } else {
//       final appState = Provider.of<AppState>(context, listen: false);
//       var cartItems = appState.cartItems;
//       double addedPrice = 120 * cartItems.length.toDouble();
//       String value = base.replaceAll(".00", "");
//       double added = addedPrice;
//       double price = (double.parse(value) + added) > 2320
//           ? 2320
//           : (double.parse(value) + added);
//       return price.toStringAsFixed(2);
//     }
//   } else {
//     if (option['name'].toString().contains('Standard')) {
//       final appState = Provider.of<AppState>(context, listen: false);
//       var cartItems = appState.cartItems;
//       double addedPrice = 200 * cartItems.length.toDouble();
//       String value = base.replaceAll(".00", "");
//       double added = addedPrice;
//       double price = (double.parse(value) + added) > 4000
//           ? 4000
//           : (double.parse(value) + added);
//       return price.toStringAsFixed(2);
//     } else {
//       final appState = Provider.of<AppState>(context, listen: false);
//       var cartItems = appState.cartItems;
//       double addedPrice = 150 * cartItems.length.toDouble();
//       String value = base.replaceAll(".00", "");
//       double added = addedPrice;
//       double price = (double.parse(value) + added) > 3000
//           ? 3000
//           : (double.parse(value) + added);
//       return price.toStringAsFixed(2);
//     }
//   }
// }

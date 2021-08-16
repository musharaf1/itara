import 'package:flutter/material.dart';
import 'package:itarashop/app_state.dart';
import 'package:itarashop/model/Delivery.dart';
import 'package:itarashop/ui/order/checkout_screen.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

class DeliveryOption extends StatelessWidget {
  final Map<String, dynamic>? option;
  final bool isSelected;
  final bool isSummary;
  final Delivery? address;

  DeliveryOption(
      {required this.option,
      this.isSelected = false,
      this.isSummary = false,
      required this.address});

  String formatStringRangeToDate(String date) {
    final List dt = date.split(" - ").toList();
    // TODO: Fixed Dart Bug returning [0] before [0] and [1]
    if (dt.length == 2) {
      date = Jiffy(DateTime.parse(dt[0])).format("EEE do, MMMM");
      date += " - " + Jiffy(DateTime.parse(dt[1])).format("EEE do, MMMM");
    }
    return date;
  }

  // String getPrice(BuildContext context) {
  //   final appState = Provider.of<AppState>(context);
  //   var cartItems = appState.cartItems;
  //   double addedPrice = 150 * cartItems.length.toDouble();
  //   String value  = option['basePrice'].replaceAll(".00", "");
  //   double added = addedPrice > 2000? 2000 : addedPrice;
  //   double price = double.parse(value) + added;
  //   return price.toInt().toString();
  // }
  String price = '';

  @override
  Widget build(BuildContext context) {
    if (isSummary == false) {
      price = getPrice(option!['basePrice'], context, address, option!)!;
    }
    // print(option);
    final TextTheme textTheme = Theme.of(context).textTheme;

    final TextStyle mutedStyle = textTheme.bodyText2!.copyWith(
      color: Colors.black45,
      height: 1.3,
      fontSize: 14,
    );
    final TextStyle strongStyle = textTheme.bodyText2!.copyWith(
      height: 1.3,
      fontSize: 14,
    );

    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 16),
      dense: true,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (isSelected)
            Icon(Icons.check_circle)
          else
            Icon(
              Icons.circle,
              color: Colors.grey.withOpacity(.3),
            ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: option!['name'],
                        style: textTheme.bodyText2,
                      ),
                      TextSpan(text: "  "),
                      if (isSummary == false)
                        TextSpan(
                          text: "From ₦${option!['basePriceIsland']}",
                          // text: price.isEmpty
                          //     ? "From ${option!['basePriceIsland']}"
                          //     : "₦" +
                          //         getPrice(option!['basePrice'], context,
                          //             address, option!)!,
                          style: textTheme.bodyText1!.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                    option!['name'].toString().contains('Fast')
                        ? 'Available Monday to Friday excluding Public holidays.'
                        : 'Available Monday to Friday excluding Public holidays.',
                    style: mutedStyle),
                SizedBox(height: 4),
                Text(
                    option!['name'].toString().contains('Fast')
                        ? 'Your product will be delivered on or before'
                        : 'Your product will be delivered between',
                    style: mutedStyle),
                if (option!['estimatedDeliveryDate'] != null)
                  Text(
                    option!['name'].toString().contains('Fast')
                        ? Jiffy(DateTime.parse(
                                option!['estimatedDeliveryDate']))
                            .format("EEE do, MMMM")
                        : formatStringRangeToDate(
                            option!['estimatedDeliveryDate']),
                    style: strongStyle,
                  ),
                // if (!isSummary)
                //   Text.rich(
                //     TextSpan(
                //       children: [
                //         TextSpan(text: 'Friday, May 13th', style: strongStyle),
                //         TextSpan(text: ' and ', style: mutedStyle),
                //         TextSpan(text: 'Monday May 15th', style: strongStyle),
                //       ],
                //     ),
                //   ),
                if (!isSummary)
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: 'between ', style: mutedStyle),
                        TextSpan(text: '9am - 5pm', style: strongStyle),
                      ],
                    ),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

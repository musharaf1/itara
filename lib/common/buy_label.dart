import 'package:flutter/material.dart';

class BuyLabel extends StatelessWidget {
  final String? price;
  final String? comparePrice;

  BuyLabel({@required this.price, this.comparePrice});

  String formatComparePrice() {
    double _price = double.parse(price!.replaceFirst(',', ''));
    double _comparePrice = double.parse(comparePrice!.replaceFirst(',', ''));

    var compare = (_comparePrice / _price) * 100;
    return '${compare.toStringAsFixed(0)}%';
  }

  @override
  Widget build(BuildContext context) {
    bool hasCompare = comparePrice != null;

    if (hasCompare) {
      return buildPriceCompare(context);
    } else {
      return buildPrice(context);
    }
  }

  Widget buildPrice(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(width: 1, color: Colors.black12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'BUY',
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(width: 4),
          Text(
            "₦${price}",
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primaryVariant),
          ),
        ],
      ),
    );
  }

  Widget buildPriceCompare(BuildContext context) {
    return FittedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(
              // horizontal: 10,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              // border: Border.all(width: 1, color: Colors.black12),
            ),
            child: Row(
              children: <Widget>[
                Text(
                  'BUY',
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                SizedBox(width: 4),
                Text(
                  "₦${price}",
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.primaryVariant,
                        decoration: TextDecoration.lineThrough,
                      ),
                ),
                SizedBox(width: 4),
                Text(
                  "₦${comparePrice}",
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
          ),
          SizedBox(height: 4),
          // Container(
          //   padding: EdgeInsets.all(6.0),
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(5.0),
          //     color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          //   ),
          //   child: Text(
          //     formatComparePrice() + " Discount",
          //     style: TextStyle(
          //       color: Theme.of(context).colorScheme.primaryVariant,
          //       // fontSize: 12,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class PaymentOption extends StatelessWidget {
  final Map? option;
  final bool isSelected;
  final bool isSummary;

  PaymentOption({
    @required this.option,
    this.isSelected = false,
    this.isSummary = false,
  });

  @override
  Widget build(BuildContext context) {
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

    // print(option);

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  option!['name'],
                  style: textTheme.bodyText2,
                ),
                SizedBox(height: 8),
                Image.network(
                  option!['imageUrl'],
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 8),
                Text(
                  'Your payment is safe. If anything goes wrong we\'ve got your back',
                  style: mutedStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

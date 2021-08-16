import 'package:flutter/material.dart';
import '../utils/utils.dart';
import 'button_widget.dart';

class Total extends StatelessWidget {
  final String? subtotal;
  final String couponCode;
  final String shipping;
  final String total;
  final String vat;
  final Function? onTap;
  final bool isDisabled;
  final bool isLoading;
  final bool isSummary;
  final String buttonLabel;

  Total({
    @required this.subtotal,
    this.shipping = "-",
    this.total = "",
    this.vat = "",
    this.onTap,
    this.isDisabled = true,
    this.buttonLabel = "Submit",
    this.isLoading = false,
    this.isSummary = false,
    this.couponCode = '',
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(24, 24, 24, 16),
      // : EdgeInsets.zero,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Subtotal'),
              Text(toPrice(subtotal)),
            ],
          ),
          if (this.shipping.isNotEmpty) SizedBox(height: 8.0),
          if (this.shipping.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Shipping Fee'),
                Text(toPrice(this.shipping)),
              ],
            ),
          SizedBox(height: 8.0),
          if (this.vat.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('VAT'),
                Text(toPrice(this.vat)),
              ],
            ),
          if (this.vat.isNotEmpty) SizedBox(height: 16.0),
          if (this.couponCode.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${this.couponCode}% off'),
                Text(
                    '(${toPrice(double.parse(this.couponCode) / 100 * double.parse(this.subtotal!.replaceAll(',', '')))})'),
              ],
            ),
          total.isEmpty ? SizedBox.shrink() : SizedBox(height: 16.0),
          Divider(height: 1),
          SizedBox(height: 16.0),
          if (total.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total', style: textTheme.bodyText1),
                Text(
                  toPrice(this.total),
                  style: textTheme.bodyText1!.copyWith(
                    color: Theme.of(context).colorScheme.primaryVariant,
                  ),
                ),
              ],
            ),
          total.isEmpty
              ? SizedBox.shrink()
              : SizedBox(height: isSummary ? 16.00 : 32.0),
          total.isEmpty ? SizedBox.shrink() : Divider(height: 1),
          total.isEmpty
              ? SizedBox.shrink()
              : SizedBox(height: isSummary ? 16.00 : 32.0),
          if (!isSummary)
            InkWell(
              child: Button(
                label: buttonLabel,
                gradient: 'colored',
                textColor: isDisabled ? Colors.black : Colors.white,
                disabled: isDisabled,
                loading: isLoading,
              ),
              onTap: () {
                if (onTap != null && !isDisabled) this.onTap!();
              },
            ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:itarashop/api/ApiResource.dart';
import 'package:itarashop/common/progressbar_circular.dart';

class CouponManager extends StatefulWidget {
  final Function(String couponSlug, String price) ?onSave;

  CouponManager({@required this.onSave});

  @override
  _CouponManagerState createState() => _CouponManagerState();
}

class _CouponManagerState extends State<CouponManager> {
  final ApiResource apiResource = ApiResource();
  final controller = TextEditingController();

  bool isLoading = false;
  Map? coupon;
  bool isValid = true;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                style: textTheme.bodyText1,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 4,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(
                      color: Colors.black12,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(
                      color: Colors.black12,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'enter your coupon here',
                  hintStyle: textTheme.bodyText2!.copyWith(
                    fontSize: 14,
                    color: Colors.grey.withOpacity(.8),
                  ),
                ),
                onFieldSubmitted: (String? value) async {
                  if (value != null && value.isNotEmpty) {
                    isLoading = true;
                    coupon = null;
                    setState(() {});

                    try {
                      coupon = await apiResource.getCoupon(couponCode: value);
                      isValid = true;

                      widget.onSave!(coupon!['couponCode'], coupon!['discountPercentage']);
                    } catch (e) {
                      isValid = false;
                    }
                    isLoading = false;
                    setState(() {});
                  }
                },
              ),
            ),
            SizedBox(width: 8),
            if (isLoading)
              SizedBox(
                height: 16,
                width: 16,
                child: ProgressbarCircular(),
              ),
            if (coupon != null && isValid)
              Icon(
                Icons.check,
                color: Colors.black,
                size: 16,
              ),
            if (!isLoading && !isValid)
              GestureDetector(
                onTap: () {
                  controller.clear();
                  isValid = true;
                  setState(() {
                    
                  });
                },
                child: Icon(
                  Icons.close,
                  color: Colors.red,
                  size: 16,
                ),
              ),
          ],
        ),
        SizedBox(height: 8),
        if (coupon != null && isValid)
          Center(
            child: Text.rich(
              TextSpan(children: [
                TextSpan(text: 'Your code is valid'),
                TextSpan(
                    text: '   ${coupon!['discountPercentage']}% Discount',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primaryVariant,
                    )),
              ]),
            ),
          ),
        if (!isValid)
          Center(
            child: Text(
              'Your code is invalid',
              style: TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }
}

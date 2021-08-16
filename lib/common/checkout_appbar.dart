import 'package:flutter/material.dart';

import 'button_widget.dart';

class CheckoutAppBar extends StatelessWidget {
  final int? step;

  CheckoutAppBar({this.step = 0});

  @override
  AppBar build(BuildContext context) {
    return AppBar(
      brightness: Brightness.light,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: EdgeInsets.only(
          left: 24,
          bottom: 10,
          
        ),
        title: FittedBox(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Button(
                label: 'Checkout',
                height: 35,
                gradient: step == 0 ? 'colored' : null,
                borderWidth: 1,
                borderColor: Colors.black12,
                fontWeight: FontWeight.w400,
              ),
              SizedBox(width: 2),
              Button(
                label: 'Payment',
                height: 35,
                gradient: step == 1 ? 'colored' : null,
                borderWidth: 1,
                borderColor: Colors.black12,
                fontWeight: FontWeight.w400,
              ),
              SizedBox(width: 2),
              Button(
                label: 'Summary',
                height: 35,
                gradient: step == 2 ? 'colored' : null,
                borderWidth: 1,
                borderColor: Colors.black12,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

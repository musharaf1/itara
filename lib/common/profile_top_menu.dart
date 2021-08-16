import 'package:flutter/material.dart';

import 'small_button.dart';

class ProfileTopMenu extends StatelessWidget {
  final String? userId;

  ProfileTopMenu({@required this.userId});

  @override
  Widget build(BuildContext context) {
    final Color color = Colors.black54;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SmallButton(
            title: 'Orders',
            icon: Icons.add_box_outlined,
            reverse: true,
            color: Colors.transparent,
            textColor: color,
            iconColor: color,
            padding: EdgeInsets.zero,
            fontSize: 14,
            iconSize: 24,
            onTap: () {
              Navigator.pushNamed(context, '/account/orders', arguments: {
                'userId': userId,
              });
            },
          ),
          SmallButton(
            title: 'Address',
            icon: Icons.pin_drop_outlined,
            reverse: true,
            color: Colors.transparent,
            textColor: color,
            iconColor: color,
            padding: EdgeInsets.zero,
            fontSize: 14,
            iconSize: 24,
            onTap: () {
              Navigator.pushNamed(context, '/account/address-book', arguments: {
                'userId': userId,
              });
            },
          ),
          SmallButton(
            title: 'Wishlists',
            icon: Icons.favorite_outline,
            reverse: true,
            color: Colors.transparent,
            textColor: color,
            iconColor: color,
            padding: EdgeInsets.zero,
            fontSize: 14,
            iconSize: 24,
            onTap: () {
              Navigator.pushNamed(context, '/account/wishlists', arguments: {
                'userId': userId,
              });
            },
          )
        ],
      ),
    );
  }
}

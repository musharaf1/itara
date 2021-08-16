import 'package:flutter/material.dart';

import '../app_theme.dart';

class ColorWidget extends StatelessWidget {
  final String? color;
  final bool? selected;
  final Function(String color)? onTap;

  ColorWidget({this.color, this.selected, this.onTap});
  @override
  Widget build(BuildContext context) {
    if (color == null) {
      return SizedBox(
        height: 30,
        width: 30,
      );
    }
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(int.parse(color!.replaceAll('#', "0xFF"))),
        boxShadow: [
          AppTheme.shadows['product']!,
        ],
      ),
      // padding: EdgeInsets.zero,
      height: 30,
      width: 30,
      margin: EdgeInsets.only(
        left: 3.0,
        top: 8.0,
        right: 16.0,
        bottom: 8.0,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(30.0),
        onTap: () {
          onTap!(color!);
        },
        child: selected!
            ? Icon(
                Icons.check,
                size: 18,
                color: color!.startsWith('#0000') ? Colors.white : Colors.black,
              )
            : SizedBox.shrink(),
      ),
    );
  }
}

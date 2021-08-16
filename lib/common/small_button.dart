import 'package:flutter/material.dart';

class SmallButton extends StatelessWidget {
  final String? title;
  final IconData? icon;
  final Color iconColor;
  final double borderRadius;
  final Color? color;
  final Color textColor;
  final Color borderColor;
  final bool reverse;
  final EdgeInsets padding;
  final double? fontSize;
  final double iconSize;
  final Function? onTap;

  SmallButton({
    @required this.title,
    this.icon,
    this.iconColor = Colors.white,
    this.onTap,
    this.borderRadius = 50.0,
    this.color,
    this.textColor = Colors.white,
    this.reverse = false,
    this.padding = EdgeInsets.zero,
    this.fontSize,
    this.iconSize = 16,
    this.borderColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => onTap!(),
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: BorderSide(width: 1, color: borderColor),
        ),
        padding: padding,
        primary: color == null
            ? Theme.of(context).colorScheme.primaryVariant
            : color,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        textDirection: reverse ? TextDirection.rtl : TextDirection.ltr,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              title!,
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                    fontSize: fontSize,
                  ),
            ),
          ),
          SizedBox(width: 4),
          if (icon != null)
            Icon(
              icon,
              size: iconSize,
              color: iconColor,
            ),
        ],
      ),
    );
  }
}

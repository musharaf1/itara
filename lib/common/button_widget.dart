import 'package:flutter/material.dart';
import '../common/progressbar_circular.dart';

import '../app_theme.dart';

class Button extends StatelessWidget {
  final String? label;
  final String? gradient;
  final bool loading;
  final double height;
  final Color? color;
  final Color? textColor;
  final IconData? icon;
  final bool disabled;
  final double borderWidth;
  final FontWeight fontWeight;
  final Color borderColor;

  Button({
    @required this.label,
    this.gradient,
    this.loading = false,
    this.height = 50.0,
    this.borderWidth = 2.0,
    this.borderColor = Colors.black,
    this.color,
    this.textColor,
    this.icon,
    this.disabled = false,
    this.fontWeight = FontWeight.w500,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: height,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      decoration: disabled || loading
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(6.0),
              color: Colors.black.withAlpha(30),
            )
          : BoxDecoration(
              gradient: gradient != null ? AppTheme.gradients[gradient] : null,
              border: gradient == null
                  ? Border.all(
                      color: this.borderColor,
                      width: this.borderWidth,
                    )
                  : null,
              borderRadius: BorderRadius.circular(6.0),
            ),
      child: loading
          ? ProgressbarCircular()
          : Text(
              label!,
              style: theme.textTheme.bodyText1!.copyWith(
                fontWeight: this.fontWeight,
                color: textColor != null
                    ? textColor
                    : gradient != null
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.secondary,
              ),
            ),
    );
  }
}

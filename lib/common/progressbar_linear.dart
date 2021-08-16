import 'package:flutter/material.dart';

class ProgressbarLinear extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(
        Theme.of(context).colorScheme.primaryVariant,
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
    );
  }
}

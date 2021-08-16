import 'package:flutter/material.dart';

class SlideHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      width: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black,
        border: Border.all(
          width: 6.0,
          color: Theme.of(context).colorScheme.primaryVariant,
        ),
      ),
    );
  }
}

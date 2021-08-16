import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ProgressbarCircular extends StatelessWidget {
  final double height;
  final double width;
  final bool useLogo;

  ProgressbarCircular({
    this.width = 30,
    this.height = 30,
    this.useLogo = false,
  });

  @override
  Widget build(BuildContext context) {
    if (useLogo) {
      return Lottie.asset(
        'assets/lottie/loader-faster.json',
        width: 45,
        height: 45,
        // frameRate: FrameRate.max,
        fit: BoxFit.cover,
      );
    }

    return SizedBox(
      height: height,
      width: width,
      child: CircularProgressIndicator(
        strokeWidth: 2.0,
        valueColor: AlwaysStoppedAnimation<Color>(
          Theme.of(context).colorScheme.primaryVariant,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

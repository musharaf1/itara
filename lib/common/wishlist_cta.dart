import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../common/progressbar_circular.dart';

class WishlistCTA extends StatefulWidget {
  final bool selected;

  WishlistCTA({this.selected = false});

  @override
  _WishlistCTAState createState() => _WishlistCTAState();
}

class _WishlistCTAState extends State<WishlistCTA> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return SizedBox(
        width: 14,
        height: 14,
        child: ProgressbarCircular(),
      );
    }

    if (widget.selected) {
      return Container(
        child: InkWell(
          borderRadius: BorderRadius.circular(30.0),
          onTap: () => removeWishlist(),
          child: SvgPicture.asset(
            'assets/images/heart_active.svg',
            width: 14,
            height: 14,
            fit: BoxFit.contain,
          ),
        ),
      );
    }

    return Container(
      child: InkWell(
        borderRadius: BorderRadius.circular(30.0),
        onTap: () => addWishlist(),
        child: SvgPicture.asset(
          'assets/images/heart.svg',
          width: 16,
          height: 16,
          color: Colors.black26,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  removeWishlist() {}

  addWishlist() {}
}

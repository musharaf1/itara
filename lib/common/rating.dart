import 'package:flutter/material.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class Rating extends StatelessWidget {
  final double? rating;

  Rating({@required this.rating});

  @override
  Widget build(BuildContext context) {
    return SmoothStarRating(
      starCount: 5,
      rating: rating,
      isReadOnly: true,
      size: 22,
      color: Theme.of(context).colorScheme.primary,
      borderColor: Theme.of(context).colorScheme.primary,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductCartShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade200,
            highlightColor: Colors.grey.shade300,
            child: Container(
              width: 120,
              height: 140,
              color: Colors.grey.shade200,
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey.shade200,
                highlightColor: Colors.grey.shade300,
                child: Container(
                  color: Colors.grey.shade200,
                  height: 14,
                  width: double.maxFinite - 100,
                ),
              ),
              SizedBox(height: 8),
              Shimmer.fromColors(
                baseColor: Colors.grey.shade200,
                highlightColor: Colors.grey.shade300,
                child: Container(
                  height: 14,
                  width: double.maxFinite - 100,
                  color: Colors.grey.shade200,
                ),
              ),
              SizedBox(height: 8),
              Shimmer.fromColors(
                baseColor: Colors.grey.shade200,
                highlightColor: Colors.grey.shade300,
                child: Container(
                  height: 8,
                  width: 80,
                  color: Colors.grey.shade200,
                ),
              ),
              SizedBox(height: 16),
              Shimmer.fromColors(
                baseColor: Colors.grey.shade200,
                highlightColor: Colors.grey.shade300,
                child: Container(
                  height: 6,
                  width: 50,
                  color: Colors.grey.shade200,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

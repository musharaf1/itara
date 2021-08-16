import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DeliveryOptionShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.black12.withAlpha(50),
      highlightColor: Colors.black12,
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 24, 0, 0),
        child: Column(
          children: [
            for (var i in [1, 2])
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.withOpacity(.4),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 20,
                            color: Colors.grey.withOpacity(.4),
                          ),
                          SizedBox(height: 8),
                          Container(
                            height: 10,
                            width: 200,
                            color: Colors.grey.withOpacity(.4),
                          ),
                          SizedBox(height: 8),
                          Container(
                            height: 10,
                            width: 200,
                            color: Colors.grey.withOpacity(.4),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}

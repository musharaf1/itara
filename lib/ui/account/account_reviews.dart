import 'package:flutter/material.dart';

class AccountReviewScreen extends StatelessWidget {
  final List reviews = ["Nice product", "Aweful product"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reviews', style: Theme.of(context).textTheme.headline6!.copyWith(
                fontWeight: FontWeight.w500,
              ),),
      ),
      body: Column(
        children: [
          Divider(
            height: 1.0,
          ),
          Expanded(
            child: Center(
              child: Text('No reviews'),
            ),
          ),
          // Expanded(
          //   child: ListView.separated(
          //     itemCount: reviews.length,
          //     itemBuilder: (context, int i) {
          //       return Container(
          //         child: Text('Hello $i'),
          //       );
          //     },
          //     separatorBuilder: (context, int i) {
          //       return Divider(
          //         height: 1.0,
          //       );
          //     },
          //   ),
          // )
        ],
      ),
    );
  }
}

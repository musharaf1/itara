import 'package:flutter/material.dart';
import 'package:itarashop/api/ApiResource.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'button_widget.dart';
import 'custom_alert.dart';

class ProductOrder extends StatefulWidget {
  final Map? item;

  const ProductOrder({@required this.item});

  @override
  _ProductOrderState createState() => _ProductOrderState();
}

class _ProductOrderState extends State<ProductOrder> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ApiResource _apiResource = ApiResource();
  Map<String, dynamic> data = {};

  bool isEditing = false;
  double rating = 0.0;
  String ?review;
  bool loading = false;
  bool posting = false;

  Future<void> submitReview() async {
    //
    try {
      this.setState(() {
        posting = true;
      });

      // api call
      await _apiResource.submitReview(
        body: data['body'],
        rating: data['rating'],
        orderItemId: widget.item!['orderNumber'],
        productNumber: widget.item!['product']['productNumber'],
      );

      this.setState(() {
        posting = false;
      });

      await showDialog(
        context: context,
        builder: (context) =>  CustomAlert(
          title: 'Review submitted',
          onCancel: () {
            this.setState(() {
              isEditing = false;
            });
          },
        ),
      );
    } catch (e) {
      print(e);
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    print(widget.item);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Order No: ${widget.item!['orderNumber']}',
          style: textTheme.title,
        ),
        SizedBox(height: 8),
        Text(
          'Total Qty: ${widget.item!['totalQuantity']}',
          style: TextStyle(
            color: Colors.grey.shade500,
          ),
        ),
        SizedBox(height: 1.5),
        Text(
          'Delivery on ${widget.item!['timeOrdered']}',
          style: textTheme.subtitle,
        ),
        SizedBox(height: 16),
        Text(
          'Total: ₦${widget.item!['totalPrice']}',
          style: textTheme.title,
        ),
        SizedBox(height: 8),
        if (isEditing)
          Container(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    style: textTheme.body2,
                    decoration: InputDecoration(
                      hintText: 'Write your review about this product',
                    ),
                    onFieldSubmitted: (dynamic value) {
                      this.setState(() {
                        review = value;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  Text('Tap star to choose'),
                  SizedBox(height: 8),
                  SmoothStarRating(
                    starCount: 5,
                    rating: rating,
                    isReadOnly: false,
                    allowHalfRating: false,
                    size: 22,
                    color: Theme.of(context).colorScheme.primary,
                    borderColor: Colors.grey.shade300,
                    onRated: (double value) {
                      this.setState(() {
                        rating = value;
                      });
                    },
                    // color: Theme.of(context).colorScheme.primary,
                    // borderColor: Theme.of(context).colorScheme.primary,
                  ),
                  SizedBox(height: 16),
                  if (rating == 0 && review == null)
                    GestureDetector(
                      onTap: () {
                        this.setState(() {
                          isEditing = !isEditing;
                        });
                      },
                      child: Button(
                        label: 'CLOSE',
                        gradient: 'colored',
                        loading: loading,
                        disabled: true,
                      ),
                    )
                  else
                    GestureDetector(
                      onTap: () {
                        this.setState(() {
                          loading = true;
                        });
                      },
                      child: Button(
                        label: 'SUBMIT',
                        gradient: 'colored',
                        loading: loading,
                      ),
                    ),
                  // Padding(
                  //   padding: EdgeInsets.all(8),
                  //   child: Text('Close review'),
                  // ),
                ],
              ),
            ),
          )
        else
          Container(
            child: GestureDetector(
              onTap: () {
                this.setState(() {
                  isEditing = !isEditing;
                });
              },
              child: Button(
                label: 'Rate and Review',
                gradient: 'colored',
              ),
            ),
          ),
        SizedBox(height: 8),
        // if (!isEditing)
        //   GestureDetector(
        //     onTap: () {
        //       Navigator.pushNamed(context, '/orders', arguments: {
        //         'orderNumber': widget.item['orderNumber'],
        //       });
        //     },
        //     child: Text.rich(
        //       TextSpan(
        //         children: [
        //           TextSpan(
        //             text: 'View more',
        //             style: textTheme.bodyText1.copyWith(
        //               color: Colors.grey.shade500,
        //               fontWeight: FontWeight.w400,
        //             ),
        //           ),
        //           WidgetSpan(
        //             alignment: PlaceholderAlignment.middle,
        //             child: Padding(
        //               padding: const EdgeInsets.only(left: 4.0),
        //               child: Icon(
        //                 Icons.arrow_forward_ios,
        //                 size: 14,
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //       textAlign: TextAlign.center,
        //     ),
        //   ),
      ],
    );
  }
}

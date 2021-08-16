import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:itarashop/common/rating.dart';
import 'package:itarashop/model/UserReview.dart';

class CustomerReviewsPage extends StatelessWidget {
  final List<UserReview>? reviews;
  const CustomerReviewsPage({ Key? key, this.reviews }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat _dateFormatter = DateFormat("dd MMM yyyy");
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Reviews', style: Theme.of(context).textTheme.headline6!.copyWith(
                fontWeight: FontWeight.w500,
              ),),
        centerTitle: false,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          children: reviews!.map((review) {
            return Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          color: Colors.black12,
                          child: Image(
                            image: NetworkImage(review.user!.profilePictureUrl!),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "${review.user!.firstName} ${review.user!.lastName}",
                            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                  color: Colors.black87,
                                ),
                          ),
                          Rating(rating: review.rating),
                          Text(
                            _dateFormatter.format(
                              DateTime.parse(review.timeReviewed!),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    color: Theme.of(context).colorScheme.primary,
                    child: Text(
                      review.rating!.toStringAsFixed(1),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
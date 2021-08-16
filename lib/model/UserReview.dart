import 'User.dart';

class UserReview {
  String? productReviewId;
  double? rating = 0;
  String? timeReviewed;
  User? user;

  UserReview({
    this.productReviewId,
    this.rating,
    this.timeReviewed,
    this.user,
  });

  factory UserReview.fromJson(Map json) {
    return UserReview(
      productReviewId: json['productReviewId'],
      rating: json['rating'],
      timeReviewed: json['timeReviewed'],
      user: User.fromJson(json['user']),
    );
  }

  Map toMap() {
    final data = Map<String, dynamic>();

    data['productReviewId'] = productReviewId;
    data['rating'] = rating;
    data['timeReviewed'] = timeReviewed;
    data['user'] = user!.toMap();

    return data;
  }
}

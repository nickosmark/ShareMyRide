import 'package:flutter/material.dart';
import 'package:flutter_app/models/ReviewModel.dart';

// Card reviewCard(String imageUrl, String name, String review, double rating) {
//   return ReviewCard();
// }

class ReviewCard extends StatelessWidget {
  // final String imageUrl;
  // final String name;
  // final String reviewText;
  // final double rating;
  final ReviewModel reviewModel; 

  const ReviewCard({
    @required this.reviewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
      child: ListTile(
        leading: CircleAvatar(
            backgroundImage: new NetworkImage(
                reviewModel.imageUrl)),
        title: Text(reviewModel.name),
        subtitle: Text(reviewModel.reviewText),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(reviewModel.rating.toString()),
            Icon(
              Icons.star,
              size: 15.0,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_app/models/UserModel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewsScreen extends StatelessWidget {
  final UserModel myUser;
  final UserModel reviewee;

  ReviewsScreen({this.reviewee, this.myUser});

  final Color darkBlueColor = Color.fromRGBO(26, 26, 48, 1.0);
  final Color lightBlueColor = Colors.blue;
  final Color lightGreyBackground = Color.fromRGBO(229, 229, 229, 1.0);
  //
  //
  double revRating;
  String reviewText;


  // i need url,name, AND PHONE from card(reviewee)
  //and
  //myUserModel to create ReviewModel


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShareMyRide',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: darkBlueColor,
        accentColor: lightBlueColor,
        //cardColor: lightGreyBackground,
        textTheme: TextTheme(
          body1: TextStyle(
            color: darkBlueColor,
            fontFamily: 'fira',
            fontSize: 12.0,
          ),
          subhead: TextStyle(
            color: darkBlueColor,
            fontFamily: 'fira',
            fontSize: 16.0,
          ),
        ),
      ),
      home: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 20.0),
                  child: CircleAvatar(
                      radius: 60.0,
                      backgroundImage:
                          new NetworkImage(reviewee.getUrlFromNameHash(genderInput: reviewee.gender))),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    reviewee.name,
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                RatingBar(
                  initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding:
                      EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    revRating = rating;
                    print(rating);
                  },
                ),
                Container(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                  child: TextField(
                    onChanged: (value) => reviewText = value,
                    obscureText: false,
                    //expands: true,
                    maxLines: 5,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        labelText: "Enter your review here"),
                    textAlignVertical: TextAlignVertical.top,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 50.0, bottom: 100.0),
                  child: RaisedButton(
                    onPressed: () {
                      //TODO create a review
                      //create ReviewModel with phone == revieweePhone
                      //name == myUser.name
                      //imageUrl == myUser.getNameHash....
                      //rating == rating
                      //reviewtext = reviewtext.....
                      // db.createReview(ReviewModel review)
                      //navigate to ridescreen
                      Navigator.pop(context);
                    }, //onPressed
                    child: Text(
                      "SUBMIT",
                      style: TextStyle(color: Colors.white),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    color: darkBlueColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


/*
                      showDialog(
                        context: context,
                        barrierDismissible: false, // user must tap button!
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('This is the title.'),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  Text('This is a test alert dialog box.'),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('I get it.'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                child: Text('Or not.'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                      */
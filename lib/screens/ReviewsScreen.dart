import 'package:flutter/material.dart';
import 'package:flutter_app/models/reviewModel.dart';
import 'package:flutter_app/screens/ProfileScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewsScreen extends StatelessWidget {
  final Color darkBlueColor = Color.fromRGBO(26, 26, 48, 1.0);
  final Color lightBlueColor = Colors.blue;
  final Color lightGreyBackground = Color.fromRGBO(229, 229, 229, 1.0);
  final String name = "Ketoyla Perry";
  double revRating;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShareMyRide',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: darkBlueColor,
        accentColor: lightBlueColor,
        textTheme: TextTheme(
          body1: TextStyle(color: Color.fromRGBO(26, 26, 48, 1.0)),
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
                          new NetworkImage('https://via.placeholder.com/150')),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    name,
                    style: GoogleFonts.oswald(
                        textStyle: TextStyle(fontSize: 30.0)),
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

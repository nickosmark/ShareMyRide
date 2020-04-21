import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_app/models/ReviewModel.dart';
import 'package:flutter_app/models/UserModel.dart';
import 'package:flutter_app/screens/ProfileEditScreen.dart';
<<<<<<< HEAD
import 'package:flutter_app/widgets/ReviewCard.dart';
=======
import 'package:flutter_app/models/userModel.dart';
>>>>>>> master

class ProfileScreen extends StatelessWidget {
  final UserModel userModel;

  ProfileScreen({
    @required this.userModel,
  });

  List<Widget> reviewWidgetList = [];

  var darkBlueColor = Color.fromRGBO(26, 26, 48, 1.0);
  var lightBlueColor = Colors.blue;
  var lightGreyBackground = Color.fromRGBO(229, 229, 229, 1.0);
<<<<<<< HEAD
=======
  final UserModel user;

  ProfileScreen(this.user);

>>>>>>> master

  @override
  Widget build(BuildContext context) {
    List<ReviewModel> reviewsListFromConstr = userModel.reviewsList;
    if (reviewsListFromConstr.isEmpty) {
      reviewWidgetList.add(
        Text('You have no reviews yet'),
      );
    } else {
      for (var item in reviewsListFromConstr) {
        reviewWidgetList.add(ReviewCard(reviewModel: item));
      }
    }
    return MaterialApp(
      title: 'ShareMyRide',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: darkBlueColor,
        accentColor: lightBlueColor,
        //cardColor: lightGreyBackground,
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
                  margin:
                      EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileEditScreen()),
                            );
                          }),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 60.0,
                  backgroundImage: new NetworkImage(
                    userModel.getUrlFromId(genderInput: userModel.gender),
                  ),
                ),
                Text(
<<<<<<< HEAD
                  userModel.name,
=======
                  '${user.name}',
>>>>>>> master
                  style:
                      GoogleFonts.oswald(textStyle: TextStyle(fontSize: 30.0)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(right: 5.0),
                      child: Text(
                        'My Rating:',
                        style: GoogleFonts.oswald(
                            textStyle: TextStyle(
                          fontSize: 15.0,
                        )),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 5.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            userModel.getRatingAverage().toString(),
                            style: GoogleFonts.oswald(
                                textStyle: TextStyle(
                              fontSize: 15.0,
                            )),
                          ),
                          Icon(
                            Icons.star,
                            size: 15.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(15.0, 15.0, 0.0, 0.0),
                      child: Text(
                        'Personal Info',
                        style: GoogleFonts.oswald(
                            textStyle: TextStyle(
                          fontSize: 20.0,
                        )),
                      ),
                    ),
                  ],
                ),
                Card(
                  margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                  child: ListTile(
                    leading: Icon(Icons.phone),
<<<<<<< HEAD
                    title: Text(userModel.phone),
=======
                    title: Text('${user.phone}'),
>>>>>>> master
                  ),
                ),
                Card(
                  margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                  child: ListTile(
                    leading: Icon(Icons.email),
<<<<<<< HEAD
                    title: Text(userModel.email),
=======
                    title: Text('${user.email}'),
>>>>>>> master
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(15.0, 25.0, 0.0, 0.0),
                      child: Text(
                        'Car Info',
                        style: GoogleFonts.oswald(
                            textStyle: TextStyle(
                          fontSize: 20.0,
                        )),
                      ),
                    ),
                  ],
                ),
                Card(
                  margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                  child: ListTile(
                    leading: Icon(Icons.directions_car),
<<<<<<< HEAD
                    title: Text(userModel.carInfo),
=======
                    title: Text('${user.carInfo}'),
>>>>>>> master
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(15.0, 25.0, 0.0, 0.0),
                      child: Text(
                        'Reviews',
                        style: GoogleFonts.oswald(
                            textStyle: TextStyle(
                          fontSize: 20.0,
                        )),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: reviewWidgetList,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

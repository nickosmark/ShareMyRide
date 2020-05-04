import 'package:flutter/material.dart';
import 'package:flutter_app/services/DataBase.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/models/ReviewModel.dart';
import 'package:flutter_app/models/UserModel.dart';
import 'package:flutter_app/screens/ProfileEditScreen.dart';
import 'package:flutter_app/widgets/ReviewCard.dart';

class ProfileScreen extends StatelessWidget {
  //TODO remove userModel from constructor
  final UserModel userModel;
  final DataBase db;

  ProfileScreen({
    @required this.db,
    @required this.userModel,
  });

  List<Widget> reviewWidgetList = [];

  var darkBlueColor = Color.fromRGBO(26, 26, 48, 1.0);
  var lightBlueColor = Colors.blue;
  var lightGreyBackground = Color.fromRGBO(229, 229, 229, 1.0);

  void addReviewCards(UserModel userModel){
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
  }

  @override
  Widget build(BuildContext context) {
    Future<UserModel> futureUser = db.getCurrentUserModel();
    UserModel initialUser = UserModel(
      id: 0,
      name:'waiting...',
      gender: Gender.nonBinary,
      phone: 'waiting...',
      email: 'waiting...',
      rating: 0.0,
      carInfo: 'waiting...',
      reviewsList: [],
      ridesList: [],
    );
    UserModel errorUser = UserModel(
      id: 0,
      name:'ERROR',
      gender: Gender.nonBinary,
      phone: 'ERROR',
      email: 'ERROR',
      rating: 0.0,
      carInfo: 'ERROR',
      reviewsList: [],
      ridesList: [],
    );

    Widget userScreen(UserModel userModel){
      addReviewCards(userModel);
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
            fontFamily: 'oswald',
            fontSize: 12.0,
          ),
          subhead: TextStyle(
            color: darkBlueColor,
            fontFamily: 'oswald',
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
                                  builder: (context) => ProfileEditScreen(db: this.db, isNewUser: false,)),
                            );
                          }),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 60.0,
                  backgroundImage: new NetworkImage(
                    userModel.getUrlFromNameHash(genderInput: userModel.gender),
                  ),
                ),
                Text(
                  userModel.name,
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
                    title: Text(userModel.phone),
                  ),
                ),
                Card(
                  margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                  child: ListTile(
                    leading: Icon(Icons.email),
                    title: Text(userModel.email),
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
                    title: Text(userModel.carInfo),
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

    return FutureBuilder<UserModel>(
      future: futureUser,
      initialData: initialUser,
      builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot){
        if(snapshot.hasData){
          print('WE HAVE DATA!!!');
          return userScreen(snapshot.data);
        }else if(snapshot.hasError){
          print('error');
          return userScreen(errorUser);
        }else{
          //waiting...
          print('waiting');
          return SizedBox(
            child: CircularProgressIndicator(),
            width: 60,
            height: 60,
          );
        }

        }
    );

  }
}

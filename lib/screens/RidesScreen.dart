import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter_app/models/RidesModel.dart';
import 'package:flutter_app/models/UserModel.dart';
import 'package:flutter_app/models/UserRide.dart';
import 'package:flutter_app/screens/ProfileScreen.dart';
import 'package:flutter_app/screens/ReviewsScreen.dart';
import 'package:flutter_app/services/DataBase.dart';
import 'package:flutter_app/widgets/ReviewCard.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/models/ReviewModel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



class RidesScreen extends StatelessWidget {
  final DataBase db ;
  RidesScreen({this.db});

  var darkBlueColor = Color.fromRGBO(26, 26, 48, 1.0);
  var lightBlueColor = Colors.blue;
  var lightGreyBackground = Color.fromRGBO(229, 229, 229, 1.0);

  Future<List<UserRide>> futureUserRides;

  List<Widget> pendingList = [];
  List<Widget> confirmedList = [];
  List<Widget> completedList = [];




  void acceptRide(String fellowTravellerPhone){
    //db.updateRideToConfirmed(fellowTravellerPhone)
  }
  void declineRide(String fellowTravellerPhone){
    //db.deleteRide(fellowTravellerPhone)
  }
  void completeRide(String fellowTravellerPhone){
    //db.updateRideToCompleted(fellowTravellerPhone)
  }
  void cancelRide(String fellowTravellerPhone){

  }
  void leaveReview(UserModel fellowTraveller, UserModel currentUser){
    //TODO navigate to ReviewScreen


  }

  void organizeUserRidesInCategories(List<UserRide> userRides){


    //TODO needs work. doesnt check if i have pending but not completed
    if (userRides.isEmpty) {
      pendingList.add(
        Text('Go find/create a ride...'),
      );
      confirmedList.add(
        Text('seriously go..'),
      );
      completedList.add(
        Text('r u kidding me? Just use the app '),
      );
    } else {
      for (var item in userRides) {
        //Data needed for cards!!

        UserModel fellowTraveller = item.fellowTraveler;
        RidesModel ride = item.ride;

        if(item.status == Status.pending){

          if(item.isDriver){

            pendingList.add(pendingCardDriver(fellowTraveller,ride));
          }else{
            pendingList.add(pendingCardPassenger(fellowTraveller,ride));
          }

        }
        if(item.status == Status.confirmed){
          confirmedList.add(confirmedCard(fellowTraveller,ride));
        }
        if(item.status == Status.completed){
          completedList.add(completedCard(fellowTraveller,ride));
        }
      }
    }
  }

  void getDataFromDb(){
    futureUserRides = db.getCurrentUserRides();
  }


  @override
  Widget build(BuildContext context) {
    //get a Future list from database
    getDataFromDb();

    return FutureBuilder<List<UserRide>>(
     future: futureUserRides,
     builder: (BuildContext context, AsyncSnapshot<List<UserRide>> snapshot){
       if(snapshot.hasData){
         print('We have userRating!!!');
         return buildRideScreen(snapshot.data);
       }else if(snapshot.hasError){
         print('error in user rides');
         return buildRideScreen([]);
       }else{
         //waiting...
         print('waiting for userRides');
         return Center(
           child: SizedBox(
             child: CircularProgressIndicator(),
             width: 100,
             height: 100,
           ),
         );
       }
     },
    );
  }

  MaterialApp buildRideScreen(List<UserRide> userRides) {
    organizeUserRidesInCategories(userRides);
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0,vertical:20.0),
                    child: Text(
                      'Pending',
                        style:TextStyle(
                          fontSize: 32.0,
                          fontWeight: FontWeight.w600,
                        ),
                    ),
                  ),
                  IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.expand_more,
                          size: 25.0,
                          color: Colors.black,
                        ),
                      ),
                ],
              ),
              Column(
                children: pendingList,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0,vertical:20.0),
                    child: Text(
                      'Confirmed',
                        style:TextStyle(
                          fontSize: 32.0,
                          fontWeight: FontWeight.w600,
                        ),
                    ),
                  ),
                  IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.expand_more,
                          size: 25.0,
                          color: Colors.black,
                        ),
                      ),
                ],
              ),
              Column(
                children: confirmedList,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0,vertical:20.0),
                    child: Text(
                      'Completed',
                        style:TextStyle(
                          fontSize: 32.0,
                          fontWeight: FontWeight.w600,
                        ),
                    ),
                  ),
                  IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.expand_more,
                          size: 25.0,
                          color: Colors.black,
                        ),
                      ),
                ],
              ),
              Column(
                children: completedList,
              ),
            ],
          ),
        ),
      ),
    ),
  );
  }


  Widget pendingCardDriver(UserModel fellowTraveller, RidesModel ride){
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
      child: ListTile(
        leading: CircleAvatar(
            backgroundImage: new NetworkImage(fellowTraveller.getUrlFromNameHash(genderInput: fellowTraveller.gender))),
        title: Text(fellowTraveller.name),
        subtitle: Text('${ride.fromText} -> ${ride.toText}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 30.0),
              child: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.check,
                  size: 25.0,
                  color: Colors.green,
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.close,
                size: 25.0,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Should show the name of the driver
  Widget pendingCardPassenger(UserModel fellowTraveller, RidesModel ride){
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
      child: ListTile(
        leading: CircleAvatar(
            backgroundImage: new NetworkImage(fellowTraveller.getUrlFromNameHash(genderInput: fellowTraveller.gender))),
        title: Text(fellowTraveller.name),
        subtitle: Text(' ${ride.fromText} -> ${ride.toText}'),
        trailing: Padding(
          padding: const EdgeInsets.only(right: 0.0),
          child: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.access_time,
              size: 25.0,
              color: lightBlueColor,
            ),
          ),
        ),
      ),
    );
  }


  Widget confirmedCard(UserModel fellowTraveller, RidesModel ride){
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
      child: ListTile(
        leading: CircleAvatar(
            backgroundImage: new NetworkImage(fellowTraveller.getUrlFromNameHash(genderInput: fellowTraveller.gender))),
        title: Text(fellowTraveller.name),
        subtitle: Text(' ${ride.fromText} -> ${ride.toText}'),
        trailing: Padding(
          padding: const EdgeInsets.only(right: 0.0),
          child: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.cancel,
              size: 25.0,
              color: Colors.redAccent,
            ),
          ),
        ),
      ),
    );
  }


  Widget completedCard(UserModel fellowTraveller, RidesModel ride){
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
      child: ListTile(
        leading: CircleAvatar(
            backgroundImage: new NetworkImage(fellowTraveller.getUrlFromNameHash(genderInput: fellowTraveller.gender))),
        title: Text(fellowTraveller.name),
        subtitle: Text(' ${ride.fromText} -> ${ride.toText}'),
        trailing: Padding(
          padding: const EdgeInsets.only(right: 0.0),
          child: IconButton(
            onPressed: () async{
              UserModel currentUser = await db.getCurrentUserModel();
              //leaveReview(fellowTraveller, currentUser, context);
            },
            icon: Icon(
              Icons.chat,
              size: 25.0,
              color: darkBlueColor,
            ),
          ),
        ),
      ),
    );
  }



}

//TODO change everything to stateless widget
class completedCard extends StatelessWidget {
  final DataBase db;
  final UserModel fellowTraveller;
  final RidesModel ride;

  completedCard({this.db,this.fellowTraveller, this.ride});

  final darkBlueColor = Color.fromRGBO(26, 26, 48, 1.0);
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
      child: ListTile(
        leading: CircleAvatar(
            backgroundImage: new NetworkImage(fellowTraveller.getUrlFromNameHash(genderInput: fellowTraveller.gender))),
        title: Text(fellowTraveller.name),
        subtitle: Text(' ${ride.fromText} -> ${ride.toText}'),
        trailing: Padding(
          padding: const EdgeInsets.only(right: 0.0),
          child: IconButton(
            onPressed: () async{
              UserModel currentUser = await db.getCurrentUserModel();
              //leaveReview(fellowTraveller, currentUser, context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ReviewsScreen(reviewee: fellowTraveller, myUser: currentUser,)),
              );
            },
            icon: Icon(
              Icons.chat,
              size: 25.0,
              color: darkBlueColor,
            ),
          ),
        ),
      ),
    );
  }
}



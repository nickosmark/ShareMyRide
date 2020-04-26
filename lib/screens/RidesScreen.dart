import 'package:flutter/material.dart';
import 'package:flutter_app/models/UserModel.dart';
import 'package:flutter_app/screens/ProfileScreen.dart';
import 'package:flutter_app/widgets/ReviewCard.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/models/ReviewModel.dart';



class RidesScreen extends StatelessWidget {
  final UserModel userModel;

  RidesScreen({this.userModel});

  List<Widget> pendingList = [];
  List<Widget> confirmedList = [];
  List<Widget> completedList = [];

  var darkBlueColor = Color.fromRGBO(26, 26, 48, 1.0);
  var lightBlueColor = Colors.blue;
  var lightGreyBackground = Color.fromRGBO(229, 229, 229, 1.0);


  void getDataFromUserRides(){
    List<UserRide> userRides = userModel.ridesList;

    //TODO needs work. doesnt check if i have pending but not completed
    if (userRides.isEmpty) {
      pendingList.add(
        Text('Go find/create a ride...'),
      );
      confirmedList.add(
        Text('nothing yet'),
      );
      completedList.add(
        Text('r u kidding me? Just use the app'),
      );
    } else {
      for (var item in userRides) {
        //Data needed for cards!!

        if(item.status == Status.pending){
          //TODO check if Driver or passenger and show different pending Card

          if(item.isDriver){
            String url = item.fellowTraveler.getUrlFromNameHash(genderInput: item.fellowTraveler.gender);
            String name = item.fellowTraveler.name;
            double fromWhere = item.ride.fromWhere;
            double toWhere = item.ride.toWhere;
            pendingList.add(pendingCardDriver(url, name, fromWhere, toWhere));
          }else{
            //SHOW PASSENGER DATA
            String url = item.fellowTraveler.getUrlFromNameHash(genderInput: item.fellowTraveler.gender);
            // check if this is the same, should be the same??:
            // String url = item.ride.driver.getUrlFromNameHash() ;
            String name = item.fellowTraveler.name;
            double fromWhere = item.ride.fromWhere;
            double toWhere = item.ride.toWhere;
            pendingList.add(pendingCardPassenger(url, name, fromWhere, toWhere));
          }

        }
        if(item.status == Status.confirmed){
          //confirmedList.add(confirmedCard(url, name, fromWhere, toWhere));
        }
        if(item.status == Status.completed){
          //completedList.add(completedCard(url, name, fromWhere, toWhere));
        }
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    getDataFromUserRides();
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0,vertical:20.0),
                      child: Text(
                        'Pending',
                        style: GoogleFonts.oswald(
                            textStyle: TextStyle(fontSize: 30.0)),
                      ),
                    ),
                    IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.expand_more,
                            size: 25.0,
                            color: Colors.red,
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
                        style: GoogleFonts.oswald(
                            textStyle: TextStyle(fontSize: 30.0)),
                      ),
                    ),
                    IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.expand_more,
                            size: 25.0,
                            color: Colors.red,
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
                        style: GoogleFonts.oswald(
                            textStyle: TextStyle(fontSize: 30.0)),
                      ),
                    ),
                    IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.expand_more,
                            size: 25.0,
                            color: Colors.red,
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


  Widget pendingCardDriver(String url, String name, double fromWhere, double toWhere){
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
      child: ListTile(
        leading: CircleAvatar(
            backgroundImage: new NetworkImage(url)),
        title: Text(name),
        subtitle: Text('$fromWhere -> $toWhere'),
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
  Widget pendingCardPassenger(String url, String name, double fromWhere, double toWhere){
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
      child: ListTile(
        leading: CircleAvatar(
            backgroundImage: new NetworkImage(url)),
        title: Text(' $name'),
        subtitle: Text('THIS IS PASSENGER CARD !! $fromWhere -> $toWhere'),
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


  Widget confirmedCard(String url, String name, double fromWhere, double toWhere){
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
      child: ListTile(
        leading: CircleAvatar(
            backgroundImage: new NetworkImage(url)),
        title: Text(name),
        subtitle: Text('$fromWhere -> $toWhere'),
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


  Widget completedCard(String url, String name, double fromWhere, double toWhere){
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
      child: ListTile(
        leading: CircleAvatar(
            backgroundImage: new NetworkImage(url)),
        title: Text(name),
        subtitle: Text('$fromWhere -> $toWhere'),
        trailing: Padding(
          padding: const EdgeInsets.only(right: 0.0),
          child: IconButton(
            onPressed: () {},
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


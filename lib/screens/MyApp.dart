import 'package:flutter/material.dart';
import 'package:flutter_app/models/UserModel.dart';
import 'package:flutter_app/screens/HomeScreen.dart';
import 'package:flutter_app/screens/ProfileScreen.dart';
import 'package:flutter_app/screens/RidesScreen.dart';
import 'package:flutter_app/services/DataBase.dart';
import 'package:flutter_app/services/fakeDB.dart';

import 'package:flutter_app/screens/chrisHomeScreen.dart';


class MyApp extends StatefulWidget {
  final DataBase db;
  final int selectedIndex;

  // MyApp contsructor takes a selectedIndex;
  // 0 for HomeScreen
  // 1 for Rides
  // 2 for Profile
  MyApp({this.db,this.selectedIndex});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  //A typical passenger user story:
  //Driver Bob creates RidesModel, RidesModel are public
  //Passenger Alice Searches through RidesModel object list to find a ride that she wants
  //Passenger Alice requests a Ride:
  //sends the ride to driver Bob --> creates new UserRide to his UserModelObject-->
  // ride1object.driver.addToUserRideList(ride1object,aliceUserObject,false) //false == not a driver
  //At the same time she waits for a response,
  //her Pending tab should have the drivers Bob name and the ride's from/to
  //aliceUserObject.addToUserRideList(ride1object, bobUserObject, true)

  static var ridaki = FakeDB.ride55; //gets created at home screen
  static var driverr = FakeDB.randomDriver39;
  static var passengerr = FakeDB.randomPassenger12;

  //Create a random User. Can be driver or passenger
  UserModel randomUser12 = passengerr;

  DataBase db;
  void enimeroseTonBob(){
    //TODO isDriver is
    ridaki.driver.addToUserRideList(incomingRide: ridaki, fellow: passengerr, isDriver: true);
  }




  //Selected Icon in the bottomNavBar
  int _selectedIndex = 0;

  //The screen showing first
  Widget _selectedScreen ;

  @override
  void initState() {
    super.initState();
    //_selectedScreen = widget.selectedScreen;
    //enimeroseTonBob();
    db = widget.db;
    _selectedIndex = widget.selectedIndex;
    switch (_selectedIndex) {
      case 0:
        _selectedScreen = ChrisHomeScreen();
        break;
      case 1:
        _selectedScreen = RidesScreen(userModel: randomUser12,);
        break;
      case 2:
        _selectedScreen = ProfileScreen(userModel: randomUser12);
        break;
    }

  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'oswald',
        textTheme: TextTheme(
          body1: TextStyle(
            fontFamily: 'oswald',
          ),
        ),
      ),
      home: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('HOME'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.drive_eta),
              title: Text('RIDES'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              title: Text('PROFILE'),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
              switch (_selectedIndex) {
                case 0:
                  _selectedScreen = ChrisHomeScreen();

                  break;
                case 1:
                  _selectedScreen = RidesScreen(userModel: randomUser12);
                  break;
                case 2:
                  _selectedScreen = ProfileScreen(userModel: randomUser12);
                  break;
              }
            });
          },
        ),
        body: _selectedScreen,
      ),
    );
  }
}
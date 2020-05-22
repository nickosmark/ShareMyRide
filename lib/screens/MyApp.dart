import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  void printCurrentUserFromFireStore() async {
    UserModel currentUser = await db.getCurrentUserModel();
    print(currentUser.toString());
  }

  DataBase db;

  //Selected Icon in the bottomNavBar
  int _selectedIndex = 0;

  //The screen showing first
  Widget _selectedScreen ;

  @override
  void initState() {
    super.initState();
    db = widget.db;
    printCurrentUserFromFireStore();
    //_selectedScreen = widget.selectedScreen;
    _selectedIndex = widget.selectedIndex;
    switch (_selectedIndex) {
      case 0:
        _selectedScreen = ChrisHomeScreen(db: db,);
        break;
      case 1:
        _selectedScreen = RidesScreen(db: db,);
        break;
      case 2:
        _selectedScreen = ProfileScreen(db: db,);
        break;
    }

  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        return SystemNavigator.pop();
      },
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: 'fira',
          textTheme: TextTheme(
            body1: TextStyle(
              fontFamily: 'fira',
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
                    _selectedScreen = ChrisHomeScreen(db: db,);
                    break;
                  case 1:
                    _selectedScreen = RidesScreen(db: db);
                    break;
                  case 2:
                    _selectedScreen = ProfileScreen(db: db,);
                    break;
                }
              });
            },
          ),
          body: _selectedScreen,
        ),
      ),
    );
  }
}
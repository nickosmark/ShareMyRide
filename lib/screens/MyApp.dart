import 'package:flutter/material.dart';
import 'package:flutter_app/models/UserModel.dart';
import 'package:flutter_app/screens/HomeScreen.dart';
import 'package:flutter_app/screens/ProfileScreen.dart';
import 'package:flutter_app/screens/RidesScreen.dart';
import 'package:flutter_app/services/fakeDB.dart';

class MyApp extends StatefulWidget {
  final int selectedIndex;

  // MyApp contsructor takes a selectedIndex;
  // 0 for HomeScreen
  // 1 for Rides
  // 2 for Profile
  MyApp({this.selectedIndex});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //Created a random User from fake DB.
  UserModel randomUser12 = FakeDB.randomUser12;

  //Selected Icon in the bottomNavBar
  int _selectedIndex = 0;

  //The screen showing first
  Widget _selectedScreen ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_selectedScreen = widget.selectedScreen;
    _selectedIndex = widget.selectedIndex;
    switch (_selectedIndex) {
      case 0:
        _selectedScreen = HomeScreen();
        break;
      case 1:
        _selectedScreen = RidesScreen();
        break;
      case 2:
        _selectedScreen = ProfileScreen(userModel: randomUser12);
        break;
    }

  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
                  _selectedScreen = HomeScreen();
                  break;
                case 1:
                  _selectedScreen = RidesScreen();
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
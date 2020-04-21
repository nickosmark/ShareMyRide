import 'package:flutter/material.dart';
import 'package:flutter_app/models/UserModel.dart';
import 'package:flutter_app/screens/ConfirmScreen.dart';
import 'package:flutter_app/screens/HomeScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/ProfileScreen.dart';
import 'screens/ProfileEditScreen.dart';
import 'screens/LoginScreen.dart';
import 'screens/RidesScreen.dart';
import 'services/fakeDB.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //Created a random User from fake DB.
  UserModel randomUser12 = FakeDB.randomUser12;

  //Selected Icon in the bottomNavBar
  int _selectedIndex = 0;

  //The screen showing first
  Widget _selectedScreen = HomeScreen();
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

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: ProfileScreen()
//     );
//   }
// }

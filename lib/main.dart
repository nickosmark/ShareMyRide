import 'package:flutter/material.dart';
import 'package:flutter_app/models/UserModel.dart';
import 'package:flutter_app/screens/HomeScreen.dart';
import 'screens/ProfileScreen.dart';
import 'screens/RidesScreen.dart';
import 'services/fakeDB.dart';
import 'package:flutter_app/screens/MyApp.dart';

void main() => runApp(MyApp(selectedIndex: 0,));



// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: ProfileScreen()
//     );
//   }
// }

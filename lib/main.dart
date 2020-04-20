import 'package:flutter/material.dart';
import 'package:flutter_app/screens/ConfirmScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/ProfileScreen.dart';
import 'screens/ProfileEditScreen.dart';
import 'screens/LoginScreen.dart';
import 'screens/RidesScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RidesScreen()
    );
  }
}



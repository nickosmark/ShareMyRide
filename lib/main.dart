import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        backgroundColor: Color.fromRGBO(229, 229, 229, 1),
        primaryColor: Colors.blue,
        accentColor: Colors.green,
        textTheme: TextTheme(body1: TextStyle(color: Colors.purple)),
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
        ),
        body: SafeArea(
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 100.0,
                  height: double.infinity,
                  color: Colors.pink[200],
                  child: Text(
                    'container 1',
                    style: GoogleFonts.pacifico(),
                  ),
                ),
                Container(
                  width: 100.0,
                  height: 100.0,
                  color: Colors.pink[200],
                  child: Text('container 2'),
                ),
                Container(
                  width: 100.0,
                  height: double.infinity,
                  color: Colors.pink[200],
                  child: Text('container 3'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
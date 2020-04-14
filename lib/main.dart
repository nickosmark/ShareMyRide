import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.yellow[50],
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
                  child: Text('container 1'),
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

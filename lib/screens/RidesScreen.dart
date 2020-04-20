import 'package:flutter/material.dart';
import 'package:flutter_app/screens/ProfileScreen.dart';
import 'package:flutter_app/widgets/reviewcard.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/models/reviewModel.dart';



class RidesScreen extends StatelessWidget {
  var darkBlueColor = Color.fromRGBO(26, 26, 48, 1.0);
  var lightBlueColor = Colors.blue;
  var lightGreyBackground = Color.fromRGBO(229, 229, 229, 1.0);
  //var review_1 = ReviewModel('https://randomuser.me/api/portraits/women/95.jpg','jinaa','shes the best', 5.0);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShareMyRide',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: darkBlueColor,
        accentColor: lightBlueColor,
        //cardColor: lightGreyBackground,
        textTheme: TextTheme(
          body1: TextStyle(color: Color.fromRGBO(26, 26, 48, 1.0)),
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
        ),
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
                Card(
                  margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                  child: ListTile(
                    leading: CircleAvatar(
                        backgroundImage: new NetworkImage(
                            'https://randomuser.me/api/portraits/women/95.jpg')),
                    title: Text('Julia Alexandratou'),
                    subtitle: Text('Athens -> Patras'),
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
                Card(
                  margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                  child: ListTile(
                    leading: CircleAvatar(
                        backgroundImage: new NetworkImage(
                            'https://randomuser.me/api/portraits/women/95.jpg')),
                    title: Text('Julia Alexandratou'),
                    subtitle: Text('Athens -> Patras'),
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
                Card(
                  margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                  child: ListTile(
                    leading: CircleAvatar(
                        backgroundImage: new NetworkImage(
                            'https://randomuser.me/api/portraits/women/95.jpg')),
                    title: Text('Julia Alexandratou'),
                    subtitle: Text('Athens -> Patras'),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

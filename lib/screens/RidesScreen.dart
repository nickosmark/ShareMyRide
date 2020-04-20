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
                Container(
                  margin:
                      EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileScreen()),
                            );
                          }),
                    ],
                  ),
                ),
                CircleAvatar(
                    radius: 60.0,
                    backgroundImage:
                        new NetworkImage('https://via.placeholder.com/150')),
                Text(
                  'Edit name',
                  style:
                      GoogleFonts.oswald(textStyle: TextStyle(fontSize: 30.0)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(right: 5.0),
                      child: Text(
                        'My Rating:',
                        style: GoogleFonts.oswald(
                            textStyle: TextStyle(
                          fontSize: 15.0,
                        )),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 5.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            '4,3',
                            style: GoogleFonts.oswald(
                                textStyle: TextStyle(
                              fontSize: 15.0,
                            )),
                          ),
                          Icon(
                            Icons.star,
                            size: 15.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(15.0, 35.0, 0.0, 0.0),
                      child: Text(
                        'Personal Info',
                        style: GoogleFonts.oswald(
                            textStyle: TextStyle(
                          fontSize: 20.0,
                        )),
                      ),
                    ),
                  ],
                ),
                Card(
                  margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                  child: ListTile(
                    leading: Icon(Icons.phone),
                    title: Text('+30 6999999999'),
                  ),
                ),
                Card(
                  margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                  child: ListTile(
                    leading: Icon(Icons.email),
                    title: Text('covid@coronavirius.com'),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(15.0, 25.0, 0.0, 0.0),
                      child: Text(
                        'Car Info',
                        style: GoogleFonts.oswald(
                            textStyle: TextStyle(
                          fontSize: 20.0,
                        )),
                      ),
                    ),
                  ],
                ),
                Card(
                  margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                  child: ListTile(
                    leading: Icon(Icons.directions_car),
                    title: Text('Mercendez Benz'),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(15.0, 25.0, 0.0, 0.0),
                      child: Text(
                        'Reviews',
                        style: GoogleFonts.oswald(
                            textStyle: TextStyle(
                          fontSize: 20.0,
                        )),
                      ),
                    ),
                  ],
                ),
                Card(
                  margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                  child: ListTile(
                    leading: CircleAvatar(
                        backgroundImage: new NetworkImage(
                            'https://images.unsplash.com/photo-1510227272981-87123e259b17?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&cs=tinysrgb&w=200&fit=max&s=3759e09a5b9fbe53088b23c615b6312e')),
                    title: Text('Jina Jinoglou'),
                    subtitle: Text(
                        'Amazing driver!! She helped me with my anxiety. The best part is that she is also a Trump supporter :)'),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text('5,0'),
                        Icon(
                          Icons.star,
                          size: 15.0,
                        ),
                      ],
                    ),
                  ),
                ),
                //reviewCard(review_1.getUrl(),review_1.getName(),'sheee is the best', 5.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_app/models/ReviewModel.dart';
import 'package:flutter_app/models/reviewModel.dart';
import 'package:flutter_app/models/UserModel.dart';
import 'package:flutter_app/screens/ProfileScreen.dart';
import 'package:google_fonts/google_fonts.dart';

final nameControler = TextEditingController();
final phoneControler = TextEditingController();
final emailControler = TextEditingController();
final carInfoControler = TextEditingController();


@override
void dispose(){
  nameControler.dispose();
  phoneControler.dispose();
  emailControler.dispose();
  carInfoControler.dispose();

}
class ProfileEditScreen extends StatefulWidget {
 
  _ProfileEditScreeState createState() => _ProfileEditScreeState();
}

class _ProfileEditScreeState extends State<ProfileEditScreen> {
   var darkBlueColor = Color.fromRGBO(26, 26, 48, 1.0);
  var lightBlueColor = Colors.blue;
  var lightGreyBackground = Color.fromRGBO(229, 229, 229, 1.0);
  @override
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
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  margin:
                      EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            final user = UserModel(id: 1, name: nameControler.text, gender: Gender.male, phone: phoneControler.text, email: emailControler.text, carInfo: carInfoControler.text,
                            rating: 4.2, reviewsList: []);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileScreen(userModel: user,)),

                            );
                          }),
                          IconButton(
                          icon: Icon(Icons.check),
                          onPressed: () {
                            final user = UserModel(id: 1, name: nameControler.text, gender: Gender.male, phone: phoneControler.text, email: emailControler.text, carInfo: carInfoControler.text,
                            rating: 4.2, reviewsList: []);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileScreen(userModel: user,)),
                            );
                          })
                    ],
                  ),
                ),
                CircleAvatar(
                    radius: 60.0,
                    backgroundImage:
                        new NetworkImage('https://via.placeholder.com/150')),
                Container(
                  padding:
                  EdgeInsets.all(10.0),
                    child: TextField(
                      controller: nameControler,
                      obscureText: false,
                      decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Enter name"
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(15.0, 25.0, 0.0, 0.0),
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
                  child: TextField(
                    controller: phoneControler,
                    obscureText: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      icon: Icon(Icons.phone),
                      labelText: "Enter phone number"
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                  child: TextField(
                    controller: emailControler,
                    obscureText: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      icon: Icon(Icons.email),
                      labelText: "Enter email"
                    ),
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
                  child: TextField(
                    controller: carInfoControler,
                    obscureText: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      icon: Icon(Icons.directions_car),
                      labelText: "Enter car information"
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

  
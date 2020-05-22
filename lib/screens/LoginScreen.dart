import 'package:flutter/material.dart';
import 'package:flutter_app/screens/MyApp.dart';
import 'package:flutter_app/screens/ProfileEditScreen.dart';
import 'package:flutter_app/services/DataBase.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatelessWidget {

  final DataBase db;

  LoginScreen({@required this.db});
  String phoneInput;
  var darkBlueColor = Color.fromRGBO(26, 26, 48, 1.0);
  var lightBlueColor = Colors.blue;
  var lightGreyBackground = Color.fromRGBO(229, 229, 229, 1.0);
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
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 25.0, horizontal: 10.0),
                      child: Text(
                        "Share My Ride",
                        style: GoogleFonts.pacifico(
                            textStyle: TextStyle(fontSize: 50.0)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 30.0, top: 50.0),
                      child: Text(
                        "Phone",
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                      child: TextField(
                        obscureText: false,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Enter your phone number",
                        ),
                        onChanged: (value){
                          print(' typing : $value');
                          phoneInput = value;
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: 50.0, bottom: 80.0),
                          child: RaisedButton(
                            onPressed: () {
                            },
                            child: Text(
                              "Next",
                              style: TextStyle(color: Colors.white),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                            color: darkBlueColor,
                          ),
                        )
                      ],
                    ),
                    Column(
                      
                      children: <Widget>[
                        Container(
                          height: 130.0,
                          child: Image.asset('assets/images/login_icon.png', color: darkBlueColor,),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 25.0, 8.0, 0.0),
                          child: InkWell(
                            onTap: () async{
                              var result = await db.auth.getAnonUserSingInResult();
                              if(result == null){
                                print('problem with registationn :(((((((((((');
                              }else{
                                //If no problems with sing in go to profileScreen to enter data
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProfileEditScreen(db: db, isNewUser: true),
                                  ),
                                );
                              }
                            },
                            child: Text(
                              'Sign in anonymously',
                              style: TextStyle(
                                color: darkBlueColor,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

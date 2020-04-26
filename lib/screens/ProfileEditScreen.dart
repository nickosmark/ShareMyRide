import 'package:flutter/material.dart';
import 'package:flutter_app/models/UserModel.dart';
import 'package:flutter_app/screens/MyApp.dart';
import 'package:flutter_app/screens/ProfileScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/services/fakeDB.dart';

//random bourditses
//final user = UserModel(id: 1, name: nameControler.text, gender: Gender.male, phone: phoneControler.text, email: emailControler.text, carInfo: carInfoControler.text,
//    rating: 4.2, reviewsList: []);

class ProfileEditScreen extends StatefulWidget {
  //Checks if the User is a new User so that close and check buttons have different behaviour
  final bool isNewUser;
  //TODO oti ekana paei strafi xreiazetai kainourgio ProfileCreateScreen h passaro userModel
  ProfileEditScreen({this.isNewUser});

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  Gender gender = Gender.male;

  String name;

  String phone;

  String email;

  String carInfo;

  var darkBlueColor = Color.fromRGBO(26, 26, 48, 1.0);

  var lightBlueColor = Colors.blue;

  var lightGreyBackground = Color.fromRGBO(229, 229, 229, 1.0);


  // Should pass User to profile edit screen
//  void updateFakeUser() {
//    FakeDB.randomUser12.name = this.name;
//    FakeDB.randomUser12.phone = this.phone;
//    FakeDB.randomUser12.email = this.email;
//    FakeDB.randomUser12.gender = this.gender;
//  }

  void iconsClickEventHandler(BuildContext context, String iconName) {
    if (iconName == 'check') {
      //TODO edit UserModel object. EDIT ! NOT CREATE!
      //updateFakeUser();
      //If the user is new navigate to Home Screen.If she
      //just edits her profile navigate to profile screen
      if (widget.isNewUser) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyApp(selectedIndex: 0),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyApp(selectedIndex: 2),
          ),
        );
      }
    }
    //
    //
    if (iconName == 'close') {
      if (widget.isNewUser) {
        //TODO DELETE ACCOUNT
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyApp(selectedIndex: 2),
          ),
        );
      }
    }
  }

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
                          onPressed: () =>
                              iconsClickEventHandler(context, 'close')),
                      IconButton(
                          icon: Icon(Icons.check),
                          onPressed: () =>
                              iconsClickEventHandler(context, 'check'))
                    ],
                  ),
                ),
                CircleAvatar(
                    radius: 60.0,
                    backgroundImage:
                        new NetworkImage('https://via.placeholder.com/150')),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: TextField(
                    onChanged: (value) => name = value,
                    obscureText: false,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: "Enter name"),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[],
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
                    onChanged: (value) => phone = value,
                    obscureText: false,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.phone),
                        labelText: "Enter phone number"),
                  ),
                ),
                Card(
                  margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                  child: TextField(
                    onChanged: (value) => email = value,
                    obscureText: false,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.email),
                        labelText: "Enter email"),
                  ),
                ),
                Card(
                    margin:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex:1,
                          child: Icon(
                            Icons.child_care
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Enter your gender:',
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: DropdownButton<Gender>(
                            isExpanded: true,
                            value: gender,
                            icon: Icon(Icons.arrow_downward),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Colors.deepPurple),
                            onChanged: (Gender newValue) {
                              setState(() {
                                gender = newValue;
                              });
                            },
                            items: <Gender>[Gender.male, Gender.female, Gender.nonBinary]
                                .map<DropdownMenuItem<Gender>>((Gender value) {
                              return DropdownMenuItem<Gender>(
                                value: value,
                                child: Text(value.toString().substring(7)),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    )),
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
                    onChanged: (value) => carInfo = value,
                    obscureText: false,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        icon: Icon(Icons.directions_car),
                        labelText: "Enter car information"),
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

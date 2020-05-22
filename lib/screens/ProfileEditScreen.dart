import 'package:flutter/material.dart';
import 'package:flutter_app/models/RidesModel.dart';
import 'package:flutter_app/models/UserModel.dart';
import 'package:flutter_app/models/UserRide.dart';
import 'package:flutter_app/screens/AuthScreen.dart';
import 'package:flutter_app/screens/MyApp.dart';
import 'package:flutter_app/screens/ProfileScreen.dart';
import 'package:flutter_app/services/DataBase.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/services/fakeDB.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class ProfileEditScreen extends StatefulWidget {
  //Checks if the User is a new User so that close and check buttons have different behaviour
  final bool isNewUser;
  final DataBase db;
  ProfileEditScreen({this.db, this.isNewUser});

  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  Gender gender = Gender.male;

  String name;

  String phone;

  String email;

  String carInfo;

  bool hasGenderChanged = false;

  var darkBlueColor = Color.fromRGBO(26, 26, 48, 1.0);

  var lightBlueColor = Colors.blue;

  var lightGreyBackground = Color.fromRGBO(229, 229, 229, 1.0);


  void deleteAccount() async {
    var user = await widget.db.auth.getCurrentFireBaseUser();
    print("deleting user...");
    await user.delete();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AuthScreen(),
      ),
    );
  }



  void iconsClickEventHandler(BuildContext context, String iconName) async {
    if (iconName == 'check') {
      //If the user is new navigate to Home Screen.If she
      //just edits her profile navigate to profile screen
      if (widget.isNewUser) {
        // check if phone, name,etc are null-> show a toast
        if(this.name==null || this.email==null || this.carInfo==null){
          Fluttertoast.showToast(
            msg: "Εrror, please fill all the fields",
            timeInSecForIosWeb: 1,
          );
        }else{
          //This is where a new UserModel get created
          //Identifier should be phone so i pass UUID to phone number
          UserModel user = UserModel(
            name: this.name,
            gender: this.gender,
            phone: await widget.db.auth.getCurrentFireBaseUserID(),
            email: this.email,
            carInfo: this.carInfo,
            rating: 0.0,
          );
          var result = widget.db.createUserModel(user);
          if(result == null){
            print('Problem with creation.');
          }else{
            //if no problem proceed to MyApp->HomeScreen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyApp(db: widget.db,selectedIndex: 0),
              ),
            );
          }

        }

      } else {
        //existing user. Update data
        //check if a specific field is updated in order to
        // correctly update the database
        Map<String,dynamic> updatedFields = new Map();
        if(this.hasGenderChanged){
          updatedFields['gender'] = this.gender.toString();
          print("DEBUG the gender has changed");
        }
        if (this.name != null){
          updatedFields['name'] = this.name;
          print("DEBUG name changed");
        }
        if(this.email != null){
          updatedFields['email'] = this.email;
          print("DEBUG phone changed");
        }
        if(this.carInfo != null){
          updatedFields['carInfo'] = this.carInfo;
          print("DEBUG carinfo changed");
        }

        //print(updatedFields);
        await widget.db.updateCurrentUserModel(updatedFields);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyApp(db: widget.db,selectedIndex: 2),
          ),
        );
      }
    }
    //
    //
    if (iconName == 'close') {
      if (widget.isNewUser) {
        //DELETE user if he hasn't entered anything and
        deleteAccount();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AuthScreen(),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyApp(db: widget.db,selectedIndex: 2),
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
                            Icons.wc,
                            color: Colors.black54,
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Enter your gender',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16.0,
                              ),
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
                              this.hasGenderChanged = true;
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
                Container(
                  child: RaisedButton(
                    onPressed: () async{
                      //delete user
                      print("deleting user...");
                      await deleteAccount();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AuthScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "DELETE USER",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    color: Colors.red[700],
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

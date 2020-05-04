import 'package:flutter/material.dart';
import 'package:flutter_app/models/UserModel.dart';
import 'package:flutter_app/screens/AuthScreen.dart';
import 'package:flutter_app/screens/MyApp.dart';
import 'package:flutter_app/screens/ProfileScreen.dart';
import 'package:flutter_app/services/DataBase.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/services/fakeDB.dart';

//random bourditses
//final user = UserModel(id: 1, name: nameControler.text, gender: Gender.male, phone: phoneControler.text, email: emailControler.text, carInfo: carInfoControler.text,
//    rating: 4.2, reviewsList: []);

class ProfileEditScreen extends StatefulWidget {
  //Checks if the User is a new User so that close and check buttons have different behaviour
  final bool isNewUser;
  final DataBase db;
  //TODO oti ekana paei strafi xreiazetai kainourgio ProfileCreateScreen h passaro userModel
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
        //TODO check if phone, name,etc are null-> show a toast
        //TODO for now i check name, we should check number when PhoneAuth
        if(this.name.isEmpty){
          //show dialog
          print('phone is empty');
        }else{
          //This is where a new UserModel get created
          //Identifier should be phone so i pass UUID to phone number
          //UserMode id == 0 . I think it should be removed eventually
          UserModel user = UserModel(
            id: 0,
            name: this.name,
            gender: this.gender,
            phone: await widget.db.auth.getCurrentFireBaseUserID(),
            email: this.email,
            carInfo: this.carInfo,
            rating: 0.0,
            reviewsList: [],
            ridesList: [],
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
        //TODO update user
        //check if a specific field is updated in order to
        // correctly update the database

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

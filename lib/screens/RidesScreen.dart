
import 'package:flutter/material.dart';
import 'package:flutter_app/models/RidesModel.dart';
import 'package:flutter_app/models/UserModel.dart';
import 'package:flutter_app/models/UserRide.dart';
import 'package:flutter_app/screens/MyApp.dart';
import 'package:flutter_app/screens/ProfileScreen.dart';
import 'package:flutter_app/screens/ReviewsScreen.dart';
import 'package:flutter_app/services/DataBase.dart';
import 'package:flutter_app/widgets/ReviewCard.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/models/ReviewModel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



class RidesScreen extends StatefulWidget {
  final DataBase db ;
  RidesScreen({this.db});

  @override
  _RidesScreenState createState() => _RidesScreenState();
}

class _RidesScreenState extends State<RidesScreen> {
  var darkBlueColor = Color.fromRGBO(26, 26, 48, 1.0);

  var lightBlueColor = Colors.blue;

  var lightGreyBackground = Color.fromRGBO(229, 229, 229, 1.0);

  Future<List<UserRide>> futureUserRides;

  List<Widget> pendingList = [];

  List<Widget> confirmedList = [];

  List<Widget> completedList = [];

  List<Widget> myRidesList = [];

  //
  bool showMyRides = true;
  bool showPending = true;
  bool showConfirmed = true;
  bool showCompleted = true;

  void acceptRide(UserRide ride, BuildContext context) async{
    await widget.db.updateRideToConfirmed(ride);
    //Navigate again to Rides Tab
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MyApp(db: widget.db, selectedIndex: 1,)),
    );
  }

  void declineRide(UserRide ride, BuildContext context){
    //remove userride from this user and fellowTravellers pending!! list
    //db.deleteUserRide(fellowTravellerPhone)
    //TODO
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MyApp(db: widget.db, selectedIndex: 1,)),
    );
  }

  void completeRide(UserRide ride, BuildContext context) async{
    //When a ride is completed, delete ride from results
    //TODO prosoxi diagrafi to ride
    //await widget.db.deleteRideModelFromUserRide(ride);
    //It gets deleted before updating. Should delete somewhere else?
    //uncomment to test new change indb
    //await db.deleteUserRide(ride);
    await widget.db.updateRideToCompleted(ride);
    //navigate again to Rides Tab
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MyApp(db: widget.db, selectedIndex: 1,)),
    );
  }

  void cancelRide(UserRide ride, BuildContext context){
    //remove from both confirmed list
    //TODO
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MyApp(db: widget.db, selectedIndex: 1,)),
    );
  }

  void deleteRide(UserRide userRide, BuildContext context) async{
    //Completely delete ride. Cant be searched again
    await widget.db.deleteRideModelFromUserRide(userRide);
    //also delete from this users UserRide list
    await widget.db.deleteUserRide(userRide);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MyApp(db: widget.db, selectedIndex: 1,)),
    );
  }

  void organizeUserRidesInCategories(List<UserRide> userRides, BuildContext context){


    //TODO needs work. doesnt check if i have pending but not completed
    if (userRides.isEmpty) {
      pendingList.add(
        Text('Go find/create a ride...'),
      );
      confirmedList.add(
        Text('seriously go..'),
      );
      completedList.add(
        Text('r u kidding me? Just use the app '),
      );
    } else {
      for (var item in userRides) {
        //Data needed for cards!!

        UserModel fellowTraveller = item.fellowTraveler;
        RidesModel ride = item.ride;

        if(item.status == Status.myRides){
          myRidesList.add(myRidesCard(item,ride,context));
        }

        if(item.status == Status.pending){

          if(item.isDriver){

            pendingList.add(pendingCardDriver(item,fellowTraveller,ride, context));
          }else{
            pendingList.add(pendingCardPassenger(item,fellowTraveller,ride, context));
          }

        }
        if(item.status == Status.confirmed){
          confirmedList.add(confirmedCard(item,fellowTraveller,ride, context));
        }
        if(item.status == Status.completed){
          if(item.isFinished != null){
            if(!item.isFinished){
              completedList.add(completedCard(item,fellowTraveller,ride, context));
            }
          }

        }
        if(item.isFinished != null){
          if (item.isFinished) {
            completedList.add(finishedCard(item,fellowTraveller,ride,context));
          }
        }
      }
    }
  }

  void getDataFromDb(){
    futureUserRides = widget.db.getCurrentUserRides();
  }

  @override
  Widget build(BuildContext context) {
    //clear lists
     pendingList = [];

    confirmedList = [];

    completedList = [];

    myRidesList = [];

    //get a Future list from database
    getDataFromDb();

    return FutureBuilder<List<UserRide>>(
     future: futureUserRides,
     //initialData: [],
     builder: (BuildContext context, AsyncSnapshot<List<UserRide>> snapshot){
       if(snapshot.hasData){
         print('We have userRating!!!');
         return buildRideScreen(snapshot.data, context);
       }else if(snapshot.hasError){
         print('error in user rides');
         return buildRideScreen([], context);
       }else{
         //waiting...
         print('waiting for userRides');
         return Center(
           child: SizedBox(
             child: CircularProgressIndicator(),
             width: 100,
             height: 100,
           ),
         );
       }
     },
    );
  }
  
  IconButton expandedIconButton(bool showDetails, String status){
    var moreDetails = IconButton(
      onPressed: () {
        setState(() {
          if (showDetails){
            switch (status){
              case 'myRides':
                this.showMyRides = false;
                break;
              case 'pending':
                this.showPending = false;
                break;
              case 'confirmed':
                this.showConfirmed = false;
                break;
              case 'completed':
                this.showCompleted = false;
                break;
            }
          }else{
            switch (status){
              case 'myRides':
                this.showMyRides = true;
                break;
              case 'pending':
                this.showPending = true;
                break;
              case 'confirmed':
                this.showConfirmed = true;
                break;
              case 'completed':
                this.showCompleted = true;
                break;
            }
          }
        });
      },
      icon: Icon(
        Icons.expand_more,
        size: 25.0,
        color: Colors.black,
      ),
    );
    
    var lessDetails = IconButton(
      onPressed: () {
        setState(() {
          if (showDetails){
            switch (status){
              case 'myRides':
                this.myRidesList = [];
                this.pendingList = [];
                this.confirmedList= [];
                this.completedList = [];
                this.showMyRides = false;
                break;
              case 'pending':
                this.myRidesList = [];
                this.pendingList = [];
                this.confirmedList= [];
                this.completedList = [];
                this.showPending = false;
                break;
              case 'confirmed':
                this.myRidesList = [];
                this.pendingList = [];
                this.confirmedList= [];
                this.completedList = [];
                this.showConfirmed = false;
                break;
              case 'completed':
                this.myRidesList = [];
                this.pendingList = [];
                this.confirmedList= [];
                this.completedList = [];
                this.showCompleted = false;
                break;
            }
          }else{
            switch (status){
              case 'myRides':
                this.myRidesList = [];
                this.pendingList = [];
                this.confirmedList= [];
                this.completedList = [];
                this.showMyRides = true;
                break;
              case 'pending':
                this.myRidesList = [];
                this.pendingList = [];
                this.confirmedList= [];
                this.completedList = [];
                this.showPending = true;
                break;
              case 'confirmed':
                this.myRidesList = [];
                this.pendingList = [];
                this.confirmedList= [];
                this.completedList = [];
                this.showConfirmed = true;
                break;
              case 'completed':
                this.myRidesList = [];
                this.pendingList = [];
                this.confirmedList= [];
                this.completedList = [];
                this.showCompleted = true;
                break;
            }
          }
        });
      },
      icon: Icon(
        Icons.expand_less,
        size: 25.0,
        color: Colors.black,
      ),
    );
    return showDetails ? moreDetails : lessDetails;
  }

  MaterialApp buildRideScreen(List<UserRide> userRides, BuildContext context,) {
    organizeUserRidesInCategories(userRides, context);
    return MaterialApp(
    title: 'ShareMyRide',
    theme: ThemeData(
      scaffoldBackgroundColor: Colors.white,
      primaryColor: darkBlueColor,
      accentColor: lightBlueColor,
      //cardColor: lightGreyBackground,
      textTheme: TextTheme(
        body1: TextStyle(
          color: darkBlueColor,
          fontFamily: 'fira',
          fontSize: 12.0,
        ),
        subhead: TextStyle(
            color: darkBlueColor,
            fontFamily: 'fira',
            fontSize: 16.0,
        ),
      ),
    ),
    home: Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MyApp(db: widget.db, selectedIndex: 1,)),
          );
        },
        child: Icon(Icons.refresh),
        backgroundColor: darkBlueColor,
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
                      'My Rides',
                      style:TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  expandedIconButton(showMyRides, 'myRides'),
                ],
              ),
              Visibility(
                visible: showMyRides,
                child: Column(
                  children: myRidesList,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0,vertical:20.0),
                    child: Text(
                      'Pending',
                        style:TextStyle(
                          fontSize: 32.0,
                          fontWeight: FontWeight.w600,
                        ),
                    ),
                  ),
                  expandedIconButton(showPending, 'pending'),
                ],
              ),
              Visibility(
                visible: showPending,
                child: Column(
                  children: pendingList,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0,vertical:20.0),
                    child: Text(
                      'Confirmed',
                        style:TextStyle(
                          fontSize: 32.0,
                          fontWeight: FontWeight.w600,
                        ),
                    ),
                  ),
                  expandedIconButton(showConfirmed, 'confirmed'),
                ],
              ),
              Visibility(
                visible: showConfirmed,
                child: Column(
                  children: confirmedList,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0,vertical:20.0),
                    child: Text(
                      'Completed',
                        style:TextStyle(
                          fontSize: 32.0,
                          fontWeight: FontWeight.w600,
                        ),
                    ),
                  ),
                  expandedIconButton(showCompleted, 'completed'),
                ],
              ),
              Visibility(
                visible: showCompleted,
                child: Column(
                  children: completedList,
                ),
              ),
              Container(
                height: 70.0,
              )
            ],
          ),
        ),
      ),
    ),
  );
  }

  Widget pendingCardDriver(UserRide userRide, UserModel fellowTraveller, RidesModel ride, BuildContext context){
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
      child: ListTile(
        leading: CircleAvatar(
            backgroundImage: new NetworkImage(fellowTraveller.getUrlFromNameHash(genderInput: fellowTraveller.gender))),
        title: Text(fellowTraveller.name),
        subtitle: Text('${ride.fromText} -> ${ride.toText}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 30.0),
              child: IconButton(
                onPressed: () {
                  acceptRide(userRide, context);
                },
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
    );
  }

  Widget pendingCardPassenger(UserRide userRide, UserModel fellowTraveller, RidesModel ride, BuildContext context){
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
      child: ListTile(
        leading: CircleAvatar(
            backgroundImage: new NetworkImage(fellowTraveller.getUrlFromNameHash(genderInput: fellowTraveller.gender))),
        title: Text(fellowTraveller.name),
        subtitle: Text(' ${ride.fromText} -> ${ride.toText}'),
        trailing: Padding(
          padding: const EdgeInsets.only(right: 0.0),
          child: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.access_time,
              size: 25.0,
              color: lightBlueColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget confirmedCard(UserRide userRide,UserModel fellowTraveller, RidesModel ride, BuildContext context){
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
      child: ListTile(
        leading: CircleAvatar(
            backgroundImage: new NetworkImage(fellowTraveller.getUrlFromNameHash(genderInput: fellowTraveller.gender))),
        title: Text(fellowTraveller.name),
        subtitle: Text(' ${ride.fromText} -> ${ride.toText}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 30.0),
              child: IconButton(
                onPressed: () {
                  completeRide(userRide, context);
                },
                icon: Icon(
                  Icons.check_circle,
                  size: 25.0,
                  color: Colors.green,
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.cancel,
                size: 25.0,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget completedCard(UserRide userRide, UserModel fellowTraveller, RidesModel ride, BuildContext context){
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
      child: ListTile(
        leading: CircleAvatar(
            backgroundImage: new NetworkImage(fellowTraveller.getUrlFromNameHash(genderInput: fellowTraveller.gender))),
        title: Text(fellowTraveller.name),
        subtitle: Text(' ${ride.fromText} -> ${ride.toText}'),
        trailing: Padding(
          padding: const EdgeInsets.only(right: 0.0),
          child: IconButton(
            onPressed: () async{
              UserModel currentUser = await widget.db.getCurrentUserModel();
              //leaveReview(fellowTraveller, currentUser, context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ReviewsScreen(db: widget.db, ride: userRide, reviewee: fellowTraveller, myUser: currentUser,)),
              );
            },
            icon: Icon(
              Icons.chat,
              size: 25.0,
              color: darkBlueColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget finishedCard(UserRide userRide, UserModel fellowTraveller, RidesModel ride, BuildContext context){
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
      child: ListTile(
        leading: CircleAvatar(
            backgroundImage: new NetworkImage(fellowTraveller.getUrlFromNameHash(genderInput: fellowTraveller.gender))),
        title: Text(fellowTraveller.name),
        subtitle: Text(' ${ride.fromText} -> ${ride.toText}'),
        trailing: Padding(
          padding: const EdgeInsets.only(right: 0.0),
          child: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.chat,
              size: 25.0,
              color: Colors.black12,
            ),
          ),
        ),
      ),
    );
  }

  Widget myRidesCard(UserRide userRide, RidesModel ride, BuildContext context){
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
      child: ListTile(
        title: Text(' ${ride.fromText} -> ${ride.toText}'),
        subtitle: Text(' waiting for passengers...'),
        trailing: Padding(
          padding: const EdgeInsets.only(right: 0.0),
          child: IconButton(
            onPressed: () {
              deleteRide(userRide, context);
            },
            icon: Icon(
              Icons.delete,
              size: 25.0,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}

//class completedCard extends StatelessWidget {
//  final DataBase db;
//  final UserModel fellowTraveller;
//  final RidesModel ride;
//
//  completedCard({this.db,this.fellowTraveller, this.ride});
//
//  final darkBlueColor = Color.fromRGBO(26, 26, 48, 1.0);
//  @override
//  Widget build(BuildContext context) {
//    return Card(
//      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
//      child: ListTile(
//        leading: CircleAvatar(
//            backgroundImage: new NetworkImage(fellowTraveller.getUrlFromNameHash(genderInput: fellowTraveller.gender))),
//        title: Text(fellowTraveller.name),
//        subtitle: Text(' ${ride.fromText} -> ${ride.toText}'),
//        trailing: Padding(
//          padding: const EdgeInsets.only(right: 0.0),
//          child: IconButton(
//            onPressed: () async{
//              UserModel currentUser = await db.getCurrentUserModel();
//              //leaveReview(fellowTraveller, currentUser, context);
//              Navigator.push(
//                context,
//                MaterialPageRoute(
//                    builder: (context) => ReviewsScreen(reviewee: fellowTraveller, myUser: currentUser,)),
//              );
//            },
//            icon: Icon(
//              Icons.chat,
//              size: 25.0,
//              color: darkBlueColor,
//            ),
//          ),
//        ),
//      ),
//    );
//  }
//}



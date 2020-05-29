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
  final DataBase db;
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

  void acceptRide(UserRide ride, BuildContext context) async {
    await widget.db.updateRideToConfirmed(ride);
    //Navigate again to Rides Tab
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MyApp(
                db: widget.db,
                selectedIndex: 1,
              )),
    );
  }

  void declineRide(UserRide ride, BuildContext context) async {
    //remove userride from this user and fellowTravellers pending!! list
    //db.deleteUserRide(fellowTravellerPhone)
    await widget.db.declineRide(ride);

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MyApp(
                db: widget.db,
                selectedIndex: 1,
              )),
    );
  }

  void completeRide(UserRide ride, BuildContext context) async {
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
          builder: (context) => MyApp(
                db: widget.db,
                selectedIndex: 1,
              )),
    );
  }

  void cancelRide(UserRide ride, BuildContext context) async {
    //remove from both confirmed list
    await widget.db.cancelRide(ride);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MyApp(
                db: widget.db,
                selectedIndex: 1,
              )),
    );
  }

  void deleteRide(UserRide userRide, BuildContext context) async {
    //Completely delete ride. Cant be searched again
    await widget.db.deleteRideModelFromUserRide(userRide);
    //also delete from this users UserRide list
    await widget.db.deleteUserRide(userRide);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MyApp(
                db: widget.db,
                selectedIndex: 1,
              )),
    );
  }

  void organizeUserRidesInCategories(
      List<UserRide> userRides, BuildContext context) {
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

        if (item.status == Status.myRides) {
          myRidesList.add(myRidesCard(item, ride, context));
        }

        if (item.status == Status.pending) {
          if (item.isDriver) {
            pendingList
                .add(pendingCardDriver(item, fellowTraveller, ride, context));
          } else {
            pendingList.add(
                pendingCardPassenger(item, fellowTraveller, ride, context));
          }
        }
        if (item.status == Status.confirmed) {
          confirmedList
              .add(confirmedCard(item, fellowTraveller, ride, context));
        }
        if (item.status == Status.completed) {
          if (item.isFinished != null) {
            if (!item.isFinished) {
              completedList
                  .add(completedCard(item, fellowTraveller, ride, context));
            }
          }
        }
        if (item.isFinished != null) {
          if (item.isFinished) {
            completedList
                .add(finishedCard(item, fellowTraveller, ride, context));
          }
        }
      }
    }
  }

  void getDataFromDb() {
    futureUserRides = widget.db.getCurrentUserRides();
  }

  @override
  Widget build(BuildContext context) {
    //get a Future list from database
    getDataFromDb();

    return FutureBuilder<List<UserRide>>(
      future: futureUserRides,
      //initialData: [],
      builder: (BuildContext context, AsyncSnapshot<List<UserRide>> snapshot) {
        if (snapshot.hasData) {
          print('We have userRating!!!');
          return buildRideScreen(snapshot.data, context);
        } else if (snapshot.hasError) {
          print('error in user rides');
          return buildRideScreen([], context);
        } else {
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

  IconButton expandedIconButton(bool showDetails, String status) {
    var moreDetails = IconButton(
      onPressed: () {
        this.myRidesList = [];
        this.pendingList = [];
        this.confirmedList = [];
        this.completedList = [];
        setState(() {
          if (showDetails) {
            switch (status) {
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
          } else {
            switch (status) {
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
        this.myRidesList = [];
        this.pendingList = [];
        this.confirmedList = [];
        this.completedList = [];
        setState(() {
          if (showDetails) {
            switch (status) {
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
          } else {
            switch (status) {
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
        Icons.expand_less,
        size: 25.0,
        color: Colors.black,
      ),
    );
    return showDetails ? moreDetails : lessDetails;
  }

  MaterialApp buildRideScreen(
    List<UserRide> userRides,
    BuildContext context,
  ) {
    this.myRidesList = [];
    this.pendingList = [];
    this.confirmedList = [];
    this.completedList = [];
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
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MyApp(
                        db: widget.db,
                        selectedIndex: 1,
                      )),
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
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 20.0),
                      child: Text(
                        'My Rides',
                        style: TextStyle(
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
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 20.0),
                      child: Text(
                        'Pending',
                        style: TextStyle(
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
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 20.0),
                      child: Text(
                        'Confirmed',
                        style: TextStyle(
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
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 20.0),
                      child: Text(
                        'Completed',
                        style: TextStyle(
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

  void deleteAlertDialog(BuildContext context, UserRide userRide) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Warning'),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you really want to delete this worderful ride?'),
                Text('Are you sure bro?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Yes, delete'),
              onPressed: () {
                deleteRide(userRide, context);
              },
            ),
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /// alert dialog with embeded map for randevouz point
  void rendevouzAlertDialog(
      BuildContext context, UserRide userRide, String action) {
    String dialogTitle = '';
    String action1Text = '';
    String action2Text = '';
    var onAction1Pressed;
    var onAction2Pressed;

    if (action == 'confirm') {
      dialogTitle = 'Accept ride?';
      action1Text = 'Yes, accept';
      action2Text = 'No, go back';
      onAction1Pressed = () {
        acceptRide(userRide, context);
      };
      onAction2Pressed = () {
        Navigator.of(context).pop();
      };
    }
    if (action == 'decline') {
      dialogTitle = 'Decline ride?';
      action1Text = 'Yes, decline';
      action2Text = 'No, go back';
      onAction1Pressed = () {
        Navigator.of(context).pop();
        declineRide(userRide, context);
      };
      onAction2Pressed = () {
        Navigator.of(context).pop();
      };
    }
    if (action == 'complete') {
      dialogTitle = 'Is the ride finished?';
      action1Text = 'Yes';
      action2Text = 'No, go back';
      onAction1Pressed = () {
        completeRide(userRide, context);
      };
      onAction2Pressed = () {
        Navigator.of(context).pop();
      };
    }
    if (action == 'cancel') {
      dialogTitle = 'Cancel Ride?';
      action1Text = 'Yes, cancel';
      action2Text = 'No, go back';
      onAction1Pressed = () {
        cancelRide(userRide, context);
      };
      onAction2Pressed = () {
        Navigator.of(context).pop();
      };
    }

    //Google maps data
    LatLng randPoint = userRide.randPoint;
    List<Marker> markersList = [
      Marker(
          markerId: MarkerId('0'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          position: randPoint,
          infoWindow: InfoWindow(title: 'Rendevous Point'))
    ];
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(dialogTitle),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Selected Pick-Up point'),
                SizedBox(
                  width: 200,
                  height: 200,
                  child: GoogleMap(
                    initialCameraPosition:
                        CameraPosition(target: randPoint, zoom: 15),
                    markers: Set.of(markersList),
                    zoomControlsEnabled: false,
                    myLocationEnabled: true,
                    tiltGesturesEnabled: true,
                    compassEnabled: true,
                    scrollGesturesEnabled: true,
                    zoomGesturesEnabled: true,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(action1Text),
              onPressed: () {
                if (action == 'confirm') {
                  acceptRide(userRide, context);
                }
                if (action == 'decline') {
                  declineRide(userRide, context);
                }
                if (action == 'complete') {
                  completeRide(userRide, context);
                }
                if (action == 'cancel') {
                  cancelRide(userRide, context);
                }
              },
            ),
            FlatButton(
              child: Text(action2Text),
              onPressed: () {
                if (action == 'confirm') {
                  Navigator.of(context).pop();
                }
                if (action == 'decline') {
                  Navigator.of(context).pop();
                }
                if (action == 'complete') {
                  Navigator.of(context).pop();
                }
                if (action == 'cancel') {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  /// alert dialog with text
  void confirmAlertDialog(
      BuildContext context, UserRide userRide, String action) {
    String dialogTitle = '';
    String action1Text = '';
    String action2Text = '';
    ListBody dialogBodyComplete;
    ListBody dialogBodyCancel;
    bool
        isComplete; //used to quickly build alert widget tree without checking for strings

    if (action == 'complete') {
      isComplete = true;
      dialogTitle = 'Is the ride finished?';
      dialogBodyComplete = ListBody(
        children: <Widget>[
          Text('You are about to finish this ride.'),
          Text('Make sure to leave a review to your fellow traveler !'),
        ],
      );
      action1Text = 'Yes';
      action2Text = 'No, go back';
    }
    if (action == 'cancel') {
      isComplete = false;
      dialogTitle = 'Cancel Ride?';
      dialogBodyCancel = ListBody(
        children: <Widget>[
          Text('The ride is already approved!'),
          Text('Are you sure you want to cancel it?'),
          Text('This action results to bad karma :( '),
        ],
      );
      action1Text = 'Yes, cancel';
      action2Text = 'No, go back';
    }

    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(dialogTitle),
          content: SingleChildScrollView(
              child: isComplete ? dialogBodyComplete : dialogBodyCancel),
          actions: <Widget>[
            FlatButton(
              child: Text(action1Text),
              onPressed: () {
                if (action == 'complete') {
                  completeRide(userRide, context);
                }
                if (action == 'cancel') {
                  cancelRide(userRide, context);
                }
              },
            ),
            FlatButton(
              child: Text(action2Text),
              onPressed: () {
                if (action == 'complete') {
                  Navigator.of(context).pop();
                }
                if (action == 'cancel') {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  List<Widget> reviewCardsWidgetsFromList(List<ReviewModel> reviews){
    List<Widget> reviewWidgetList = [];
    if (reviews.isEmpty || reviews == null) {
      reviewWidgetList.add(
        Text('You have no reviews yet'),
      );
    } else {
      for (var item in reviews) {
        reviewWidgetList.add(ReviewCard(reviewModel: item));
      }
    }
    return reviewWidgetList;
  }

  double getRatingAverage(List<ReviewModel> reviewsList){

    if(reviewsList.isEmpty){
      return 0.0;
    }else{
      double sum = 0;
      for (var item in reviewsList) {
        var currentRating = item.rating;
        sum = sum + currentRating;
      }
      return sum/reviewsList.length;
    }
  }

  void userInfoAlertDIalog(BuildContext context, UserRide userRide, String action, UserModel fellowTraveller, List<ReviewModel> reviews) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(fellowTraveller.name),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 100,
                      child: CircleAvatar(
                          backgroundImage: new NetworkImage(
                              fellowTraveller.getUrlFromNameHash(
                                  genderInput: fellowTraveller.gender))),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(right: 5.0),
                        child: Text(
                          'Rating:',
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
                              getRatingAverage(reviews).toString().substring(0,3),
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
                ),
                ListTile(
                  leading: Icon(Icons.phone),
                  title: Text(fellowTraveller.phone.substring(0, 9)),
                ),
                ListTile(
                  leading: Icon(Icons.email),
                  title: Text(fellowTraveller.email),
                ),
                Column(
                  children: reviewCardsWidgetsFromList(reviews),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Back'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget pendingCardDriver(UserRide userRide, UserModel fellowTraveller, RidesModel ride, BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
      child: ListTile(
        leading: InkWell(
          onTap: () async{
            var userReviews = await widget.db.getUserReviewsFromPhone(fellowTraveller.phone);
            //todo show info AND phone/email
            userInfoAlertDIalog(context, userRide, 'confirm', fellowTraveller, userReviews);
          },
          child: CircleAvatar(
              backgroundImage: new NetworkImage(fellowTraveller
                  .getUrlFromNameHash(genderInput: fellowTraveller.gender))),
        ),
        title: Text(fellowTraveller.name),
        subtitle: Text('${ride.fromText} -> ${ride.toText}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                onPressed: () {
                  //acceptRide(userRide, context);
                  rendevouzAlertDialog(context, userRide, 'confirm');
                },
                icon: Icon(
                  Icons.check,
                  size: 25.0,
                  color: Colors.green,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                rendevouzAlertDialog(context, userRide, 'decline');
              },
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

  Widget pendingCardPassenger(UserRide userRide, UserModel fellowTraveller, RidesModel ride, BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
      child: ListTile(
        leading: InkWell(
          onTap: () async{
            var userReviews = await widget.db.getUserReviewsFromPhone(fellowTraveller.phone);
            //todo show info AND phone/email
            userInfoAlertDIalog(context, userRide, 'confirm', fellowTraveller, userReviews);
          },
          child: CircleAvatar(
              backgroundImage: new NetworkImage(fellowTraveller
                  .getUrlFromNameHash(genderInput: fellowTraveller.gender))),
        ),
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

  Widget confirmedCard(UserRide userRide, UserModel fellowTraveller, RidesModel ride, BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
      child: ListTile(
        leading: InkWell(
          onTap: () async{
            var userReviews = await widget.db.getUserReviewsFromPhone(fellowTraveller.phone);
            //todo show info AND phone/email
            userInfoAlertDIalog(context, userRide, 'confirm', fellowTraveller, userReviews);
          },
          child: CircleAvatar(
              backgroundImage: new NetworkImage(fellowTraveller
                  .getUrlFromNameHash(genderInput: fellowTraveller.gender))),
        ),
        title: Text(fellowTraveller.name),
        subtitle: Text(' ${ride.fromText} -> ${ride.toText}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 30.0),
              child: IconButton(
                onPressed: () {
                  //completeRide(userRide, context);
                  confirmAlertDialog(context, userRide, 'complete');
                },
                icon: Icon(
                  Icons.check_circle,
                  size: 25.0,
                  color: Colors.green,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                confirmAlertDialog(context, userRide, 'cancel');
              },
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

  Widget completedCard(UserRide userRide, UserModel fellowTraveller, RidesModel ride, BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
      child: ListTile(
        leading: InkWell(
          onTap: () async{
            var userReviews = await widget.db.getUserReviewsFromPhone(fellowTraveller.phone);
            //todo show info AND phone/email
            userInfoAlertDIalog(context, userRide, 'confirm', fellowTraveller, userReviews);
          },
          child: CircleAvatar(
              backgroundImage: new NetworkImage(fellowTraveller
                  .getUrlFromNameHash(genderInput: fellowTraveller.gender))),
        ),
        title: Text(fellowTraveller.name),
        subtitle: Text(' ${ride.fromText} -> ${ride.toText}'),
        trailing: Padding(
          padding: const EdgeInsets.only(right: 0.0),
          child: IconButton(
            onPressed: () async {
              UserModel currentUser = await widget.db.getCurrentUserModel();
              //leaveReview(fellowTraveller, currentUser, context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ReviewsScreen(
                          db: widget.db,
                          ride: userRide,
                          reviewee: fellowTraveller,
                          myUser: currentUser,
                        )),
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

  Widget finishedCard(UserRide userRide, UserModel fellowTraveller, RidesModel ride, BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
      child: ListTile(
        leading: InkWell(
          onTap: () async{
            var userReviews = await widget.db.getUserReviewsFromPhone(fellowTraveller.phone);
            //todo show info AND phone/email
            userInfoAlertDIalog(context, userRide, 'confirm', fellowTraveller, userReviews);
          },
          child: CircleAvatar(
              backgroundImage: new NetworkImage(fellowTraveller
                  .getUrlFromNameHash(genderInput: fellowTraveller.gender))),
        ),
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

  Widget myRidesCard(UserRide userRide, RidesModel ride, BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
      child: ListTile(
        title: Text(' ${ride.fromText} -> ${ride.toText}'),
        subtitle: Text(' waiting for passengers...'),
        trailing: Padding(
          padding: const EdgeInsets.only(right: 0.0),
          child: IconButton(
            onPressed: () {
              //deleteRide(userRide, context);
              deleteAlertDialog(context, userRide);
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/RidesModel.dart';
import 'package:flutter_app/models/UserModel.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:search_map_place/search_map_place.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter_app/widgets/RideResultCard.dart';
import 'package:flutter_app/widgets/ReviewCard.dart';
import 'package:flutter_app/models/ReviewModel.dart';
import 'package:flutter_app/services/fakeDB.dart';
import 'package:flutter_app/services/SearchEngine.dart';
import 'package:flutter_app/services/GoogleMapService.dart';

class ChrisHomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<ChrisHomeScreen> {

  final dateController = TextEditingController();
  final format = DateFormat("yyyy-MM-dd HH:mm:ss");
  String from = "";
  String to = "";
  String date;
  static RidesModel fakeRide = FakeDB.fakeRide;
  List<RidesModel> results = [fakeRide];
  RidesModel currentRide = new RidesModel(fromText: 'from', toText: 'to', randPoints: [new LatLng(38.236785, 23.94523)], toLatLng: new LatLng(37.236785, 23.44523), dateTime: new DateTime(2020), driver: fakeUser);
  static UserModel fakeUser = FakeDB.fakeUser;
  static ReviewModel reviewModel = FakeDB.reviewModel;
  List <ReviewModel> reviewList = [reviewModel,reviewModel,reviewModel,reviewModel];
  bool showStartingScreen = true;
  bool showResults = false;
  bool showDetails = false;
  GoogleMapService googleMapService = new GoogleMapService();
  LatLng startCords, endCords;

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    googleMapService.loadMapStyle();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return homeScaffold();
  }

  Widget homeScaffold() {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      body: Stack(
          children: <Widget>[
            googleMapService.googleMap(context),
            _startingScreen(),
            _resultsScreen(),
            _detailsScreen(currentRide)
          ],
      ),
    );
  }

  Widget _startingScreen(){
    return Visibility(
      visible: showStartingScreen,
      child: Stack(
        children: <Widget>[
          SizedBox(
            height: 250.0,
            child: ListView(
              children: <Widget>[
                fillField("From: ", Colors.blue, 10.0, BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue,
                )),
                fillField("To: ", Colors.red, 10.0, BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed
                )),
                dateField(),
              ],

            ),
          ),
          bottomLeftButton(80.0, Icons.search, "Search", _onSearchPressed),
          bottomLeftButton(15.0, Icons.add, "Create", _onCreatePressed),
        ],
      ),
    );
  }

  Align fillField(String str, Color clr, double top, BitmapDescriptor bitmapDescriptor) {
    return Align(
        alignment: Alignment.topCenter,
        child: Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0, top: top),
            child:
            SearchMapPlaceWidget(
              apiKey: googleMapService.googleAPiKey,
              // The language of the autocompletion
              language: 'el',
              placeholder: str,
              icon: IconData(0xe55f, fontFamily: 'MaterialIcons'),
              iconColor: clr,
              // The position used to give better recommendations. In this case we are using the user position
              location: LatLng(37.9931036, 23.7301123),
              radius: 30000,
              onSelected: (Place place) async {
                final geolocation = await place.geolocation;
                startCords = geolocation.coordinates;
                googleMapService.mapController.animateCamera(CameraUpdate.newLatLngZoom(startCords, 15));

                if(str=="From: "){
                  from = place.description;
                  googleMapService.removePolylines();
                  googleMapService.originLatitude = startCords.latitude;
                  googleMapService.originLongitude = startCords.longitude;
                  setState(() {
                    googleMapService.getPolyline();
                  });
                }

                googleMapService.addMarker(geolocation.coordinates, place.placeId, bitmapDescriptor, place.description);
                if(str=="To: "){
                  to = place.description;
                  googleMapService.removePolylines();
                  googleMapService.destLatitude = startCords.latitude;
                  googleMapService.destLongitude = startCords.longitude;
                  setState(() {
                    googleMapService.getPolyline();
                  });
                }

              },

            )
        ));
  }

  Align dateField() {
    return Align(
        alignment: Alignment.topCenter,
        child: Padding(
            padding: EdgeInsets.only(left: 18.0, right: 18.0, top: 10.0),
            child: DateTimeField(
              format: format,
              controller: dateController,
              decoration: InputDecoration(
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(5.0)
                  ),
                  suffixIcon: Icon(
                    Icons.calendar_today,
                    color: Colors.black,
                  ),
                  fillColor: Colors.white,
                  labelText: "Date: ",
                  labelStyle: TextStyle(
                    color: Colors.black
                  )
              ),
              onShowPicker: (context, currentValue) async {
                final date = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(2100));
                if (date != null) {
                  final time = await showTimePicker(
                    context: context,
                    initialTime:
                    TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                  );
                  return DateTimeField.combine(date, time);
                } else {
                  return currentValue;
                }
              },
            )));
  }//dateField

  Widget bottomLeftButton(double bottom, IconData icon, String label, Function onPressed) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Visibility(
        visible: true,
        child: Padding(
          padding: EdgeInsets.only(right: 10.0, bottom: bottom),
          child: SizedBox(
            height: 60.0,
            width: 120.0,
            child: FlatButton(
              onPressed: () {
                onPressed();
              },
              color: Colors.blue,
              textColor: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide.none,
                borderRadius: BorderRadius.circular(50.0)
              ),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 5,
                  ),
                  Icon(icon),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.0
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //the method called when the user presses the search button
  _onSearchPressed() {
    googleMapService.removePolylines();
    date = dateController.text;
    SearchEngine searchEngine = new SearchEngine(from, to, startCords, endCords, DateTime.parse(date));
    results = searchEngine.getResults();
    setState(() {
      showStartingScreen = false;
      showResults = true;
    });
  }//onSearchPressed

  //the method called when the user presses the create button
  _onCreatePressed() {
    googleMapService.removePolylines();
    date = dateController.text;
    setState(() {
      showDialog(context: context, child:
      new AlertDialog(
        title: new Text(''),
        content: new Text(''),
      )
      );
    });
  }//onCreatePressed

  Widget _resultsScreen() {
    return Align(
        alignment: Alignment.bottomLeft,
        child: Visibility(
          visible: showResults,
          child: SizedBox(
            height: 230.0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.0),
                    topRight: Radius.circular(40.0)),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Hey Xzhibit!',
                        style: TextStyle(fontSize: 22.0),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'We have found these results for you.',
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: _listResultItem(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  } //buildContainer

  List<Widget> _listResultItem() {
    List<Widget> items = new List<Widget>();
    RideResultCard resultCard = new RideResultCard();
    SizedBox box = new SizedBox(width: 10);
    Widget card;

    for(final ride in results){
      items.add(box);
      resultCard = new RideResultCard(ridesModel: ride);
      card = createCard(resultCard);
      items.add(card);
    }

    return items;

  } //list items

  Widget createCard(RideResultCard rideResultCard){
    return GestureDetector(
      onTap: () {
        setState(() {
          showResults = false;
          showDetails = true;
          currentRide = rideResultCard.ridesModel;
        });
      },
      child: Container(width: 300, child: rideResultCard),
    );
  }

  Widget _detailsScreen(RidesModel ride) {
    UserModel driver = ride.driver;
    return Align(
      alignment: Alignment.bottomLeft,
      child: Visibility(
        visible: showDetails,
        child: GestureDetector(
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: <Widget>[
              SizedBox(
                //first white box
                height: 500.0,
                width: double.infinity,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0)),
                    color: Colors.white,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: new NetworkImage(driver.getUrlFromNameHash(genderInput: driver.gender)),
                      radius: 30.0,
                    ),
                    title: Text(
                      driver.name,
                      style: TextStyle(fontSize: 20.0),
                    ),
                    subtitle: Row(
                      children: <Widget>[
                        Icon(
                          Icons.directions_car,
                          size: 20.0,
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          driver.carInfo,
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(driver.rating.toString()),
                        Icon(
                          Icons.star,
                          size: 15.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                //second blue box
                height: 400.0,
                width: double.infinity,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0)),
                    color: Colors.deepPurple[900],
                  ),
                  child: Padding(
                    padding:
                    const EdgeInsets.only(top: 15.0, left: 5.0, right: 5.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: <Widget>[
                              Text(
                                ride.fromText,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.white),
                              ),
                              Icon(
                                Icons.arrow_downward,
                                size: 30.0,
                                color: Colors.white,
                              ),
                              Text(
                                ride.toText,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                'Cost Estimation:',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.white),
                              ),
                              SizedBox(
                                height: 30.0,
                              ),
                              Text(
                                '200.22€',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 30.0, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                //third white box
                height: 250.0,
                width: double.infinity,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0)),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      Expanded(
                        child: ListView(
                          children: _getReviews(reviewList),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  } //showDetails

  List<Widget> _getReviews(List<ReviewModel> list){
    List<ReviewCard> reviews = new List<ReviewCard>();

    for(final review in list){
      ReviewCard card = new ReviewCard(reviewModel: review);
      reviews.add(card);
    }

    return reviews;
  }

} //build_end
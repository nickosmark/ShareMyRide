import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/RidesModel.dart';
import 'package:flutter_app/models/SearchModel.dart';
import 'package:flutter_app/models/UserModel.dart';
import 'package:flutter_app/models/UserRide.dart';
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
import 'package:geocoder/geocoder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_app/services/DataBase.dart';

import 'MyApp.dart';

class ChrisHomeScreen extends StatefulWidget {
  final DataBase db;

  ChrisHomeScreen({@required this.db});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<ChrisHomeScreen> {

  //Google map variables
  GoogleMapController _mapController;
  double _originLatitude, _originLongitude;
  LatLng placeCords, startCords, endCords;
  double _destLatitude, _destLongitude;
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String _googleAPiKey = "AIzaSyBWVICFOmSbt_Z7cnt3swbt9LvZgQg-1uw";
  String mapStyle;
  Completer<GoogleMapController> _controller = Completer();

  //In app necessary variables
  final format = DateFormat("dd-MM-yyyy HH:mm");
  final Color darkBlueColor = Color.fromRGBO(26, 26, 48, 1.0);
  //Search/Create variables
  String from = "";
  String to = "";
  DateTime dateTime;
  LatLng pickUpPoint;
  List<LatLng> randPoints = new List<LatLng>();
  List<String> selectedPoints = new List<String>();
  //booleans for widgets' visibility
  bool showStartingScreen = true;
  bool showResults = false;
  bool showDetails = false;
  bool showCreate = false;
  bool isTouchable = false;
  bool showPickUpPoints = false;

  //fake data
  static RidesModel fakeRide = FakeDB.fakeRide;
  static UserModel fakeUser = FakeDB.fakeUser;
  static ReviewModel reviewModel = FakeDB.reviewModel;


  //Data displayed on result screen
  List<RidesModel> rideSearchResults = [fakeRide];
  UserModel currentUser = UserModel(name: 'waiting name', gender: null, phone: '000000', email: 'waiting mail', carInfo: 'subaru', rating: 0.0);
  //Data displayed on details Screen
  //They get updated when Request Ride is tapped.
  RidesModel detailsRide = new RidesModel(fromText: 'from', toText: 'to', randPoints: [new LatLng(38.236785, 23.94523)], toLatLng: new LatLng(37.236785, 23.44523), dateTime: new DateTime(2020), driver: fakeUser);
  List <ReviewModel> detailsReviewList = [reviewModel,reviewModel,reviewModel,reviewModel];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {

    _loadMapStyle();
    super.initState();
  }

  @override
  void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
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
            _googleMap(context),
            _startingScreen(showStartingScreen),
            _resultsScreen(showResults, currentUser.name, rideSearchResults),
            _detailsScreen(showDetails, detailsRide, detailsReviewList),
            _createScreen(showCreate),
            _pickUpPointScreen(showPickUpPoints)
          ],
      ),
    );
  }

  Widget _startingScreen(bool isVisible){
    return Visibility(
      visible: isVisible,
      child: Stack(
        children: <Widget>[
          SizedBox(
            height: 250.0,
            child: ListView(
              children: <Widget>[
                _fillField("From: ", Colors.blue, 10.0, BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue,
                )),
                _fillField("To: ", Colors.red, 10.0, BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed
                )),
                _dateField(),
              ],

            ),
          ),
          _customButton(Alignment.bottomRight, 80.0, Icons.search, "Search", _onSearchPressed),
          _customButton(Alignment.bottomRight, 15.0, Icons.add, "Create", _onCreatePressed),
        ],
      ),
    );
  }

  Align _fillField(String str, Color clr, double top, BitmapDescriptor bitmapDescriptor) {
    return Align(
        alignment: Alignment.topCenter,
        child: Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0, top: top),
            child:
            SearchMapPlaceWidget(
              apiKey: _googleAPiKey,
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
                placeCords = geolocation.coordinates;
                _mapController.animateCamera(CameraUpdate.newLatLngZoom(placeCords, 15));
                _clearPolylines();

                if(str=="From: "){
                  from = place.description;
                  _addMarker(geolocation.coordinates, place.placeId, bitmapDescriptor, place.description);
                  _originLatitude = placeCords.latitude;
                  _originLongitude = placeCords.longitude;
                  startCords = placeCords;
                  setState(() {

                  });
                }

                if(str=="To: "){
                  to = place.description;
                  _addMarker(geolocation.coordinates, place.placeId, bitmapDescriptor, place.description);
                  _destLatitude = placeCords.latitude;
                  _destLongitude = placeCords.longitude;
                  endCords = placeCords;
                }

                if(_originLongitude!= null && _originLatitude != null && _destLongitude != null && _destLatitude != null)
                  _getPolyline("demo");

              },

            )
        ));
  }

  Align _dateField() {
    return Align(
        alignment: Alignment.topCenter,
        child: Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
            child: DateTimeField(
              format: format,
              onChanged: (DateTime dt){
                dateTime = dt;
              },
              resetIcon: Icon(Icons.clear, color: Colors.black,),
              decoration: InputDecoration(
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(5.0)
                  ),
                  //suffixIcon: Icon(Icons.calendar_today, color: Colors.black,),
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

  Widget _customButton(Alignment alignment, double bottom, IconData icon, String label, Function onPressed) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: EdgeInsets.only(right: 10.0, bottom: bottom, left: 10.0, top: 10.0),
        child: SizedBox(
          height: 50.0,
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
    );
  }

  //the method called when the user presses the search button
  _onSearchPressed() async {
    _clearPolylines();
    _clearMarkers();
    if(_areFieldsFilled()) {
      this.currentUser = await widget.db.getCurrentUserModel();
      var search = SearchModel(
        fromText: this.from,
        toText: this.to,
        fromCords: this.startCords,
        toCords: this.endCords,
        searchDate: this.dateTime,
        searcher: currentUser,
      );
      this.rideSearchResults = await widget.db.getRidesModelsFromSearch(search);
      setState(() {
        showStartingScreen = false;
        showResults = true;
      });
    }
  }//onSearchPressed

  //the method called when the user presses the create button
  _onCreatePressed() {
    if(_areFieldsFilled()) {
      _convertPolylineToRandPoints();
      randPoints.add(startCords);
      setState(() {
        showStartingScreen = false;
        showCreate = true;
        isTouchable = true;
        _mapController.animateCamera(CameraUpdate.newLatLngZoom(startCords, 15));
      });
    }
  }//onCreatePressed

  _getUserDataFromDB() async {
    this.currentUser = await widget.db.getCurrentUserModel();
    var userReviews = await widget.db.getCurrentUserReviews();
    //update rating on db ??? Do we need that?
    widget.db.updateCurrentUserRating(userReviews);
    //update local user rating value. This should be used on ride used by confirmed button
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
    this.currentUser.rating = getRatingAverage(userReviews);
    //update rating on db
  }

  bool _areFieldsFilled(){
    if(from == "") {
      _showToast("Missing 'From' field!");
      return false;
    }
    if(to == "") {
      _showToast("Missing 'To' field!");
      return false;
    }
    if(dateTime == null) {
      _showToast("Missing 'Date' field!");
      return false;
    }
    return true;
  }

  void _convertPolylineToRandPoints() {
    PolylineId id = PolylineId("demo");
    for(final x in polylines[id].points){
      LatLng temp = x;
      randPoints.add(temp);
    }
  }

  _showToast(String message){
    Fluttertoast.showToast(
        msg: message,
        timeInSecForIosWeb: 1,
    );
  }

  Widget _createScreen(bool isVisible){
    return Visibility(
      visible: isVisible,
        child: Stack(
          children: <Widget>[
            _topText(),
            _customButton(Alignment.bottomRight, 15.0, Icons.check_circle, "Finish", _onFinishPressed),
            _customButton(Alignment.bottomLeft, 15.0, Icons.cancel, "Cancel", _onCancelPressed)
          ],
      )
    );
  }

  Widget _topText(){
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        height: 90.0,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.orange[200],
          ),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              'Select rendezvous points to pick up passengers, besides the recommended route (optional). \nYour starting point is rendezous point #1.',
              style: TextStyle(
                fontSize: 18.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  _onFinishPressed(){
    showDialog(context: context, barrierDismissible: true, child:
    new AlertDialog(
      title: new Text('Ride Overview'),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))
      ),
      content: new SizedBox(
        //height: 300,
        child: Column(
          children: <Widget>[
            Text('From: $from', style: TextStyle(fontSize: 18.0),),
            Text('To: $to', style: TextStyle(fontSize: 18.0),),
            Text('Date: $dateTime', style: TextStyle(fontSize: 18.0),),
            Text('Selected rendezvous points:', style: TextStyle(fontSize: 18.0),),
            Text(_showSelectedPoints())
          ],
        ),
      ),
      actions: [
        FlatButton(
          child: Text("I'm not done yet"),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop('dialog');
          },
        ),
        FlatButton(
          child: Text("Confirm"),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop('dialog');
            _showToast("Ride Successfully created!");
            _onConfirmPressed();

          },
        ),
      ],
    )
    );
  }

  _onConfirmPressed() async{
    //Do your thing Mark
    //right on it baby <3 <3 :)
    await _getUserDataFromDB();
    RidesModel ridesModel = new RidesModel(fromText: from, toText: to, randPoints: randPoints, toLatLng: endCords, dateTime: dateTime, driver: currentUser);
    var result = await widget.db.createRidesModel(ridesModel);
    if(result == null){
      print('error creating ride in homeScreen');
    }

    //Add created ride to my rides section on rides tab
    var myRidesRide = UserRide(
        phone: this.currentUser.phone,
        status: Status.myRides,
        isDriver: true,
        isFinished: false,
        ride: ridesModel,
        fellowTraveler: UserModel(),
        randPoint: LatLng(13.00,14.00),
    );
    var result2 = await widget.db.createUserRide(myRidesRide);
    if(result2 == null){
      print('error creating My Rides ride');
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyApp(db: widget.db, selectedIndex: 1,),
      ),
    );

  }

  String _showSelectedPoints(){
    String result = "";
    if(selectedPoints.isEmpty)
      result = "None";
    else{
      for(final x in selectedPoints){
        result += x + "\n";
      }
    }
    return result;
  }

  _onCancelPressed(){
    setState(() {
      showStartingScreen = true;
      showCreate = false;
      isTouchable = false;
      _resetAllData();
      selectedPoints.clear();
    });
  }

  Widget _resultsScreen(bool isVisible, String name, List<RidesModel> results) {
    return Visibility(
      visible: isVisible,
      child: Stack(
        children: <Widget>[
          _customButton(Alignment.topLeft, 0.0, Icons.arrow_back_ios, "Back", _onBackPressed),
          Align(
            alignment: Alignment.bottomLeft,
            child: SizedBox(
            height: 250.0,
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
                    padding: const EdgeInsets.only(left: 25, top: 7.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Hey $name!',
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
                      children: _listResultItem(results),
                    ),
                  ),
                ],
              ),
            ),
        ),
          ),
      ]
      ),
    );
  } //buildContainer

  void _onBackPressed(){
    setState(() {
      showStartingScreen = true;
      showResults = false;
      _resetAllData();
    });
  }

  _resetAllData(){
    _clearPolylines();
    _clearMarkers();
    from = to = "";
    dateTime = null;
    _destLatitude = _destLongitude = _originLatitude = _originLongitude = null;
  }

  List<Widget> _listResultItem(List<RidesModel> results) {
    List<Widget> items = new List<Widget>();
    RideResultCard resultCard = new RideResultCard();
    SizedBox box = new SizedBox(width: 10);
    Widget card;

    for(final ride in results){
      items.add(box);
      resultCard = new RideResultCard(ridesModel: ride, onPressed: _showRideDetails);
      card = createCard(resultCard);
      items.add(card);
    }

    return items;

  }//list items

  _showRideDetails(RidesModel ridesModel) async{
    //this.detailsReviewList = await
    detailsReviewList = await widget.db.getUserReviewsFromPhone(ridesModel.driver.phone);
    setState((){
      showResults = false;
      showDetails = true;
      detailsRide = ridesModel;
    });
  }

  _requestRideFinal(){
    //create two userRides/
    //pass it to UserRide of the currentUser
    var currentUserRide = UserRide(
      isDriver: false,
      phone: this.currentUser.phone,
      status: Status.pending,
      ride: this.detailsRide,
      fellowTraveler: this.detailsRide.driver,
      randPoint: pickUpPoint,
      isFinished: false,
    );
    //create waiting pending for this currentUser
    var result = widget.db.createUserRide(currentUserRide);
    if(result == null){
      print('couldnt create a current user Ride');
    }else{
      print('current UserRide creation Successfull!!');
    }
    //create accept/decline pending for driver
    var driverUserRide = UserRide(
        isDriver: true,
        phone: this.detailsRide.driver.phone,
        status: Status.pending,
        ride: this.detailsRide,
        fellowTraveler: this.currentUser,
        randPoint: pickUpPoint,
        isFinished: false
    );
    var result2 = widget.db.createUserRide(driverUserRide);
    if(result2 == null){
    print('couldnt create a new driver user Ride');
    }else{
    print('driver UserRide creation Successfull!!');
    }
  }

  Widget createCard(RideResultCard rideResultCard){
    return GestureDetector(
      onTap: () {
        if(!(polylines.containsKey(PolylineId(rideResultCard.ridesModel.driver.name)))){
          _clearPolylines();
          _originLatitude = rideResultCard.ridesModel.randPoints[0].latitude;
          _originLongitude = rideResultCard.ridesModel.randPoints[0].longitude;
          _destLatitude = rideResultCard.ridesModel.toLatLng.latitude;
          _destLongitude = rideResultCard.ridesModel.toLatLng.longitude;
          _addMarker(rideResultCard.ridesModel.randPoints[0], "Start", BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueBlue), "Start");
          _addMarker(rideResultCard.ridesModel.toLatLng, "End", BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed), "End");
          _getPolyline(rideResultCard.ridesModel.driver.name);
          _mapController.animateCamera(CameraUpdate.newLatLngZoom(rideResultCard.ridesModel.randPoints[0], 14));
        }
      },
      child: Container(width: 300, child: rideResultCard),
    );
  }

  Widget _detailsScreen(bool isVisible, RidesModel ride, List<ReviewModel> list) {
    UserModel driver = ride.driver;
    String from, to;
    double rating = double.parse((driver.rating).toStringAsFixed(1));
    if(ride.fromText.length > 300)
      from = ride.fromText.substring(0, 27) + "...";
    else
      from = ride.fromText;

    if(ride.toText.length > 300)
      to = ride.toText.substring(0, 27) + "...";
    else
      to = ride.toText;

    return Align(
      alignment: Alignment.bottomLeft,
      child: Visibility(
        visible: isVisible,
        child: GestureDetector(
          onTap: () {
            setState(() {
              showResults = true;
              showDetails = false;
            });
          },
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
                      radius: 28.0,
                    ),
                    title: Text(
                      driver.name,
                      style: TextStyle(fontSize: 24.0),
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
                        Text(rating.toString(),style: TextStyle(fontSize: 18.0),),
                        Icon(
                          Icons.star,
                          size: 20.0,
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
                    color: darkBlueColor,
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
                                from,
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
                                to,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20.0, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        /*
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

                         */
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
                          children: _getReviews(list),
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      RaisedButton(
                        onPressed: () {
                          //_requestRideFinal();
                          _selectPickUpPoint(ride);
                        },
                        child: Text(
                          "Select Pick-Up Point",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.0,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        color: darkBlueColor,
                      )
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

  Widget _pickUpPointScreen(bool isVisible){
    return Visibility(
      visible: isVisible,
      child: _customButton(Alignment.topLeft, 1.0, Icons.arrow_back_ios, "Return", _onReturnPressed)
      );
  }

  _onReturnPressed(){
    setState(() {
      showPickUpPoints = false;
      showDetails = true;
    });
  }

  _selectPickUpPoint(RidesModel ride) async{
    showDetails = false;
    showPickUpPoints = true;
    if(!(polylines.containsKey(PolylineId(ride.driver.name)))) {
      _originLatitude = ride.randPoints[0].latitude;
      _originLongitude = ride.randPoints[0].longitude;
      _destLatitude = ride.toLatLng.latitude;
      _destLongitude = ride.toLatLng.longitude;
      _getPolyline(ride.driver.name);
      LatLng dest = new LatLng(_destLatitude, _destLongitude);
      final String destination = await _getAddressFromLatLng(dest);
      _addMarker(dest, "to", BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed), destination);
    }
    _mapController.animateCamera(CameraUpdate.newLatLngZoom(ride.randPoints[0], 15));
    if(markers.containsKey(MarkerId("Start")))
      markers.remove(MarkerId("Start"));
    int i = 0;
    for(final point in ride.randPoints){
      if(i%3==0)
        _showRendezvousPoint("address$i", point, true);
      i++;
    }
  }

  _onPickUpPointSelected(){
    _clearMarkers();
    _clearPolylines();
      showDialog(context: context, barrierDismissible: true, child:
      new AlertDialog(
        title: Text('Request Ride Successful!'),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))
        ),
        content: Column(
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            Text(
              "You are waiting for confirmation.\nCheck your Rides tab."
            ),
            SizedBox(
              height: 10.0,
            ),
            Image(
              image: new AssetImage('assets/images/check_img.png'),
            ),
          ],
        ),
        actions: [
          FlatButton(
            child: Text('YAY!'),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop('dialog');
              _requestRideFinal();
              setState(() {
                showResults = true;
              });
            },
          ),
        ],
      )
    );
  }

  List<Widget> _getReviews(List<ReviewModel> list){
    List<ReviewCard> reviews = new List<ReviewCard>();

    for(final review in list){
      ReviewCard card = new ReviewCard(reviewModel: review);
      reviews.add(card);
    }

    return reviews;
  }

  //Google map related methods

  Widget _googleMap(BuildContext context){
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
            target: LatLng(37.9838, 23.7275),
            zoom: 15
        ),
        zoomControlsEnabled: false,
        myLocationEnabled: true,
        tiltGesturesEnabled: true,
        compassEnabled: true,
        scrollGesturesEnabled: true,
        zoomGesturesEnabled: true,
        onMapCreated: onMapCreated,
        markers: Set<Marker>.of(markers.values),
        polylines: Set<Polyline>.of(polylines.values),
        onTap: _onMapTap,
      ),
    );
  }

  void _onMapTap(LatLng point){
    if (isTouchable){
      _showPointDialog(point);
    }
  }

  void _showPointDialog (LatLng point) async{
    final String name = await _getAddressFromLatLng(point);
    showDialog(context: context, barrierDismissible: false, child:
      new AlertDialog(
        title: new Text('Add this rendezvous point?'),
        content: new Text(name),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))
        ),
        actions: [
          FlatButton(
            child: Text('No'),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop('dialog');
            },
          ),
          FlatButton(
            child: Text('Yes'),
            onPressed: () {
              _showRendezvousPoint(name, point, false);
              randPoints.add(point);
              selectedPoints.add(name);
              Navigator.of(context, rootNavigator: true).pop('dialog');
            },
          ),
        ],
      )
    );
  }

  Future<String> _getAddressFromLatLng(LatLng point) async{
    final coordinates = new Coordinates(point.latitude, point.longitude);
    var address = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = address.first;
    String name = first.addressLine;
    return name;
  }

  void _showRendezvousPoint(String title, LatLng point, bool selectOn){
    Marker rendezvousPoint =
    Marker(markerId: MarkerId(title),
      position: point,
      consumeTapEvents: true,
      onTap: () async {
        if(selectOn) {
          final String address = await _getAddressFromLatLng(point);
          showDialog(context: context, barrierDismissible: true, child:
          new AlertDialog(
            title: new Text('Select this pick-up point?'),
            content: new Text(address),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))
            ),
            actions: [
              FlatButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                },
              ),
              FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  pickUpPoint = point;
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                  _onPickUpPointSelected();
                },
              ),
            ],
          )
          );
        }
      },
      infoWindow: new InfoWindow(title: title),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
    );
    markers[MarkerId(title)] = rendezvousPoint;
    setState(() {

    });
  }

  void onMapCreated(GoogleMapController controller) async{
    _mapController = controller;
    _mapController.setMapStyle(mapStyle);
  }

  void _loadMapStyle() {
    rootBundle.loadString('assets/map_style.txt').then((string) {
      mapStyle = string;
    });
  }

  // method that creates the polyline given the from and to geolocation
  _getPolyline(String name) async {
    List<PointLatLng> result = await polylinePoints.getRouteBetweenCoordinates(
      _googleAPiKey,
      _originLatitude,
      _originLongitude,
      _destLatitude,
      _destLongitude,);
    if (result.isNotEmpty) {
      result.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    PolylineId id = PolylineId(name);
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.blue, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {

    });
  }

  _clearPolylines(){
    polylineCoordinates.clear();
    polylines.clear();
  }

  _clearMarkers(){
    markers.clear();
  }

  // method that adds the marker to the map
  _addMarker(LatLng position, String id, BitmapDescriptor descriptor, String info){
    MarkerId markerId = MarkerId(id);
    Marker marker =
    Marker(markerId: markerId,
        icon: descriptor,
        position: position,
        infoWindow: InfoWindow(title: info
        ));
    markers[markerId] = marker;
  }

} //build_end
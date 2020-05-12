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
import 'package:geocoder/geocoder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_app/services/DataBase.dart';

class ChrisHomeScreen extends StatefulWidget {
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
  //Search/Create variables
  String from = "";
  String to = "";
  DateTime dateTime;
  List<LatLng> randPoints = new List<LatLng>();
  List<String> selectedPoints = new List<String>();
  //booleans for widgets' visibility
  bool showStartingScreen = true;
  bool showResults = false;
  bool showDetails = false;
  bool showCreate = false;
  bool isTouchable = false;

  //fake data
  static RidesModel fakeRide = FakeDB.fakeRide;
  List<RidesModel> results = [fakeRide];
  RidesModel currentRide = new RidesModel(fromText: 'from', toText: 'to', randPoints: [new LatLng(38.236785, 23.94523)], toLatLng: new LatLng(37.236785, 23.44523), dateTime: new DateTime(2020), driver: fakeUser);
  static UserModel fakeUser = FakeDB.fakeUser;
  static ReviewModel reviewModel = FakeDB.reviewModel;
  List <ReviewModel> reviewList = [reviewModel,reviewModel,reviewModel,reviewModel];

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
            _resultsScreen(showResults, fakeUser.name, results),
            _detailsScreen(showDetails, currentRide),
            _createScreen(showCreate),
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
          _customButton(Alignment.bottomRight, 80.0, Icons.search, "Search", _onSearchPressed),
          _customButton(Alignment.bottomRight, 15.0, Icons.add, "Create", _onCreatePressed),
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
                }

                if(str=="To: "){
                  to = place.description;
                  _addMarker(geolocation.coordinates, place.placeId, bitmapDescriptor, place.description);
                  _destLatitude = placeCords.latitude;
                  _destLongitude = placeCords.longitude;
                  endCords = placeCords;
                }
                _getPolyline();

              },

            )
        ));
  }

  Align dateField() {
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
  _onSearchPressed() {
    _clearPolylines();
    if(_areFieldsFilled()) {
      SearchEngine searchEngine = new SearchEngine(from, to, startCords, endCords, dateTime);
      results = searchEngine.getResults();
      setState(() {
        showStartingScreen = false;
        showResults = true;
      });
    }
  }//onSearchPressed

  //the method called when the user presses the create button
  _onCreatePressed() {
    if(_areFieldsFilled()) {
      setState(() {
        showStartingScreen = false;
        showCreate = true;
        isTouchable = true;
        randPoints.add(startCords);
        _convertPolylineToRandPoints();
      });
    }
  }//onCreatePressed

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

  void _convertPolylineToRandPoints() async{
    PolylineId id = PolylineId("poly");
    for(final x in polylines[id].points){
      LatLng temp = x;
      randPoints.add(temp);
      //final String address = await _getAddressFromLatLng(temp);
      //_showRendezvousPoint(address, temp);
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
    RidesModel ridesModel = new RidesModel(fromText: from, toText: to, randPoints: randPoints, toLatLng: endCords, dateTime: dateTime, driver: fakeUser);
    showDialog(context: context, barrierDismissible: true, child:
    new CupertinoAlertDialog(
      title: new Text('Ride Overview'),
      content: new SizedBox(
        //height: 300,
        child: Column(
          children: <Widget>[
            Text('From: ${ridesModel.fromText}', style: TextStyle(fontSize: 18.0),),
            Text('To: ${ridesModel.toText}', style: TextStyle(fontSize: 18.0),),
            Text('Date: ${ridesModel.dateTime}', style: TextStyle(fontSize: 18.0),),
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
            _onConfirmPressed(ridesModel);
            Navigator.of(context, rootNavigator: true).pop('dialog');
          },
        ),
      ],
    )
    );
  }

  //TODO Make it work baby. This function will get your RidesModel to the firebase
  _onConfirmPressed(RidesModel ridesModel){
    //Do your thing Mark
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
      _clearPolylines();
      _clearMarkers();
      from = to = "";
      dateTime = null;
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
      _clearPolylines();
      _clearMarkers();
      from = to = "";
      dateTime = null;
    });
  }

  List<Widget> _listResultItem(List<RidesModel> results) {
    List<Widget> items = new List<Widget>();
    RideResultCard resultCard = new RideResultCard();
    SizedBox box = new SizedBox(width: 10);
    Widget card;

    for(final ride in results){
      items.add(box);
      resultCard = new RideResultCard(ridesModel: ride, onPressed: _requestRide);
      card = createCard(resultCard);
      items.add(card);
    }

    return items;

  }//list items

  void _requestRide(){

  }

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

  Widget _detailsScreen(bool isVisible, RidesModel ride) {
    UserModel driver = ride.driver;
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
                      SizedBox(
                        height: 2,
                      ),
                      FlatButton(
                        onPressed: () {

                        },
                        child: DecoratedBox(
                          child: Text(
                            "Request Ride",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.0
                            ),
                          ),
                          decoration: new BoxDecoration(
                            color: Colors.deepPurple[900],
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
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
      new CupertinoAlertDialog(
        title: new Text('Add this rendezvous point?'),
        content: new Text(name),
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
              _showRendezvousPoint(name, point);
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

  void _showRendezvousPoint(String title, LatLng point){
    Marker rendezvousPoint =
    Marker(markerId: MarkerId(title),
      position: point,
      infoWindow: new InfoWindow(title: title),
      icon:
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
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

  Future<void> gotoLocation(double lat, double long) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(lat, long), zoom: 15, tilt: 50.0, bearing: 45.0)));
  }

  // method that creates the polyline given the from and to geolocation
  _getPolyline() async {
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
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.blue, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {

    });
  }

  _clearPolylines(){
    polylineCoordinates.clear();
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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

class ChrisHomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<ChrisHomeScreen> {

  GoogleMapController mapController;
  double _originLatitude, _originLongitude;
  LatLng startCoords;
  double _destLatitude, _destLongitude;
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyBWVICFOmSbt_Z7cnt3swbt9LvZgQg-1uw";
  String _mapStyle;

  Completer<GoogleMapController> _controller = Completer();

  final dateController = TextEditingController();
  final format = DateFormat("dd-MM-yy HH:mm");
  int mode = 0;
  String from = "";
  String to = "";
  String date;
  List<Widget> results;
  RideResultCard resultCard = new RideResultCard();
  static ReviewModel reviewModel = new ReviewModel(imageUrl: 'https://img.documentonews.gr/unsafe/1000x600/smart/http://img.dash.documentonews.gr/documento/imagegrid/2018/10/31/5bd98303cd3a18740d2cf935.jpg',
      name:'Your dad/mom', reviewText:'The worst driver... Women drive better than non-binarys!', rating: 0.5);
  static ReviewCard reviewCard = new ReviewCard(reviewModel: reviewModel);
  List <ReviewCard> reviewList = [reviewCard, reviewCard, reviewCard, reviewCard, reviewCard, reviewCard];
  bool showResults = true;

  @override
  void dispose() {
    dateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    switch (mode) {
      case 0:
        {
          return homeScaffold();
        }
        break;
      case 1:
        {
          return searchScaffold();
        }
        break;
    }
  }

  Widget _googlemap(BuildContext context){
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
            target: LatLng(37.9838, 23.7275),
            zoom: 15
        ),
        myLocationEnabled: true,
        tiltGesturesEnabled: true,
        compassEnabled: true,
        scrollGesturesEnabled: true,
        zoomGesturesEnabled: true,
        onMapCreated: _onMapCreated,
        markers: Set<Marker>.of(markers.values),
        polylines: Set<Polyline>.of(polylines.values),
      ),
    );
  }
  void _onMapCreated(GoogleMapController controller) async{

    mapController = controller;
    mapController.setMapStyle(_mapStyle);
  }


  Future<void> _gotoLocation(double lat, double long) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(lat, long), zoom: 15, tilt: 50.0, bearing: 45.0)));
  }

  Widget homeScaffold() {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: FloatingActionButton.extended(
              onPressed: () {
                _removePolylines();
                date = dateController.text;
                setState(() {
                  mode = 1;
                  results = [_listResultItem(), _listResultItem(), _listResultItem()];
                });
              }, //onPressed
              label: Text('Search'),
              icon: Icon(Icons.search),
              backgroundColor: Colors.blue,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: FloatingActionButton.extended(
              onPressed: () {
                String text1 = from+  "\n";
                String text2 = to+  "\n";
                String text3 = dateController.text;
                return showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text(text1 + text2 + text3),
                    );
                  },
                );
              }, //onPressed
              label: Text('Create'),
              icon: Icon(Icons.add),
              backgroundColor: Colors.blue,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            _googlemap(context),
            dateField(),
            fillField("To: ", Colors.red, 120.0, BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRed
            )),
            fillField("From: ", Colors.blue, 50.0, BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueBlue
            )),


          ],
        ),
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
              apiKey: googleAPiKey,
              // The language of the autocompletion
              language: 'el',
              placeholder: str,
              icon: IconData(0xe55f, fontFamily: 'MaterialIcons'),
              iconColor: clr,
              // The position used to give better recomendations. In this case we are using the user position
              location: LatLng(37.9931036, 23.7301123),
              radius: 30000,
              onSelected: (Place place) async {
                final geolocation = await place.geolocation;
                startCoords = geolocation.coordinates;
                mapController.animateCamera(CameraUpdate.newLatLngZoom(startCoords, 15));
                if(str=="From: "){
                  from = place.description;
                  _originLatitude = startCoords.latitude;
                  _originLongitude = startCoords.longitude;
                }


                _addMarker(geolocation.coordinates, place.placeId, bitmapDescriptor, place.description);
                if(str=="To: "){
                  to = place.description;
                  _destLatitude = startCoords.latitude;
                  _destLongitude = startCoords.longitude;
                  print("polyline called");
                  _getPolyline();
                }

              },
            )
//          TextField(
//            controller: controller,
//            decoration: InputDecoration(
//                filled: true,
//                fillColor: Colors.white,
//                prefixIcon: Icon(
//                  Icons.location_on,
//                  color: clr,
//                ),
//                labelText: str),
//          ),
        ));
  }
  // method thad adds the polyline to the list of polylines
  // that will display on map
  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.blue, points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  // method that creates the polyline given the from and to geolocation
  _getPolyline() async {
    List<PointLatLng> result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyBWVICFOmSbt_Z7cnt3swbt9LvZgQg-1uw",
      _originLatitude,
      _originLongitude,
      _destLatitude,
      _destLongitude,);
    if (result.isNotEmpty) {
      result.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }
  _removePolylines(){
    polylineCoordinates.clear();
  }


  // method that adds the marker to the map
  _addMarker(LatLng position, String id, BitmapDescriptor descriptor, String info){
    setState(() {
      MarkerId markerId = MarkerId(id);
      Marker marker =
      Marker(markerId: markerId,
          icon: descriptor,
          position: position,
          infoWindow: InfoWindow(title: info
          ));
      markers[markerId] = marker;
    });

  }

  Align dateField() {
    return Align(
        alignment: Alignment.topCenter,
        child: Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 190.0),
            child: DateTimeField(
              format: format,
              controller: dateController,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(
                    Icons.calendar_today,
                    color: Colors.black38,
                  ),
                  labelText: "Date: "),
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
  }

  Scaffold searchScaffold() {
    return Scaffold(
      body: Stack(
        children: <Widget>[_googlemap(context), _showResults(), _showDetails()],
      ),
    );
  }

  Widget _showResults() {
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
                      children: <Widget>[
                        SizedBox(
                          width: 10.0,
                        ),
                        _listResultItem(),
                        SizedBox(
                          width: 10.0,
                        ),
                        _listResultItem(),
                        SizedBox(
                          width: 10.0,
                        ),
                        _listResultItem(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  } //buildContainer

  Widget _listResultItem() {
    resultCard = new RideResultCard(from: from, to: to);
    return GestureDetector(
      onTap: () {
        setState(() {
          showResults = false;
        });
      },
      child: Container(width: 300, child: resultCard),
    );
  } //list items

  Widget _showDetails() {

    return Align(
      alignment: Alignment.bottomLeft,
      child: Visibility(
        visible: !showResults,
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
                      backgroundImage: new NetworkImage(
                          'https://img.documentonews.gr/unsafe/1000x600/smart/http://img.dash.documentonews.gr/documento/imagegrid/2018/10/31/5bd98303cd3a18740d2cf935.jpg'),
                      radius: 30.0,
                    ),
                    title: Text(
                      'Jason Antigoniiiiiiiiiiii',
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
                          'Batmobile',
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text('1.0'),
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
                          children: reviewList,
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

} //build_end



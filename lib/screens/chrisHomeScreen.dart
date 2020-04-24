import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class chrisHomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<chrisHomeScreen> {
  Completer<GoogleMapController> _controler = Completer();
  String _mapStyle;
  final format = DateFormat("dd-MM-yy");

  @override
  void initState() {
    rootBundle.loadString('assets/map_style.txt').then((string) {
      _mapStyle = string;
    });
    super.initState();
  }

  double zoomVal = 0.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton.extended(
              onPressed: () {
                // Add your onPressed code here!
              },
              label: Text('Search'),
              icon: Icon(Icons.search),
              backgroundColor: Colors.pink,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FloatingActionButton.extended(
              onPressed: () {
                // Add your onPressed code here!
              },
              label: Text('Create'),
              icon: Icon(Icons.add),
              backgroundColor: Colors.blue,
            ),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          //_googleMap(context),
          fillField("From: ", Colors.blue, 50.0),
          fillField("To: ", Colors.red, 120.0),
          dateField(),
        ],
      ),
    );
  }

  Align fillField(String str, Color clr, double top) {
    return Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.only(left: 10.0, right: 10.0, top: top),
          child: TextField(
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(
                  Icons.location_on,
                  color: clr,
                ),
                labelText: str),
          ),
        ));
  }

  Align dateField() {
    return Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 190.0),
          child: DateTimeField(
              format: format,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(
                    Icons.calendar_today,
                    color: Colors.grey,
                  ),
                  labelText: "Date: "),
              onShowPicker: (context, currentValue) {
                return showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(2100));
              }),
        ));
  }

  Widget _googleMap(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType: MapType.normal,
        //zoomControlsEnabled: false,
        initialCameraPosition:
            CameraPosition(target: LatLng(37.9838, 23.7275), zoom: 12),
        onMapCreated: (GoogleMapController controler) {
          controler.setMapStyle(_mapStyle);
          _controler.complete(controler);
        },
        markers: {firstmarker, secondmarker},
      ),
    );
  }

  Future<void> _gotoLocation(double lat, double long) async {
    final GoogleMapController controller = await _controler.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(lat, long), zoom: 15, tilt: 50.0, bearing: 45.0)));
  }
}

Marker firstmarker = Marker(
    markerId: MarkerId("mark1"),
    position: LatLng(37.9833, 23.7272),
    infoWindow: InfoWindow(title: "arxhPeous"),
    icon: BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueBlue,
    ));

Marker secondmarker = Marker(
    markerId: MarkerId("mark2"),
    position: LatLng(37.9839, 23.7277),
    infoWindow: InfoWindow(title: "telosPeous"),
    icon: BitmapDescriptor.defaultMarkerWithHue(
      BitmapDescriptor.hueRed,
    ));

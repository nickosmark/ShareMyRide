import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class ChrisHomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<ChrisHomeScreen> {
  Completer<GoogleMapController> _controller = Completer();
  String _mapStyle;
  final fromController = TextEditingController();
  final toController = TextEditingController();
  final dateController = TextEditingController();
  final format = DateFormat("dd-MM-yy HH:mm");
  int mode = 0;
  String from;
  String to;
  String date;
  List<Widget> results;

  @override
  void dispose() {
    fromController.dispose();
    toController.dispose();
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

  double zoomVal = 0.5;

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

  Widget _googleMap(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType: MapType.normal,
        zoomControlsEnabled: false,
        initialCameraPosition:
            CameraPosition(target: LatLng(37.9838, 23.7275), zoom: 12),
        onMapCreated: (GoogleMapController controller) {
          controller.setMapStyle(_mapStyle);
          _controller.complete(controller);
        },
        markers: {firstmarker, secondmarker},
      ),
    );
  }

  Future<void> _gotoLocation(double lat, double long) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(lat, long), zoom: 15, tilt: 50.0, bearing: 45.0)));
  }

  Scaffold homeScaffold() {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: FloatingActionButton.extended(
              onPressed: () {
                from = fromController.text;
                to = toController.text;
                date = dateController.text;
                setState(() {
                  mode = 1;
                  results = [_boxes(), _boxes(), _boxes()];
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
                String text1 = fromController.text + "\n";
                String text2 = toController.text + "\n";
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
      body: Stack(
        children: <Widget>[
          _googleMap(context),
          fillField("From: ", Colors.blue, 50.0, fromController),
          fillField("To: ", Colors.red, 120.0, toController),
          dateField(),
        ],
      ),
    );
  }

  Align fillField(
      String str, Color clr, double top, TextEditingController controller) {
    return Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.only(left: 10.0, right: 10.0, top: top),
          child: TextField(
            controller: controller,
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
        children: <Widget>[_googleMap(context), _buildContainer1()],
      ),
    );
  }

  Widget _buildContainer() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        color: Colors.grey,
        height: 200.0,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            SizedBox(
              width: 10.0,
              height: 10.0,
            ),
            _boxes(),
            SizedBox(
              width: 10.0,
              height: 10.0,
            ),
            _boxes(),
            SizedBox(
              width: 10.0,
              height: 10.0,
            ),
            _boxes(),
          ],
        ),
      ),
    );
  }//buildContainer

  Widget _buildContainer1() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: SizedBox(
        height: 200.0,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.red,
          ),
          child: Column(
            children: <Widget>[
              Text('yo'),
              Text('yo'),
              Expanded(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    SizedBox(width: 10.0,),
                    _boxes(),
                    SizedBox(width: 10.0,),
                    _boxes(),
                    SizedBox(width: 10.0,),
                    _boxes(),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

  Widget _boxes() {
    return GestureDetector(
      onTap: () {
        setState(() {
          mode = 0;
        });
      },
          child: Container(
            color: Colors.white,
            width: 250,
            child: Column(
              children: <Widget>[
                Text(from, style: TextStyle(fontSize: 20.0),),
                Text(to, style: TextStyle(fontSize: 20.0),),
                Text(date, style: TextStyle(fontSize: 20.0),),
              ],
            ),
          ),

    );
  }
} //build_end

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

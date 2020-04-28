import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Completer<GoogleMapController> _controler = Completer();

  @override
  void initState(){
    super.initState();
  }
  double zoomVal = 0.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _googlemap(context),
          // _zoomminusfunction(),
          // _zoomplusfunction(),
           _buildContainer()
        ],
      ),
      
    );
  }

  Widget _buildContainer(){
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20.0),
        height: 150.0,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            SizedBox(width: 10.0,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _boxes(),
              ),
               SizedBox(width: 10.0,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _boxes(),
              ),
               SizedBox(width: 10.0,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _boxes(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _googlemap(BuildContext context){
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(target: LatLng(37.9838, 23.7275), zoom: 12),
        onMapCreated: (GoogleMapController controler){
          _controler.complete(controler);
        },
        markers:{
          firstmarker, secondmarker
        },
      ),
    );
  }
  
  Future<void> _gotoLocation(double lat, double long) async{
    final GoogleMapController controller = await _controler.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat,long), zoom: 15, tilt: 50.0, bearing: 45.0)));
  }
}
Marker firstmarker = Marker(
  markerId: MarkerId("mark1"),
  position: LatLng(37.9833, 23.7272),
  infoWindow: InfoWindow(title: "arxhPeous"),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueBlue,
  )
);

Marker secondmarker = Marker(
  markerId: MarkerId("mark2"),
  position: LatLng(37.9839, 23.7277),
  infoWindow: InfoWindow(title: "telosPeous"),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueRed,
  )
);

Widget _boxes(){
  return GestureDetector(
    onTap: (){
      _gotoLocation(37.4324, 36.3432);
      
    },
    child: Container(
      child: new FittedBox(
        child: Material(
          color: Colors.white,
          elevation: 14.0,
          borderRadius: BorderRadius.circular(24.0),
          shadowColor: Color(0x802196F3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 180,
                height: 200,
                child: Text(
                  "sex",
                  style: TextStyle(fontSize: 16.0),
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}

void _gotoLocation(double d, double e) {
}
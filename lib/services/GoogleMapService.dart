import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/cupertino.dart';

class GoogleMapService{

  GoogleMapController mapController;
  double originLatitude, originLongitude;
  LatLng startCords, endCords;
  double destLatitude, destLongitude;
  Map<MarkerId, Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyBWVICFOmSbt_Z7cnt3swbt9LvZgQg-1uw";
  String mapStyle;

  Completer<GoogleMapController> _controller = Completer();

  Widget googleMap(BuildContext context){
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
      ),
    );
  }

  void onMapCreated(GoogleMapController controller) async{
    mapController = controller;
    mapController.setMapStyle(mapStyle);
  }

  void loadMapStyle() {
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
  getPolyline() async {
    List<PointLatLng> result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      originLatitude,
      originLongitude,
      destLatitude,
      destLongitude,);
    if (result.isNotEmpty) {
      result.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.blue, points: polylineCoordinates);
    polylines[id] = polyline;
  }

  removePolylines(){
    polylineCoordinates.clear();
  }

  // method that adds the marker to the map
  addMarker(LatLng position, String id, BitmapDescriptor descriptor, String info){
    MarkerId markerId = MarkerId(id);
    Marker marker =
    Marker(markerId: markerId,
        icon: descriptor,
        position: position,
        infoWindow: InfoWindow(title: info
        ));
    markers[markerId] = marker;
  }

}
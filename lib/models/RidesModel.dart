import 'package:flutter/material.dart';
import 'package:flutter_app/models/UserModel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


//These class represents public rides. rides that you can find searching...
//Should be used when someone click CREATE
class RidesModel{

  String fromText;
  String toText;
  List<LatLng> randPoints;
  LatLng toLatLng;
  DateTime dateTime;
  UserModel driver;

  RidesModel({
    this.fromText,
    this.toText,
    this.randPoints,
    this.toLatLng,
    this.dateTime,
    this.driver
  });

}
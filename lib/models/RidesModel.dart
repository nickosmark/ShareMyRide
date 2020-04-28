import 'package:flutter/material.dart';
import 'package:flutter_app/models/UserModel.dart';


//These class represents public rides. rides that you can find searching...
//Should be used when someone click CREATE
class RidesModel{

  //TODO from and To are Double. should use LatLong
  double fromWhere;
  double toWhere;
  DateTime dateTime;
  UserModel driver;

  RidesModel({
    this.fromWhere,
    this.toWhere,
    this.dateTime,
    this.driver
  });

}
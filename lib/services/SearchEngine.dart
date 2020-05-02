import 'package:flutter_app/models/ReviewModel.dart';
import 'package:flutter_app/models/RidesModel.dart';
import 'package:flutter_app/models/UserModel.dart';
import 'package:flutter_app/widgets/RideResultCard.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchEngine{

  String fromText;
  String toText;
  LatLng fromCords;
  LatLng toCords;
  DateTime searchDate;

  SearchEngine(String fromText, String toText, LatLng fromCords, toCords, DateTime date) {
    this.fromText = fromText;
    this.toText = toText;
    this.fromCords = fromCords;
    this.toCords = toCords;
    this.searchDate = date;
  }

  List<RideResultCard> getResults() {
    List<RideResultCard> results;



    return results;
  }

}
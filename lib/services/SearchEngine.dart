import 'package:flutter_app/models/ReviewModel.dart';
import 'package:flutter_app/models/RidesModel.dart';
import 'package:flutter_app/models/UserModel.dart';
import 'package:flutter_app/widgets/RideResultCard.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_app/services/fakeDB.dart';

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

  List<RidesModel> getResults() {
    List<RidesModel> results;

    /*
    In here the function will perform a search query
    in the real database for rides with the same starting
    point and finishing point (fromCords , toCords) or any
    other comparison we make to find more results. Each and
    every ride we wish to return is stored in $results and
    therefore is returned.
     */

    results.add(FakeDB.ride39);
    results.add(FakeDB.ride55);
    results.add(FakeDB.ride39);
    results.add(FakeDB.ride55);

    return results;
  }

}
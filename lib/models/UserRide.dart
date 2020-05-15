import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/models/RidesModel.dart';
import 'package:flutter_app/models/UserModel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

enum Status{
  pending,
  confirmed,
  completed,
  myRides,
}

class UserRide {
  String phone;
  Status status;
  bool isDriver;
  bool isFinished;
  RidesModel ride;
  UserModel fellowTraveler;
  LatLng randPoint;

  final Geoflutterfire geo = Geoflutterfire();

  UserRide({
    this.phone,
    this.status,
    this.isDriver,
    this.isFinished,
    this.ride,
    this.fellowTraveler,
    this.randPoint,
  });

  UserRide copyWith({
    String phone,
    Status status,
    bool isDriver,
    bool isFinished,
    RidesModel ride,
    UserModel fellowTraveler,
    LatLng randPoint
  }) {
    return UserRide(
      phone: phone ?? this.phone,
      status: status ?? this.status,
      isDriver: isDriver ?? this.isDriver,
      isFinished: isFinished ?? this.isFinished,
      ride: ride ?? this.ride,
      fellowTraveler: fellowTraveler ?? this.fellowTraveler,
      randPoint: randPoint ?? this.randPoint,
    );
  }


  Map fromLatLngtoGeoFirePoint(LatLng latLng){
    return geo.point(latitude: latLng.latitude, longitude: latLng.longitude).data;
  }

  LatLng fromGeoPointToLatLng(GeoFirePoint point){
    return LatLng(point.latitude, point.longitude);
  }

  Map<String, dynamic> toMap() {
    return {
      'phone' : phone,
      'status': status?.toString(),
      'isDriver': isDriver,
      'isFinished' : isFinished,
      'ride': ride?.toMap(),
      'fellowTraveler': fellowTraveler?.toMap(),
      'randPoint' : fromLatLngtoGeoFirePoint(randPoint),
    };
  }

  static UserRide fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    LatLng fromGeoPointToLatLng(Map<String, dynamic> map){
      GeoPoint point = map['geopoint'];
      Map result = {
        'geopoint': map['geopoint'],
        'geohash': map['geohash'],
      };
      return LatLng(point.latitude, point.longitude);
    }
  
    Status status;
    if(map['status'] == 'Status.pending'){
      status = Status.pending;
    }else if(map['status'] == 'Status.confirmed'){
      status = Status.confirmed;
    }else if(map['status'] == 'Status.completed'){
      status = Status.completed;
    }else if(map['status'] == 'Status.myRides'){
      status = Status.myRides;
    }else{
      status = null;
    }

    return UserRide(
      phone: map['phone'],
      status: status,
      isDriver: map['isDriver'],
      isFinished: map['isFinished'],
      ride: RidesModel.fromMap(map['ride']),
      fellowTraveler: UserModel.fromMap(map['fellowTraveler']),
      randPoint: fromGeoPointToLatLng(map['randPoint']),
    );
  }

  String toJson() => json.encode(toMap());

  static UserRide fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserRide(userPhone: $phone, status: $status, isDriver: $isDriver, ride: $ride, fellowTraveler: $fellowTraveler)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is UserRide &&
      o.phone == phone &&
      o.status == status &&
      o.isDriver == isDriver &&
      o.ride == ride &&
      o.fellowTraveler == fellowTraveler;
  }

  @override
  int get hashCode {
    return status.hashCode ^
      isDriver.hashCode ^
      ride.hashCode ^
      fellowTraveler.hashCode;
  }
}

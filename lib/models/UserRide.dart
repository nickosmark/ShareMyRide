import 'dart:convert';

import 'package:flutter_app/models/RidesModel.dart';
import 'package:flutter_app/models/UserModel.dart';

enum Status{
  pending,
  confirmed,
  completed,
}

class UserRide {
  String userPhone;
  Status status;
  bool isDriver;
  RidesModel ride;
  UserModel fellowTraveler;

  UserRide({
    this.userPhone,
    this.status,
    this.isDriver,
    this.ride,
    this.fellowTraveler,
  });

  UserRide copyWith({
    String userPhone,
    Status status,
    bool isDriver,
    RidesModel ride,
    UserModel fellowTraveler,
  }) {
    return UserRide(
      userPhone: userPhone ?? this.userPhone,
      status: status ?? this.status,
      isDriver: isDriver ?? this.isDriver,
      ride: ride ?? this.ride,
      fellowTraveler: fellowTraveler ?? this.fellowTraveler,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userPhone' : userPhone,
      'status': status?.toString(),
      'isDriver': isDriver,
      'ride': ride?.toMap(),
      'fellowTraveler': fellowTraveler?.toMap(),
    };
  }

  static UserRide fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    Status status;
    if(map['status'] == 'Status.pending'){
      status = Status.pending;
    }else if(map['status'] == 'Status.confirmed'){
      status = Status.confirmed;
    }else if(map['status'] == 'Status.completed'){
      status = Status.completed;
    }else{
      status = null;
    }

    return UserRide(
      userPhone: map['userPhone'],
      status: status,
      isDriver: map['isDriver'],
      ride: RidesModel.fromMap(map['ride']),
      fellowTraveler: UserModel.fromMap(map['fellowTraveler']),
    );
  }

  String toJson() => json.encode(toMap());

  static UserRide fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserRide(userPhone: $userPhone, status: $status, isDriver: $isDriver, ride: $ride, fellowTraveler: $fellowTraveler)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is UserRide &&
      o.userPhone == userPhone &&
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

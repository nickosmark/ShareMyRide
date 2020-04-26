import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:flutter_app/models/ReviewModel.dart';
import 'package:flutter_app/models/RidesModel.dart';

enum Gender {
  male,
  female,
  nonBinary,
}

enum Status{
  pending,
  confirmed,
  completed,
}

class UserRide {
  Status status;
  bool isDriver;
  RidesModel ride;
  UserModel fellowTraveler;

  UserRide({
    this.status,
    this.isDriver,
    this.ride,
    this.fellowTraveler,
  });
}

class UserModel {

  int id;
  String name;
  Gender gender;
  String phone;
  String email;
  String carInfo;
  double rating;
  List<ReviewModel> reviewsList ;
  List<UserRide> ridesList;
  //
  //Constructor
  UserModel({
    this.id,
    this.name,
    this.gender,
    this.phone,
    this.email,
    this.carInfo,
    this.rating,
    this.reviewsList,
    this.ridesList,
  });
  
  String getUrlFromNameHash({Gender genderInput}){
    int id = this.name.hashCode % 100;
    switch (genderInput) {
      case Gender.male:
        return 'https://randomuser.me/api/portraits/men/$id.jpg';
        break;
      case Gender.female:
        return 'https://randomuser.me/api/portraits/women/$id.jpg';
        break;
      case Gender.nonBinary:
        return 'https://img.documentonews.gr/unsafe/1000x600/smart/http://img.dash.documentonews.gr/documento/imagegrid/2018/10/31/5bd98303cd3a18740d2cf935.jpg';
        break;    
      default:
      return 'https://upload.wikimedia.org/wikipedia/en/0/00/The_Child_aka_Baby_Yoda_%28Star_Wars%29.jpg';
    }
    
  }

  void addReviewToUser({ReviewModel review}){
    reviewsList.add(review);
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, phone: $phone, email: $email, carInfo: $carInfo, rating: $rating, : $reviewsList)';
  }

  double getRatingAverage(){

    if(reviewsList.isEmpty){
      return 0.0;
    }else{
      double sum = 0;
      for (var item in reviewsList) {
        var currentRating = item.rating;
        sum = sum + currentRating;
      }
    return sum/reviewsList.length;
    }
  }

  //

  void addToUserRideList({RidesModel incomingRide,UserModel fellow,bool isDriver}){
    var userRide = UserRide(
        status: Status.pending,
        isDriver: isDriver,
        ride: incomingRide,
        fellowTraveler: fellow,
    );

    ridesList.add(userRide);
  }




}

import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:flutter_app/models/ReviewModel.dart';
import 'package:flutter_app/models/RidesModel.dart';
import 'package:flutter_app/models/UserRide.dart';

enum Gender {
  male,
  female,
  nonBinary,
}



class UserModel {

  int id;
  String name;
  Gender gender;
  String phone;
  String email;
  String carInfo;
  double rating;
  List<ReviewModel> reviewsList;
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
    return 'UserModel(id: $id, name: $name, gender: $gender, phone: $phone, email: $email, carInfo: $carInfo, rating: $rating, reviewsList: $reviewsList, ridesList: $ridesList)';
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





  UserModel copyWith({
    int id,
    String name,
    Gender gender,
    String phone,
    String email,
    String carInfo,
    double rating,
    List<ReviewModel> reviewsList,
    List<UserRide> ridesList,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      carInfo: carInfo ?? this.carInfo,
      rating: rating ?? this.rating,
      reviewsList: reviewsList ?? this.reviewsList,
      ridesList: ridesList ?? this.ridesList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'gender': gender?.toString(),
      'phone': phone,
      'email': email,
      'carInfo': carInfo,
      'rating': rating,
      'reviewsList': reviewsList?.map((x) => x?.toMap())?.toList(),
      'ridesList': ridesList?.map((x) => x?.toMap())?.toList(),
    };
  }

  static UserModel fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    Gender gender;
    if(map['gender'] == 'Gender.male'){
      gender = Gender.male;
    }else if(map['gender'] == 'Gender.female'){
      gender = Gender.female;
    }else if(map['gender'] == 'Gender.nonBinary'){
      gender = Gender.nonBinary;
    }else{
      gender = null;
    }

  
    return UserModel(
      id: map['id'],
      name: map['name'],
      gender: gender,
      phone: map['phone'],
      email: map['email'],
      carInfo: map['carInfo'],
      rating: map['rating'],
      reviewsList: List<ReviewModel>.from(map['reviewsList']?.map((x) => ReviewModel.fromMap(x))),
      ridesList: List<UserRide>.from(map['ridesList']?.map((x) => UserRide.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  static UserModel fromJson(String source) => fromMap(json.decode(source));

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is UserModel &&
      o.id == id &&
      o.name == name &&
      o.gender == gender &&
      o.phone == phone &&
      o.email == email &&
      o.carInfo == carInfo &&
      o.rating == rating &&
      listEquals(o.reviewsList, reviewsList) &&
      listEquals(o.ridesList, ridesList);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      gender.hashCode ^
      phone.hashCode ^
      email.hashCode ^
      carInfo.hashCode ^
      rating.hashCode ^
      reviewsList.hashCode ^
      ridesList.hashCode;
  }
}

import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:flutter_app/models/ReviewModel.dart';

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
  List<ReviewModel> reviewsList ;
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
  });
  
  String getUrlFromId({Gender genderInput}){
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


}

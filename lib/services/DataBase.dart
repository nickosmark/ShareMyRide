//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/models/ReviewModel.dart';
import 'package:flutter_app/models/RidesModel.dart';
import 'package:flutter_app/models/SearchModel.dart';
import 'package:flutter_app/models/UserModel.dart';
import 'package:flutter_app/models/UserRide.dart';
import 'package:flutter_app/services/Authenticator.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class Paths{
  static String UserModel = 'UserModel';
  static String ReviewModel = 'ReviewModel';
  static String UserRide = 'UserRide';
  static String RidesModel = 'RidesModel';
}

class DataBase {
  final Authenticator auth;
  final db = Firestore.instance;
  final Geoflutterfire geo = Geoflutterfire();
  DataBase({this.auth});


  Future<String> getCurrAnonUserPhone() async {
    String currentUserId = await auth.getCurrentFireBaseUserID();

  }

  Future<UserModel> getCurrentUserModel() async{
    UserModel generatedUserModel;
    var userCollection = db.collection(Paths.UserModel);
    String currentUser = await auth.getCurrentFireBaseUserID();
    var query = userCollection.where('phone',isEqualTo: currentUser);
    var remoteDoc = await query.getDocuments();
    List results = [];
    for(var i in remoteDoc.documents){
      //Map result = i.data;
      results.add(i.data);
    }
    generatedUserModel = UserModel.fromMap(results[0]);
    if(currentUser == 'NoUserYet'){
      generatedUserModel = UserModel(
        name: 'No User Yet :(',
        gender: Gender.nonBinary,
        phone: '0000000',
        email: 'error no email',
        carInfo: 'no car mate :/',
        rating: 0.0,
      );
    }
    return generatedUserModel;
  }

  Future<List<ReviewModel>>getCurrentUserReviews() async{
    List<ReviewModel> generetedList = [];
    String currentUser = await auth.getCurrentFireBaseUserID();
    var reviewCollection = db.collection(Paths.ReviewModel);
    var query = reviewCollection.where('phone',isEqualTo: currentUser);
    var remoteDoc = await query.getDocuments();
    List results = [];
    for(var i in remoteDoc.documents){
      //Map result = i.data;
      ReviewModel review = ReviewModel.fromMap(i.data);
      generetedList.add(review);
    }
      return generetedList;
  }
  
  Future<List<UserRide>> getCurrentUserRides() async {
    List<UserRide> generatedList = [];
    String currentUser = await auth.getCurrentFireBaseUserID();
    var userRideCollection = db.collection(Paths.UserRide);
    var query = userRideCollection.where('phone', isEqualTo: currentUser);
    var remoteDoc = await query.getDocuments();
    for(var i in remoteDoc.documents){
      UserRide userRide = UserRide.fromMap(i.data);
      generatedList.add(userRide);
    }
    return generatedList;
  }


  Future<List<RidesModel>> getRidesModelsFromSearch(SearchModel searchModel) async{
    String currentUser = await auth.getCurrentFireBaseUserID();

    //Destination set when searching for ride
    GeoFirePoint toGeoFirePoint = GeoFirePoint(searchModel.toCords.latitude, searchModel.toCords.longitude);
    List<RidesModel> generatedList = [];
    var ridesModelCollection = db.collection(Paths.RidesModel);
    //var query = ridesModelCollection.where('dateTime', isGreaterThanOrEqualTo: searchModel.searchDate.millisecondsSinceEpoch);
    var geoRef = geo.collection(collectionRef: ridesModelCollection)
        .within(center: toGeoFirePoint, radius: 3, field: 'toLatLng', strictMode: true);

    var listFromStream = await geoRef.first;
    for(var i in listFromStream){

      //exclude rides created by current user
      //exclude past rides
      if(i.data['driver']['phone'] != currentUser && i.data['dateTime'] >= searchModel.searchDate.millisecondsSinceEpoch){
        RidesModel ride = RidesModel.fromMap(i.data);
        generatedList.add(ride);
      }

    }

    return generatedList;
  }


  Future<List<ReviewModel>> getUserReviewsFromPhone(String phone) async{
    List<ReviewModel> generetedList = [];
    var reviewCollection = db.collection(Paths.ReviewModel);
    var query = reviewCollection.where('phone',isEqualTo: phone);
    var remoteDoc = await query.getDocuments();
    List results = [];
    for(var i in remoteDoc.documents){
      //Map result = i.data;
      ReviewModel review = ReviewModel.fromMap(i.data);
      generetedList.add(review);
    }
    return generetedList;
  }


  //should return DocRef??
  Future<DocumentReference> createUserModel(UserModel user) async{
    DocumentReference docRef;
    var userCollection = db.collection(Paths.UserModel);
    try {
      docRef = await userCollection.add(user.toMap());
    }catch (e) {
      docRef = null;
    }
    return docRef;
  }


  Future<DocumentReference> createUserRide(UserRide userRide) async {
    DocumentReference docRef;
    var userRideCollection = db.collection(Paths.UserRide);
    try{
      docRef = await userRideCollection.add(userRide.toMap());
    }catch (e){
      docRef = null;
    }
    return docRef;
  }


  Future<DocumentReference> createReviewModel(ReviewModel review) async{
    DocumentReference docRef;
    var reviewModelCollection = db.collection(Paths.ReviewModel);
    try{
      docRef = await reviewModelCollection.add(review.toMap());
    }catch (e){
      docRef = null;
    }
    return docRef;
  }

  Future<DocumentReference> createRidesModel(RidesModel ride) async{
    DocumentReference docRef;
    var reviewModelCollection = db.collection(Paths.RidesModel);
    try{
      docRef = await reviewModelCollection.add(ride.toMap());
    }catch (e){
      docRef = null;
    }
    return docRef;
  }

  Future<void> updateRideToConfirmed(UserRide ride) async{
    String phone = ride.phone;
    String fellowTravellerPhone = ride.fellowTraveler.phone;

    //search for this user
    //update status of this user
    var userRideCollection = db.collection(Paths.UserRide);
    var query = userRideCollection
        .where('phone',isEqualTo: ride.phone)
        .where('status', isEqualTo: "Status.pending")
        .where('ride.fromText',isEqualTo: ride.ride.fromText)
        .where('ride.toText',isEqualTo: ride.ride.toText);
    var remoteDoc = await query.getDocuments();
    for(var i in remoteDoc.documents){
        try {
          i.reference.updateData({'status' : 'Status.confirmed'});
        } on Exception catch (e) {
          print('couldnt change from pending to confirmed');
        }
    }

    //search for fellowTraveller
    //update status of fellowTraveller
    var query2 = userRideCollection
        .where('phone',isEqualTo: fellowTravellerPhone)
        .where('status', isEqualTo: "Status.pending")
        .where('ride.fromText',isEqualTo: ride.ride.fromText)
        .where('ride.toText',isEqualTo: ride.ride.toText);
    var remoteDoc2 = await query2.getDocuments();
    for(var i in remoteDoc2.documents){
        try {
          i.reference.updateData({'status' : 'Status.confirmed'});
        } on Exception catch (e) {
          print('couldnt change from pending to confirmed');
        }

    }
  }

  Future<void> updateRideToCompleted(UserRide ride) async{
    String phone = ride.phone;
    String fellowTravellerPhone = ride.fellowTraveler.phone;

    //search for this user
    //update status of this user
    var userRideCollection = db.collection(Paths.UserRide);
    var query = userRideCollection
        .where('phone',isEqualTo: ride.phone)
        .where('status', isEqualTo: "Status.confirmed")
        .where('ride.fromText',isEqualTo: ride.ride.fromText)
        .where('ride.toText',isEqualTo: ride.ride.toText);
    var remoteDoc = await query.getDocuments();
    for(var i in remoteDoc.documents){
        try {
          i.reference.updateData({'status' : 'Status.completed'});
        } on Exception catch (e) {
          print('couldnt change from confirmed to completed');
        }
    }

    //search for fellowTraveller
    //update status of fellowTraveller
    var query2 = userRideCollection
        .where('phone',isEqualTo: fellowTravellerPhone)
        .where('status', isEqualTo: "Status.confirmed")
        .where('ride.fromText',isEqualTo: ride.ride.fromText)
        .where('ride.toText',isEqualTo: ride.ride.toText);
    var remoteDoc2 = await query2.getDocuments();
    for(var i in remoteDoc2.documents){
        try {
          i.reference.updateData({'status' : 'Status.completed'});
        } on Exception catch (e) {
          print('couldnt change from confirmed to completed');
        }
    }
  }

  Future<void> updateRideToFinished(UserRide ride, UserModel reviewee) async{
    //search for this user
    //update status of this user
    var userRideCollection = db.collection(Paths.UserRide);
    var query = userRideCollection
        .where('phone',isEqualTo: ride.phone)
        .where('status', isEqualTo: "Status.completed")
        .where('ride.fromText',isEqualTo: ride.ride.fromText)
        .where('ride.toText',isEqualTo: ride.ride.toText);
    var remoteDoc = await query.getDocuments();
    for(var i in remoteDoc.documents){
      try {
        i.reference.updateData({'isFinished' : true});
      } on Exception catch (e) {
        print('couldnt change from completed to finished ');
      }
    }
  }

  Future<void> declineRide(UserRide ride) async{
    String phone = ride.phone;
    String fellowTravellerPhone = ride.fellowTraveler.phone;


    //decline for this user
    var userRideCollection = db.collection(Paths.UserRide);
    var query = userRideCollection
        .where('phone',isEqualTo: ride.phone)
        .where('status', isEqualTo: "Status.pending")
        .where('ride.fromText',isEqualTo: ride.ride.fromText)
        .where('ride.toText',isEqualTo: ride.ride.toText);
    var remoteDoc = await query.getDocuments();
    for(var i in remoteDoc.documents){
      try {
        i.reference.delete();
      } on Exception catch (e) {
        print('couldnt decline');
      }
    }


    //decline for fellowtraveler
    var query2 = userRideCollection
        .where('phone',isEqualTo: fellowTravellerPhone)
        .where('status', isEqualTo: "Status.pending")
        .where('ride.fromText',isEqualTo: ride.ride.fromText)
        .where('ride.toText',isEqualTo: ride.ride.toText);
    var remoteDoc2 = await query2.getDocuments();
    for(var i in remoteDoc2.documents){
      try {
        i.reference.delete();
      } on Exception catch (e) {
        print('couldnt decline');
      }
    }
  }

  Future<void> cancelRide(UserRide ride) async{
    String phone = ride.phone;
    String fellowTravellerPhone = ride.fellowTraveler.phone;


    //cancel for this user
    var userRideCollection = db.collection(Paths.UserRide);
    var query = userRideCollection
        .where('phone',isEqualTo: ride.phone)
        .where('status', isEqualTo: "Status.confirmed")
        .where('ride.fromText',isEqualTo: ride.ride.fromText)
        .where('ride.toText',isEqualTo: ride.ride.toText);
    var remoteDoc = await query.getDocuments();
    for(var i in remoteDoc.documents){
      try {
        i.reference.delete();
      } on Exception catch (e) {
        print('couldnt cancel');
      }
    }


    //cancel for fellowtraveler
    var query2 = userRideCollection
        .where('phone',isEqualTo: fellowTravellerPhone)
        .where('status', isEqualTo: "Status.confirmed")
        .where('ride.fromText',isEqualTo: ride.ride.fromText)
        .where('ride.toText',isEqualTo: ride.ride.toText);
    var remoteDoc2 = await query2.getDocuments();
    for(var i in remoteDoc2.documents){
      try {
        i.reference.delete();
      } on Exception catch (e) {
        print('couldnt cancel');
      }
    }
  }


  Future<void> updateCurrentUserModel(Map<String,dynamic> userData) async{
    var userCollection = db.collection(Paths.UserModel);
    String currentUser = await auth.getCurrentFireBaseUserID();
    var query = userCollection.where('phone',isEqualTo: currentUser);
    var remoteDoc = await query.getDocuments();
    for(var i in remoteDoc.documents){
      //Map result = i.data;
      try {
        i.reference.updateData(userData);
      } on Exception catch (e) {
        print('couldnt change from completed to finished ');
      }
    }
  }

  void updateCurrentUserRating(List<ReviewModel> reviewsList) async{

    double getRatingAverage(List<ReviewModel> reviewsList){

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
    var averageRating=getRatingAverage(reviewsList);
    var userCollection = db.collection(Paths.UserModel);
    String currentUser = await auth.getCurrentFireBaseUserID();
    var query = userCollection.where('phone',isEqualTo: currentUser);
    var remoteDoc = await query.getDocuments();
    List results = [];
    for(var i in remoteDoc.documents){
      //Map result = i.data;
      //results.add(i.data);
      try{
        i.reference.updateData({'rating' : averageRating});
      } on Exception catch (e) {
        print('couldnt update rating on DB : $e');
      }

    }
  }




  Future<void> deleteRideModelFromUserRide(UserRide userRide) async{
    var ridesCollection = db.collection(Paths.RidesModel);
    var query = ridesCollection
        .where('driver.phone',isEqualTo: userRide.phone)
        .where('fromText',isEqualTo: userRide.ride.fromText)
        .where('toText',isEqualTo: userRide.ride.toText);
    var remoteDoc = await query.getDocuments();
    for(var i in remoteDoc.documents){
      i.reference.delete();
    }
  }

  Future<void> deleteUserRide(UserRide userRide) async{
    var userRidesCollection = db.collection(Paths.UserRide);
    var query = userRidesCollection
        .where('phone',isEqualTo: userRide.phone)
        .where('status', isEqualTo: "Status.myRides")
        .where('ride.fromText',isEqualTo: userRide.ride.fromText)
        .where('ride.toText',isEqualTo: userRide.ride.toText);
    var remoteDoc = await query.getDocuments();
    for(var i in remoteDoc.documents){
      i.reference.delete();
    }

  }


  Future<List<Map>> getAllUserModelsFromDb() async{
    var remoteDocuments = await db.collection('UserModel').getDocuments();
    List<Map> resultDB =[];
    for(var i in remoteDocuments.documents){
      resultDB.add(i.data);
    }

    return resultDB;
  }



  //
  //
  //
  //FIXME delete this shit
  void signUpUser() async{
    db.collection('UserModel').add({
      'name': await auth.getCurrentFireBaseUserID(),
      'phone': '1234567',
      'reviewsList': [],
    });
  }


  Future<Map> showCurrentUserModel() async{
    Map result ;
    String authId = await auth.getCurrentFireBaseUserID();
    var messageList = await db.collection('UserModel').getDocuments();
    for(var i in messageList.documents){
      var senderEntry = i.data['name'];
      if( senderEntry == authId ){
        result = i.data;
      }
    }
    if(result == null){
      return {
        'error' : ' no meesenges found from that User'
      };
    }else{
      return result;
    }
  }


}
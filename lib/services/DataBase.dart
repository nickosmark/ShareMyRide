import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/models/RidesModel.dart';
import 'package:flutter_app/models/UserModel.dart';
import 'package:flutter_app/services/Authenticator.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class Paths{
  static String UserModel = 'UserModel';
  static String ReviewModel = 'ReviewModel';
  static String UserRide = 'UserRide';
}

class DataBase {
  final Authenticator auth;
  final db = Firestore.instance;
  final Geoflutterfire geo = Geoflutterfire();
  DataBase({this.auth});


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
        ridesList: [],
      );
    }
    return generatedUserModel;
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

  void updateUserModel(UserModel user){
    var collection = db.collection(Paths.UserModel);
    //collection.a
  }


  Future<List<Map>> getAllUserModelsFromDb() async{
    var remoteDocuments = await db.collection('UserModel').getDocuments();
    List<Map> resultDB =[];
    for(var i in remoteDocuments.documents){
      resultDB.add(i.data);
    }

    return resultDB;
  }



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
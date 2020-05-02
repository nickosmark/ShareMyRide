import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/services/Authenticator.dart';


class DataBase {
  final Authenticator auth;
  final db = Firestore.instance;
  DataBase({this.auth});

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
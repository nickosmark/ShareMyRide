import 'package:firebase_auth/firebase_auth.dart';

class Authenticator {
  final _auth = FirebaseAuth.instance;


  //can be print in console i guess
  Future<AuthResult> getAnonUserSingInResult() async {
    AuthResult result;
    try{
      result = await _auth.signInAnonymously();
      //AuthResult.user type=FireBaseUser
    }catch(e){
      result = null;
    }
    return result;
  }


//  Future<AuthResult> getPhoneVerificationResult() async{
//    AuthResult result;
//    try{
//      result = await _auth.ph
//    }catch(e){
//      print(e);
//      result = null;
//    }
//
//    return result;
//  }

  FirebaseUser getAnonUserData(AuthResult result) {
    FirebaseUser user;
    try{
      user = result.user;
    }catch(e){
      user = null;
    }

    return user;
  }

  Future<FirebaseUser> getCurrentFireBaseUser()async{
    var user = await _auth.currentUser();
    return user;
  }

  Future<String> getCurrentFireBaseUserID() async {
    var currentUser = await _auth.currentUser();
    String currentUserId = currentUser.uid;
    if(currentUserId == null){
      return 'NoUserYet';
    }else{
      return currentUser.uid;
    }
  }

  Future<bool> isUserAuthenticated() async{
    var currentUser = await _auth.currentUser();
    if(currentUser == null){
      return false;
    }else{
      return true;
    }
  }




}
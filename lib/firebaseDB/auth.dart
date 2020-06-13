import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'firestoreDB.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;


Future<int> registerUser(String email, String pass, String name) async{
  var _auth= FirebaseAuth.instance;
  try{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setString('email', email);
    var result = await _auth.createUserWithEmailAndPassword(email: email, password: pass);

    var user = result.user;

    var info = UserUpdateInfo();
    info.displayName = name;
    info.photoUrl = '/';

    await user.updateProfile(info);
    await FireStoreClass.regUser(name: name,email: email);
    return 1;
  }
  catch(e){
    print(e.code);
    switch (e.code) {
      case 'ERROR_INVALID_EMAIL':
        return -2;
        break;
      case 'ERROR_EMAIL_ALREADY_IN_USE':
        return -3;
        break;
        /*
      case 'ERROR_USER_NOT_FOUND':
        authError = 'User Not Found';
        break;
      case 'ERROR_WRONG_PASSWORD':
        authError = 'Wrong Password';
        break;
        */
      case 'ERROR_WEAK_PASSWORD':
        return -4;
        break;
    }
    return 0;
  }
}

Future<void> logout() async{
  var _auth = FirebaseAuth.instance;
  final prefs = await SharedPreferences.getInstance();
  prefs.clear();
  _auth.signOut();
}

Future<int> loginFirebase(String email, String pass) async{
  var _auth = FirebaseAuth.instance;
  try {
    await FireStoreClass.getDetails(email:email);
    var result = await _auth.signInWithEmailAndPassword(
        email: email, password: pass);
    var user = result.user;
    if(user==null) {
      return null;
    }
    return 1;
  }
  catch(e)
  {
    switch (e.code) {
      case 'ERROR_INVALID_EMAIL':
        return -1;
        break;
      case 'ERROR_WRONG_PASSWORD':
        return -2;
        break;
      case 'ERROR_USER_NOT_FOUND':
        return -3;
        break;
      /*case 'ERROR_WRONG_PASSWORD':
        authError = 'Wrong Password';
        break;
      case 'ERROR_WEAK_PASSWORD':
        return -4;
        break;
       */
    }
    return null;
  }
}
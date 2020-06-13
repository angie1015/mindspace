import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class FireStoreClass{
  static final Firestore _db = Firestore.instance;
  //static final liveCollection = 'liveuser';
  static final userCollection = 'users';
  static final emailCollection = 'user_email';

  /*static void createLiveUser({name, id}) async{
    final snapShot = await _db.collection(liveCollection).document(name).get();
    if(snapShot.exists){
      await _db.collection(liveCollection).document(name).updateData({
        'name': name,
        'channel': id
      });
    } else {
      await _db.collection(liveCollection).document(name).setData({
        'name': name,
        'channel': id
      });
    }
  }
*/
  static Future<void> regUser({name, email}) async{
    await _db.collection(emailCollection).document(email).setData({
      'name': name,
      'email': email,
      'prime': -1,
    });
    return true;
  }


  static Future<void> getDetails({email}) async{
    var document = await Firestore.instance.document('user_email/$email').get();
    var checkData = document.data;
    if(checkData==null)
      return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', document.data['name']);
    await prefs.setString('email', document.data['email']);
  }

  static Future<void> pushResultDB({result,email,normality,disorder}) async {
    var document = await Firestore.instance.document('user_email/$email').get();
    var check = document.data['primeResult'];
    if(check == -1){
      await _db.collection(emailCollection).document(email).updateData({
        'primeResult': result,
        'normality':normality,
        'disorder':disorder,
      });
    }


  }
}
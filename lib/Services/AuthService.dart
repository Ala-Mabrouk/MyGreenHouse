import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/User.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

//sign with e-mail and password
  //signIn with mail
  Future<UserApp?> signInEmailPassword(String mail, String pass) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      UserCredential result =
          await _auth.signInWithEmailAndPassword(email: mail, password: pass);

      if (result.user != null) {
        prefs.setString('UserID', result.user!.uid);

        //get user info from database
        //_user = await UserServices().getUserInfo(result.user!.uid);
        return UserApp();
      }
      return null;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }

  bool verifEmail() {
    FirebaseAuth.instance.currentUser!.reload();
    return FirebaseAuth.instance.currentUser!.emailVerified;
  }

  Future sendEmailVerif() async {
    try {
      User? _user = FirebaseAuth.instance.currentUser;
      await _user!.sendEmailVerification();
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

//sign out
  Future<bool> logout() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
      await _auth.signOut();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return false;
    }
  }
}

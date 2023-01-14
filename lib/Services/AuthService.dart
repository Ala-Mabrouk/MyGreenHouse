import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/User.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
//sign with e-mail and password
  //signIn with mail
  Future<UserApp?> signInEmailPassword(String mail, String pass) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      UserApp _user;
      UserCredential result =
          await _auth.signInWithEmailAndPassword(email: mail, password: pass);

      if (result.user != null) {
        prefs.setString('UserID', result.user!.uid);
        print("result.user!.uid: " + result.user!.uid);
        //get user info from database
        //_user = await UserServices().getUserInfo(result.user!.uid);
        return new UserApp();
      }
      return null;
    } on FirebaseAuthException catch (e) {
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
      print(e);
    }
  }

//sign out
  Future<bool> logout() async {
    print('Logout');

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
      await _auth.signOut();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}

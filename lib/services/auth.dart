import 'package:firebase_auth/firebase_auth.dart';
import 'package:zeepalmtodo/helper/shared_preference.dart';
import 'package:zeepalmtodo/model/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  LocalUser? userFromFirebaseUser(User? user) {
    return user != null ? LocalUser(uid: user.uid) : null;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future resetPass(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    HelperFunctions.saveUserLoggedInSharedPreference(false);
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}

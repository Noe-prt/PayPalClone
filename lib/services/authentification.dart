import 'package:firebase_auth/firebase_auth.dart';
import 'user_wallet.dart';

class AuthService {

  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      UserWallet().createUserWallet(credential.user?.uid, credential.user?.email);
      return credential.user;
    }
    catch (e) {
      print("l'erreur est : $e");
    }
    return null;

  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    }
    catch (e) {
      print("l'erreur est :$e");
    }
    return null;
  }

}


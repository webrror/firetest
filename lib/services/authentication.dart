import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  get user => _auth.currentUser;

  // SIGN UP METHOD

  Future signUp(String email, String password) async {
    try {
      final userCred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return userCred;
    } on FirebaseAuthException catch (e) {
      return null;
    }
  }

  // SIGN IN METHOD

  Future signIn(String email, String password) async {
    try {
      final userCred = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return userCred;
    } on FirebaseAuthException catch (e) {
      return null;
    }
  }

  // SIGN OUT METHOD

  Future signOut() async {
    await _auth.signOut();
  }
}

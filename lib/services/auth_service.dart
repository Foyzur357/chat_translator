import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signUp(String email, String password) async {
    String? errorMessage;
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      await _firebaseAuth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (error) {
      print("=================${error.code}___${error.message}");
      switch (error.code) {
        case "weak-password":
          errorMessage = "The password provided is too weak.";
          break;
        case "email-already-in-use":
          errorMessage = "The account already exists for that email.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
    }
    if (errorMessage != null) {
      return errorMessage;
    }

    return "success";
  }

  Future<String> signIn(String email, String password) async {
    String? errorMessage;
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (error) {
      // print("=================${error.code}___${error.message}");
      switch (error.code) {
        case "invalid-email":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "wrong-password":
          errorMessage = "Your password is wrong.";
          break;
        case "user-not-found":
          errorMessage = "User with this email doesn't exist.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
    }
    if (errorMessage != null) {
      return errorMessage;
    }

    return "success";
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  bool isUserSignedIn() {
    return _firebaseAuth.currentUser != null;
  }

  bool isVerified() {
    return _firebaseAuth.currentUser?.emailVerified ?? false;
  }

  String? uid() {
    return _firebaseAuth.currentUser?.uid;
  }
}

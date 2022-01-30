import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'firebase_util.dart';

Future<String> signIn({
  required String email,
  required String password,
}) async {
  try {
    Future<UserCredential> userCredentials = sFirebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    var userCredential = await userCredentials;
    if (userCredential.user?.emailVerified == true) {
      return '--';
    } else {
      return 'email account not verified, kindly verify through the link in your mail or resend the verification link above';
    }
  } on SocketException {
    return 'No internet connection.';
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      return ('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      return ('Wrong password provided for that user.');
    } else {
      return "error occurred";
    }
  } catch (e) {
    return e.toString();
  }
}

Future<String> signInWithGoogle() async {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

  if (googleSignInAccount != null) {
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    try {
      final UserCredential userCredential =
          await sFirebaseAuth.signInWithCredential(credential);

      if (userCredential.user != null) {
        return '--';
      } else {
        return 'error occurred with authentication';
      }
    } on SocketException {
      return 'No internet connection.';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
        return 'The account already exists with a different credential.';
      } else if (e.code == 'invalid-credential') {
        return 'Error occurred while accessing credentials. Try again.';
      } else {
        return e.toString();
      }
    } catch (e) {
      return e.toString();
    }
  } else {
    return 'Google authentication currently unavailable';
  }
}

Future<String> signUp({required String email, required String password}) async {
  try {
    var userCredential = await sFirebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    await userCredential.user?.sendEmailVerification();
    return "--";
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      return ('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      return ('The account already exists for that email.');
    } else {
      return 'Error Occurred';
    }
  } catch (e) {
    return (e.toString());
  }
}

Future<String> forgotPassword({
  required String email,
}) async {
  try {
    await sFirebaseAuth.sendPasswordResetEmail(email: email);
    return "a password reset link has been sent to your mail";
  } catch (e) {
    return (e.toString());
  }
}

Future<String> resendVerification({
  required String email,
  required String password,
}) async {
  try {
    Future<UserCredential> userCredentials = sFirebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    var userCredential = await userCredentials;
    if (userCredential.user?.emailVerified != true) {
      await userCredential.user?.sendEmailVerification();
      sFirebaseAuth.signOut();
      return 'verification link has be resent';
    } else {
      sFirebaseAuth.signOut();
      return 'account already verified';
    }
  } on SocketException {
    return 'No internet connection.';
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      return ('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      return ('Wrong password provided for that user.');
    } else {
      return "error occurred";
    }
  } catch (e) {
    return e.toString();
  }
}

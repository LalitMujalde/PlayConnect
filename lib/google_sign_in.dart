// ignore_for_file: avoid_print, prefer_const_constructors, no_leading_underscores_for_local_identifiers, use_build_context_synchronously
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:major_project/home.dart';
import 'package:major_project/player.dart';
import 'package:major_project/vender.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  BuildContext? get context => null;
  
  Future<UserCredential> signInWithGoogle(BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential authResult =
        await _auth.signInWithCredential(credential);

    final User? user = authResult.user;

    ///Her to check isNewUser OR Not
    if (authResult.additionalUserInfo!.isNewUser) {
      if (user != null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MakeProfilePage()));
      }
    } else {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
    }

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential> venderSignInWithGoogle(BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential authResult =
        await _auth.signInWithCredential(credential);

    final User? user = authResult.user;

    ///Her to check isNewUser OR Not
    if (authResult.additionalUserInfo!.isNewUser) {
      if (user != null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => VenMakeProfilePage()));
      }
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => VenderHomePage()));
    }

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  void googleLogout() {
    googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}
